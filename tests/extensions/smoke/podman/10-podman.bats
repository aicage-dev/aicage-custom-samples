#!/usr/bin/env bats

@test "podman present" {
  run docker run --rm \
    --entrypoint /bin/bash \
    "${AICAGE_EXTENSION_IMAGE}" \
    -lc 'command -v podman && podman --version'
  [ "$status" -eq 0 ]
}
