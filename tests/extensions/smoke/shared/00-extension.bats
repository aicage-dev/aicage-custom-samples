#!/usr/bin/env bats

@test "extension image boots" {
  run docker run --rm \
    --entrypoint /bin/bash \
    "${AICAGE_EXTENSION_IMAGE}" \
    -lc 'echo extension-boot && uname -m'
  [ "$status" -eq 0 ]
  [[ "$output" == *"extension-boot"* ]]
}
