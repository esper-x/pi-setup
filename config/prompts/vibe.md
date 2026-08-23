---
description: Enable Vibe subagent routing, delegation, validation, and publishing policy
argument-hint: "[task]"
---

# Vibe mode

Apply the following subagent routing policy to this task.

Optimize monetary cost before latency and aggregate token count. Delegate repository exploration and implementation when a cheaper specialized agent can complete a bounded workstream reliably, even when delegation duplicates context. The parent retains ownership of architecture, experiment selection, integration, acceptance, and the final answer.

## When to delegate

At the start of a broad task, identify qualifying workstreams and delegate them, or state briefly why delegation would not help. Reassess after major checkpoints when new independent work appears.

Execute directly only when startup would cost more than the work: a factual answer, one short command, or a known single-line edit. The parent may run routing, integration, and concise final-verification commands, but substantial discovery, implementation, conflict resolution, and review belong to a suitable cheaper agent.

Use these user agents by exact name:

- `code-explorer` — broad repository discovery, contract tracing, and data-flow tracing.
- `quick-implementer` — mechanical, well-specified changes limited to one or two files.
- `implementer` — multi-file behavior changes, debugging, or substantial tests.
- `code-validator` — focused read-only test, build, lint, or type-check execution.
- `code-reviewer` — independent review for high-risk, security-sensitive, architectural, public-API, migration, concurrency, or hard-to-validate changes.
- `commit-pusher` — commit and push only when the user explicitly requests both.

Do not substitute a builtin generic agent when one of these custom agents matches the task.

## Pi execution rules

Before delegation, list the available agents and use only executable, non-disabled agents. Launch execution through `subagent` with `workflowScript`. Use `runs.run` for one child or dependent steps and `runs.all` for independent parallel work. A multi-step or parallel workflow uses one top-level asynchronous `workflowScript`; do not launch additional top-level workflows for its children.

Use `context: "fresh"` unless the child genuinely needs parent conversation history. Reuse completed evidence and retained children for related follow-ups. Resume a child only when it is reported as resumable; otherwise start a narrowly scoped replacement and label it as a fallback.

Prefer one child per task. Add parallel lanes only when their scopes are genuinely independent. Use worktree isolation for parallel writers. Every writer must preserve unrelated user changes.

## Exploration

Use `code-explorer` only when discovery is expected to cross several files, require meaningful tracing, or add substantial raw evidence to the parent context. Do not use it to reread known files.

For broad exploration, run at most two explorers by default. Give each a distinct concern or repository boundary and require a decision-ready report of at most 300 words. Keep exploration sequential when one finding determines the next investigation or when agents would inspect substantially the same files.

## Implementation and validation

Use `quick-implementer` for a localized, low-risk change with an obvious narrow check. Use `implementer` for broader behavior changes and tests.

Detach behavioral verification from `implementer` by default. The implementer runs cheap structural checks and returns a complete affected-test manifest: every added or changed test plus directly affected existing tests. Then delegate focused verification to `code-validator`.

Every validator task must state the exact command, assigned manifest entries, validation boundary, and concurrency plan. Run every manifest entry with focused file, class, package, or equivalent selectors instead of replacing it with a whole-suite command. Prefer one validator using up to three runner workers when safe. Otherwise partition the manifest across at most three validators with non-overlapping shards. Do not parallelize commands that share mutable databases, fixtures, snapshots, generated files, ports, caches, or coverage output unless those resources are isolated.

When all affected unit-test entries pass, do not rerun the global unit-test suite by default. Treat integration and end-to-end checks as separate scopes. The parent classifies failures before repair. Consolidate likely implementation failures, resume the original `implementer` with the evidence, and return the affected checks to a validator. Escalate after two unsuccessful repair cycles or when failures are flaky, environmental, or contract-level.

## Review and publishing

Use `code-reviewer` only when the routing criteria above justify independent review. Reviewers inspect the actual diff and return evidence-backed findings; they do not edit unless the user explicitly authorizes a fix pass.

Use `commit-pusher` only after the work is complete and only when the user explicitly asks to commit and push. It may stage only in-scope files and must preserve unrelated changes.

## Current task

$@
