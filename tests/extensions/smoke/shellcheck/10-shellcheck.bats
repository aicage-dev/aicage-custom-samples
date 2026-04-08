#!/usr/bin/env bats

@test "shellcheck present" {
  run docker run --rm \
    --entrypoint /bin/bash \
    "${AICAGE_EXTENSION_IMAGE}" \
    -lc 'command -v shellcheck && shellcheck --version'
  [ "$status" -eq 0 ]
}
