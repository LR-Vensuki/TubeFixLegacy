#!/bin/bash
# deploy.sh - copy the staged build (.theos/_ from `make stage`) onto a
# jailbroken iPhone over USB through AFC2 (no SSH needed). Every file is
# written next to its target and renamed over it, so a running app that
# has the old dylib mapped doesn't crash. Restart the YouTube app afterwards.
cd "$(dirname "$0")/.."
STAGE="${1:-.theos/_}"
I="python3 tools/idev.py afc2"
(cd "$STAGE" && find . -type d | sed 's|^\.||' | grep -v '^$' | grep -v '^/DEBIAN') | while read -r dir; do
    $I mkdir "$dir" >/dev/null 2>&1
done
(cd "$STAGE" && find . -type f | sed 's|^\.||' | grep -v '^/DEBIAN') | while read -r file; do
    $I put "$STAGE$file" "$file.tflnew" >/dev/null && $I mv "$file.tflnew" "$file" >/dev/null && echo "  $file" || echo "FAILED $file"
done
