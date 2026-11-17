#!/usr/bin/env bash
set -euo pipefail

if command -v apk >/dev/null 2>&1; then
  # *** Alpine ***
  apk add --no-cache podman
elif command -v dpkg >/dev/null 2>&1; then
  # *** Debian ***
  apt-get update
  apt-get install -y --no-install-recommends podman
  apt-get clean
  rm -rf /var/lib/apt/lists/*
elif command -v rpm >/dev/null 2>&1; then
  # *** RedHat/Fedora ***
  dnf install -y podman
  dnf clean all
elif command -v pacman >/dev/null 2>&1; then
  # *** Arch ***
  pacman -Sy --noconfirm podman
  pacman -Scc --noconfirm
else
  echo "Unsupported distro" >&2
  exit 1
fi

echo "podman version output:"
podman --version
