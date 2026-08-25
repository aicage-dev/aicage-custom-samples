#!/usr/bin/env bats

@test "syft present" {
  run docker run --rm \
    --entrypoint /bin/bash \
    "${AICAGE_EXTENSION_IMAGE}" \
    -lc 'command -v syft && syft version'
  [ "$status" -eq 0 ]
}
