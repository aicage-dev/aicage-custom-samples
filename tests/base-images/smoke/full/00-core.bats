#!/usr/bin/env bats

@test "full base core utilities present" {
  run docker run --rm \
    "${AICAGE_IMAGE_BASE_IMAGE}" \
    -c '
      set -euo pipefail
      command -v curl
      command -v file
      command -v git
      command -v jq
      command -v patch
      command -v rg
      command -v rsync
      command -v ssh
      command -v tar
      command -v tini
      command -v tree
      command -v unzip
      command -v yq
      command -v zip
    '
  [ "$status" -eq 0 ]
}
