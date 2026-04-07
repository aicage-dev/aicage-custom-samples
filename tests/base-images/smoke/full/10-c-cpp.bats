#!/usr/bin/env bats

@test "full base c/c++ toolchain present" {
  run docker run --rm \
    "${AICAGE_IMAGE_BASE_IMAGE}" \
    -c '
      set -euo pipefail
      command -v gcc
      command -v g++
      command -v clang
      command -v cmake
      command -v gdb
      command -v lldb
      command -v ninja
      command -v pkg-config
      command -v strace
      command -v valgrind
      command -v ld.lld >/dev/null || command -v lld >/dev/null
    '
  [ "$status" -eq 0 ]
}
