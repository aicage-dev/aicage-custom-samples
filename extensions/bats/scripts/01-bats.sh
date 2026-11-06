#!/usr/bin/env bash
set -euo pipefail

readonly API_URL="https://api.github.com/repos"
TEMP_DIR="$(mktemp -d)"
readonly TEMP_DIR

trap 'rm -rf "${TEMP_DIR}"' EXIT

download_latest_release() {
  local repository="$1"
  local destination="$2"
  local version

  version="$(curl -fsSL --retry 4 --retry-connrefused \
    "${API_URL}/${repository}/releases/latest" |
    sed -nE 's/^[[:space:]]*"tag_name": "([^"]+)".*/\1/p')"

  if [[ -z "${version}" ]]; then
    echo "Could not determine the latest release for ${repository}" >&2
    exit 1
  fi

  echo "Downloading ${repository} ${version}"
  mkdir -p "${destination}"
  curl -fsSL --retry 4 --retry-connrefused \
    "${API_URL}/${repository}/tarball/${version}" |
    tar -xz --strip-components=1 -C "${destination}"
}

install_standard_library() {
  local source="$1"
  local destination="$2"
  local file

  install -d -m 755 "${destination}/src"
  install -m 755 "${source}/load.bash" "${destination}/load.bash"
  for file in "${source}"/src/*.bash; do
    install -m 755 "${file}" "${destination}/src/$(basename "${file}")"
  done
}

download_latest_release "bats-core/bats-core" "${TEMP_DIR}/bats-core"
"${TEMP_DIR}/bats-core/install.sh" /usr/local

download_latest_release "bats-core/bats-support" "${TEMP_DIR}/bats-support"
install_standard_library "${TEMP_DIR}/bats-support" /usr/lib/bats-support

download_latest_release "bats-core/bats-assert" "${TEMP_DIR}/bats-assert"
install_standard_library "${TEMP_DIR}/bats-assert" /usr/lib/bats-assert

download_latest_release "bats-core/bats-detik" "${TEMP_DIR}/bats-detik"
install -d -m 755 /usr/lib/bats-detik
for file in "${TEMP_DIR}/bats-detik"/lib/*.bash; do
  install -m 755 "${file}" "/usr/lib/bats-detik/$(basename "${file}")"
done

download_latest_release "bats-core/bats-file" "${TEMP_DIR}/bats-file"
install_standard_library "${TEMP_DIR}/bats-file" /usr/lib/bats-file

echo "bats version output:"
bats --version
