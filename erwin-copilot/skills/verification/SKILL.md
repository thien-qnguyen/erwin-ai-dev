---
name: verification
description: Verify an implemented software change without overstating confidence. Use after implementation and after review-driven fixes to run the smallest meaningful build, test, lint, type-check, smoke, or runtime checks and report verified versus unverified areas.
---

# Verification

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
