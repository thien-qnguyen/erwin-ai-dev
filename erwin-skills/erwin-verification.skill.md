# Erwin Verification Skill

## Purpose

Verify that an implemented change behaves as intended without overstating confidence.

## Use When

Use after implementation and after any review-driven fix.

## Method

1. Discover the repository's supported build/test commands and constraints.
2. Start with the smallest meaningful verification scope for the change.
3. Run targeted automated tests for affected behaviour when available or practical.
4. Build affected modules/projects/packages where meaningful.
5. Widen to broader regression/build/E2E coverage when change risk justifies it.
6. Distinguish static inspection, compile/build validation, automated runtime testing, and manual verification.
7. Record failures honestly; do not reinterpret failed verification as success.
8. Never claim a check was executed if it was only inferred from code inspection.

## Output

- Verification performed
- Results
- Failing or blocked checks
- Unverified areas
- Residual risk
