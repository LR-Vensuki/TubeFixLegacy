#!/bin/bash
# build.sh - builds TubeFixLegacy and packs the .deb.
#
# Run by the "TubeFixLegacy" target of TubeFixLegacy.xcodeproj (Xcode 4.6.3,
# iPhoneOS 6.1 SDK), or from Terminal:
#     bash xcode/build.sh            build, result in packages/
#     bash xcode/build.sh clean      remove build products
#
# Steps: Logos (.x -> .m) -> clang for armv7 + armv7s -> lipo -> ad-hoc
# signature -> stage the package layout -> xcode/mkdeb.py.
#
# Written for bash 3.2 (OS X 10.8). Paths may contain spaces
# ("~/Xcode Projects/..."), so everything is quoted and flags live in arrays.
#
# Overrides (normally not needed inside Xcode):
#   TFL_CC, TFL_LIPO, TFL_SDK   compiler, lipo, iPhoneOS SDK path
#   TFL_TARGET_TRIPLE=1         pass -target <arch>-apple-ios5.0 (non-Apple hosts)
#   TFL_LDID=/path/to/ldid      sign with ldid -S instead of codesign
#   TFL_ARCHS="armv7"           architectures (default: armv7 armv7s)
#   TFL_JOBS=4                  parallel compiles (default: CPU count)
#   TFL_WORK_DIR=dir            intermediate files

set -e
set -o pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

note() { echo "[TubeFixLegacy] $*"; }
# "error:" at the start of a line shows up in Xcode's issue navigator
fail() { echo "error: $*" >&2; exit 1; }

WORK_BASE="${TFL_WORK_DIR:-${TARGET_TEMP_DIR:-$ROOT/build}}"
WORK="$WORK_BASE/tfl-work"
PKG_OUT="$ROOT/packages"
ARCH_LIST="${TFL_ARCHS:-armv7 armv7s}"
MIN_IOS=5.0

if [ "$1" = "clean" ] || [ "$ACTION" = "clean" ]; then
    rm -rf "$WORK"
    note "cleaned $WORK"
    exit 0
fi

# ---------------------------------------------------------------- toolchain
if [ -n "$TFL_CC" ]; then CC="$TFL_CC"; else CC="$(xcrun -sdk iphoneos -find clang 2>/dev/null || true)"; fi
[ -n "$CC" ] && [ -x "$CC" ] || fail "clang not found - install Xcode 4.6.3 and run: sudo xcode-select -switch /Applications/Xcode.app"
if [ -n "$TFL_LIPO" ]; then LIPO="$TFL_LIPO"; else LIPO="$(xcrun -sdk iphoneos -find lipo 2>/dev/null || echo lipo)"; fi

SDK="$TFL_SDK"
if [ -z "$SDK" ] && [ -n "$SDKROOT" ] && [ -d "$SDKROOT" ]; then
    case "$SDKROOT" in *iPhoneOS*) SDK="$SDKROOT" ;; esac
fi
if [ -z "$SDK" ]; then SDK="$(xcodebuild -version -sdk iphoneos Path 2>/dev/null || true)"; fi
[ -n "$SDK" ] && [ -d "$SDK" ] || fail "iPhoneOS SDK not found (Xcode 4.6.3 ships iPhoneOS6.1.sdk)"

if [ -z "$TFL_JOBS" ]; then
    TFL_JOBS="$(sysctl -n hw.ncpu 2>/dev/null || getconf _NPROCESSORS_ONLN 2>/dev/null || echo 2)"
fi

note "clang: $CC"
note "SDK:   $SDK"
note "archs: $ARCH_LIST"

arch_flags() {
    if [ -n "$TFL_TARGET_TRIPLE" ]; then
        echo "-target $1-apple-ios$MIN_IOS -arch $1"
    else
        echo "-arch $1 -miphoneos-version-min=$MIN_IOS"
    fi
}

mkdir -p "$WORK"

# C11 <stdatomic.h> arrived with clang 3.6; Apple LLVM 4.2 needs the shim
COMPAT_INC=()
FIRST_ARCH="${ARCH_LIST%% *}"
if [ -n "$TFL_FORCE_ATOMIC_SHIM" ] || ! printf '#include <stdatomic.h>\n' | "$CC" -x c -fsyntax-only -isysroot "$SDK" $(arch_flags "$FIRST_ARCH") - >/dev/null 2>&1; then
    COMPAT_INC=(-I"$ROOT/xcode/compat-include")
    note "compiler has no <stdatomic.h>, using xcode/compat-include"
