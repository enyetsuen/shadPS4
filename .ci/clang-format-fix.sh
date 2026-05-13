#!/bin/bash -ex

# SPDX-FileCopyrightText: 2023 Citra Emulator Project
# SPDX-License-Identifier: GPL-2.0-or-later

# Fix trailing whitespace in-place
grep -rlI '\s$' src *.yml *.txt *.md Doxyfile .gitignore .gitmodules .ci* dist/*.desktop \
    dist/*.svg dist/*.xml | xargs -r sed -i 's/[ \t]*$//'

CLANG_FORMAT=clang-format
$CLANG_FORMAT --version

if [ "$GITHUB_EVENT_NAME" = "pull_request" ]; then
    files_to_lint="$(git diff --name-only --diff-filter=ACMRTUXB $COMMIT_RANGE | grep '^src/[^.]*[.]\(cpp\|h\)$' || true)"
else
    files_to_lint="$(find src/ -name '*.cpp' -or -name '*.h')"
fi

set +x

for f in $files_to_lint; do
    $CLANG_FORMAT -i "$f"
done

set -x
