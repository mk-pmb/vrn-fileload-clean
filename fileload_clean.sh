#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-
SELFFILE="$(readlink -m "$BASH_SOURCE")"; SELFPATH="$(dirname "$SELFFILE")"
SELFNAME="$(basename "$SELFFILE" .sh)"; INVOKED_AS="$(basename "$0" .sh)"


function fileload_clean () {
  local BFN="$1"
  [ "$BFN" == --env ] && BFN="$FILELOAD_BFN"
  BFN="${BFN##*/}"
  BFN="${BFN%%\.*}"

  local PDF_URL='http://fahrplanauskunft.vrn.de/vrn/FILELOAD?Filename=#.pdf'
  PDF_URL="${PDF_URL//#/$BFN}"
  local ORIG_SAVE_FN="$BFN.orig.pdf"
  dwnl_pdf "$PDF_URL" "$ORIG_SAVE_FN" || return $?

  local PDF_DPI=300
  local ORIG_JPEG="$BFN.@${PDF_DPI}dpi.jpeg"
  # [ -s "$ORIG_JPEG" ] || pdf2jpeg "$ORIG_SAVE_FN" "$ORIG_JPEG" || return $?

  local CLEAN_SVG="$BFN.svg"
  [ -s "$CLEAN_SVG" ] || pdf2svg "$ORIG_SAVE_FN" "$CLEAN_SVG" || return $?

  local CLEAN_PNG="$BFN.png"
  [ -s "$CLEAN_PNG" ] || convert -- "$CLEAN_SVG" "$CLEAN_PNG" || return $?

  return 0
}


function dwnl_pdf () {
  local SRC_URL="$1"; shift
  local SAVE_AS="$1"; shift
  [ -s "$SAVE_AS" ] && return 0

  local WGET_OPTS=(
    # --quiet
    --tries=2
    --timeout=10
    --continue
    )
  wget "${WGET_OPTS[@]}" -O "$SAVE_AS".part -- "$SRC_URL" || return $?
  [ -s "$SAVE_AS".part ] || return 3
  mv --no-clobber --no-target-directory -- "$SAVE_AS"{.part,} || return $?
  return 0
}


function pdf2jpeg () {
  local SRC="$1"; shift
  local DEST="$1"; shift
  echo -n "$SRC -> $DEST: "
  pdftoppm -f 1 -l 1 -r "${PDF_DPI:-1}" -jpeg "$SRC" "$DEST" || return $?
  mv --no-clobber --no-target-directory -- "$DEST"{-1.jpg,} || return $?
  echo ok.
  return 0
}


function pdf2svg () {
  local SRC="$1"; shift
  local DEST="$1"; shift
  echo -n "$SRC -> $DEST: "
  local CONV_OPTS=(
    -svg
    -f 1 -l 1
    -r "$PDF_DPI"
    -cropbox
    -nocenter
    )
  local SED_OPTS=(
    -rf "$SELFPATH"/clean_fileload_svg.sed
    )
  pdftocairo "${CONV_OPTS[@]}" -- "$SRC" - \
    | LANG=C sed "${SED_OPTS[@]}">"$DEST" || return $?
  local PIPE_RV="${PIPESTATUS[*]}"
  let PIPE_RV="${PIPE_RV// /+}"
  echo "rv=$PIPE_RV"
  return "$PIPE_RV"
}





















fileload_clean "$@"; exit $?
