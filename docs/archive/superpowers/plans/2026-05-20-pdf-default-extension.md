# PDF Default Extension Fidelity Plan

## Tasks

- [x] Identify extensionless PDF export requests as a user-facing planner gap.
- [x] Add focused ExportPlanner coverage for extensionless paths.
- [x] Normalize extensionless inferred-PDF paths to `.pdf` while preserving explicit extensions.
- [x] Document the architecture and command-parity decision.
- [x] Run focused verification before commit.

## Decisions

- `ExportPlanner` remains the single place that infers export format and normalizes the requested path.
- Only extensionless paths are changed; explicit `.pdf`, `.xps`, and custom extensions keep current behavior.
- XPS still requires an explicit `.xps` extension because format inference remains extension-based.
