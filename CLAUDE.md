# CLAUDE.md

Instructions for working on this repo. (The *global* instructions that apply everywhere are in `global/AGENTS.md`. Don't confuse the two.)

## What this is

Config for Claude Code and Codex, installed into `$HOME` by `install.sh`. Most targets are symlinks back into this repo, so the tools themselves write here: `/config` or `/permissions` in Claude Code edits `claude/settings.json`. Review those diffs before committing.

The same repo runs on two Macs (personal and work) with different usernames. No hardcoded `/Users/<name>` paths; `install.sh` derives everything from `$HOME` and its own location.

## Constraints

- `~/.codex/config.toml` is never symlinked: the Codex app rewrites it with machine-specific paths. Shared keys go in `codex/config.base.toml` as single-line top-level `key = value`; `install.sh` merges them. Tables aren't supported by the merge.
- Codex appends "always allow" approvals to `~/.codex/rules/default.rules`, which stays local. Shared rules go in `codex/ai-dotfiles.rules`; keep them generic (no absolute paths, no one-off commands).
- Skills must work in both tools: plain `SKILL.md` frontmatter (`name`, `description`), relative links that stay inside the skill directory (each skill is symlinked on its own, so `../` escapes it). Codex-specific metadata lives in `agents/openai.yaml`.
- Vendored skills: record upstream, pinned commit, and every local edit in `VENDORED.md`.
- Use the `writing-for-agents` skill when editing skills or the global instructions.

## Validating changes

- `bash -n install.sh` then `./install.sh --dry-run`.
- To test install.sh in isolation: `HOME=$(mktemp -d) CODEX_HOME= ./install.sh`.
- After installing, start a new session: `/skills` in Claude Code, the skill picker in Codex.
