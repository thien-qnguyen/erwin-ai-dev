# Erwin Development Workflow

This workflow is technology-agnostic and applies to backend, frontend, and full-stack development tasks.

## Stage 1 — Repository Discovery

- Read repository-local instructions and conventions.
- Identify language, framework, package/build system, test tooling, architecture boundaries, and relevant project structure.
- Identify any constraints that affect build, test, dependency installation, or runtime verification.

## Stage 2 — Requirement Analysis

- Extract requested behaviour, acceptance criteria, constraints, and explicit non-goals.
- Separate facts from assumptions.
- Surface material ambiguity before implementation.

## Stage 3 — Investigation

- Trace the relevant code path and data/control flow.
- Gather evidence for the observed behaviour or implementation need.
- Identify the root cause for defects, or the precise change point for feature work.

## Stage 4 — Impact Analysis

Determine:

- affected components and boundaries
- behaviour that must change
- adjacent behaviour that must remain unchanged
- compatibility concerns
- state/data/API/UI impacts
- concurrency, performance, security, or operational risks where relevant

## Stage 5 — Testing Strategy

- Search for existing automated coverage.
- Select the smallest test level that provides meaningful regression protection.
- Prefer extending existing test infrastructure.
- If no suitable test infrastructure exists, propose the smallest practical addition.
- Do not introduce a new test framework without approval.

## Stage 6 — Proposed Solution

Present:

- interpreted requirements
- root cause or implementation need
- proposed change
- expected affected files/components when known
- impact/risk analysis
- testing strategy
- verification plan

Then stop for explicit human approval before material implementation.

## Stage 7 — Regression Protection

Where practical:

- add or extend tests that protect behaviour which must remain unchanged
- add a test that captures the new requirement or defect
- demonstrate pre-fix failure for the new requirement when practical and valuable

Do not create tests solely to increase coverage metrics.

## Stage 8 — Implementation

- Implement only the approved scope.
- Follow repository conventions.
- Avoid unrelated cleanup and architectural expansion.
- If the design must materially change, stop and request approval again.

## Stage 9 — Verification

- Run the smallest meaningful build scope.
- Run targeted tests for affected behaviour.
- Widen build/test scope when risk justifies it.
- Distinguish static inspection from runtime verification.
- Never claim unexecuted verification as completed.

## Stage 10 — Independent Diff Review

Review the complete final diff as if written by another developer. Check at minimum:

- correctness and requirement alignment
- unintended regression
- edge cases and error paths
- state/data consistency
- API or UI contract changes
- async/concurrency behaviour when relevant
- performance implications when relevant
- security implications when relevant
- unnecessary changes or scope creep
- consistency with repository conventions

If meaningful findings exist: fix, re-run affected verification, and review again.

## Stage 11 — Requirement Reconciliation

Re-read the original task and map each requirement/acceptance criterion to the final implementation and verification evidence.

Explicitly identify:

- satisfied requirements
- any deviation from the approved solution
- unresolved or unverified items

## Stage 12 — Handoff

Produce a concise final report containing:

- root cause or implementation summary
- changed areas
- tests added or updated
- verification performed
- requirements reconciliation
- remaining risks
- anything not verified
