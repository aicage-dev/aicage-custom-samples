#!/usr/bin/env bash
set -euo pipefail

curl \
  -fsSL \
  --retry 8 \
  --retry-all-errors \
  --retry-delay 2 \
  --max-time 300 \
  https://hermes-agent.nousresearch.com/install.sh |
  HERMES_HOME=/usr/local/share/hermes-agent \
    PLAYWRIGHT_BROWSERS_PATH=/usr/local/share/hermes-agent/ms-playwright \
    UV_CACHE_DIR=/usr/local/share/hermes-agent/uv/cache \
    UV_TOOL_DIR=/usr/local/share/hermes-agent/uv/tools \
    bash -s -- \
      --non-interactive \
      --skip-computer-use

if [ "$(command -v hermes)" != "/usr/local/bin/hermes" ]; then
  echo "Hermes launcher was not installed system-wide in /usr/local/bin." >&2
  exit 1
fi

for launcher in /usr/local/bin/hermes /usr/local/bin/hermes-agent /usr/local/bin/hermes-acp; do
  if [ -f "${launcher}" ]; then
    sed -i '/^unset PYTHONPATH$/i export PLAYWRIGHT_BROWSERS_PATH=/usr/local/share/hermes-agent/ms-playwright' "${launcher}"
  fi
done
