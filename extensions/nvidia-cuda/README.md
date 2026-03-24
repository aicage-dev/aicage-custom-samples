# NVIDIA CUDA Extension

This extension installs NVIDIA CUDA user-space tooling into an `aicage` image.

## What it adds

- NVIDIA's CUDA package repository for the active distro
- The `cuda-toolkit` package
- Standard CUDA user-space libraries that come with the toolkit

This extension intentionally does **not** install:

- The NVIDIA kernel driver
- `nvidia-container-toolkit`
- Workload-specific libraries such as cuDNN, NCCL, TensorRT, or framework wheels

Those pieces either belong on the host or vary too much by application.

## Supported base images

The extension currently supports:

- Debian-like images by mapping to `debian<VERSION_ID without dots>`
- Ubuntu-like images by mapping to `ubuntu<VERSION_ID without dots>`
- Fedora-like images by mapping to `fedora<VERSION_ID>`
- `amd64` / `x86_64` only

The scripts validate that the corresponding NVIDIA repository actually exists
before attempting installation. If NVIDIA does not publish a matching repo for
the detected release, the build exits with a clear error.

Alpine is intentionally rejected. NVIDIA's CUDA packaging is published for DEB/RPM distro families, not Alpine's `apk` ecosystem.

## Script layout

The extension uses one top-level script per distro family because `aicage`
executes every script in `scripts/`:

- [scripts/01-alpine.sh](/home/stefan/development/github/aicage/aicage-custom-samples/extensions/nvidia-cuda/scripts/01-alpine.sh)
  errors out only on Alpine and exits early everywhere else
- [scripts/02-deb.sh](/home/stefan/development/github/aicage/aicage-custom-samples/extensions/nvidia-cuda/scripts/02-deb.sh)
  runs only on Debian/Ubuntu-family images
- [scripts/03-rpm.sh](/home/stefan/development/github/aicage/aicage-custom-samples/extensions/nvidia-cuda/scripts/03-rpm.sh)
  runs only on Fedora/RPM-family images

## Host requirements

For containers built with this extension to use an NVIDIA GPU, the host still needs:

1. An NVIDIA Linux driver installed on the host
2. `nvidia-smi` working on the host
3. NVIDIA Container Toolkit installed and configured for Docker on the host

The container uses the host's kernel driver. Do not try to install the NVIDIA driver inside the image.

## Runtime Docker args

`aicage` passes Docker args through to `docker run`. For NVIDIA GPUs, the important runtime flag is:

```bash
aicage --gpus all -- <agent>
```

To expose only selected GPUs:

```bash
aicage --gpus '"device=0"' -- <agent>
```

If you persist those args when prompted, `aicage` will reuse them for that project and agent.

## What may still be missing for your workload

`cuda-toolkit` is a reasonable base layer for CUDA development, but many applications need more:

- PyTorch or TensorFlow builds compiled for CUDA
- cuDNN for deep learning workloads
- NCCL for multi-GPU communication
- TensorRT for inference-focused images

Add those separately in your project image customization if your workload needs them.

## Notes

- This extension covers the in-container side only.
- Host-side GPU enablement is separate from image contents.
- CUDA user-space in the container must be compatible with the host driver. In
  practice, the host driver must be new enough for the CUDA version installed
  in the image.
- Fedora support assumes NVIDIA publishes a CUDA repository for the detected
  Fedora release. If a future Fedora version is not published yet, the build
  will fail when adding the repo.
- Post-install validation checks package state and presence of `libcudart.so`.
  It does not require `nvcc` to be on `PATH`.