fi

# rebuild everything when any header changed since the last build
STAMP="$WORK/.last-build"
FORCE=0
if [ ! -f "$STAMP" ] || [ -n "$(find "$ROOT/common" "$ROOT/common-google" "$ROOT/googleapp" "$ROOT/classic" "$ROOT/preferences" "$ROOT/lib" "$ROOT/base64" "$ROOT/xcode" \( -name '*.h' -o -name 'build.sh' -o -name '*.txt' \) -newer "$STAMP" 2>/dev/null | head -1)" ]; then
    FORCE=1
fi

# ---------------------------------------------------------------- Logos
LOGOS="$ROOT/xcode/logos/bin/logos.pl"
LOGOS_OK=1
printf '%%hook NSObject\n- (id)init { return %%orig; }\n%%end\n' > "$WORK/logos-test.x"
if [ -n "$TFL_NO_LOGOS" ] || ! perl "$LOGOS" -c generator=MobileSubstrate "$WORK/logos-test.x" > /dev/null 2> "$WORK/logos-test.err"; then
    LOGOS_OK=0
    note "warning: Logos can't run here ($(head -1 "$WORK/logos-test.err")); using the pre-generated sources in xcode/generated"
fi

logos() {  # $1 = .x relative to ROOT, $2 = output .m
    mkdir -p "$(dirname "$2")"
    if [ "$LOGOS_OK" = 1 ]; then
        perl "$LOGOS" -c generator=MobileSubstrate -c warnings=error "$1" > "$2.tmp" || { rm -f "$2.tmp"; fail "Logos failed on $1"; }
        mv "$2.tmp" "$2"
    else
        [ -f "$ROOT/xcode/generated/$1.m" ] || fail "no pre-generated Logos output for $1 - run xcode/regenerate.py on a machine with Perl"
        cp "$ROOT/xcode/generated/$1.m" "$2"
    fi
}

# signin.x embeds signinpolyfil.js as a C array (Theos does this with xxd)
if [ ! -f "$ROOT/googleapp/signinpolyfil.h" ] || [ "$ROOT/googleapp/signinpolyfil.js" -nt "$ROOT/googleapp/signinpolyfil.h" ]; then
    (cd "$ROOT/googleapp" && xxd -i signinpolyfil.js > signinpolyfil.h.tmp && mv signinpolyfil.h.tmp signinpolyfil.h) || \
        python "$ROOT/xcode/mkdeb.py" --xxd "$ROOT/googleapp/signinpolyfil.js" signinpolyfil_js > "$ROOT/googleapp/signinpolyfil.h" || \
        fail "couldn't generate googleapp/signinpolyfil.h"
fi

# ---------------------------------------------------------------- flags
COMMON_FLAGS=(-isysroot "$SDK" -Os -g0 -DNDEBUG -DTARGET_IPHONE=1 -fmessage-length=0 -Wno-deprecated-declarations -Wno-unused-variable -Wno-unused-function -Wno-attributes -Wno-unknown-pragmas -Wno-arc-bridge-casts-disallowed-in-nonarc -include "$ROOT/common/TFLCompat.h" -I"$ROOT/xcode/include" -iquote "$ROOT" "${COMPAT_INC[@]}")

GOOGLE_FLAGS=(-fno-objc-arc -iquote "$ROOT/googleapp" -I"$ROOT/googleapp/Translators" -I"$ROOT/lib/protobuf" -I"$ROOT/common/SABR/proto/generated" -DGOOGLE_APP=1 -DMSHookMessageEx=TRGatedHookMessageEx)
GOOGLE_FRAMEWORKS=(-framework Foundation -framework CoreFoundation -framework UIKit -framework CoreGraphics -framework QuartzCore -framework MediaPlayer -framework AVFoundation -framework CoreMedia -framework CFNetwork -framework Security)

CLASSIC_FLAGS=(-fno-objc-arc)
CLASSIC_FRAMEWORKS=(-framework Foundation -framework CoreFoundation -framework UIKit -framework MediaPlayer -framework AVFoundation)

PREFS_FLAGS=(-fobjc-arc -DZIP_HAVE_SYMLINK=1)
PREFS_FRAMEWORKS=(-framework Foundation -framework CoreFoundation -framework UIKit -framework MessageUI)

# ---------------------------------------------------------------- compiling
FAILED="$WORK/.failed"
rm -f "$FAILED"

