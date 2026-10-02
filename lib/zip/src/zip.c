/*
 * zip.c - minimal, self-contained ZIP writer implementing the subset of
 * kuba--/zip that TubeReplacer uses. See zip.h for why this exists.
 *
 * Produces a standard ZIP archive using the STORE method (stored, no
 * compression): a local file header + raw data per entry, followed by a
 * central directory and an end-of-central-directory record. All multi-byte
 * fields are little-endian, per the ZIP spec (APPNOTE.TXT). No external
 * dependencies (no zlib/miniz).
 */
#include "zip.h"

#include <stdint.h>
#include <stdlib.h>
#include <string.h>

/* ---- CRC-32 (IEEE 802.3, as used by ZIP) ------------------------------- */

static uint32_t tr_crc32(uint32_t crc, const void *data, size_t len) {
    static uint32_t table[256];
    static int have_table = 0;
    const uint8_t *p = (const uint8_t *)data;
    if (!have_table) {
        for (uint32_t i = 0; i < 256; i++) {
            uint32_t c = i;
            for (int k = 0; k < 8; k++)
                c = (c & 1) ? (0xEDB88320u ^ (c >> 1)) : (c >> 1);
            table[i] = c;
        }
        have_table = 1;
    }
    crc = crc ^ 0xFFFFFFFFu;
    for (size_t i = 0; i < len; i++)
        crc = table[(crc ^ p[i]) & 0xFF] ^ (crc >> 8);
    return crc ^ 0xFFFFFFFFu;
}

/* ---- growable byte buffer ---------------------------------------------- */

typedef struct {
    uint8_t *data;
    size_t len;
    size_t cap;
} tr_buf;

static int tr_buf_reserve(tr_buf *b, size_t extra) {
    if (b->len + extra <= b->cap)
        return 0;
    size_t ncap = b->cap ? b->cap : 256;
    while (ncap < b->len + extra)
        ncap *= 2;
    uint8_t *nd = (uint8_t *)realloc(b->data, ncap);
    if (!nd)
        return -1;
    b->data = nd;
    b->cap = ncap;
    return 0;
}

static int tr_buf_append(tr_buf *b, const void *src, size_t n) {
    if (tr_buf_reserve(b, n) != 0)
        return -1;
    if (n) {
        memcpy(b->data + b->len, src, n);
        b->len += n;
    }
    return 0;
}

static int tr_buf_u16(tr_buf *b, uint16_t v) {
    uint8_t t[2] = {(uint8_t)(v & 0xFF), (uint8_t)((v >> 8) & 0xFF)};
    return tr_buf_append(b, t, 2);
}

static int tr_buf_u32(tr_buf *b, uint32_t v) {
    uint8_t t[4] = {(uint8_t)(v & 0xFF), (uint8_t)((v >> 8) & 0xFF),
                    (uint8_t)((v >> 16) & 0xFF), (uint8_t)((v >> 24) & 0xFF)};
    return tr_buf_append(b, t, 4);
}

static void tr_put_u32(uint8_t *p, uint32_t v) {
    p[0] = (uint8_t)(v & 0xFF);
    p[1] = (uint8_t)((v >> 8) & 0xFF);
    p[2] = (uint8_t)((v >> 16) & 0xFF);
    p[3] = (uint8_t)((v >> 24) & 0xFF);
}

/* ---- entry bookkeeping ------------------------------------------------- */

typedef struct {
    char *name;
    uint32_t crc;
    uint32_t size;         /* uncompressed == compressed (STORE) */
    uint32_t header_offset; /* offset of the local file header */
} tr_entry;

struct zip_t {
    tr_buf local;   /* local file headers + entry data */
    tr_entry *entries;
    size_t nentries;
    size_t entcap;
    /* currently open entry */
    int cur_open;
    char *cur_name;
    uint32_t cur_offset;
    uint32_t cur_crc;
    uint32_t cur_size;
};

#define ZIP_LOCAL_SIG 0x04034b50u
#define ZIP_CENTRAL_SIG 0x02014b50u
#define ZIP_EOCD_SIG 0x06054b50u

struct zip_t *zip_stream_open(const char *stream, size_t size, int level,
                              char mode) {
    (void)stream;
    (void)size;
    (void)level;
    if (mode != 'w')
        return NULL; /* only the write/stream path is implemented */
    struct zip_t *z = (struct zip_t *)calloc(1, sizeof(*z));
    return z;
}

int zip_entry_open(struct zip_t *zip, const char *entryname) {
    if (!zip || !entryname || zip->cur_open)
        return -1;
    size_t namelen = strlen(entryname);
    if (namelen == 0 || namelen > 0xFFFF)
        return -1;

    zip->cur_offset = (uint32_t)zip->local.len;
    zip->cur_crc = 0;
    zip->cur_size = 0;
    zip->cur_name = (char *)malloc(namelen + 1);
    if (!zip->cur_name)
        return -1;
    memcpy(zip->cur_name, entryname, namelen + 1);

    /* Local file header with placeholder crc/sizes; patched in _close. */
    if (tr_buf_u32(&zip->local, ZIP_LOCAL_SIG) != 0)
        return -1;
    tr_buf_u16(&zip->local, 20);        /* version needed */
    tr_buf_u16(&zip->local, 0);         /* general purpose flags */
    tr_buf_u16(&zip->local, 0);         /* compression: 0 = STORE */
    tr_buf_u16(&zip->local, 0);         /* mod time */
    tr_buf_u16(&zip->local, 0x21);      /* mod date (1980-01-01) */
    tr_buf_u32(&zip->local, 0);         /* crc32 (patched) */
    tr_buf_u32(&zip->local, 0);         /* compressed size (patched) */
    tr_buf_u32(&zip->local, 0);         /* uncompressed size (patched) */
    tr_buf_u16(&zip->local, (uint16_t)namelen);
    tr_buf_u16(&zip->local, 0);         /* extra field length */
    if (tr_buf_append(&zip->local, entryname, namelen) != 0)
        return -1;

    zip->cur_open = 1;
    return 0;
}

