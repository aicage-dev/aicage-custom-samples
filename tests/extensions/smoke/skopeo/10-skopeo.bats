#!/usr/bin/env bats

@test "skopeo present" {
  run docker run --rm \
    --entrypoint /bin/bash \
    "${AICAGE_EXTENSION_IMAGE}" \
    -lc 'command -v skopeo && skopeo --version'
  [ "$status" -eq 0 ]
}
