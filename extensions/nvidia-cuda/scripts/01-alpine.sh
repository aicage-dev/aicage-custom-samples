#!/usr/bin/env bash
set -euo pipefail

if ! command -v apk >/dev/null 2>&1; then
  exit 0
fi

echo "Alpine is not supported by this extension." >&2
echo "NVIDIA publishes CUDA packages for DEB/RPM distro families, not Alpine/apk." >&2
exit 1
