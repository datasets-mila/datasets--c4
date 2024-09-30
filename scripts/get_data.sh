#!/bin/bash

# Set _DATALAD_SRC to a script that activate datalad like
# _DATALAD_SRC=/network/datasets/scripts/activate_datalad.sh
source ./scripts/utils.sh activate_datalad

# init git-annex if first run
git-annex list --fast >/dev/null 2>&1 || git-annex init

# Prepare git-lfs
./scripts/datalad.sh run scripts/download_extract_git-lfs.sh

# Download git-lfs files
PATH="$PATH:$PWD/bin" git submodule update --init
./scripts/datalad.sh run -i c4/ scripts/download.sh
