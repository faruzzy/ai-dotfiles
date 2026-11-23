---
name: understand-change
description: Walk me through a PR or this session's changes until I've demonstrated I understand them, with a running checklist, explain-back, and quizzes. Use for /understand-change [PR number or URL] [paths...].
disable-model-invocation: true
---

# Understand a change

Teach me a change until I can explain it, not until you have explained it. The change is a PR, or the work of the current session.

## 1. Gather the change

- **A PR number or URL:** read it with `gh pr view <pr> --comments`, `gh pr diff <pr>`, and any linked issues. Extra arguments are paths: teach those files, and use the rest of the PR only as context.
- **No argument:** this session's change. That is every commit in `$(git merge-base HEAD origin/<default branch>)..HEAD`, plus uncommitted and untracked changes, plus this conversation's reasoning and the alternatives it rejected. On the default branch itself, that range is the unpushed commits; include them.

Read the changed files in full, with the callers and tests needed to understand them; a diff alone hides the context. Done when you can state the problem and the solution in two sentences each, citing code. Open by telling me the range you gathered (PR, or commits plus uncommitted files), so I can correct it before we start.

## 2. Write the checklist

Keep it at `~/.local/share/understand-change/<repo>/<pr-N or branch>.md`, where `<repo>` is the main checkout's directory name and `/` in a branch name becomes `-`. If the file exists, read it and resume at the first unticked item.

Four sections:

- **Problem:** what was wrong, why it existed, and each code path where it showed up.
- **Solution:** the approach and why it beat the alternatives, each design decision, each edge case.
- **Impact:** why it matters, and what else it affects (callers, stored data, users, other repos).
- **Findings:** bugs, gaps, and open questions raised along the way.

Each item is one concrete fact I should be able to explain, with `file:line` where it applies, and covers both why and how. Update the file after every item.

## 3. Teach Problem, then Solution, then Impact

For each section, in order:

1. Ask me to explain it in my own words first. Explain nothing until I've tried.
2. Fill the gaps my explanation shows. Show the relevant code, and keep asking "why" until the answer is a reason the code, a requirement, or the conversation states. I may ask for it ELI5, ELI14, or "like I'm an intern".
3. Quiz me with two to four questions that test understanding rather than recall: predict the behaviour for an input, say why an alternative lost, find the edge case. Mix open-ended and multiple-choice. Use the question tool if you have one (`AskUserQuestion` in Claude Code), otherwise plain text. Vary where the correct option sits, and reveal answers only after I've answered every question.
4. Tick an item (`- [x]`) only when my explanation or answers demonstrated it. Re-teach the rest and quiz them with new questions. Move on only when every item in the section is ticked.

## Findings

When teaching surfaces a bug, a design flaw, or a gap in the change or the code around it, explain it instead of quizzing on it. Discuss it with me until we agree what it is, record it under Findings, and continue. Fixing it is a follow-up, not part of this session.

## Finish

Done when every item under Problem, Solution, and Impact is ticked. Close with what I demonstrated, the Findings, and anything still unresolved. Leave the checklist file in place.
