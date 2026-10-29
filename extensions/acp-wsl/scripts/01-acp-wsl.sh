#!/usr/bin/env bash
set -euo pipefail

ARCH="$(uname -m)"
case "$ARCH" in
  x86_64) ARCH=amd64 ;;
  aarch64) ARCH=arm64 ;;
  *)
    echo "Unsupported architecture: $ARCH" >&2
    exit 1
    ;;
esac

curl -fsSL \
  "https://github.com/aicage-dev/acp-wsl/releases/latest/download/acp-wsl-debug-linux-${ARCH}" \
  -o /usr/local/bin/acp-wsl

chmod 755 /usr/local/bin/acp-wsl

echo "acp-wsl version output:"
acp-wsl --version

# Save the inherited agent command in a launcher selectable at runtime.
printf '#!/usr/bin/env bash\nexec acp-wsl --log-file /mnt/c/development/github/aicage/acp-wsl/bin/release/log/out.log -- %q "$@"\n' \
  "${AICAGE_ENTRYPOINT_CMD:?Missing agent command}" >/usr/local/bin/acp-wsl-agent
chmod 755 /usr/local/bin/acp-wsl-agent
