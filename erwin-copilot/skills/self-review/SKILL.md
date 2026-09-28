---
name: self-review
description: Independently review the complete implementation diff before completion. Use after implementation and verification, and again after meaningful review-driven fixes, to find concrete regressions, scope creep, correctness issues, and weak tests.
---

# Self Review

Review the diff as if it was authored by another developer. Do not merely restate the intended solution.

## Review Areas

Check what is relevant to the change:

- correctness and requirement alignment
- unintended regressions
- edge cases and failure paths
- null/undefined/empty-state handling
- state and data consistency
- async/concurrency/race behaviour
- persistence/query behaviour
- API and UI contracts
- performance and unnecessary work
- security and trust-boundary implications
- accessibility/user interaction implications for UI changes
- error handling and observability
- unnecessary dependencies or architectural changes
- dead code, duplication, or scope creep
- repository conventions and maintainability
- test quality and whether tests actually protect intended behaviour

## Finding Policy

- Prioritise concrete, actionable findings.
- Do not manufacture low-value style findings.
- For each meaningful finding, explain the risk and location.
- Fix findings that are within approved scope, then re-run affected verification and review again.
- If a finding requires material scope/design expansion, request approval instead of silently implementing it.

## Output

- Findings, ordered by severity/impact
- Fixes applied
- Re-verification performed
- Remaining concerns
