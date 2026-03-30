#!/usr/bin/env bash
set -euo pipefail

if command -v apk >/dev/null 2>&1; then
  # *** Alpine ***
  apk add --no-cache imagemagick ghostscript pngquant
elif command -v dpkg >/dev/null 2>&1; then
  # *** Debian ***
  apt-get update
  apt-get install -y --no-install-recommends \
    ghostscript \
    imagemagick \
    pngquant
  apt-get clean
  rm -rf /var/lib/apt/lists/*
elif command -v rpm >/dev/null 2>&1; then
  # *** RedHat/Fedora ***
  if command -v dnf >/dev/null 2>&1; then
    dnf install -y ImageMagick ghostscript pngquant
    dnf clean all
  elif command -v yum >/dev/null 2>&1; then
    yum install -y ImageMagick ghostscript pngquant
    yum clean all
  else
    echo "RPM-based image detected, but neither dnf nor yum is available." >&2
    exit 1
  fi
else
  echo "Unsupported package manager. Expected apk, dpkg/apt, or rpm with dnf/yum." >&2
  exit 1
fi

mkdir -p /usr/local/share/aicage-extensions
printf '%s\n' "imagemagick" "ghostscript" "pngquant" \
  > /usr/local/share/aicage-extensions/imagemagick.txt

echo "ImageMagick version output:"
if command -v magick >/dev/null 2>&1; then
  magick -version
elif command -v convert >/dev/null 2>&1; then
  convert -version
else
  echo "ImageMagick install could not be verified: neither 'magick' nor 'convert' was found." >&2
  exit 1
fi

echo "Ghostscript version output:"
gs --version

echo "pngquant version output:"
pngquant --version
