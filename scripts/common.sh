#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

log() {
  printf '[aicage-custom-samples] %s\n' "$*" >&2
}

die() {
  log "$*"
  exit 1
}

yaml_scalar() {
  local file="$1"
  local key="$2"
  sed -n "s/^${key}:[[:space:]]*//p" "${file}" | head -n 1 | sed -e 's/^"//' -e 's/"$//'
}

base_from_image() {
  local base="$1"
  yaml_scalar "${ROOT_DIR}/base-images/${base}/base.yml" from_image
}

base_test_suite() {
  local base="$1"
  case "${base}" in
    minimal)
      echo minimal
      ;;
    debian-mirror)
      echo debian-mirror
      ;;
    *)
      echo full
      ;;
  esac
}
