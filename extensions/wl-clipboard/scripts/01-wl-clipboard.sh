#!/usr/bin/env bash
set -euo pipefail

if command -v apk >/dev/null 2>&1; then
  # *** Alpine ***
  apk add --no-cache wl-clipboard
elif command -v dpkg >/dev/null 2>&1; then
  # *** Debian ***
  apt-get update
  apt-get install -y --no-install-recommends wl-clipboard
  apt-get clean
  rm -rf /var/lib/apt/lists/*
elif command -v rpm >/dev/null 2>&1; then
  # *** RedHat/Fedora ***
  dnf install -y wl-clipboard
  dnf clean all
elif command -v pacman >/dev/null 2>&1; then
  # *** Arch ***
  pacman -Sy --noconfirm wl-clipboard
  pacman -Scc --noconfirm
else
  echo "Unsupported distro" >&2
  exit 1
fi

echo "wl-copy version output:"
wl-copy --version
