#!/usr/bin/env bats

@test "dotnet present" {
  run docker run --rm \
    --entrypoint /bin/bash \
    "${AICAGE_EXTENSION_IMAGE}" \
    -lc 'command -v dotnet && dotnet --version'
  [ "$status" -eq 0 ]
}
