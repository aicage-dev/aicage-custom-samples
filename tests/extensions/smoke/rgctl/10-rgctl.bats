#!/usr/bin/env bats

@test "rgctl present" {
  run docker run --rm \
    --entrypoint /bin/bash \
    "${AICAGE_EXTENSION_IMAGE}" \
    -lc 'command -v rgctl && rgctl --version'
  [ "$status" -eq 0 ]
}
