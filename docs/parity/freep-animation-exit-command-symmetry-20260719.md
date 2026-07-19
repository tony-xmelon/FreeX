# FreeP exit animation command symmetry

## Scope

The Animations ribbon now exposes `Wipe Out`, `Split Out`, and `Zoom Out` alongside the existing exit commands. The shared command planner maps them to the existing `Exit` animation plans, so WPF and Avalonia use the same authoring contract and renderer-supported presets.

## Verification

- `PresentationAnimationCommandPlannerTests`: 32/32
- `LocTests`: 11/11
- Ribbon definition inventory and generated-profile parity: verified after inventory refresh
- Host ribbon registration coverage: covered by `RibbonTransitionsAnimationsTests`

The change is authoring-surface parity only; it does not alter document layout or the established visual baseline.
