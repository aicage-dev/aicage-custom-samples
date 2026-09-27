#!/usr/bin/env bash
set -euo pipefail

curl \
  -fsSL \
  --retry 8 \
  --retry-all-errors \
  --retry-delay 2 \
  --max-time 300 \
  https://hermes-agent.nousresearch.com/install.sh |
  HOME=/usr/local/share/hermes-agent \
    HERMES_HOME=/usr/local/share/hermes-agent \
    PLAYWRIGHT_BROWSERS_PATH=/usr/local/share/hermes-agent/ms-playwright \
    UV_CACHE_DIR=/usr/local/share/hermes-agent/uv/cache \
    UV_TOOL_DIR=/usr/local/share/hermes-agent/uv/tools \
    bash -s -- \
    --non-interactive

# Hermes publishes source-install launchers in HOME/.local/bin.
# The image exposes commands through /usr/local/bin instead.
launcher_dir=/usr/local/share/hermes-agent/.local/bin
shopt -s nullglob
for launcher in "${launcher_dir}"/hermes*; do
  if [ -f "${launcher}" ]; then
    install -m 0755 "${launcher}" "/usr/local/bin/$(basename "${launcher}")"
    rm -f "${launcher}"
  fi
done
shopt -u nullglob

if [ "$(command -v hermes)" != "/usr/local/bin/hermes" ]; then
  echo "Hermes launcher was not installed system-wide in /usr/local/bin." >&2
  exit 1
fi

for launcher in /usr/local/bin/hermes /usr/local/bin/hermes-agent /usr/local/bin/hermes-acp; do
  if [ -f "${launcher}" ]; then
    sed -i '/^unset PYTHONPATH$/i export PLAYWRIGHT_BROWSERS_PATH=/usr/local/share/hermes-agent/ms-playwright' "${launcher}"
  fi
done
