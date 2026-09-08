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

Use these custom agents by exact name:

- `code-explorer` — broad repository discovery, contract tracing, and data-flow tracing.
- `quick-implementer` — mechanical, well-specified changes limited to one or two files.
- `implementer` — multi-file behavior changes, debugging, or substantial tests.
- `code-validator` — focused read-only test, build, lint, or type-check execution.
- `code-reviewer` — independent review for high-risk, security-sensitive, architectural, public-API, migration, concurrency, or hard-to-validate changes.
- `commit-pusher` — commit and push only when the user explicitly requests both.

Do not substitute a builtin generic agent when one of these custom agents matches the task. Use only agent types currently advertised by the `Agent` tool; do not rely on its fallback for an unavailable or disabled custom agent.

## Pi execution rules

Use the `Agent` tool for single-agent delegation. Every call must provide a self-contained `prompt`, a 3–5 word `description`, and the matching `subagent_type`. Omit `run_in_background` or set it to `true` by default; the plugin backgrounds agents and sends a completion notification with a preview.

For several independent workstreams known up front, send multiple `Agent` calls in one message so they run concurrently. Use `get_subagent_result` for the full output of a background agent (`wait: true` only when the current turn genuinely depends on it); never poll or sleep. Use `run_in_background: false` only when the very next action requires the result. Steer a running child with `steer_subagent`; resume a finished child with `Agent(..., resume: "<agent-id>")`. If resume is unavailable, start a clearly labelled, self-contained same-role fallback.

Agents start with fresh task context by default. Set `inherit_context: true` only when the child genuinely needs the parent conversation.

Use `SubagentWorkflow` only when the number of agents depends on runtime discovery or work must pass through deterministic stages; `/vibe` permits that limited use. Pass a single `script` beginning with a pure-literal `export const meta = { ... }`. Inside it, select custom roles with `agentType`, prefer `pipeline` for multi-stage work, and use `parallel` only when a real barrier is required.

Keep writes single-threaded by default. Use `isolation: "worktree"` only for intentionally parallel writers; each worktree starts from committed `HEAD` and cannot see staged or uncommitted changes, and completed changes remain on a branch that must be merged separately. Otherwise omit isolation (or pass `"off"`), keep one writer in the active checkout, and do not edit that checkout concurrently with it. Every writer must preserve unrelated user changes.

## Exploration

Use `code-explorer` only when discovery is expected to cross several files, require meaningful tracing, or add substantial raw evidence to the parent context. Do not use it to reread known files.

For broad exploration, run at most two explorers by default. Give each a distinct concern or repository boundary and require a decision-ready report of at most 300 words. Keep exploration sequential when one finding determines the next investigation or when agents would inspect substantially the same files.

## Implementation and validation

Use `quick-implementer` for a localized, low-risk change with an obvious narrow check. Use `implementer` for broader behavior changes and tests.

Detach behavioral verification from `implementer` by default. The implementer runs cheap structural checks and returns a complete affected-test manifest: every added or changed test plus directly affected existing tests. Then delegate focused verification to `code-validator` with the exact manifest and command. The implementer must not claim green behavioral tests without validator evidence.

Every validator task must state the exact command, assigned manifest entries, validation boundary, and concurrency plan. Run every manifest entry with focused file, class, package, or equivalent selectors instead of replacing it with a whole-suite command. Prefer one validator using up to three runner workers when safe. Otherwise partition the manifest across at most three validators with non-overlapping shards. Do not parallelize commands that share mutable databases, fixtures, snapshots, generated files, ports, caches, or coverage output.

When all affected unit-test entries pass, do not rerun the global unit-test suite by default. Treat integration and end-to-end checks as separate scopes. The parent classifies failures before repair, resumes the original `implementer` with concrete evidence, and returns the affected checks to `code-validator`. Escalate after two unsuccessful repair cycles or when failures are flaky, environmental, or contract-level.

## Review and publishing

Use `code-reviewer` only when the routing criteria above justify independent review. Reviewers inspect the actual diff and return evidence-backed findings; they do not edit unless the user explicitly authorizes a fix pass.

Use `commit-pusher` only after the work is complete and only when the user explicitly asks to commit and push. It may stage only in-scope files and must preserve unrelated changes.

## Current task

$@
