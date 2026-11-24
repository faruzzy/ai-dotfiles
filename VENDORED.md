# Vendored skills

Skills in `skills/` are copied from upstream and pinned. They don't update on their own; to pull an improvement, diff against upstream at a newer commit and copy what you want, then update the commit here.

| Skill | Upstream | Path upstream |
|---|---|---|
| grilling | mattpocock/skills | skills/productivity/grilling |
| grill-me | mattpocock/skills | skills/productivity/grill-me |
| tdd | mattpocock/skills | skills/engineering/tdd |
| diagnosing-bugs | mattpocock/skills | skills/engineering/diagnosing-bugs |
| wizard | mattpocock/skills | skills/engineering/wizard |
| handoff | mattpocock/skills | skills/productivity/handoff |
| writing-for-agents | mattpocock/skills | skills/productivity/writing-for-agents |
| spec-driven-development | addyosmani/agent-skills | skills/spec-driven-development |
| planning-and-task-breakdown | addyosmani/agent-skills | skills/planning-and-task-breakdown |
| incremental-implementation | addyosmani/agent-skills | skills/incremental-implementation |
| source-driven-development | addyosmani/agent-skills | skills/source-driven-development |
| shipping-and-launch | addyosmani/agent-skills | skills/shipping-and-launch |
| socratic-tutor | janestreet/agent_skills | socratic-tutor |
| blast-radius | cursor/plugins | pstack/skills/blast-radius |
| rederive | EricJujianZou/rederive | skills/rederive |

Pinned commits:

- `mattpocock/skills` @ `5863806dd4e15c63174bee4e7515a4256792ecfa` (2026-11-12) — MIT, see `LICENSES/mattpocock-skills.MIT`
- `addyosmani/agent-skills` @ `301b02b12bff98e4688e6984af6556802322bbde` (2026-11-12) — MIT, see `LICENSES/addyosmani-agent-skills.MIT`
- `janestreet/agent_skills` @ `7c6715c29548a3b39d4a9545c698ee4fd17a7213` (2026-11-13) — MIT, see `LICENSES/janestreet-agent-skills.MIT`
- `cursor/plugins` @ `536a3352a050e47cb75f86be497ea304ef342301` (2026-11-17) — MIT, see `LICENSES/cursor-plugins-pstack.MIT`
- `EricJujianZou/rederive` @ `f8f4629de73a04ba23f40fe4659b629364fa47e9` (2026-11-21) — MIT, see `LICENSES/ericjujianzou-rederive.MIT`

## Local changes

Re-apply these after re-syncing a skill from upstream.

- **Addy skills' `references/`**: upstream links to `../../references/*.md` at the repo root, which doesn't resolve once a skill is symlinked on its own. The needed checklists are copied into each skill's own `references/` dir and the links rewritten to `references/…` (planning-and-task-breakdown, incremental-implementation, shipping-and-launch).
- **spec-driven-development**, Phase 4: points at `tdd` instead of Addy's `test-driven-development`, and drops the `context-engineering` reference (neither is vendored).
- **incremental-implementation**, Increment Checklist: the pointer to `test-driven-development`'s "Discover the Stack First" section is replaced with an inline instruction to find the project's commands.

- **socratic-tutor**: progress persists in `~/.local/share/socratic-tutor/<topic>.md`. Added a "Saved progress" section (write after every level change and on "save state"), a resume check at the top of "Session start" (resume opens with spaced review instead of the diagnostic), "save state" now writes the file (printing the block only without file access), and a resume trigger in the description. Ideas adapted from [jawnlam/lifelong-learning](https://github.com/jawnlam/lifelong-learning) (CC-BY 4.0, by Jawn Lam; reworded, not copied): the learner record and next-session seed in the progress file, explain-it-back, confidence checks, smoothness-as-warning, and the real-world task for level 5 on hands-on topics.
- **blast-radius**: pstack-only references replaced, since neither skill is vendored: step 6 asks two or three fresh subagents (different models where the tool allows) instead of running `arena`, and the hand-back says "write it plainly" instead of "write it through `unslop`". Step 3's "Solid versus React" is generalised to "the framework's render and effect order". Added `agents/openai.yaml` keeping it user-invoked in Codex, matching upstream's `disable-model-invocation: true`.

## Written here

- **fallow**: original, based on the [fallow README](https://github.com/fallow-rs/fallow) (MIT). Inspired by bdbch/ai-dotfiles, whose version has no license and so isn't copied.
- **red-team**: original, inspired by `grizzled-red-teaming` in [paulirish/skills](https://github.com/paulirish/skills) (no license, so reworded, not copied): the four-field brief with honest `unknown`s, the premise verdict, the evidence bar for blockers, vacuous-success checks, and "ship it" as a valid outcome. The "prefer the framing that deletes code" rule in `global/AGENTS.md` comes from the same repo's `accretion-bouncer`. The reviewer's "complete effect path" and "the change can't vouch for itself" checks are adapted from `dsh-find-simplifications` and `dsh-code-review` in [deepseek-ai/deepseek-harness](https://github.com/deepseek-ai/deepseek-harness) @ `2e39e70` (MIT), and the session-vantage comment rule in `global/AGENTS.md` from its `dsh-trim-cot-leakage`. The "enumerate, don't sample" check is an idea from the `review-pr-local` skill in [warpdotdev/warp](https://github.com/warpdotdev/warp) @ `f8223ce` (AGPL-3.0, so idea only, no text copied). Re-review rounds (`PRIOR ROUNDS`, bug classes, stepping back at round three) and the `pre-existing` tag come from Anthropic's posts [How the Claude Code team thinks about verification](https://claude.dev/blog/how-the-claude-code-team-thinks-about-verification/) and [Solving code review at Anthropic](https://claude.dev/blog/solving-code-review-at-anthropic/).

- **understand-change**: original, inspired by [ThariqS's "Learn Quiz" gist](https://gist.github.com/ThariqS/1389dcdff9eba4789887a2211370f06b) (no license, so reworded, not copied): explain-back before teaching, problem/solution/impact checklist, quizzes with answers revealed after submission, findings discussed rather than quizzed. Added: session mode, a resumable checklist outside the repo, Codex fallback to plain-text questions.

## Considered and left out

- **google/elephant-goldfish-model**: design-doc workflow with ~9 reviewer subagents. Coupled skills + agents + standards, so it can only be installed whole, as a plugin. Skipped for cost; revisit for large design docs.
- **Addy**: code-review-and-quality, code-simplification, security-and-hardening (Claude Code ships `/code-review`, `/simplify`, `/security-review`); using-agent-skills (second skill router on top of the native one); test-driven-development and debugging-and-error-recovery (Matt's `tdd` and `diagnosing-bugs` are tighter); interview-me and idea-refine (overlap `grilling`); frontend-ui-engineering (covered by the `frontend-design` plugin); the agent personas.
- **Matt**: to-spec, to-tickets, triage, wayfinder (need an issue tracker set up per repo); course/TS-specific misc skills; in-progress skills.
- **bdbch/ai-dotfiles**: OpenCode-only and unlicensed, so nothing copied. Ideas adopted in our own words: scope discipline, critical self-review, comment only where needed, no unprompted browser opening (`global/AGENTS.md`), Chrome DevTools MCP (`mcp/servers.txt`), the fallow skill, SCOPES.md. Not adopted: never-autocommit (conflicts with committing at milestones), 100-line review chunks, plan as the default mode.
