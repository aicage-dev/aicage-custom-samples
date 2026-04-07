#!/usr/bin/env bats

@test "debian-mirror development tooling present" {
  run docker run --rm \
    "${AICAGE_IMAGE_BASE_IMAGE}" \
    -c '
      set -euo pipefail
      command -v python3
      command -v pipx
      command -v python3-config
      command -v uv
      command -v node
      command -v npm
      command -v corepack
      command -v xdg-open
      command -v docker
      docker buildx version
      docker compose version
    '
  [ "$status" -eq 0 ]
}
