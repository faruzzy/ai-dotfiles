# Global instructions

Applies to every project, in Claude Code (`~/.claude/CLAUDE.md`) and Codex (`~/.codex/AGENTS.md`). A project's own CLAUDE.md or AGENTS.md overrides anything here.

## How I like to work

- For anything bigger than a small fix: read the whole brief, propose a plan (structure, data model, milestones), ask the open questions, then wait for my approval before writing code.
- When you ask, give your recommended answer with each question so I can just say yes. Look up facts yourself; only ask me for decisions.
- Work in milestones and stop for my review after each one. Commit at the end of a milestone; otherwise commit only when I ask.
- A small, polished core beats broad, half-done coverage. Push back on scope creep, including mine. Don't over-architect.
- If something is unclear, ask instead of guessing.

## Scope

- Change only what the task needs. Don't refactor unrelated code, rename things, or add features I didn't ask for.
- When you notice an unrelated problem, leave it alone and keep a note. At the end, list those as follow-ups (where, what, why it matters) so I can decide whether to include them or handle them in a separate branch.
- If a fix still fails after two or three attempts, stop. Explain what you tried, what the evidence says, and what you'd try next, instead of looping.

## Code

- Comment only where a reader would otherwise struggle: a non-obvious reason, constraint, or workaround. Don't narrate what the code does. Keep comments short and in plain English.

## Correctness

- I often work with fast-moving tools (Next.js, Tailwind v4, Auth.js, AWS). Check the official docs for the installed version before relying on an API or config option you remember.
- Before calling something done, run the project's own checks (typecheck, lint, tests, build). If something fails or you skipped a step, say so plainly.
- Don't open pages in a browser (e.g. via Chrome DevTools MCP) unless I asked for it; if inspecting a page would help, ask first.
- Review your own changes as skeptically as someone else's. Look for what's wrong, not for confirmation. For non-trivial work, get an independent review from a fresh subagent that sees the diff, not your reasoning.

## Git

- Commit messages: Conventional Commits, `type(scope): imperative subject`, with a body explaining why when it isn't obvious.
- Commit grouping: each commit is one logical change. Put related edits together, even across files, and split unrelated ones into separate commits instead of one catch-all. Don't split a single change into many tiny commits either.
- Never add a `Co-Authored-By` trailer or a "Generated with …" line to commits or PR descriptions. The history should read as mine.
- Never force-push, rewrite pushed history, or delete branches without asking.

## Environment

- macOS on Apple Silicon, zsh, Neovim, tmux. Runtimes come from `mise`.
- The same configs run on two Macs (personal and work) with different usernames. Use `$HOME` or `~`, never a hardcoded `/Users/<name>` path, in anything committed.
