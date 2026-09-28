# Erwin AI Dev

A lightweight, technology-agnostic AI development framework for software engineering tasks across backend, frontend, and full-stack codebases.

## Goals

- Turn loosely defined development requests into a disciplined engineering workflow.
- Keep human approval at meaningful decision points.
- Prefer minimal, well-scoped changes over broad refactors.
- Add practical regression protection without forcing one testing style or framework.
- Verify changes before declaring work complete.
- Keep the framework portable across repositories, languages, and tooling.

## Core Workflow

1. Discover repository context and local instructions.
2. Extract requirements and acceptance criteria.
3. Investigate the relevant code and runtime path.
4. Determine the root cause or implementation need.
5. Analyse the change surface, risks, and affected components.
6. Define an appropriate testing and verification strategy.
7. Propose a solution and wait for human approval before material implementation.
8. Add or extend regression protection where practical.
9. Implement the approved solution.
10. Run the smallest meaningful build and test scope.
11. Review the complete diff independently.
12. Fix meaningful findings and re-verify.
13. Reconcile the final change against the original requirements.
14. Produce a concise handoff with verified and unverified areas clearly separated.

## Principles

- Repository-specific instructions take precedence over generic framework preferences.
- Do not introduce a new dependency, testing framework, build system, architectural pattern, or tool merely because this framework prefers it.
- Reuse the repository's existing technology and conventions whenever practical.
- Do not expand the approved scope silently.
- Do not treat implementation as completion.
- Prefer behaviour-focused tests over coverage-driven tests.
- Prefer the smallest meaningful verification scope first, then widen only when justified.
- If a change cannot be verified automatically, state that clearly instead of implying certainty.

## Structure

- `erwin-agents/` — agent roles and operating rules.
- `erwin-workflows/` — deterministic development lifecycle definitions.
- `erwin-skills/` — reusable capabilities selected by workflow stage and task context.
- `erwin-templates/` — reusable output and handoff formats.

## Usage

Use this repository as a reusable reference or copy only the pieces needed for a target project. The framework is intentionally generic and should not contain confidential project information, organisation-specific business rules, secrets, credentials, or private infrastructure details.