compile_one() {  # $1 = source (absolute), $2 = object, $3 = arch, $4 = source dir for quoted includes, rest = flags
    local src="$1" obj="$2" arch="$3" srcdir="$4"
    shift 4
    local lang=objective-c
    case "$src" in *.c) lang=c ;; *.mm) lang=objective-c++ ;; esac
    mkdir -p "$(dirname "$obj")"
    if ! "$CC" -x "$lang" $(arch_flags "$arch") "${COMMON_FLAGS[@]}" -iquote "$srcdir" "$@" -c "$src" -o "$obj" 2> "$obj.log"; then
        cat "$obj.log" >&2
        echo "$src ($arch)" >> "$FAILED"
        return 1
    fi
    # show warnings, but only once per file
    if [ -s "$obj.log" ] && [ "$arch" = "$FIRST_ARCH" ]; then cat "$obj.log" >&2; fi
    return 0
}

# compile_target <name> <flags array name>  -> fills OBJECTS_<arch> lists in $WORK/<name>/<arch>.objs
compile_target() {
    local name="$1" flagsvar="$2"
    eval "local flags=(\"\${${flagsvar}[@]}\")"
    local list="$ROOT/xcode/sources/$name.txt"
    [ -f "$list" ] || fail "missing $list"
    note "compiling $name"
    local arch rel src obj running=0
    for arch in $ARCH_LIST; do
        : > "$WORK/$name/$arch.objs" 2>/dev/null || { mkdir -p "$WORK/$name"; : > "$WORK/$name/$arch.objs"; }
    done
    while IFS= read -r rel || [ -n "$rel" ]; do
        [ -z "$rel" ] && continue
        src="$ROOT/$rel"
        [ -f "$src" ] || fail "source file missing: $rel"
        if [ "${rel##*.}" = "x" ]; then
            local gen="$WORK/gen/$rel.m"
            if [ "$FORCE" = 1 ] || [ ! -f "$gen" ] || [ "$src" -nt "$gen" ]; then
                logos "$rel" "$gen"
            fi
            src="$gen"
        fi
        for arch in $ARCH_LIST; do
            obj="$WORK/$name/$arch/${rel//\//_}.o"
            echo "$obj" >> "$WORK/$name/$arch.objs"
            if [ "$FORCE" = 0 ] && [ -f "$obj" ] && [ "$obj" -nt "$src" ]; then
                continue
            fi
            compile_one "$src" "$obj" "$arch" "$(dirname "$ROOT/$rel")" "${flags[@]}" &
            running=$((running + 1))
            if [ "$running" -ge "$TFL_JOBS" ]; then
                wait || true
                running=0
            fi
        done
    done < "$list"
    wait || true
    if [ -f "$FAILED" ]; then
        fail "$name: $(wc -l < "$FAILED" | tr -d ' ') file(s) failed to compile: $(tr '\n' ' ' < "$FAILED")"
    fi
}

# link_target <name> <kind: dylib|bundle> <install name> <frameworks array name> <extra ld args...>
link_target() {
    local name="$1" kind="$2" install="$3" fwvar="$4"
    shift 4
    eval "local fws=(\"\${${fwvar}[@]}\")"
    local arch slices=()
    for arch in $ARCH_LIST; do
        local objs=()
        while IFS= read -r o; do [ -n "$o" ] && objs+=("$o"); done < "$WORK/$name/$arch.objs"
        local out="$WORK/$name/$arch/$name"
        local kindflags=(-dynamiclib -install_name "$install")
        [ "$kind" = bundle ] && kindflags=(-bundle)
        "$CC" $(arch_flags "$arch") -isysroot "$SDK" "${kindflags[@]}" -o "$out" "${objs[@]}" \
            -lobjc "${fws[@]}" "$@" -Wl,-segalign,4000 || fail "linking $name ($arch) failed"
        slices+=("$out")
    done
    "$LIPO" -create "${slices[@]}" -output "$WORK/products/$name" || fail "lipo failed for $name"
}

sign() {
    if [ -n "$TFL_LDID" ]; then
        "$TFL_LDID" -S "$1" || fail "ldid failed on $1"
    else
        CODESIGN_ALLOCATE="$(xcrun -sdk iphoneos -find codesign_allocate 2>/dev/null || echo codesign_allocate)" \
            codesign -f -s - "$1" || fail "codesign failed on $1"
    fi
}

mkdir -p "$WORK/products" "$WORK/lib"

