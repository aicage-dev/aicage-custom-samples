#!/usr/bin/env bash
set -euo pipefail

if command -v unzip >/dev/null 2>&1; then
  _needs_unzip=0
else
  _needs_unzip=1
fi

if [[ "${_needs_unzip}" -eq 1 ]]; then
  if command -v apk >/dev/null 2>&1; then
    apk add --no-cache unzip
  elif command -v pacman >/dev/null 2>&1; then
    pacman -Sy --noconfirm --needed unzip
    rm -rf /var/cache/pacman/pkg/* /var/lib/pacman/sync/*
  elif command -v dpkg >/dev/null 2>&1; then
    apt-get update
    apt-get install -y --no-install-recommends unzip
    apt-get clean
    rm -rf /var/lib/apt/lists/*
  elif command -v rpm >/dev/null 2>&1; then
    dnf install -y unzip
    dnf clean all
  else
    echo "[install_kiro] Unsupported distro: unable to install unzip." >&2
    exit 1
  fi
fi

curl \
  -fsSL \
  --retry 8 \
  --retry-all-errors \
  --retry-delay 2 \
  --max-time 300 \
  https://cli.kiro.dev/install |
  bash

if [[ -x "/root/.local/bin/kiro-cli" ]]; then
  install -m 0755 /root/.local/bin/kiro-cli /usr/local/bin/kiro-cli
fi

if ! command -v kiro-cli >/dev/null 2>&1; then
  echo "[install_kiro] 'kiro-cli' executable not found after installation." >&2
  exit 1
fi
