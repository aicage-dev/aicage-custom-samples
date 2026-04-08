#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"

cd "${REPO_ROOT}"

if [[ -d .venv ]]; then
  # shellcheck disable=SC1091
  source .venv/bin/activate

  if [[ ! -f .venv/bin/pymarkdown ]]; then
    echo "Install lint deps"
    pip install -r requirements-dev.txt
  fi
fi

echo "Validate agent.yml files with schema"
check-jsonschema \
  --schemafile validation/agent.schema.json \
  agents/*/agent.y*ml

echo "Validate base.yml files with schema"
check-jsonschema \
  --schemafile validation/base.schema.json \
  base-images/*/base.y*ml

echo "Validate extension.yml files with schema"
check-jsonschema \
  --schemafile validation/extension.schema.json \
  extensions/*/extension.y*ml

echo "Run yamllint"
yamllint .

mapfile -t shell_scripts < <(find . -type f -name '*.sh' -not -path './.venv/*' | sort)

echo "Validate shell scripts with bash -n"
for script in "${shell_scripts[@]}"; do
  bash -n "${script}"
done

if command -v shellcheck >/dev/null 2>&1 && [[ ${#shell_scripts[@]} -gt 0 ]]; then
  echo "Run shellcheck"
  shellcheck -x "${shell_scripts[@]}"
fi

echo "Validate Markdown"
pymarkdown --config .pymarkdown.json scan --recurse --exclude '.venv/**' .
