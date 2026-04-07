#!/usr/bin/env bats

@test "full base language toolchains present" {
  run docker run --rm \
    "${AICAGE_IMAGE_BASE_IMAGE}" \
    -c '
      set -euo pipefail
      command -v ant
      command -v go
      command -v gradle
      command -v java
      command -v javac
      command -v mvn
      command -v node
      command -v npm
      command -v corepack
      command -v python3
      command -v python3-config
      command -v pipx
      command -v uv
      command -v cargo
      command -v rustc
      command -v rustfmt
      command -v cargo-clippy
      command -v docker
      docker buildx version
      docker compose version
    '
  [ "$status" -eq 0 ]
}
