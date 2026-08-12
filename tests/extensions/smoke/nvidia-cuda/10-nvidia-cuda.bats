#!/usr/bin/env bats

@test "cuda toolkit marker and binaries present" {
  run docker run --rm \
    --entrypoint /bin/bash \
    "${AICAGE_EXTENSION_IMAGE}" \
    -lc '
      set -euo pipefail
      test -f /usr/local/share/aicage-extensions/nvidia-cuda.txt
      command -v nvcc
      cuda_root=/usr/local
      if command -v pacman >/dev/null 2>&1; then
        cuda_root=/opt/cuda
      fi
      test -d "${cuda_root}"
      find "${cuda_root}" -type f \( -name "libcudart.so" -o -name "libcudart.so.*" \) | grep -q .
    '
  [ "$status" -eq 0 ]
}
