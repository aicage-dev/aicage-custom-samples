#!/usr/bin/env bats

@test "debian-mirror core utilities present" {
  run docker run --rm \
    "${AICAGE_IMAGE_BASE_IMAGE}" \
    -c '
      set -euo pipefail
      command -v bash
      command -v curl
      command -v git
      command -v gosu
      command -v jq
      command -v tini
    '
  [ "$status" -eq 0 ]
}
