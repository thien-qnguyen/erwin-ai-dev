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

## Repository Structure

### Framework source

- `erwin-agents/` — source agent roles and operating rules.
- `erwin-workflows/` — deterministic development lifecycle definitions.
- `erwin-skills/` — source skill definitions and framework-owned skill content.
- `erwin-templates/` — reusable output and handoff formats.
- `erwin-generators/` — prompts used to generate optional external tooling such as MCP servers.

### Copilot distribution

- `erwin-copilot/agents/` — custom agents in VS Code/Copilot-compatible `.agent.md` format.
- `erwin-copilot/skills/<name>/SKILL.md` — Agent Skills using the standard discoverable layout. Each skill's `name` matches its parent directory.
- `erwin-install/` — local installation helpers and documentation.

The distribution is intentionally separate from the source layout. This keeps framework-owned source files namespaced while allowing Copilot to consume the standard folder/file names it requires.

## Recommended Personal Installation

For personal reuse across workspaces, install the Copilot distribution into the user-level customization directories instead of copying framework files into each target repository.

```powershell
./erwin-install/install-copilot.ps1
```

This installs:

```text
~/.copilot/agents/erwin-developer.agent.md
~/.copilot/skills/requirement-analysis/SKILL.md
~/.copilot/skills/root-cause-analysis/SKILL.md
~/.copilot/skills/impact-analysis/SKILL.md
~/.copilot/skills/testing-strategy/SKILL.md
~/.copilot/skills/verification/SKILL.md
~/.copilot/skills/self-review/SKILL.md
~/.copilot/skills/requirement-reconciliation/SKILL.md
~/.copilot/skills/task-handoff/SKILL.md
~/.copilot/skills/jira-issue/SKILL.md
```

After installation, open a new Copilot chat or reload VS Code and use `/agents` and `/skills` to verify discovery.

## Agent Behavior

`Erwin Developer` treats the Erwin workflow as its default development lifecycle and prefers installed Erwin skills at the relevant stages rather than inventing an ad-hoc process.

Specialized skills act as entry points and compose with the core flow. For example, an exact Jira issue key can trigger `jira-issue`, which still uses the core requirement, impact, testing, verification, self-review, reconciliation, and handoff stages.

Target-repository instructions and explicit user requirements remain authoritative when they conflict with generic framework guidance.

## Public-Safe Scope

Use this repository as a reusable framework. Do not add confidential project information, organisation-specific business rules, secrets, credentials, private infrastructure details, or proprietary source code.
