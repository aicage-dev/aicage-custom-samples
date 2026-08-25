#!/usr/bin/env bats

@test "grype present" {
  run docker run --rm \
    --entrypoint /bin/bash \
    "${AICAGE_EXTENSION_IMAGE}" \
    -lc 'command -v grype && grype version'
  [ "$status" -eq 0 ]
}
