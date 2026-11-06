#!/usr/bin/env bats

@test "bats and helper libraries present" {
  run docker run --rm \
    --entrypoint /bin/bash \
    "${AICAGE_EXTENSION_IMAGE}" \
    -lc '
      set -euo pipefail
      command -v bats
      bats --version
      test -f /usr/lib/bats-support/load.bash
      test -f /usr/lib/bats-assert/load.bash
      test -f /usr/lib/bats-file/load.bash
      find /usr/lib/bats-detik -maxdepth 1 -name "*.bash" | grep -q .
    '
  [ "$status" -eq 0 ]
}
