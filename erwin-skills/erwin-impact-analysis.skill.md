# Erwin Impact Analysis Skill

## Purpose

Understand the blast radius of a proposed change before implementation.

## Use When

Use after the likely change point is understood and before approval.

## Method

Evaluate:

- affected modules, components, services, pages, endpoints, jobs, or shared utilities
- upstream callers and downstream consumers
- behaviour that must change
- adjacent behaviour that must remain unchanged
- public contracts, schemas, state, persistence, caching, and configuration where relevant
- backward compatibility
- concurrency, performance, security, accessibility, and operational concerns where relevant
- likely regression areas
- explicit non-goals

Do not invent risks merely to lengthen the report. Focus on risks supported by the change surface.

## Output

- Change surface
- Affected boundaries
- Preserved behaviour
- Compatibility concerns
- Meaningful risks
- Non-goals