int zip_entry_write(struct zip_t *zip, const void *buf, size_t bufsize) {
    if (!zip || !zip->cur_open)
        return -1;
    if (bufsize == 0)
        return 0;
    if (tr_buf_append(&zip->local, buf, bufsize) != 0)
        return -1;
    zip->cur_crc = tr_crc32(zip->cur_crc, buf, bufsize);
    zip->cur_size += (uint32_t)bufsize;
    return 0;
}

int zip_entry_close(struct zip_t *zip) {
    if (!zip || !zip->cur_open)
        return -1;

    /* Patch crc32 / compressed size / uncompressed size back into the
     * local header we wrote in _open. Those three 4-byte fields start
     * 14 bytes after the header's signature. */
    uint8_t *hdr = zip->local.data + zip->cur_offset;
    tr_put_u32(hdr + 14, zip->cur_crc);
    tr_put_u32(hdr + 18, zip->cur_size); /* compressed (== uncompressed) */
    tr_put_u32(hdr + 22, zip->cur_size); /* uncompressed */

    if (zip->nentries + 1 > zip->entcap) {
        size_t ncap = zip->entcap ? zip->entcap * 2 : 4;
        tr_entry *ne = (tr_entry *)realloc(zip->entries, ncap * sizeof(*ne));
        if (!ne)
            return -1;
        zip->entries = ne;
        zip->entcap = ncap;
    }
    tr_entry *e = &zip->entries[zip->nentries++];
    e->name = zip->cur_name;
    e->crc = zip->cur_crc;
    e->size = zip->cur_size;
    e->header_offset = zip->cur_offset;

    zip->cur_name = NULL;
    zip->cur_open = 0;
    return 0;
}

ssize_t zip_stream_copy(struct zip_t *zip, void **buf, size_t *bufsize) {
    if (!zip || !buf || !bufsize)
        return -1;

    /* Build central directory + end-of-central-directory into a temp buf. */
    tr_buf cd = {0};
    uint32_t cd_offset = (uint32_t)zip->local.len;
    for (size_t i = 0; i < zip->nentries; i++) {
        tr_entry *e = &zip->entries[i];
        size_t namelen = strlen(e->name);
        tr_buf_u32(&cd, ZIP_CENTRAL_SIG);
        tr_buf_u16(&cd, 20);   /* version made by */
        tr_buf_u16(&cd, 20);   /* version needed */
        tr_buf_u16(&cd, 0);    /* flags */
        tr_buf_u16(&cd, 0);    /* compression: STORE */
        tr_buf_u16(&cd, 0);    /* mod time */
        tr_buf_u16(&cd, 0x21); /* mod date */
        tr_buf_u32(&cd, e->crc);
        tr_buf_u32(&cd, e->size); /* compressed */
        tr_buf_u32(&cd, e->size); /* uncompressed */
        tr_buf_u16(&cd, (uint16_t)namelen);
        tr_buf_u16(&cd, 0); /* extra length */
        tr_buf_u16(&cd, 0); /* comment length */
        tr_buf_u16(&cd, 0); /* disk number start */
        tr_buf_u16(&cd, 0); /* internal attrs */
        tr_buf_u32(&cd, 0); /* external attrs */
        tr_buf_u32(&cd, e->header_offset);
        if (tr_buf_append(&cd, e->name, namelen) != 0) {
            free(cd.data);
            return -1;
        }
    }
    uint32_t cd_size = (uint32_t)cd.len;

    /* End of central directory record. */
    tr_buf_u32(&cd, ZIP_EOCD_SIG);
    tr_buf_u16(&cd, 0); /* disk number */
    tr_buf_u16(&cd, 0); /* disk with central dir */
    tr_buf_u16(&cd, (uint16_t)zip->nentries);
    tr_buf_u16(&cd, (uint16_t)zip->nentries);
    tr_buf_u32(&cd, cd_size);
    tr_buf_u32(&cd, cd_offset);
    tr_buf_u16(&cd, 0); /* comment length */

    size_t total = zip->local.len + cd.len;
    uint8_t *out = (uint8_t *)malloc(total ? total : 1);
    if (!out) {
        free(cd.data);
        return -1;
    }
    if (zip->local.len)
        memcpy(out, zip->local.data, zip->local.len);
    if (cd.len)
        memcpy(out + zip->local.len, cd.data, cd.len);
    free(cd.data);

    *buf = out;
    *bufsize = total;
    return (ssize_t)total;
}

void zip_stream_close(struct zip_t *zip) {
    if (!zip)
        return;
    free(zip->local.data);
    if (zip->cur_name)
        free(zip->cur_name);
    for (size_t i = 0; i < zip->nentries; i++)
        free(zip->entries[i].name);
    free(zip->entries);
    free(zip);
}
