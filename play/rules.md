# Play rules

How to record what a game needs to run on Linux (Steam, Proton, gamescope).

## Layout

One folder per game, named by the naming rules in the root README. Inside, one `README.md`:

1. **Title** — store name as `# H1`.
2. **Launch options** — the exact string from Steam, in a `text` block, copied verbatim.
3. **Compatibility** — Proton version if overridden for this game, or "Steam default".
4. **Flags** — table: flag, what it does. Only flags in the string above.
5. **Hardware** — what the string depends on: GPU ids, connectors, resolutions, custom wrappers and what they do. Skip if nothing.

## Rules

- Copy launch options verbatim from `userdata/<id>/config/localconfig.vdf` (`LaunchOptions`). Do not retype.
- Explain every flag. Look up the meaning in the tool itself (`gamescope --help`), not from memory.
- Hardware-specific values (`--prefer-vk-device 8086:a788`, `--prefer-output DP-3`) stay as is and are explained in **Hardware**.
- One game, one folder. A variant for other hardware goes into the same README as a second **Launch options** block, titled by the hardware (`Launch options: laptop panel`).
- No personal data: see **Privacy** in the root README.
