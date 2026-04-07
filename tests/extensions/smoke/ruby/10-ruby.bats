#!/usr/bin/env bats

@test "ruby toolchain present" {
  run docker run --rm \
    --entrypoint /bin/bash \
    "${AICAGE_EXTENSION_IMAGE}" \
    -lc 'command -v ruby && ruby --version && command -v gem && gem --version && command -v bundle && bundle --version'
  [ "$status" -eq 0 ]
}
