# FreeP OMML Border-Box Side And Strike Lines - 2026-07-14

Scope: bounded shared FreeP math-layout evidence for PowerPoint-authored OMML `m:borderBox` side visibility and strike-line properties.

## Coverage

- Preserves `m:borderBoxPr` hidden side flags as shared `MathNode.BorderBox` side metadata.
- Preserves horizontal, vertical, bottom-left-to-top-right, and top-left-to-bottom-right strike flags as shared model state.
- Proves `MathLayoutEngine` pads the nested expression, keeps the child baseline, and emits renderer-neutral line primitives for visible sides and requested strikes.
- Keeps WPF and Avalonia renderers as consumers of the same `MathBoxRenderPlanner` line operations; no renderer-local border-box policy was added.

## Verification

- Parser coverage: `OmmlParserTests.BorderBox_ParsesHiddenSideFlags`.
- Parser coverage: `OmmlParserTests.BorderBox_DefaultsAllSidesVisible_AndExplicitFalseDoesNotHide`.
- Parser coverage: `OmmlParserTests.BorderBox_ParsesStrikeAndDiagonalFlags`.
- Shared layout/render-plan coverage: `MathLayoutEngineTests.BorderBox_EmitsVisibleSideLinesAndPadsNestedChild`.
- Shared layout/render-plan coverage: `MathLayoutEngineTests.BorderBox_EmitsStrikeAndDiagonalLinesThroughBoxCenter`.
- Shared layout/render-plan coverage: `MathLayoutEngineTests.BorderBox_HiddenHorizontalEdgesAndDiagonalStrike_EmitExactSharedEndpoints`.
- WPF renderer coverage: `SlideCanvasMathBaselineTests.RenderParaWithMath_BorderBoxNestedMath_UsesSharedLinePlan_DoesNotThrow`.
- Avalonia renderer coverage: `SlideCanvasMathBaselineTests.RenderParaWithMath_BorderBoxNestedMath_UsesSharedLinePlan_DoesNotThrow`.

## Command Inventory

Tracked as workflow evidence row `freep.omml.border-box-side-strike-lines` in the generated FreeP command/evidence inventory.

## Remaining

This is shared structural/render-plan evidence only. It does not claim PowerPoint-authoritative math visual parity, exact OfficeMath border padding/thickness metrics, or complete Cambria Math typography without COM-backed PowerPoint baselines.
