#!/usr/bin/env bats

@test "gh present" {
  run docker run --rm \
    --entrypoint /bin/bash \
    "${AICAGE_EXTENSION_IMAGE}" \
    -lc 'command -v gh && gh --version'
  [ "$status" -eq 0 ]
}
