# NVIDIA CUDA Extension

Use it with Docker argument `--gpus all`.

Host requirements:

1. NVIDIA driver installed
2. `nvidia-smi` working on the host
3. NVIDIA Container Toolkit configured for Docker

This extension installs CUDA userspace in the image.

Supported image families:

- Debian/Ubuntu via `dpkg`
- Fedora/RPM via `rpm` and `dnf`
- Arch Linux via `pacman`
- `amd64` / `x86_64` only

It does not install the kernel driver or NVIDIA Container Toolkit.
