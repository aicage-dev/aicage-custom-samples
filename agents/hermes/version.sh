#!/usr/bin/env bash
set -euo pipefail

curl \
  -fsSL \
  --retry 8 \
  --retry-all-errors \
  --retry-delay 2 \
  --max-time 300 \
  -o /dev/null \
  -w '%{url_effective}' \
  https://github.com/NousResearch/hermes-agent/releases/latest |
  sed 's#.*/tag/v##'
