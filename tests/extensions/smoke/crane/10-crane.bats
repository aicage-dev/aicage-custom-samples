#!/usr/bin/env bats

@test "crane present" {
  run docker run --rm \
    --entrypoint /bin/bash \
    "${AICAGE_EXTENSION_IMAGE}" \
    -lc 'command -v crane && crane version'
  [ "$status" -eq 0 ]
}
