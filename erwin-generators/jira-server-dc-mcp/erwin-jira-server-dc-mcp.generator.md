# Erwin Jira Server/Data Center MCP Generator Prompt

Use this prompt to generate a small, local MCP server for Jira Server/Data Center 9.12.4. The generated MCP is intended for read-only Jira investigation and a review-before-editing development workflow.

## 1. Objective

Build a small, local MCP server that lets an AI coding assistant find Jira bugs, investigate one selected issue, and support a review-before-editing workflow for repository fixes.

The MCP server itself must only read from Jira. The surrounding coding assistant may inspect and edit repository code only after it has investigated the selected Jira issue, presented a diagnosis and file-level plan, and received the user's explicit approval.

## 2. MCP Scope

Implement two MCP tools:

- `search_jira_issues`: search Jira with JQL and return one page of summary-level issue data.
- `get_jira_issue_details`: retrieve one selected issue, its visible fields and comments, and attachment metadata; download eligible images to a temporary local directory.

Do not expose MCP resources, prompts, or other capabilities unless an additional requirement calls for them. The server must not provide Jira write operations.

## 3. Functional Requirements

### Essential requirements

- For a request to list bugs, call `search_jira_issues` with the default JQL unless the user supplies another query.
- Present results compactly and sorted by updated date descending for the default query. Show key, summary, priority, status, assignee, and updated date; state Jira's total and the number displayed.
- Do not fetch details, comments, or attachments during search. When the results need paging, show one page at a time and offer the next page. Ask the user to select an issue by number or key.
- After selection, fetch only that issue's details. Inspect its report, comments, and downloaded images, then trace relevant repository code without editing it.
- Present expected behavior, current behavior, likely cause, confirmed findings versus assumptions, proposed solution, ambiguities, and a file-level plan including expected tests. Wait for explicit approval before editing.
- After approval, implement only the approved plan; if scope or approach must change, stop and request approval of a revised plan.
- Never fetch Jira data unless the user requested a Jira operation.

### Preferred design

- Make MCP tool descriptions and results clear enough for the coding assistant to follow the staged workflow reliably.
- Make pagination robust and explicit.

## 4. MCP Tool Contracts

### `search_jira_issues`

Inputs:

- `jql`: optional string, non-empty and bounded in length.
- `startAt`: optional non-negative integer, default `0`.
- `maxResults`: optional positive integer, default `25`, capped at `100`.

Default JQL:

```text
assignee = currentUser() AND type = Bug AND resolution = Unresolved AND status NOT IN ("Apply for Won't Fix") ORDER BY updated DESC
```

Use Jira REST API v2 `GET /search`. Send `jql`, `startAt`, `maxResults`, and `fields` as query parameters; encode them with a structured URL API, not string concatenation.

Request only summary-level fields: `key,summary,priority,status,resolution,issuetype,assignee,updated,project`. Do not request comments or attachments.

Return one page and the Jira-reported `total`, along with enough paging data for the next request. A suitable response contains:

- `jql`, `total`, `startAt`, `maxResults`, `displayed`
- `issues`: each with `key`, `summary`, `priority`, `status`, `resolution`, `issueType`, `assignee`, `updated`, `project`
- `nextPage`: next `startAt` and page size, or `null`

Normalize Jira objects to readable names where available. Jira must evaluate `currentUser()` as the account associated with the PAT.

### `get_jira_issue_details`

Input:

- `issueKey`: required Jira key. Validate before making a request and reject invalid keys without contacting Jira.

For the selected key only:

1. Call `GET /issue/{issueKey}?fields=*all`.
2. Call `GET /issue/{issueKey}/comment` repeatedly until all visible comment pages have been fetched.
3. Respect Jira permissions and comment visibility. Do not bypass access restrictions.

Return the issue key and all fields visible to the PAT user where practical, preserving field names and values, including custom fields. Include a readable description; preserve structured content when conversion could lose information.

