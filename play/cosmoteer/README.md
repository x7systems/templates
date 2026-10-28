# Cosmoteer: Starship Architect & Commander

## Launch options

```text
__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia __VK_LAYER_NV_optimus=NVIDIA_only PROTON_NO_FSYNC=1 gpu-game -- gamescope --prefer-vk-device 8086:a788 -w 2560 -h 1600 -W 2560 -H 1600 -f -r 240 --prefer-output eDP-1 -F linear --   gamemoderun %command%
```

## Compatibility

Proton: `proton_experimental` (per-game override).

## Flags

| Flag                                    | Meaning                                                         |
|-----------------------------------------|-----------------------------------------------------------------|
| `__NV_PRIME_RENDER_OFFLOAD=1`           | Render on the NVIDIA dGPU (PRIME offload)                       |
| `__GLX_VENDOR_LIBRARY_NAME=nvidia`      | Use the NVIDIA GLX library for OpenGL                           |
| `__VK_LAYER_NV_optimus=NVIDIA_only`     | Expose only the NVIDIA GPU to Vulkan                            |
| `PROTON_NO_FSYNC=1`                     | Disable fsync in Proton                                         |
| `gpu-game --`                           | Custom wrapper: locks NVIDIA clocks, runs the game with swap off |
| `--prefer-vk-device 8086:a788`          | gamescope composites on the Intel iGPU                          |
| `-w 2560 -h 1600` / `-W 2560 -H 1600`   | Game and output both 2560x1600                                  |
| `-f`                                    | Fullscreen                                                      |
| `-r 240`                                | Game refresh rate 240                                           |
| `--prefer-output eDP-1`                 | Show on the laptop panel                                        |
| `-F linear`                             | Linear upscale filter                                           |
| `gamemoderun`                           | Run under Feral GameMode                                        |

## Hardware

Intel iGPU `8086:a788` (compositing) + NVIDIA dGPU, laptop panel `eDP-1` (2560x1600, 240 Hz).

`gpu-game` is a custom wrapper, not a standard tool. It runs `nvidia-smi -lgc <min,max>` (resets with `-rgc` on exit) and starts the game in `systemd-run --user --scope -p MemorySwapMax=0`. Without it, drop `gpu-game --` from the string.
