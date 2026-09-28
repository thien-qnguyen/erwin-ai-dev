---
name: testing-strategy
description: Choose the smallest automated test strategy that provides meaningful regression protection for an affected behaviour. Use during solution design and again if implementation reveals a different practical test boundary.
---

# Testing Strategy

## Method

1. Discover the repository's existing test projects, frameworks, conventions, fixtures, and CI expectations.
2. Identify behaviour that must change and adjacent behaviour that must remain unchanged.
3. Prefer extending existing tests and infrastructure.
4. Select test level based on the behaviour under test, not framework preference.
5. Add characterization/regression tests around legacy behaviour when valuable and practical.
6. Prefer a pre-fix failing test for a defect or new requirement when practical.
7. Avoid mocking infrastructure so heavily that the test stops representing meaningful behaviour.
8. Do not introduce a new test framework or dependency without approval when no suitable infrastructure exists.
9. Do not heavily refactor production code solely to make a small change testable without approval.

## Typical Test-Level Guidance

- pure calculation or isolated business rule -> unit test
- service/domain behaviour with manageable dependencies -> unit or service-level test
- persistence/query/database-specific behaviour -> integration test
- API contract/serialization/request pipeline -> API or integration test
- frontend state/component behaviour -> unit/component test
- user interaction across components -> UI/component/E2E test as appropriate
- cross-layer critical flow -> integration/E2E test
- configuration or wiring-only change -> build/static/runtime smoke verification where more appropriate than a unit test

These are heuristics, not mandatory mappings.

## Output

- Existing coverage discovered
- Behaviour to protect
- Test level selected and why
- Tests to add/update
- Verification commands or project-native mechanism
- Known gaps