For each comment include author, created/updated timestamps, visibility restrictions if present, and full readable text. Preserve structured comment content when useful.

For each attachment include ID, filename, MIME type, size, author, creation time, and content URL. Do not download non-image attachments. Download image attachments only when they fit a configurable byte limit (default `10 MiB`) to a temporary issue-specific directory using safe filenames. Return local paths for downloaded images and a clear reason for any attachment skipped or not downloaded. Enforce the limit while downloading, not only from Jira's declared size.

A suitable response contains `key`, `fields`, `comments`, and `attachments`. Each attachment may additionally contain `localPath`, `skipped`, or `failed`.

## 5. External System Integration

Integrate with Jira Server/Data Center `9.12.4`, using REST API base path `/rest/api/2`. Use Atlassian REST API v2 documentation only for general endpoint shapes and response conventions; verify compatibility with Server/Data Center and do not assume Cloud-only behavior.

Use GET requests only for issue search, issue details, comments, and image content. Construct API URLs from the configured Jira base URL. Keep Jira host configuration separate from credentials.

## 6. Authentication & Configuration

- Require `JIRA_BASE_URL` and `JIRA_PAT` from the MCP process environment.
- Prefer a VS Code password input in `mcp.json` for the PAT, passed to the server as `JIRA_PAT`. Configure `JIRA_BASE_URL` in the same server environment.
- Do not rely on `.env` loading unless explicitly implemented and documented; Node.js does not load it automatically.
- Do not load Jira URL or PAT from an untracked local config file unless a future requirement explicitly adds that feature.
- Support optional `JIRA_MAX_IMAGE_BYTES`, `JIRA_TEMP_DIR`, and `JIRA_TIMEOUT_MS`; default the image limit to 10 MiB and request timeout to 30 seconds. Validate optional values.
- Require HTTPS, reject credentials embedded in the base URL, and preserve a Jira context path if configured.

## 7. Security & Safety Constraints

### Trust boundaries

- The server may read Jira data visible to the authenticated PAT user from the configured Jira origin only.
- It may write downloaded, eligible image attachments to an issue-specific directory under a temporary directory.
- It must not write to Jira or modify repository files.
- The surrounding coding-assistant workflow may inspect repository files. It may edit code only after the user explicitly approves the diagnosis and file-level plan.

### Required protections

- Send the PAT only in `Authorization: Bearer <PAT>` to the configured Jira HTTPS origin. Never put it in a URL, log, error, tool result, prompt, committed file, or example other than an unmistakable placeholder.
- Disable automatic redirects for authenticated API and attachment requests. Reject redirects rather than forwarding credentials.
- Validate attachment URLs against the configured Jira HTTPS origin before requesting them. Do not allow tool input to cause arbitrary URL requests.
- Validate and encode issue keys before using them in paths. Pass JQL as an encoded query parameter.
- Do not expose tools that return environment variables, configuration, or secrets. Redact the PAT from returned issue data defensively.
- Do not log request headers, tokens, or issue contents. Use stdout only for MCP protocol traffic.
- Do not execute shell commands or spawn processes. Limit filesystem writes to safe image attachment paths.
- Keep all Jira operations read-only: no issue creation, edits, transitions, comments, assignments, deletes, or attachment writes.

## 8. Architecture Requirements

Use a local stdio MCP server suitable for VS Code/Copilot. Separate MCP registration and transport wiring from Jira API behavior. Use the official MCP SDK and the installed SDK's supported tool-schema format; verify its actual API rather than assuming it accepts raw JSON Schema.

Use a schema validator only as required by the selected SDK and declare directly imported runtime dependencies correctly. Prefer Node.js built-ins for HTTP, URL handling, filesystem work, temporary paths, and tests where suitable.

## 9. Data Models / Important Concepts

