# Aicage custom base-image: `nvidia-cuda-ubuntu` (Ubuntu + NVIDIA CUDA)

This custom base-image starts from NVIDIA's official CUDA devel image for Ubuntu
and then runs the full `aicage-image-base` install stack on top.

It is the cleaner option when you want CUDA to be part of the base image itself instead of trying to add it later as an extension.

## What this base image gives you

- NVIDIA's official CUDA userspace from the `FROM` image
- The normal `aicage` base tooling installed via the upstream `aicage/aicage-image-base` scripts
- A regular `aicage` entrypoint and environment on top of a CUDA-capable Ubuntu base

## What you still need on the host

The image alone is not enough for GPU access. The host still needs:

1. An NVIDIA Linux driver installed on the host
2. `nvidia-smi` working on the host
3. NVIDIA Container Toolkit installed and configured for Docker

The container uses the host kernel driver. Do not install the NVIDIA driver inside the image.

## Docker runtime args

`aicage` forwards Docker args to `docker run`, so the key runtime flag is:

```bash
aicage --gpus all -- <agent>
```

To expose only one GPU:

```bash
aicage --gpus '"device=0"' -- <agent>
```

Those args can be persisted by `aicage` for the current project and agent.

## Notes

- This sample uses an official `nvidia/cuda` Ubuntu image as `FROM`.
- The pinned tag in
  [base.yml](/home/stefan/development/github/aicage/aicage-custom-samples/base-images/nvidia-cuda-ubuntu/base.yml)
  should be updated over time as NVIDIA publishes newer supported CUDA images.
- This sample is Ubuntu-based. If you need a Fedora-family CUDA base, add a
  separate custom base instead of trying to make one base span multiple distro
  families.
