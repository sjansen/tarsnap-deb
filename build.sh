#!/bin/bash

set -e
PACKAGE=tarsnap
VERSION=1.0.36.1

if [ -n "$1" ]; then
    VERSION="$1"
fi

TAR_URL="https://www.tarsnap.com/download/tarsnap-autoconf-${VERSION}.tgz"

PKGDEPS="build-essential debhelper lintian"
MINDEPS="libssl-dev zlib1g-dev e2fslibs-dev"
EXTDEPS="libacl1-dev libattr1-dev libbz2-dev liblzma-dev"
MISSING=""
for I in $PKGDEPS $MINDEPS $EXTDEPS
do
    if ! dpkg -s "$I" >/dev/null; then
        MISSING="$I $MISSING"
    fi
done
if [ -n "$MISSING" ]; then
    sudo apt-get update
    sudo apt-get install -y $MISSING
fi

TARBALL="${PACKAGE}_${VERSION}.orig.tar.gz"
wget -c "$TAR_URL" -O "$TARBALL"

SRC_DIR="${PACKAGE}-${VERSION}"
test -d "$SRC_DIR" && rm -rf "$SRC_DIR"
mkdir -p "$SRC_DIR"

tar xf "$TARBALL" -C "$SRC_DIR" --strip-components=1

cp -a deb "$SRC_DIR/debian"
sed -i "s/\${VERSION}/${VERSION}/" "$SRC_DIR"/debian/changelog
sed -i "s/\${VERSION}/${VERSION}/" "$SRC_DIR"/debian/*.install

pushd "$SRC_DIR"
dpkg-buildpackage -uc -tc -rfakeroot
popd

rm -rvf ${PACKAGE}-${VERSION}
rm -rvf ${PACKAGE}_*.{dsc,changes,debian.tar.gz}

lintian ${PACKAGE}_${VERSION}-*.deb
