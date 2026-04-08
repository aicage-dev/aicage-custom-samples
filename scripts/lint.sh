#!/usr/bin/env bash
set -euo pipefail

repo_root=$(git rev-parse --show-toplevel)
cd "$repo_root"

echo "Validate YAML"
yamllint .

echo "Validate Markdown"
pymarkdown --config .pymarkdown.json scan --recurse --exclude '.venv/**' .

mapfile -t shell_scripts < <(find . -type f -name '*.sh' -not -path './.venv/*' | sort)

if [[ ${#shell_scripts[@]} -gt 0 ]]; then
  echo "Validate shell scripts with bash -n"
  for script in "${shell_scripts[@]}"; do
    bash -n "${script}"
  done

  echo "Run shellcheck"
  shellcheck -x "${shell_scripts[@]}"
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
