---
name: red-team
description: Adversarial review of a plan, design, or diff by a fresh read-only subagent that questions the premise before the details. Use for the independent review of non-trivial work, or when asked to red-team or poke holes in something.
---

# Red team

A review from someone who didn't build the thing. The reviewer gets a brief, not your reasoning, so it is free to disagree with it.

## Steps

1. **Read the target**: the files, the diff (`git diff`, or the branch against its base), or the plan.
2. **Write the brief.** All four fields are required:

   | Field | Content |
   |---|---|
   | `TARGET` | What to review: paths, a git range, or the plan text |
   | `INTENT` | Goals and constraints, including decisions the user already approved (mark them `approved`). State them; don't argue for them |
   | `ABANDONED` | Approaches tried and dropped |
   | `OUT OF SCOPE` | What was left out on purpose |

   Write `unknown` for any field you don't actually know. A guessed intent sends the review after the wrong target; if the user is around and intent is unclear, ask them.

   Reviewing the same work again after fixes, add `PRIOR ROUNDS`: the round number, and each earlier finding with what happened to it (fixed, disputed and why, deferred). Set `TARGET` to what changed since the last round, with the original target as context.
3. **Start a fresh subagent with read-only instructions.** Its prompt is the full text of [reviewer.md](reviewer.md), unedited, followed by the brief. Paraphrasing it drops the calibration (severity bar, the ship-it option).
   - Use a general-purpose agent on the full model. A fast search or explore agent type carries its own prompt about returning quickly, which works against the review.
   - Without subagents (some Codex setups), read `reviewer.md` and review under its rules yourself, but head the report **Self-review, not independent** and tell the user an independent review didn't happen.
4. **Report.** Show the review as written, including *Residual risk* and *Could not verify*, then your response: which findings you accept, which you dispute and why.
   - When the user asked for the review, stop there.
   - When it's the review of your own work, fix the accepted findings that fall inside the task, and list the rest as follow-ups. A premise verdict other than `SOUND`, a *Bigger move*, or anything that reopens an `approved` decision goes to the user before you act on it.
