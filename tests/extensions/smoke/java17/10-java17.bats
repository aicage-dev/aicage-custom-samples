#!/usr/bin/env bats

@test "Java 17 JDK is present" {
  run docker run --rm \
    --entrypoint /bin/bash \
    "${AICAGE_EXTENSION_IMAGE}" \
    -lc 'java -version 2>&1 && javac -version 2>&1 && java -version 2>&1 | grep -Eq '\''version "17([.]|\")'\'''
  [ "$status" -eq 0 ]
}
