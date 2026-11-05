#!/usr/bin/env bash
set -euo pipefail

# Get Git tag of latest release
RGCTL_TAG="$(curl -fsSL -o /dev/null -w '%{url_effective}' https://github.com/rgctl/rgctl/releases/latest)"
RGCTL_TAG="${RGCTL_TAG##*/}"

curl -fsSL "https://raw.githubusercontent.com/rgctl/rgctl/${RGCTL_TAG}/scripts/install.sh" |
  RGCTL_INSTALL_DIR=/usr/local/bin sh

install_musl_rgctl() {
  local arch
  local version

  case "$(uname -m)" in
    x86_64|amd64)
      arch="x86_64"
      ;;
    aarch64|arm64)
      arch="aarch64"
      ;;
    *)
      echo "Unsupported rgctl architecture: $(uname -m)" >&2
      return 1
      ;;
  esac

  version="${RGCTL_TAG#v}"
  curl -fsSL \
    "https://github.com/rgctl/rgctl/releases/download/${RGCTL_TAG}/rgctl-${version}-${arch}-unknown-linux-musl.tar.gz" |
    tar -xzf - -C /usr/local/bin rgctl
}

echo "rgctl version output:"
if ! rgctl --version; then
  echo "Falling back to the musl rgctl release"
  install_musl_rgctl
  rgctl --version
fi
