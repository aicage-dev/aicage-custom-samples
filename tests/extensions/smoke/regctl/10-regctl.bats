#!/usr/bin/env bats

@test "regctl present" {
  run docker run --rm \
    --entrypoint /bin/bash \
    "${AICAGE_EXTENSION_IMAGE}" \
    -lc 'command -v regctl && regctl version'
  [ "$status" -eq 0 ]
}
