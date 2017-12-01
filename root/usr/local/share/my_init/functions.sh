#!/bin/sh

mypath() {
    path="$1"
    path="$(readlink "$path")"
    parent="$(dirname "$path")"
    saved_umask="$(umask)"
    umask 022
    mkdir -p "$parent"
    umask "$saved_umask"
    echo "$path"
}
