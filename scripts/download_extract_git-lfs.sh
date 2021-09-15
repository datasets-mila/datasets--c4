#!/bin/bash
set -o errexit -o pipefail -o noclobber

# This script is meant to be used with the command 'datalad run'

source scripts/utils.sh echo -n

_VERSION=v2.13.3

mkdir -p bin/git-lfs-linux-amd64-${_VERSION}

rm -f bin/sha256sums
echo "03197488f7be54cfc7b693f0ed6c75ac155f5aaa835508c64d68ec8f308b04c1  git-lfs-linux-amd64-${_VERSION}.tar.gz" > bin/sha256sums

for file_url in "https://github.com/git-lfs/git-lfs/releases/download/${_VERSION}/git-lfs-linux-amd64-${_VERSION}.tar.gz bin/git-lfs-linux-amd64-${_VERSION}.tar.gz"
do
        echo ${file_url} | git-annex addurl -c annex.largefiles=anything --raw --batch --with-files
done
pushd bin/ >/dev/null
sha256sum -c sha256sums
popd >/dev/null
exit_on_error_code "Failed to download git-lfs"

tar -C bin/git-lfs-linux-amd64-${_VERSION} -xf bin/git-lfs-linux-amd64-${_VERSION}.tar.gz
exit_on_error_code "Failed to extract git-lfs"

pushd bin/ >/dev/null
ln -sf git-lfs-linux-amd64-${_VERSION}/git-lfs .
popd >/dev/null
