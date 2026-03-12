#!/bin/bash
set -e

BUILD_DIR="normcap-deb-build"
rm -rf $BUILD_DIR
mkdir -p $BUILD_DIR/DEBIAN
mkdir -p $BUILD_DIR/opt/NormCapImproved
mkdir -p $BUILD_DIR/usr/share/applications
mkdir -p $BUILD_DIR/usr/share/icons/hicolor/scalable/apps

# Create the virtual environment in /opt/NormCapImproved
python3 -m venv $BUILD_DIR/opt/NormCapImproved
$BUILD_DIR/opt/NormCapImproved/bin/pip install .

# Copy desktop file and icon
cp normcap-improved.desktop $BUILD_DIR/usr/share/applications/
cp bundle/imgs/normcap.svg $BUILD_DIR/usr/share/icons/hicolor/scalable/apps/normcap-improved.svg

# Create DEBIAN/control
cat <<EOF > $BUILD_DIR/DEBIAN/control
Package: normcap-improved
Version: 0.6.0
Architecture: amd64
Maintainer: dynobo <dynobo@mailbox.org>
Depends: wl-clipboard | xclip, tesseract-ocr, tesseract-ocr-eng
Description: OCR-powered screen-capture tool (Improved)
 NormCapImproved is an OCR powered screen-capture tool.
 Includes delay configuration, sound notifications, and sequential save.
EOF

# Set permissions for DEBIAN directory
chmod 755 $BUILD_DIR/DEBIAN/control

# Build deb
dpkg-deb --build $BUILD_DIR normcap-improved_0.6.0_amd64.deb
