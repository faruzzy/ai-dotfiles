# ai-dotfiles

Personal config for Claude Code and Codex: global instructions, skills, and settings, symlinked into `~/.claude` and `~/.codex`.

```bash
./install.sh --dry-run   # show what would change
./install.sh             # apply (idempotent; backups go to ~/.ai-dotfiles-backup/)
```

## What goes where

| In this repo | Installed as | How |
|---|---|---|
| `global/AGENTS.md` | `~/.claude/CLAUDE.md`, `~/.codex/AGENTS.md` | symlink (one file for both tools) |
| `skills/<name>/` | `~/.claude/skills/<name>`, `~/.codex/skills/<name>` | symlink per skill |
| `claude/settings.json` | `~/.claude/settings.json` | symlink |
| `codex/ai-dotfiles.rules` | `~/.codex/rules/ai-dotfiles.rules` | symlink |
| `codex/config.base.toml` | keys inside `~/.codex/config.toml` | merged, because the Codex app owns that file |
| `mcp/servers.txt` | Claude Code (user scope) and Codex MCP config | `claude mcp add` / `codex mcp add`, skipped if already registered |

## Skills

| Skill | Use it for |
|---|---|
| `grilling` / `/grill-me` | Interview me in rounds, with a recommended answer for each question, before planning |
| `spec-driven-development` | Write a spec before a new project or significant feature |
| `planning-and-task-breakdown` | Turn a spec into ordered, verifiable tasks / milestones |
| `incremental-implementation` | Build in thin slices, verifying each one |
| `tdd` | Red → green, testing at agreed seams |
| `diagnosing-bugs` | Build a failing feedback loop before hypothesising |
| `source-driven-development` | Check official docs for the installed version before coding |
| `shipping-and-launch` | Pre-deploy checklist, staged rollout, rollback plan |
| `wizard` | Generate an interactive script for steps only I can do (AWS console, secrets) |
| `fallow` | TS/JS check for unused code, circular imports, duplication; `audit` after edits |
| `socratic-tutor` | "Teach me X": diagnostic, skill map, one question at a time, until mastery; progress saved per topic |
| `/handoff` | Summarise the session for a fresh agent |
| `writing-for-agents` | Editing skills, CLAUDE.md, AGENTS.md (including this repo) |

Sources, pinned commits, and local modifications: [VENDORED.md](VENDORED.md).

## Adding a skill

Drop a directory with a `SKILL.md` into `skills/`, add a row to `VENDORED.md` if it came from elsewhere, and re-run `./install.sh`. Deleting a skill here and re-running removes its stale links.
