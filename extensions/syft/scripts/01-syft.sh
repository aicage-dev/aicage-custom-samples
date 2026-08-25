#!/usr/bin/env bash
set -euo pipefail

curl -sSfL https://get.anchore.io/syft |
  sh -s -- -b /usr/local/bin

echo "syft version output:"
syft version
