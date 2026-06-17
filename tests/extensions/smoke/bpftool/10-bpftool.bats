#!/usr/bin/env bats

@test "bpftool present" {
  run docker run --rm \
    --entrypoint /bin/bash \
    "${AICAGE_EXTENSION_IMAGE}" \
    -lc 'command -v bpftool && bpftool version'
  [ "$status" -eq 0 ]
}
