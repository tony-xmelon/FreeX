# FreeP chart-level metadata retention - 2026-07-13

## Scope

This slice improves package/model retention for two chart-level OOXML properties under `c:chart`:

- `c:dispBlanksAs` with `span`, `gap`, and `zero` values.
- `c:showDLblsOverMax` as nullable authored metadata, including OOXML bare-element true parsing.

The implementation reads these fields from chart-level `c:chart`, stores them in `ChartShape`, preserves them through `SlideCloner`, and writes them back after `c:plotVisOnly` in chart schema order.

## Validation Boundary

This is package/model retention only. It does not add renderer behavior, planner behavior, UI controls, or Microsoft PowerPoint visual/reference validation. PowerPoint-backed reference verification remains deferred because local `PowerPoint.Application` COM is unavailable on this machine.
