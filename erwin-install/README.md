# Erwin AI Dev — Copilot Installation

This folder installs the Erwin AI Dev custom agent and skills into GitHub Copilot's user-level customization directories so they are available across workspaces without modifying target repositories.

## Installed Locations

- Custom agent: `~/.copilot/agents/erwin-developer.agent.md`
- Skills: `~/.copilot/skills/<skill-name>/SKILL.md`

The installable source is under `erwin-copilot/`.

## Install

From a PowerShell terminal in this repository:

```powershell
./erwin-install/install-copilot.ps1
```

If an Erwin-managed target already exists, the installer stops rather than overwriting it. To intentionally replace the installed Erwin files with the current clone:

```powershell
./erwin-install/install-copilot.ps1 -Force
```

The installer performs local file copies only. It does not install packages, access the network, modify a target source repository, or configure credentials.

## Verify Discovery

After installation, open a new Copilot chat or reload VS Code.

- Type `/agents` and verify `Erwin Developer` is available.
- Type `/skills` and verify the Erwin skills are available.
- Invoke `/jira-issue <ISSUE-KEY>` when the `jira-bug-copilot` MCP server is configured for the active environment.

Automatic skill selection and explicit slash invocation are separate behaviors. A skill may be selected automatically when its `description` matches the task, while slash invocation forces that skill directly.

## Update

Pull the latest version of this repository and reinstall intentionally:

```powershell
git pull
./erwin-install/install-copilot.ps1 -Force
```

## Security

Review changes before installing updates, especially any future scripts or executable resources added to skills. The current installer only copies files already present in this repository.
