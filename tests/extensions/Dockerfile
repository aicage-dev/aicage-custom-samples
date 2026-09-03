# check=skip=InvalidDefaultArgInFrom
ARG FROM_IMAGE

FROM ${FROM_IMAGE}

ARG EXTENSION

RUN set -eu; \
  if command -v apk >/dev/null 2>&1; then \
    apk add --no-cache bash ca-certificates curl tar unzip xz; \
  elif command -v apt-get >/dev/null 2>&1; then \
    apt-get update && \
    apt-get install -y --no-install-recommends bash ca-certificates curl tar unzip xz-utils && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*; \
  elif command -v dnf >/dev/null 2>&1; then \
    dnf install -y bash ca-certificates curl tar unzip xz && \
    dnf clean all; \
  elif command -v pacman >/dev/null 2>&1; then \
    pacman -Sy --noconfirm --needed bash ca-certificates curl tar unzip xz && \
    pacman -Scc --noconfirm; \
  else \
    echo "Unsupported distro" >&2; \
    exit 1; \
  fi

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN --mount=type=bind,source=extensions/,target=/tmp/extensions,readonly \
    mkdir -p /tmp/extension-run && \
    cp -R /tmp/extensions/${EXTENSION}/scripts/. /tmp/extension-run/ && \
    for script in /tmp/extension-run/*.sh; do \
      sed -i 's/\r$//' "$script"; \
      chmod +x "$script"; \
      bash "$script"; \
    done && \
    rm -rf /tmp/extension-run

CMD ["/bin/bash", "-lc", "echo extension-ready"]
