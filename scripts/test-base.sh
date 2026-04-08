#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SMOKE_DIR="${ROOT_DIR}/tests/base-images/smoke"
BASE=""
IMAGE_REF=""

# shellcheck source=./scripts/common.sh
source "${ROOT_DIR}/scripts/common.sh"

usage() {
  cat <<'USAGE'
Usage: scripts/test-base.sh --base <name> --image <ref> [-- <bats-args>]
USAGE
  exit 1
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --base)
      [[ $# -ge 2 ]] || usage
      BASE="$2"
      shift 2
      ;;
    --image)
      [[ $# -ge 2 ]] || usage
      IMAGE_REF="$2"
      shift 2
      ;;
    -h|--help)
      usage
      ;;
    --)
      shift
      break
      ;;
    *)
      usage
      ;;
  esac
done

[[ -n "${BASE}" ]] || die "--base is required"
[[ -n "${IMAGE_REF}" ]] || die "--image is required"

TEST_SUITE="$(base_test_suite "${BASE}")"
[[ -d "${SMOKE_DIR}/shared" ]] || die "Shared smoke suite folder missing"
[[ -d "${SMOKE_DIR}/${TEST_SUITE}" ]] || die "Smoke suite folder missing: ${TEST_SUITE}"

log "Running base smoke suite '${TEST_SUITE}'"
AICAGE_IMAGE_BASE_IMAGE="${IMAGE_REF}" \
  BASE_ALIAS="${BASE}" \
  bats "${SMOKE_DIR}/shared" "${SMOKE_DIR}/${TEST_SUITE}" "$@"
