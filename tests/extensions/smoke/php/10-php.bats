#!/usr/bin/env bats

@test "php and composer present" {
  run docker run --rm \
    --entrypoint /bin/bash \
    "${AICAGE_EXTENSION_IMAGE}" \
    -lc 'command -v php && php --version && command -v composer && composer --version'
  [ "$status" -eq 0 ]
}
