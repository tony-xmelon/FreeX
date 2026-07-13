# FreeP OMML BorderBox Geometry - 2026-07-13

Scope: bounded shared FreeP math-layout evidence for PowerPoint-authored OMML `m:borderBox` structures that hide horizontal edges while requesting diagonal strike geometry.

This slice strengthens the shared WPF/Avalonia evidence contract:

- `m:borderBoxPr/m:hideTop` and `m:hideBot` suppress horizontal border-edge line ops before renderers draw.
- `m:borderBoxPr/m:strikeTLBR` emits a renderer-neutral diagonal line from the top-left border endpoint to the bottom-right endpoint.
- The left and right visible border edges share the same top/bottom endpoints as the diagonal strike, so both WPF and Avalonia consume one exact `MathBoxRenderPlanner` line plan.
- Nested math remains padded inside the borderBox and keeps the existing baseline contract.

No host-specific math layout policy was added.

## Evidence

- Shared layout/render-plan coverage: `MathLayoutEngineTests.BorderBox_HiddenHorizontalEdgesAndDiagonalStrike_EmitExactSharedEndpoints`
- WPF renderer coverage: `SlideCanvasMathBaselineTests.RenderParaWithMath_BorderBoxHiddenEdgesAndDiagonalStrike_UsesSharedLinePlan_DoesNotThrow`
- Avalonia renderer coverage: `SlideCanvasMathBaselineTests.RenderParaWithMath_BorderBoxHiddenEdgesAndDiagonalStrike_UsesSharedLinePlan_DoesNotThrow`

## Command Inventory

No generated FreeP command inventory update was made. This slice is shared OMML parsing/layout/render planning, not a command workflow surface.

## Remaining Work

PowerPoint-authoritative math visual baselines remain blocked until a COM-capable machine is available. Broader OfficeMath work still needs exact font metrics, full spacing-table behavior, and PowerPoint-authored fixture renders for additional borderBox combinations.
