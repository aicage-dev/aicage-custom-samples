#!/usr/bin/env bats

@test "haskell toolchain present" {
  run docker run --rm \
    --entrypoint /bin/bash \
    "${AICAGE_EXTENSION_IMAGE}" \
    -lc '
      set -euo pipefail
      command -v ghc
      ghc --version
      command -v cabal
      cabal --version
      command -v stack
      stack --version

      # Exclude for Alpine arm64
      if ! (command -v apk >/dev/null 2>&1 && [[ "$(uname -m)" == "aarch64" ]]); then
        command -v haskell-language-server-wrapper
      fi
    '
  [ "$status" -eq 0 ]
}
