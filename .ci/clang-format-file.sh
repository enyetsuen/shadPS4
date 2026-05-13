#!/bin/bash

set -e

if [ $# -lt 1 ]; then
    echo "Usage: $0 <file-or-directory> [more files...]"
    exit 1
fi

CLANG_FORMAT=clang-format

if ! command -v "$CLANG_FORMAT" >/dev/null 2>&1; then
    echo "Error: clang-format not found"
    exit 1
fi

for path in "$@"; do
    if [ -f "$path" ]; then
        case "$path" in
            *.cpp|*.cc|*.c|*.hpp|*.hh|*.h)
                echo "Formatting $path"
                "$CLANG_FORMAT" -i "$path"
                ;;
            *)
                echo "Skipping unsupported file: $path"
                ;;
        esac
    elif [ -d "$path" ]; then
        find "$path" \( -name '*.cpp' -o -name '*.cc' -o -name '*.c' -o \
                         -name '*.hpp' -o -name '*.hh' -o -name '*.h' \) \
            -print0 | while IFS= read -r -d '' file; do
                echo "Formatting $file"
                "$CLANG_FORMAT" -i "$file"
            done
    else
        echo "Path not found: $path"
    fi
done
