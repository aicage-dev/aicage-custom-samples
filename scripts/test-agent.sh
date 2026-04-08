#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SMOKE_DIR="${ROOT_DIR}/tests/agents/smoke"
AGENT=""
IMAGE_REF=""

# shellcheck source=./scripts/common.sh
source "${ROOT_DIR}/scripts/common.sh"

usage() {
  cat <<'USAGE'
Usage: scripts/test-agent.sh --agent <name> --image <ref> [-- <bats-args>]
USAGE
  exit 1
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --agent)
      [[ $# -ge 2 ]] || usage
      AGENT="$2"
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

[[ -n "${AGENT}" ]] || die "--agent is required"
[[ -n "${IMAGE_REF}" ]] || die "--image is required"

log "Running agent smoke suite '${AGENT}'"
AICAGE_IMAGE="${IMAGE_REF}" \
  AGENT="${AGENT}" \
  bats "${SMOKE_DIR}" "$@"