- Search results are summaries; details are fetched only after issue selection.
- Jira issue fields may contain nested objects and custom fields. Preserve field identity and values.
- Descriptions and comments may be Jira-formatted or structured documents. Provide readable text without discarding original structure when conversion is lossy.
- Attachment metadata is distinct from downloaded content. Only eligible images receive local paths.
- Tool errors must not include credentials or unnecessary issue contents.

## 10. Error Handling & Logging

Handle missing configuration, invalid URL/key/JQL, authentication failure or expired PAT, issue not found or inaccessible, Jira unavailable, timeouts, malformed responses, and attachment failures/limits.

Return concise, sanitized MCP errors. Distinguish authentication/access errors and not-found errors where safe; never include response bodies, headers, tokens, or unnecessary issue data. Attachment failures should be reported per attachment without exposing secrets.

Do not add automatic retries unless justified and bounded; never retry authentication failures. Do not log sensitive request or response data.

## 11. Build / Run / Development Experience

Use modern Node.js with native ES modules and no compilation step unless the implementation requires one. Provide:

- `npm install`
- `npm start`
- `npm test`
- A workspace VS Code MCP configuration that launches the local server over stdio and prompts for the PAT securely.
- Setup documentation explaining Jira host configuration, PAT setup, available optional settings, and PAT rotation/revocation.

Use temporary, issue-specific attachment directories with safe names. Do not include machine-specific absolute paths.

## 12. Compatibility Requirements

- Target Jira Server/Data Center `9.12.4` and REST API v2, not Jira Cloud assumptions.
- Preserve the two tool names and their observable responsibilities unless an appended requirement explicitly changes them.
- The default query must use `currentUser()` and the PAT's Jira identity.
- Search must page and report Jira's total; it must not silently truncate results.
- Tool schemas must match the installed MCP SDK API.
- VS Code must be able to launch the server using stdio without a hosted service.

## 13. Acceptance Criteria

Verify the implementation with automated tests and local checks:

- Build/type/syntax checks and test suite pass.
- Server starts over stdio with valid environment configuration and exposes exactly the intended tools.
- MCP tool discovery confirms schemas and descriptions.
- Mocked search tests verify default JQL, selected fields, encoding, total count, mapping, and next-page behavior.
- Mocked detail tests verify key validation, `fields=*all`, complete comment paging, readable/structured content, and attachment metadata.
- Configuration tests cover missing and invalid environment values without real credentials.
- Security tests prove PAT redaction, GET-only behavior, no redirect following, same-origin restrictions, HTTPS enforcement, and image size enforcement.
- Error tests cover unauthorized, forbidden, not found, invalid query, timeout, Jira unavailable, malformed responses, and attachment failures.
- No test requires production credentials; any live integration test must be clearly marked optional.
- Confirm no Jira write requests or repository edits occur before approval.

## 14. Non-Goals

Do not build a hosted service, web server, Docker deployment, Jira write tools, arbitrary URL fetcher, shell-command tool, general-purpose filesystem browser, or an automatic code-fixing workflow that skips user review.

## 15. Implementation Freedom

Treat this prompt's requirements as:

- **Essential:** observable tool contracts, Jira compatibility, read-only behavior, staged user approval, and security boundaries.
- **Preferred:** local stdio deployment, separate Jira client, summary-first search, safe temporary image downloads, and compact JSON tool results.
- **Implementation details:** exact file layout, helper names, internal data structures, formatting, and test organization.
- **Do not preserve as requirements:** stale documentation, undeclared transitive dependencies, machine-specific paths, generated files, accidental bugs, or historical workarounds.

Preserve essential behavior and security. Improve internal architecture where appropriate, avoid unnecessary legacy complexity, and incorporate any additional requirements appended by the user.

## 16. Additional Requirements

Treat user requirements written below this section as extensions to this baseline. If an appended requirement conflicts with the baseline, treat the newer explicit user requirement as an override, while retaining all compatible security constraints.

<!-- Append additional user requirements below this line. -->
