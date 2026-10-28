# README rules

A README answers three questions in under a minute: what is this, how do I run it, where is more.

## Principles

- Short. If it scrolls more than two screens, move details to `doc/`.
- Plain. Write for a person who has never seen the project.
- Verified. Every command was run, every path exists.
- No decoration. No emoji, no badges wall, no ASCII banners, no marketing words.

## Structure

Use these sections, in this order. Skip a section that has nothing to say.

1. **Title** — project name as `# H1`.
2. **Summary** — one or two sentences: what it does and for whom. No "this project is...".
3. **Install / Requirements** — only what is needed before the first run.
4. **Usage** — the most common command or example first, copy-paste ready.
5. **Configuration** — table of options: name, default, meaning. Only if there are options.
6. **Structure** — directory tree, only if the layout is not obvious.
7. **More** — links to `doc/`, contributing, license.

## Writing style

- Imperative mood: "Run `task build`", not "You can run `task build`".
- One idea per sentence. Short sentences.
- Say what, not how nice: "Builds firmware and flashes it", not "A powerful tool for...".
- Use the same word for the same thing everywhere.
- Language is English unless the whole project is not.

## Formatting

- One `# H1`, then `##` sections. Do not skip heading levels.
- Code and commands in fenced blocks with a language tag (`bash`, `yaml`, `text`).
- Inline `code` for commands, paths, flags and values.
- Tables for options and comparisons; lists for steps.
- Relative links for files in the repo.
- No trailing "Thanks", "Enjoy", "Happy coding".

## Commands

- Show the command and, when it matters, the expected result.
- Prefer the project entry point (`task <name>`, `make <name>`) over raw tool calls.
- Mark placeholders with angle brackets: `<host>`, `<name>`.

## Maintenance

- Change behavior, change the README in the same commit.
- Remove sections that went stale instead of leaving them.
- Do not duplicate what `--help`, `task --list` or the code already says; point to it.

## Checklist

- [ ] Summary fits in two sentences
- [ ] First command works when copy-pasted
- [ ] No emoji, no empty sections
- [ ] All links and paths resolve
- [ ] Under ~100 lines
