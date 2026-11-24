# Global instructions

Applies to every project, in Claude Code (`~/.claude/CLAUDE.md`) and Codex (`~/.codex/AGENTS.md`). A project's own CLAUDE.md or AGENTS.md overrides anything here.

## How I like to work

- For anything bigger than a small fix: read the whole brief, propose a plan (structure, data model, milestones), ask the open questions, then wait for my approval before writing code.
- When you ask, give your recommended answer with each question so I can just say yes. Look up facts yourself; only ask me for decisions.
- Work in milestones and stop for my review after each one.
- A small, polished core beats broad, half-done coverage. Push back on scope creep, including mine. Don't over-architect.
- If something is unclear, ask instead of guessing.
- When I ask a question, answer it before editing files or running anything that changes state.

## Scope

- Change only what the task needs. Don't refactor unrelated code, rename things, or add features I didn't ask for.
- When you notice an unrelated problem, leave it alone and keep a note. At the end, list those as follow-ups (where, what, why it matters) so I can decide whether to include them or handle them in a separate branch.
- If a fix still fails after two or three attempts, test the premise before anything else: write down the one assumption every attempt shared, and run a check whose result would differ if it were false. Then stop and explain what you tried, what the evidence says, and what you'd try next, instead of looping.

## Code

- Comment only where a reader would otherwise struggle: a non-obvious reason, constraint, or workaround. Don't narrate what the code does. Keep comments short and in plain English.
- Write comments and docs from the code's vantage at HEAD, not your session's. A reader with no access to this conversation, the PR, or your drafts must be able to resolve every reference: no change narration ("used to", "no longer", "this PR adds"), no arguing with a reviewer ("this is safe because…"), no hedges ("probably fine for now"); state the current behaviour or invariant instead. A fixed regression reads as "without X, Y happens". Change history belongs in commit messages and PR descriptions.
- Derive, don't track. If a value can be computed from an existing source of truth (list length, timestamps, the DOM or buffer, props), compute it instead of adding a flag, cache, or copied state that has to be kept in sync. In React, compute during render rather than mirroring props into `useState` + `useEffect`. Store state only when it can't be derived (user choices, event history), and cache only for a measured cost, keyed on the underlying data.
- Keep control flow flat. Handle edge cases first with guard clauses and early returns. When a branch only contains another two-way decision, merge it into the outer if/else-if chain instead of nesting, unless that would repeat an expensive or meaningful condition. Compute values shared by several branches once, above them but after the guards that make them valid. Aim for a flat list of condition → action.
- Validate at trust boundaries (user input, network responses, files, external APIs) and trust typed values inside them; skip runtime checks the types already guarantee.
- Prefer the framing that deletes code. Before adding a helper, conversion step, cleanup pass, or special-case branch, look for the change to the input's shape or to the caller that makes it unnecessary. Make that change if it's within the task's scope; otherwise list it as a follow-up.

## Testing

- Before writing a new test, check whether an existing one covers the same behaviour; if so, extend it with assertions. Write a new test only for a new behaviour, so each test's name still says what it checks.
- Use table-driven cases (`it.each`, `parametrize`) instead of near-duplicate tests that differ only in inputs.
- Keep tests short: shared setup in helpers or fixtures, no filler comments, no asserting on implementation details.
- For a bug fix, show that the new or changed test fails without the fix before calling it fixed.
- Never quiet a flaky test with a sleep, a retry, or a skip. Find the cause; if you can't, stop and tell me what you found, proposing deletion with the reason.
- Reach for a property test (random inputs against an invariant, round-trip, or idempotence) when code has a rule that must always hold, and a differential test (old and new code on the same inputs) for a rewrite or migration.

## Correctness

- I often work with fast-moving tools (Next.js, Tailwind v4, Auth.js, AWS). Check the official docs for the installed version before relying on an API or config option you remember.
- Before calling something done, run the project's own checks (typecheck, lint, tests, build). If something fails or you skipped a step, say so plainly.
- Then run the change the way a user would: start the service and call the endpoint, run the CLI, load the data. Green checks don't prove the feature works. For UI changes, ask before driving a browser.
- Don't open pages in a browser (e.g. via Chrome DevTools MCP) unless I asked for it; if inspecting a page would help, ask first.
- Review your own changes as skeptically as someone else's. Look for what's wrong, not for confirmation. For non-trivial work, get an independent review with the `red-team` skill: a fresh subagent that sees the diff and a short brief, not your reasoning.
- When a mistake recurs (I've corrected it twice, or you notice yourself repeating an instruction), propose enforcing the rule in the strongest form that works, in this order: structure that makes it impossible, types, a lint or CI check whose error names the fix, a test. A written rule in docs or AGENTS.md comes last, for judgment calls nothing can check.

## Git

- Don't run git commands that change repository state (add, commit, push, merge, rebase, reset, amend, cherry-pick, stash, branch deletion, force-push) unless my current message asks for that operation. Approval from an earlier message doesn't carry over, and don't offer to run them. Read-only commands (status, diff, log, show, blame) and editing files are always fine.
- Commit messages, when I ask for a commit: Conventional Commits, `type(scope): imperative subject`, with a body explaining why when it isn't obvious.
- When I ask for a commit, stage explicit paths and commit only what you changed in this session: another session may be working in the same checkout. Destructive commands (`git add -A`, `git stash`, `git reset --hard`, `git clean`, force-push, `--no-verify`) are blocked in the tool settings; if one seems necessary, say why and leave it to me.
- Commit grouping: each commit is one logical change. Put related edits together, even across files, and split unrelated ones into separate commits instead of one catch-all. Don't split a single change into many tiny commits either.
- A PR description carries evidence, not claims: the checks run and their results, screenshots or a recording for UI changes, and how to revert.
- Never add a `Co-Authored-By` trailer or a "Generated with …" line to commits or PR descriptions. The history should read as mine.

## Reporting

- When responding to my feedback or a review, say first whether you agree, then what you changed.
- End-of-task reports cover only what the diff doesn't show: surprises, behaviour changes, verification (what you ran, what passed or failed), deliberate deviations from the plan or these instructions, and follow-ups. Don't recap the diff or list "updated X to say Y".

## Environment

- macOS on Apple Silicon, zsh, Neovim, tmux. Runtimes come from `mise`.
- The same configs run on two Macs (personal and work) with different usernames. Use `$HOME` or `~`, never a hardcoded `/Users/<name>` path, in anything committed.
