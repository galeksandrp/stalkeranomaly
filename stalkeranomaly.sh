#!/usr/bin/env sh

SCRIPT_FILEPATH="$(realpath "$0")"
SCRIPT_DIRPATH="$(dirname "$SCRIPT_FILEPATH")"

LTXDIFF_FILEPATH="$(realpath "$SCRIPT_DIRPATH/../DLTXify_by_right_click.1/LTXDiff.exe")"

MODS_DIRPATH="$(realpath "$SCRIPT_DIRPATH/..")"
SOURCE_DIRPATH="$(realpath "$MODS_DIRPATH/stalkeranomaly-dltx-source_NON_DLTX")"

DLTX_DIRPATH="$(realpath "$MODS_DIRPATH/stalkeranomaly-dltx-configs_DLTX")"

function dltxDiffGDDirpath() {
    dltxDiffDirpath "$(realpath "$1/..")"
}

function dltxDiffDirpath() {
    MOD_DIRPATH="$1"

    cd "$MOD_DIRPATH"

    echo ---------------------------------------------------------------------------
    echo DIRPATH: $(pwd)
    echo ---------------------------------------------------------------------------

    find -type f -name '*.ltx' -exec "$LTXDIFF_FILEPATH" diff "$SOURCE_DIRPATH" "$MOD_DIRPATH" {} \;
}

function dltxDiffDirpathes() {
    find "$MODS_DIRPATH" -maxdepth 2 -type d -name 'gamedata' ! -path '*/MCM_*/*' ! -path '*/*_DLTX/*' -exec "$SCRIPT_FILEPATH" dltxDiffGDDirpath "{}" \;

	read
}

function dltxIfyGDDirpath() {
    dltxIfyDirpath "$(realpath "$1/..")"
}

function dltxIfyDirpath() {
    MOD_DIRPATH="$1"
	MOD_NAME="$(basename "$MOD_DIRPATH")"
	PAK_NAME="$(echo $MOD_NAME | tr '[:upper:]' '[:lower:]' | sed 's/[^[:alnum:]]/_/g')"

    echo ---------------------------------------------------------------------------
    echo LTXDiff.exe dltxify "$SOURCE_DIRPATH" "$MOD_DIRPATH" "$PAK_NAME"
    echo ---------------------------------------------------------------------------

    "$LTXDIFF_FILEPATH" dltxify "$SOURCE_DIRPATH" "$MOD_DIRPATH" "$PAK_NAME"

    #tar cf - -C "${MOD_DIRPATH}_DLTX" . | tar xfp - -C "$DLTX_DIRPATH"

    cp -r "${MOD_DIRPATH}_DLTX"/* "$DLTX_DIRPATH"

    rm -rf "${MOD_DIRPATH}_DLTX"
}

function dltxIfyDirpathes() {
    rm -rf "$DLTX_DIRPATH"

    mkdir "$DLTX_DIRPATH"

    find "$MODS_DIRPATH" -maxdepth 2 -type d -name 'gamedata' -path '*/stalkeranomaly-dltx-*/*' ! -path '*/*_DLTX/*' -exec "$SCRIPT_FILEPATH" dltxIfyGDDirpath "{}" \;

	read
}

"$@"
