#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function old_tmp_files () {
  local TMP_DIR="${1:-tmp/}"; shift
  local MIN_AGE_DAYS=14
  local FIND_OPTS=(
    -maxdepth 1
    -type f
    '(' -false
      -o -name '[a-z]*.pdf'
      -o -name '[a-z]*.png'
      -o -name '[a-z]*.svg'
      ')'
    -mtime "$MIN_AGE_DAYS"    # by date of last modification
    )
  find "$TMP_DIR" "${FIND_OPTS[@]}" "$@"; return $?
}










[ "$1" == --lib ] && return 0; old_tmp_files "$@"; exit $?
