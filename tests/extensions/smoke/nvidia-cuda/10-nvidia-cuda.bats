#!/usr/bin/env bats

@test "cuda toolkit marker and binaries present" {
  run docker run --rm \
    --entrypoint /bin/bash \
    "${AICAGE_EXTENSION_IMAGE}" \
    -lc '
      set -euo pipefail
      test -f /usr/local/share/aicage-extensions/nvidia-cuda.txt
      command -v nvcc
      find /usr/local -type f \( -name "libcudart.so" -o -name "libcudart.so.*" \) | grep -q .
    '
  [ "$status" -eq 0 ]
}
