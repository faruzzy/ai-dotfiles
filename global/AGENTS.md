# Global instructions

Applies to every project, in Claude Code (`~/.claude/CLAUDE.md`) and Codex (`~/.codex/AGENTS.md`). A project's own CLAUDE.md or AGENTS.md overrides anything here.

## How I like to work

- For anything bigger than a small fix: read the whole brief, propose a plan (structure, data model, milestones), ask the open questions, then wait for my approval before writing code.
- When you ask, give your recommended answer with each question so I can just say yes. Look up facts yourself; only ask me for decisions.
- Work in milestones and stop for my review after each one.
- A small, polished core beats broad, half-done coverage. Push back on scope creep, including mine. Don't over-architect.
- If something is unclear, ask instead of guessing.

## Scope

- Change only what the task needs. Don't refactor unrelated code, rename things, or add features I didn't ask for.
- When you notice an unrelated problem, leave it alone and keep a note. At the end, list those as follow-ups (where, what, why it matters) so I can decide whether to include them or handle them in a separate branch.
- If a fix still fails after two or three attempts, stop. Explain what you tried, what the evidence says, and what you'd try next, instead of looping.

## Code

- Comment only where a reader would otherwise struggle: a non-obvious reason, constraint, or workaround. Don't narrate what the code does. Keep comments short and in plain English.
- Derive, don't track. If a value can be computed from an existing source of truth (list length, timestamps, the DOM or buffer, props), compute it instead of adding a flag, cache, or copied state that has to be kept in sync. In React, compute during render rather than mirroring props into `useState` + `useEffect`. Store state only when it can't be derived (user choices, event history), and cache only for a measured cost, keyed on the underlying data.
- Keep control flow flat. Handle edge cases first with guard clauses and early returns. When a branch only contains another two-way decision, merge it into the outer if/else-if chain instead of nesting, unless that would repeat an expensive or meaningful condition. Compute values shared by several branches once, above them but after the guards that make them valid. Aim for a flat list of condition → action.

## Testing

- Before writing a new test, check whether an existing one covers the same behaviour; if so, extend it with assertions. Write a new test only for a new behaviour, so each test's name still says what it checks.
- Use table-driven cases (`it.each`, `parametrize`) instead of near-duplicate tests that differ only in inputs.
- Keep tests short: shared setup in helpers or fixtures, no filler comments, no asserting on implementation details.

## Correctness

- I often work with fast-moving tools (Next.js, Tailwind v4, Auth.js, AWS). Check the official docs for the installed version before relying on an API or config option you remember.
- Before calling something done, run the project's own checks (typecheck, lint, tests, build). If something fails or you skipped a step, say so plainly.
- Don't open pages in a browser (e.g. via Chrome DevTools MCP) unless I asked for it; if inspecting a page would help, ask first.
- Review your own changes as skeptically as someone else's. Look for what's wrong, not for confirmation. For non-trivial work, get an independent review from a fresh subagent that sees the diff, not your reasoning.

## Git

- Don't run git commands that change repository state (add, commit, push, merge, rebase, reset, amend, cherry-pick, stash, branch deletion, force-push) unless my current message asks for that operation. Approval from an earlier message doesn't carry over, and don't offer to run them. Read-only commands (status, diff, log, show, blame) and editing files are always fine.
- Commit messages, when I ask for a commit: Conventional Commits, `type(scope): imperative subject`, with a body explaining why when it isn't obvious.
- Commit grouping: each commit is one logical change. Put related edits together, even across files, and split unrelated ones into separate commits instead of one catch-all. Don't split a single change into many tiny commits either.
- Never add a `Co-Authored-By` trailer or a "Generated with …" line to commits or PR descriptions. The history should read as mine.

## Reporting

- End-of-task reports cover only what the diff doesn't show: surprises, behaviour changes, verification (what you ran, what passed or failed), deliberate deviations from the plan or these instructions, and follow-ups. Don't recap the diff or list "updated X to say Y".

## Environment

- macOS on Apple Silicon, zsh, Neovim, tmux. Runtimes come from `mise`.
- The same configs run on two Macs (personal and work) with different usernames. Use `$HOME` or `~`, never a hardcoded `/Users/<name>` path, in anything committed.