# Substrate link stub (the device's CydiaSubstrate is used at runtime)
note "building link stubs"
SUB_SLICES=()
for arch in $ARCH_LIST; do
    "$CC" $(arch_flags "$arch") -isysroot "$SDK" -dynamiclib -install_name /Library/Frameworks/CydiaSubstrate.framework/CydiaSubstrate \
        -o "$WORK/lib/libsubstrate-$arch.dylib" "$ROOT/xcode/stubs/substrate.c" || fail "building the Substrate stub failed"
    SUB_SLICES+=("$WORK/lib/libsubstrate-$arch.dylib")
done
"$LIPO" -create "${SUB_SLICES[@]}" -output "$WORK/lib/libsubstrate.dylib"

PREFS_LINK=()
if [ -d "$SDK/System/Library/PrivateFrameworks/Preferences.framework" ]; then
    PREFS_LINK=(-F"$SDK/System/Library/PrivateFrameworks" -framework Preferences)
else
    note "SDK has no Preferences.framework, linking against xcode/stubs/Preferences.m"
    PREF_SLICES=()
    for arch in $ARCH_LIST; do
        "$CC" -x objective-c $(arch_flags "$arch") -isysroot "$SDK" -dynamiclib -fno-objc-arc \
            -install_name /System/Library/PrivateFrameworks/Preferences.framework/Preferences \
            -o "$WORK/lib/Preferences-$arch.dylib" "$ROOT/xcode/stubs/Preferences.m" -framework UIKit -framework Foundation || fail "building the Preferences stub failed"
        PREF_SLICES+=("$WORK/lib/Preferences-$arch.dylib")
    done
    "$LIPO" -create "${PREF_SLICES[@]}" -output "$WORK/lib/Preferences.dylib"
    PREFS_LINK=("$WORK/lib/Preferences.dylib")
fi

compile_target TubeFixLegacy GOOGLE_FLAGS
compile_target TubeFixLegacyClassic CLASSIC_FLAGS
compile_target TubeFixLegacyPrefs PREFS_FLAGS

note "linking"
link_target TubeFixLegacy dylib /Library/MobileSubstrate/DynamicLibraries/TubeFixLegacy.dylib GOOGLE_FRAMEWORKS "$WORK/lib/libsubstrate.dylib"
link_target TubeFixLegacyClassic dylib /Library/MobileSubstrate/DynamicLibraries/TubeFixLegacyClassic.dylib CLASSIC_FRAMEWORKS "$WORK/lib/libsubstrate.dylib"
link_target TubeFixLegacyPrefs bundle "" PREFS_FRAMEWORKS "${PREFS_LINK[@]}"

for p in TubeFixLegacy TubeFixLegacyClassic TubeFixLegacyPrefs; do sign "$WORK/products/$p"; done

# ---------------------------------------------------------------- staging
note "staging package"
STAGE="$WORK/stage"
rm -rf "$STAGE"
mkdir -p "$STAGE/Library/MobileSubstrate/DynamicLibraries" "$STAGE/Library/PreferenceBundles/TubeFixLegacyPrefs.bundle" "$STAGE/Library/PreferenceLoader/Preferences"
cp -R "$ROOT/layout/." "$STAGE/"
cp -R "$ROOT/preferences/layout/." "$STAGE/"
cp "$WORK/products/TubeFixLegacy" "$STAGE/Library/MobileSubstrate/DynamicLibraries/TubeFixLegacy.dylib"
cp "$ROOT/googleapp/TubeFixLegacy.plist" "$STAGE/Library/MobileSubstrate/DynamicLibraries/TubeFixLegacy.plist"
cp "$WORK/products/TubeFixLegacyClassic" "$STAGE/Library/MobileSubstrate/DynamicLibraries/TubeFixLegacyClassic.dylib"
cp "$ROOT/classic/TubeFixLegacyClassic.plist" "$STAGE/Library/MobileSubstrate/DynamicLibraries/TubeFixLegacyClassic.plist"
cp "$WORK/products/TubeFixLegacyPrefs" "$STAGE/Library/PreferenceBundles/TubeFixLegacyPrefs.bundle/TubeFixLegacyPrefs"
cp -R "$ROOT/preferences/Resources/." "$STAGE/Library/PreferenceBundles/TubeFixLegacyPrefs.bundle/"

mkdir -p "$PKG_OUT"
PYTHON="$(command -v python || command -v python3)"
"$PYTHON" "$ROOT/xcode/mkdeb.py" "$ROOT/control" "$STAGE" "$PKG_OUT" || fail "packing the .deb failed"
touch "$STAMP"
note "done - the .deb is in $PKG_OUT"
