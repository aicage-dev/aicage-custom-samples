#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# shellcheck source=./scripts/common.sh
source "${ROOT_DIR}/scripts/common.sh"

EXTENSION=""
FROM_IMAGE=""
IMAGE_REF=""
EXPECT_FAILURE=false

usage() {
  cat <<'USAGE'
Usage: scripts/build-extension.sh --extension <name> --from-image <ref> --image <tag> [--expect-failure]
USAGE
  exit 1
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --extension)
      [[ $# -ge 2 ]] || usage
      EXTENSION="$2"
      shift 2
      ;;
    --from-image)
      [[ $# -ge 2 ]] || usage
      FROM_IMAGE="$2"
      shift 2
      ;;
    --image)
      [[ $# -ge 2 ]] || usage
      IMAGE_REF="$2"
      shift 2
      ;;
    --expect-failure)
      EXPECT_FAILURE=true
      shift
      ;;
    -h | --help)
      usage
      ;;
    *)
      usage
      ;;
  esac
done

[[ -n "${EXTENSION}" ]] || die "--extension is required"
[[ -n "${FROM_IMAGE}" ]] || die "--from-image is required"
[[ -n "${IMAGE_REF}" ]] || die "--image is required"
[[ -d "${ROOT_DIR}/extensions/${EXTENSION}/scripts" ]] || die "Unknown extension: ${EXTENSION}"

set +e
DOCKER_BUILDKIT=1 docker build \
  --tag "${IMAGE_REF}" \
  --build-arg "FROM_IMAGE=${FROM_IMAGE}" \
  --build-arg "EXTENSION=${EXTENSION}" \
  --file "${ROOT_DIR}/tests/extensions/Dockerfile" \
  "${ROOT_DIR}"
build_status=$?
set -e

if ${EXPECT_FAILURE}; then
  if [[ ${build_status} -eq 0 ]]; then
    die "Extension '${EXTENSION}' unexpectedly built successfully"
  fi
  log "Extension '${EXTENSION}' failed as expected"
else
  [[ ${build_status} -eq 0 ]] || die "Extension '${EXTENSION}' build failed"
fi
