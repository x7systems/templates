# Templates

Rules, templates and examples for everything x7systems projects produce: READMEs, Taskfiles, scripts, configs. One folder per kind of file.

## Structure

```
templates/
├── README.md          # this file: how the repo is organized
├── LICENSE            # WTFPL
├── play/
│   ├── rules.md       # how to record game launch setups
│   └── <game>/        # one folder per game, README.md inside
├── readme/
│   ├── rules.md       # how to write a README
│   ├── template.md    # fill-in skeleton
│   └── example.md     # filled-in sample
└── taskfile/
    ├── rules.md       # structure and output convention for go-task
    ├── Taskfile.yml   # runnable example
    └── scripts/       # example script the Taskfile calls
```

## Usage

1. Open the folder for the file you are writing.
2. Read `rules.md` fully.
3. Copy the template or example into the project and fill it in.

Templates are a starting point, not a dependency. Do not link to this repo from project files.

## Folder contract

Every top-level folder is one kind of file (`readme`, `taskfile`, `nix`, `systemd`, ...) and contains:

| File          | Required | Purpose                                                      |
|---------------|----------|--------------------------------------------------------------|
| `rules.md`    | yes      | How to write this kind of file: structure, style, checks     |
| `template.*`  | no       | Skeleton with `<placeholders>`, nothing project-specific     |
| `example.*`   | no       | Filled-in sample that follows `rules.md` and works as is     |
| `scripts/`    | no       | Helpers the example calls; executable, `#!/usr/bin/env bash` |
| `<item>/`     | no       | One subfolder per item when `rules.md` says so (`play/<game>/`) |

- Folder name: singular, the tool or file type (`readme`, not `readmes`; `taskfile`, not `go-task`).
- `rules.md` comes first. No template or example without rules.
- A `rules.md` covers one kind of file. Two kinds, two folders.
- Examples must run or render; broken examples are deleted, not kept.
- Repo-wide conventions live only here, in this README.

## Naming

Applies to every new folder and file.

- English only.
- Lowercase only.
- Spaces become `-`: `The Riftbreaker` → `the-riftbreaker`, `Subnautica 2` → `subnautica-2`.
- Drop other punctuation and subtitles after `:`: `Cosmoteer: Starship Architect & Commander` → `cosmoteer`.
- Exceptions, by convention of the tool: `README.md`, `LICENSE`, `Taskfile.yml`.

## Privacy

The repo is public. Nothing in it may point to a specific person or machine.

- Not allowed: host names, user names, real names, emails, home paths (`/home/<user>`), private domains and IPs, account and app ids, serial numbers, tokens, paths into private repos.
- Allowed: technical values the setup needs to work, such as GPU vendor:device ids, display connectors (`DP-3`), resolutions, refresh rates, tool flags, env vars.
- Exception: the copyright holder in `LICENSE`.
- Replace a personal value with a placeholder (`<host>`, `<user>`) or a reserved example (`example.com`, `192.0.2.1`).
- Describe custom wrappers by what they do, not where they live.

## Writing rules.md

- Follow [readme/rules.md](readme/rules.md): short, plain, no emoji, English.
- Sections, in order: principles, structure, style, verification. Add a copy-paste block if the rules depend on exact text (colors, headers, functions).
- Blocks marked "copy verbatim" are copied, never regenerated.
- State the "why" for a rule when it is not obvious: a pitfall, an incident, a tool limit.
- End with a checklist or a verification procedure the reader can run.

## Changing this repo

- New kind of file: add the folder with `rules.md`, add it to the tree above, one commit.
- Changed rule: update the template and example in the same commit so they still match.
- Commit messages: English, imperative mood (`Add nix rules`, `Fix defer in Taskfile example`).
- Before commit: examples run, scripts pass `bash -n` and `shellcheck`, no CRLF.

## License

[WTFPL](LICENSE)
