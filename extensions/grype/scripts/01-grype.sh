#!/usr/bin/env bash
set -euo pipefail

curl -sSfL https://get.anchore.io/grype |
  sh -s -- -b /usr/local/bin

echo "grype version output:"
grype version
