/*
 * zip.h - minimal, self-contained drop-in for the subset of kuba--/zip
 * (https://github.com/kuba--/zip) that TubeReplacer actually uses.
 *
 * Upstream kuba--/zip is a git submodule (lib/zip). When the project is
 * built from a source archive rather than a `git clone --recursive`, that
 * submodule is empty and the preferences bundle fails to build
 * ("lib/zip/src/zip.c does not exist"). This vendored file provides just
 * the streaming write API that preferences/YTRPDebugListController.m calls
 * to package the network debug log before emailing it:
 *
 *     zip_stream_open / zip_entry_open / zip_entry_write /
 *     zip_entry_close / zip_stream_copy / zip_stream_close
 *
 * It writes a valid ZIP archive using the STORE method (no compression),
 * which every unzipper - including the macOS/iOS Archive Utility and the
 * one the developer opens the emailed dump with - reads natively. The
 * compression-level argument is accepted and ignored. If you need real
 * DEFLATE compression or the wider kuba--/zip API, restore the real
 * submodule with `git submodule update --init --recursive`, which
 * overwrites this file.
 */
#ifndef TR_MINIZIP_H
#define TR_MINIZIP_H

#include <stddef.h>
#include <sys/types.h> /* ssize_t */

#ifdef __cplusplus
extern "C" {
#endif

#ifndef ZIP_DEFAULT_COMPRESSION_LEVEL
#define ZIP_DEFAULT_COMPRESSION_LEVEL 6
#endif

struct zip_t;

/* Open an in-memory zip writer. `stream`/`size` are accepted for API
 * compatibility and ignored for the write path; `level` is ignored
 * (STORE is always used); `mode` must be 'w'. Returns NULL on failure. */
struct zip_t *zip_stream_open(const char *stream, size_t size, int level,
                              char mode);

/* Begin a new archive entry with the given name. Returns 0 on success. */
int zip_entry_open(struct zip_t *zip, const char *entryname);

/* Append `bufsize` bytes from `buf` to the currently open entry.
 * Returns 0 on success. */
int zip_entry_write(struct zip_t *zip, const void *buf, size_t bufsize);

/* Finish the currently open entry. Returns 0 on success. */
int zip_entry_close(struct zip_t *zip);

/* Finalize the archive and hand back a newly malloc()'d buffer holding
 * the complete .zip bytes. The caller owns it and must free() it. Returns
 * the number of bytes written, or a negative value on failure. */
ssize_t zip_stream_copy(struct zip_t *zip, void **buf, size_t *bufsize);

/* Free the writer and all its internal state. */
void zip_stream_close(struct zip_t *zip);

#ifdef __cplusplus
}
#endif

#endif /* TR_MINIZIP_H */
