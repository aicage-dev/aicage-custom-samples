#!/usr/bin/env bats

@test "acp-wsl present" {
  run docker run --rm \
    --entrypoint /bin/bash \
    "${AICAGE_EXTENSION_IMAGE}" \
    -lc 'command -v acp-wsl-agent && command -v acp-wsl && acp-wsl --version'
  [ "$status" -eq 0 ]
}
