#!/bin/sh

SCRIPTPATH=$(cd "$(dirname "$0")"; pwd)
"$SCRIPTPATH/go-revel-docker" -importPath github.com/aisrael/go-revel-docker -srcPath "$SCRIPTPATH/src" -runMode dev
