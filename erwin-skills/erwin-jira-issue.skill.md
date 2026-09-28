---
name: jira-issue
description: 'Investigate and implement a Jira issue of any type from its exact issue key. Retrieve the issue through the jira-bug-copilot MCP server, inspect repository code and tests, present a file-level plan, and wait for explicit approval before editing. Use for /jira-issue <ISSUE-KEY>.'
argument-hint: '<ISSUE-KEY>'
user-invocable: true
---

# Jira Issue Investigation and Implementation

Use this skill when the user supplies a Jira issue key and wants the issue investigated or implemented. Issues may be bugs, enhancements, or any other Jira issue type. Begin with read-only investigation and a proposal; do not edit files until the user explicitly approves the diagnosis, proposed solution, and file list.

## 1. Get the Issue Key

- Use the exact issue key provided as the skill argument or in the user's message.
- If no key is provided, ask the user for one and do not search Jira using a default query.
- Do not infer, alter, or substitute an issue key.

## 2. Retrieve Jira Details

- Use only the `get_jira_issue_details` tool exposed by the `jira-bug-copilot` MCP server, passing the exact key supplied by the user.
- Do not use another Jira MCP server, a Jira extension, a browser, direct Jira API calls, or other Jira access methods.
- Treat the issue type, summary, description, acceptance criteria, comments, and available attachments as requirements for the issue. Also consider environment, reproduction steps, and expected or actual behavior when provided.
- Inspect downloaded local image attachments when the tool returns local image paths. If image contents cannot be accessed, state that limitation and do not infer what an image shows.
- If the key cannot be retrieved or required details are missing or contradictory, state the blocker and ask a focused clarification question. Do not guess.

## 3. Investigate the Repository Without Editing

- Identify the affected product, owning project, entry point, and nearest code path that controls the requested behavior.
- Read applicable repository instructions and inspect the relevant implementation and neighboring tests.
- Investigate any Jira issue type; do not assume every issue describes a bug.
- Use relevant existing tests or the cheapest focused read-only check to verify behavior when feasible.
- Separate confirmed evidence from assumptions and unresolved questions. Do not present a hypothesis as a confirmed diagnosis.
- Do not modify code, tests, configuration, documentation, or other repository files during investigation.
- Keep investigation and proposed work limited to the Jira issue; do not take on unrelated defects or refactors.

## 4. Present the Plan and Wait for Approval

Before editing, present:

- The issue key, issue type, and concise issue summary.
- Expected behavior, based on the issue requirements; identify when it is unspecified.
- Current behavior, based on available evidence; identify when it could not be confirmed.
- Diagnosis, with confirmed evidence clearly separated from assumptions and unresolved questions.
- The proposed solution and how it addresses the requirements.
- Any ambiguity, dependency, limitation, or material risk.
- A file-level plan listing every repository-relative file expected to change and the planned change in each file.
- The focused tests or checks planned, including regression tests where the behavior is meaningfully testable and repository conventions support them.

Ask the user to explicitly approve the diagnosis, proposed solution, and complete file list. Stop and wait. Do not edit until all three are explicitly approved. If approval is ambiguous, ask for clarification. If the requested scope changes, or the diagnosis or file list needs revision, present the revised plan and wait for explicit approval again.

## 5. Implement Only the Approved Plan

- After approval, implement the agreed changes, including enhancements and other non-bug issue types.
- Follow the target project's architecture and conventions, and add or update focused tests when behavior is meaningfully testable and this follows repository conventions.
- Make no changes outside the approved file list. Do not make unrelated changes, refactors, or opportunistic fixes.
- If the approved diagnosis or file list proves incorrect, stop before expanding the scope. Explain the evidence, present a revised solution and file list, and wait for approval.
- Do not commit or push.

## 6. Validate and Report

- After the first substantive edit, run the narrowest relevant test, build, lint, or type-check command available.
- If that check fails due to the change, repair the same slice and rerun the focused check before broadening validation.
- Run the relevant checks for the approved behavior, inspect the final diff, and confirm it stays within the approved file list.
- Report the changed files and what changed, checks run and their results, and any remaining limitations, risks, or unverified requirements.
- Do not claim the issue is fully resolved if relevant behavior was not validated.
