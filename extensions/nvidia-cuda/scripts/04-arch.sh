#!/usr/bin/env bash
set -euo pipefail

if ! command -v pacman >/dev/null 2>&1; then
  exit 0
fi

case "$(uname -m)" in
  x86_64)
    ;;
  *)
    echo "Unsupported architecture for this extension: $(uname -m)" >&2
    echo "The Arch Linux CUDA package is currently available for x86_64 only." >&2
    exit 1
    ;;
esac

pacman -Sy --noconfirm --needed cuda
pacman -Scc --noconfirm
rm -rf /var/cache/pacman/pkg/* /var/lib/pacman/sync/*

cuda_bin_dir=""
for candidate in /opt/cuda/bin /usr/local/cuda/bin /usr/local/cuda-*/bin; do
  if [[ -x "${candidate}/nvcc" ]]; then
    cuda_bin_dir="${candidate}"
    break
  fi
done

if [[ -z "${cuda_bin_dir}" ]]; then
  echo "CUDA compiler nvcc was not found after installation." >&2
  exit 1
fi

ln -sf "${cuda_bin_dir}/nvcc" /usr/local/bin/nvcc
echo "Exposed CUDA compiler on PATH: nvcc"

mkdir -p /usr/local/share/aicage-extensions
printf '%s\n' "cuda" >/usr/local/share/aicage-extensions/nvidia-cuda.txt

if pacman -Q cuda >/dev/null 2>&1; then
  echo "Verified package install: cuda"
else
  echo "cuda was installed, but pacman could not verify package state." >&2
  exit 1
fi

if find /opt/cuda /usr/local -type f \( -name 'libcudart.so' -o -name 'libcudart.so.*' \) 2>/dev/null | grep -q .; then
  echo "Verified CUDA runtime library: libcudart.so"
else
  echo "CUDA runtime library libcudart.so was not found under /opt/cuda or /usr/local after installation." >&2
  exit 1
fi
