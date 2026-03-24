#!/usr/bin/env bash
set -euo pipefail

if command -v dpkg >/dev/null 2>&1 || command -v rpm >/dev/null 2>&1; then
  exit 0
fi

echo "This NVIDIA CUDA extension currently supports only dpkg- and rpm-based images." >&2
exit 1
