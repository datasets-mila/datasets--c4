#!/bin/bash
set -o errexit -o pipefail -o noclobber

# This script is meant to be used with the command 'datalad run'

# Add git-lfs to PATH if not already present
pushd bin/ >/dev/null
export PATH="${PATH}:${PWD}"
popd >/dev/null

pushd c4/ >/dev/null

git lfs install --skip-smudge
# git lfs track "*.wav"
# git add .gitattributes

git lfs fetch
git lfs pull

popd >/dev/null

./scripts/stats.sh c4/*/
