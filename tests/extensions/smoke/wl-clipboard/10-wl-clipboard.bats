#!/usr/bin/env bats

@test "wl-copy present" {
  run docker run --rm \
    --entrypoint /bin/bash \
    "${AICAGE_EXTENSION_IMAGE}" \
    -lc 'command -v wl-copy && wl-copy --version'
  [ "$status" -eq 0 ]
}
