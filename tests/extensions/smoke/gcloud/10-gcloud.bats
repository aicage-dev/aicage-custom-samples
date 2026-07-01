#!/usr/bin/env bats

@test "gcloud present" {
  run docker run --rm \
    --entrypoint /bin/bash \
    "${AICAGE_EXTENSION_IMAGE}" \
    -lc 'command -v gcloud && command -v gsutil && command -v bq && gcloud --version'
  [ "$status" -eq 0 ]
}
