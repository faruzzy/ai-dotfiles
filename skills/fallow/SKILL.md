---
name: fallow
description: Check a TypeScript/JavaScript project for unused code and dependencies, circular imports, duplication, and complexity with the fallow CLI. Use after a non-trivial edit, before opening a PR, when asked to audit or health-check a TS/JS codebase, or before deleting an export that looks unused.
---

# fallow

[fallow](https://github.com/fallow-rs/fallow) is a fast static analyzer for TS/JS. Run it from the project root; it needs no config.

Use `npx fallow …`: it picks up the project's own version if it's a devDependency, and downloads the latest otherwise. Add `--format json --quiet` when you will parse the result; each command then prints one JSON document with `actions[]`, `auto_fixable`, and `next_steps[]` you can follow.

## Which command

| Question | Command |
|---|---|
| Did my change introduce problems? | `npx fallow audit` (vs the base branch) or `npx fallow audit --base <ref>` |
| Overall state of the codebase | `npx fallow` (health, duplication, unused code in one run) |
| Where is the code hardest to change? | `npx fallow health --score` |
| What's duplicated? | `npx fallow dupes` |
| What's unused? | `npx fallow dead-code` |
| Is this export really unused? | `npx fallow dead-code --trace <file>:<export>` |

Default to `audit` after edits. It reports only findings the change introduces, so pre-existing problems don't drown the signal.

## Reading the result

- Exit 0: pass or warn. Exit 1: findings at error severity, or audit fail. Exit 2: the run itself failed; report it, never hide it with `|| true`.
- Fix findings your change introduced as part of the task.
- Findings that already existed are out of scope: list them as follow-ups for the user, don't fix them unasked.

## Rules

- `npx fallow fix` deletes code. Run `npx fallow fix --dry-run` first, show the user what it would change, and apply only with their approval.
- Before deleting anything reported unused, confirm with `dead-code --trace`; dynamic imports and framework conventions can hide real uses.
- Never run `fallow watch`: it doesn't exit.
- Don't run `fallow agent install` or `fallow hooks install` unless asked: they write project files and git hooks.
