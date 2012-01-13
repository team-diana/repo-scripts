#!/usr/bin/env bash

if [[ "$DOCS" == "" ]]; then
    DOCS="."
fi

source "$DOCS/common.sh" "$1"

NAME="repo.sh"
VER="0.0.1"

echo -n "\`$NAME\` v${VER} - Create a local `partial_code "apt"` repository for"
echo " Team DIANA packages."
echo
echo "Copyright (c) `date +%Y` Team DIANA, <info@teamdiana.org>. MIT License"
echo
echo "Based on code from multiple sources see LICENSE file for details"
echo

# Adjust the output if we are building the docs.
if [ "$1" != "build_docs" ]; then
    code "tail -f \"`pwd`/build.log\""
else
    code "tail -f build.log"
fi
echo
