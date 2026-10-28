# Terraria

## Launch options

```text
__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia __VK_LAYER_NV_optimus=NVIDIA_only gamescope --prefer-vk-device 8086:a788 -w 4096 -h 1728 -W 5120 -H 2160 -f -r 120 -F linear   -- %command%
```

## Compatibility

No per-game override. Steam default.

## Flags

| Flag                                    | Meaning                                                    |
|-----------------------------------------|------------------------------------------------------------|
| `__NV_PRIME_RENDER_OFFLOAD=1`           | Render on the NVIDIA dGPU (PRIME offload)                  |
| `__GLX_VENDOR_LIBRARY_NAME=nvidia`      | Use the NVIDIA GLX library for OpenGL                      |
| `__VK_LAYER_NV_optimus=NVIDIA_only`     | Expose only the NVIDIA GPU to Vulkan                       |
| `--prefer-vk-device 8086:a788`          | gamescope composites on the Intel iGPU                     |
| `-w 4096 -h 1728`                       | Game renders at 4096x1728                                  |
| `-W 5120 -H 2160`                       | gamescope outputs at 5120x2160                             |
| `-f`                                    | Fullscreen                                                 |
| `-r 120`                                | Game refresh rate 120                                      |
| `-F linear`                             | Linear upscale filter                                      |

## Hardware

Intel iGPU `8086:a788` (compositing) + NVIDIA dGPU (rendering), 5120x2160 monitor. Change the device id and resolutions to match yours.
