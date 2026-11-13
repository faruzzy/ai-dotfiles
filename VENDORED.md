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

Pinned commits (2026-11-12):

- `mattpocock/skills` @ `5863806dd4e15c63174bee4e7515a4256792ecfa` — MIT, see `LICENSES/mattpocock-skills.MIT`
- `addyosmani/agent-skills` @ `301b02b12bff98e4688e6984af6556802322bbde` — MIT, see `LICENSES/addyosmani-agent-skills.MIT`

## Local changes

Re-apply these after re-syncing a skill from upstream.

- **Addy skills' `references/`**: upstream links to `../../references/*.md` at the repo root, which doesn't resolve once a skill is symlinked on its own. The needed checklists are copied into each skill's own `references/` dir and the links rewritten to `references/…` (planning-and-task-breakdown, incremental-implementation, shipping-and-launch).
- **spec-driven-development**, Phase 4: points at `tdd` instead of Addy's `test-driven-development`, and drops the `context-engineering` reference (neither is vendored).
- **incremental-implementation**, Increment Checklist: the pointer to `test-driven-development`'s "Discover the Stack First" section is replaced with an inline instruction to find the project's commands.

## Considered and left out

- **google/elephant-goldfish-model**: design-doc workflow with ~9 reviewer subagents. Coupled skills + agents + standards, so it can only be installed whole, as a plugin. Skipped for cost; revisit for large design docs.
- **Addy**: code-review-and-quality, code-simplification, security-and-hardening (Claude Code ships `/code-review`, `/simplify`, `/security-review`); using-agent-skills (second skill router on top of the native one); test-driven-development and debugging-and-error-recovery (Matt's `tdd` and `diagnosing-bugs` are tighter); interview-me and idea-refine (overlap `grilling`); frontend-ui-engineering (covered by the `frontend-design` plugin); the agent personas.
- **Matt**: to-spec, to-tickets, triage, wayfinder (need an issue tracker set up per repo); course/TS-specific misc skills; in-progress skills.
