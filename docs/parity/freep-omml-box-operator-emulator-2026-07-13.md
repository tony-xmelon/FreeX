# FreeP OMML Box Operator Emulator - 2026-07-13

## Scope

This slice adds bounded shared FreeP support for OMML `m:boxPr/m:opEmu`:

- `m:box` remains a transparent wrapper by default.
- `m:boxPr/m:opEmu` now parses as a CT_OnOff flag on `MathNode.Box`.
- Boxed single-token and common multi-glyph operators such as `==` now contribute deterministic operator-class row spacing in the shared `MathLayoutEngine`.
- WPF and Avalonia continue to consume the same `MathBoxRenderPlanner` glyph plan without renderer-local math policy.

## Evidence

- Parser coverage: `OmmlParserTests.Box_WithOperatorEmulatorOn_PreservesSharedOperatorFlag`
- Parser coverage: `OmmlParserTests.Box_WithOperatorEmulatorOff_DoesNotPromoteOperatorSpacing`
- Layout/render-plan coverage: `MathLayoutEngineTests.Row_BoxOperatorEmulatorDoubleEquals_AddsRelationSpacingAdvance`
- WPF renderer coverage: `SlideCanvasMathBaselineTests.RenderParaWithMath_BoxOperatorEmulator_UsesSharedSpacingPlan_DoesNotThrow`
- Avalonia renderer coverage: `SlideCanvasMathBaselineTests.RenderParaWithMath_BoxOperatorEmulator_UsesSharedSpacingPlan_DoesNotThrow`

## Command Inventory

No generated FreeP command inventory update was made. This slice is shared OMML parsing/layout/render planning, not a command workflow surface.

## Remaining Work

PowerPoint-authoritative math visual baselines remain blocked until a COM-capable machine is available. Broader OfficeMath work still needs exact font metrics, full operator spacing-table fidelity, line-break/alignment behavior around operator emulators, and additional PowerPoint-authored equation fixtures.
