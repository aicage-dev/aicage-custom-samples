#!/usr/bin/env bats

@test "act present" {
  run docker run --rm \
    --entrypoint /bin/bash \
    "${AICAGE_EXTENSION_IMAGE}" \
    -lc 'command -v act && act --version'
  [ "$status" -eq 0 ]
}
