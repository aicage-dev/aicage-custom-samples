#!/usr/bin/env bash
set -euo pipefail

curl -fsSL https://rgctl.io/install.sh |
  RGCTL_INSTALL_DIR=/usr/local/bin sh

echo "rgctl version output:"
rgctl --version
