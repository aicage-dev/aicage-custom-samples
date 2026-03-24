# Aicage custom base-image: `amd-rocm-ubuntu` (Ubuntu + AMD ROCm)

This custom base-image starts from AMD's official ROCm dev image for Ubuntu and
then runs the full `aicage-image-base` install stack on top.

It is the cleaner option when you want ROCm to be part of the base image itself
instead of trying to add it later as an extension.

## What this base image gives you

- AMD's official ROCm userspace from the `FROM` image
- The normal `aicage` base tooling installed via the upstream
  `aicage/aicage-image-base` scripts
- A regular `aicage` entrypoint and environment on top of a ROCm-capable Ubuntu
  base

## What you still need on the host

The image alone is not enough for GPU access. The host still needs:

1. An AMD GPU and a ROCm-compatible host setup
2. `/dev/kfd` and `/dev/dri` present on the host
3. A host OS / GPU combination supported by the ROCm release you picked

The container uses the host kernel driver path. Do not install the AMD kernel
driver inside the image.

## Docker runtime args

`aicage` forwards Docker args to `docker run`. For ROCm containers, the common
runtime flags are:

```bash
aicage \
  --device /dev/kfd \
  --device /dev/dri \
  --group-add video \
  --security-opt seccomp=unconfined \
  -- <agent>
```

For some workloads AMD also documents these as common additions:

```bash
aicage \
  --device /dev/kfd \
  --device /dev/dri \
  --group-add video \
  --ipc host \
  --cap-add SYS_PTRACE \
  --security-opt seccomp=unconfined \
  -- <agent>
```

If you want to restrict access to specific GPUs, pass selected
`/dev/dri/renderD*` devices instead of the whole `/dev/dri` directory. `/dev/kfd`
is still required.

## Notes

- This sample uses an official `rocm/dev-ubuntu-*` image as `FROM`.
- The pinned tag in
  [base.yml](/home/stefan/development/github/aicage/aicage-custom-samples/base-images/amd-rocm-ubuntu/base.yml)
  should be updated over time as AMD publishes newer supported ROCm images.
- ROCm support is more matrix-driven than NVIDIA CUDA. Always verify that your
  GPU, host OS, and chosen ROCm release are supported together.
