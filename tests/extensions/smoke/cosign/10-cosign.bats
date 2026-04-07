#!/usr/bin/env bats

@test "cosign present" {
  run docker run --rm \
    --entrypoint /bin/bash \
    "${AICAGE_EXTENSION_IMAGE}" \
    -lc 'command -v cosign && cosign version'
  [ "$status" -eq 0 ]
}
