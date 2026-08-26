#!/usr/bin/env bats

@test "Java 21 JDK is present" {
  run docker run --rm \
    --entrypoint /bin/bash \
    "${AICAGE_EXTENSION_IMAGE}" \
    -lc 'java -version 2>&1 && javac -version 2>&1 && java -version 2>&1 | grep -Eq '\''version "21([.]|\")'\'''
  [ "$status" -eq 0 ]
}
