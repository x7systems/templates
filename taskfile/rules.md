# Taskfile rules

Conventions for [go-task](https://taskfile.dev) `Taskfile.yml` and for scripts its tasks call (`build.sh`, `.scripts/*`).
Reference implementation: the `voyager` task (a 6-stage build, flash and QMK pin pipeline).

## Output principle

Taskfile talks to a human through five message types, each with one fixed look.
Output of third-party programs (nix, make, rsync, qmk) is never recolored or filtered.

| Type    | Function | Style           | ANSI   | Format                          | Stream | When                                          |
|---------|----------|-----------------|--------|---------------------------------|--------|-----------------------------------------------|
| stage   | `stage`  | bold blue       | `1;34` | blank line + `▶ [n/N] Title`    | stdout | start of every stage                          |
| detail  | `info`   | plain (default) | none   | `  text` (2-space indent)       | stdout | values, paths, progress inside a stage        |
| important | `note` | bold white      | `1;37` | `  text` (2-space indent)       | stdout | user action needed, or a key value            |
| success | `ok`     | bold green      | `1;32` | blank line + `✓ Done: <task>`   | stdout | task summary, only from the Taskfile `defer`  |
| error   | `fail`   | bold red        | `1;31` | blank line + `✗ <reason>`       | stderr | task summary on failure, or the failure reason |

- Plain text uses the terminal default color. No other colors or styles exist; no non-bold blue, green or red.
- Color only when stdout is a terminal and `NO_COLOR` is unset. Otherwise print the same text without ESC codes; blank lines and the `▶ ✓ ✗` markers stay.
- `[n/N]` only when all stages of one run are known upfront and live in one place (one task or one script). The owner of the stages does the numbering. If stages are spread across subtasks, use a title without numbers.
- Every message answers one thing: what is happening (`stage`), what is it doing (`info`), what must I do (`note`), did it work (`ok` / `fail`).

## Taskfile block (YAML)

Top-level `vars:`, copy verbatim. Do not regenerate the color codes.

```yaml
vars:
  # Output convention: stage/info/note/ok/fail, color only on a TTY.
  # Prefix a cmd with {{.LOG}} to get the functions; each cmd is a separate shell.
  LOG: >-
    if [ -t 1 ] && [ -z "${NO_COLOR:-}" ]; then
    _b=$(printf '\033[1;34m'); _w=$(printf '\033[1;37m'); _g=$(printf '\033[1;32m'); _r=$(printf '\033[1;31m'); _0=$(printf '\033[0m');
    else _b= _w= _g= _r= _0=; fi;
    stage() { printf '\n%s▶ %s%s\n' "$_b" "$*" "$_0"; };
    info() { printf '  %s\n' "$*"; };
    note() { printf '  %s%s%s\n' "$_w" "$*" "$_0"; };
    ok() { printf '\n%s✓ %s%s\n' "$_g" "$*" "$_0"; };
    fail() { printf '\n%s✗ %s%s\n' "$_r" "$*" "$_0" >&2; };
```

Usage:

```yaml
tasks:
  build:
    desc: Build the thing, then deploy it
    cmds:
      # Summary line: only in tasks with 2+ stages, always the FIRST cmd.
      - defer: '{{.LOG}} if [ -n "{{.EXIT_CODE}}" ]; then fail "Failed: {{.TASK}} (exit {{.EXIT_CODE}})"; else ok "Done: {{.TASK}}"; fi'
      - '{{.LOG}} stage "[1/2] Build"'
      - make build
      - '{{.LOG}} stage "[2/2] Deploy"; note "Press the reset button now"'
      - ./deploy.sh
      # Multi-line cmd: {{.LOG}} on its own first line
      - |
        {{.LOG}}
        stage "Verify"
        info "target: $HOST"
```

- `{{.EXIT_CODE}}` in `defer` is empty on success and holds the code on failure. `{{.TASK}}` is the task name.
- go-task appends its own `task: Failed to run task ...` line under our `✗`. This is expected.
- A subtask called via `task:` prints its stages but **not** the summary, or you get a double `Done`. The summary (`defer`) lives only in the entry-point task.
- A one-stage task: one `stage`, no `defer`.

## Bash script block

Right after `set`, copy verbatim. Remove your own `die()` — it is already here.

```bash
set -Eeuo pipefail

# Output convention: stage/info/note/ok/fail, color only on a TTY.
if [[ -t 1 && -z ${NO_COLOR:-} ]]; then
  _b=$'\e[1;34m' _w=$'\e[1;37m' _g=$'\e[1;32m' _r=$'\e[1;31m' _0=$'\e[0m'
else
  _b='' _w='' _g='' _r='' _0=''
fi
_failed='' _line=''
stage() { printf '\n%s▶ %s%s\n' "$_b" "$*" "$_0"; }
info()  { printf '  %s\n' "$*"; }
note()  { printf '  %s%s%s\n' "$_w" "$*" "$_0"; }
ok()    { printf '\n%s✓ %s%s\n' "$_g" "$*" "$_0"; }
fail()  { _failed=1; printf '\n%s✗ %s%s\n' "$_r" "$*" "$_0" >&2; }
die()   { fail "$*"; exit 1; }
trap '_line=$LINENO' ERR
_on_exit() { local rc=$?; [[ $rc -eq 0 || -n $_failed ]] || fail "Failed at line ${_line:-?} (exit $rc)"; }
trap _on_exit EXIT
```

- `-E` is required: without it the ERR trap does not fire inside functions and the line number is lost.
- A script **never** prints `ok "Done"`. The Taskfile prints the summary. On error the script prints the reason (`die "..."` or `Failed at line N`), the Taskfile prints the summary. Two red lines on failure is by design.
- `exec cmd` at the end of a script replaces the process, so the EXIT trap does not run. The Taskfile `defer` catches the failure instead.
- A one-liner in YAML, not a script: use the YAML block.
- Shebang: `#!/usr/bin/env bash`. File is executable, LF line endings.

## Expected result

```text

▶ [1/3] Resolve Oryx revision
  revision abc123 (firmware 24)

▶ [2/3] Build firmware
<make output as is>

▶ [3/3] Flash with zapp
  Press the reset button on the Voyager        <- note (bold white)

✓ Done: voyager                                <- ok from the Taskfile defer
```

## Taskfile structure

- `version: '3'`, then **`silent: true` at the top level**. go-task command echo is off; stages are announced only via `stage`. For debugging `task -v <name>` still prints commands. No per-task `silent`.
- **Header comment** with a usage block: `#   task <name> [-- args]   # what it does`, grouped by section. New or renamed task: update the header in the same change.
- **`desc:` on every task** except `internal: true`. If the task takes arguments, `desc` shows usage: `'... — task x -- <name> (VAR=default)'`.
- **Sections** by domain with a separator:
  ```yaml
  # ===========================================================================
  # Section name
  #
  # Why this section exists / shared caveats.
  # ===========================================================================
  ```
- **Comments in English**, about *why* (pitfalls, incident history, host limits), not a retelling of the command.
- **Arguments:** positional via `task x -- a b` → `{{.CLI_ARGS}}`; options via `VAR=value` with a default `'{{.VAR | default "x"}}'` in the task `vars:`.
- **Checks before running:** `preconditions:` with `sh:` and a clear `msg:` (usage, "run only on host X"). Not `if ... exit` inside cmds.
- **Destructive tasks** (delete, destroy, release, wipe): `prompt: '<what will be lost>?'` plus a `preconditions` check that the target exists. Mark `(asks first)` in `desc`.
- **Thin YAML:** more than ~10 lines of logic, loops or JSON parsing go into a separate script next to the project. The task only calls it.
- **Paths** via a computed variable (`{{.TASKFILE_DIR}}`, `DOTFILES`), never a hardcoded `~`.
- **Platform-specific tasks:** `platforms: [linux]` / `[darwin]`.
- **Long tool lists** (a `nix shell` with many packages, a `docker run` line) go into a named var, not inline in the task.

## Verify after editing

1. `task --list` in the Taskfile directory: YAML parses, every `desc` is present.
2. For every changed script: `bash -n <file>` and `shellcheck <file>` with no findings.
3. Run at least one changed task for real and read the output. If a real run is dangerous (flashing, deploy, delete), run up to the first error or a safe subtask.
4. Check output without a TTY: `task <name> | cat` shows no ESC codes.
