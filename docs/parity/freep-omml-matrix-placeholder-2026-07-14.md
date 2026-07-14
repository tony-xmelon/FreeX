# FreeP OMML Matrix Placeholder Evidence - 2026-07-14

Scope: bounded FreeP OMML/math visual-baseline depth slice for authored matrix empty-cell placeholders. This keeps the behavior in the shared parser/layout/render-plan path consumed by WPF and Avalonia, without editing generated command parity inventory artifacts.

## Shared Behavior

- `OmmlParser` reads `m:mPr/m:plcHide` into the shared `MathNode.Matrix.HidePlaceholders` flag.
- `MathLayoutEngine` emits a renderer-neutral placeholder glyph (`U+25A1`) for authored empty `m:e` matrix cells by default.
- When `m:plcHide` is on, empty authored cells remain layout-only/hidden and no placeholder glyph reaches `MathBoxRenderPlanner`.
- WPF and Avalonia continue to draw only `MathDrawOp` primitives from `MathBoxRenderPlanner`; no renderer-local matrix placeholder policy was added.

## Evidence

- Parser coverage: `Parse_MatrixPlcHide_PreservesHiddenPlaceholderFlag`, `Parse_MatrixPlcHideExplicitlyOff_ShowsPlaceholders`.
- Shared layout/render-plan coverage: `Matrix_EmptyAuthoredCell_DefaultsToSharedPlaceholderGlyph`, `Matrix_WithPlcHide_SuppressesSharedPlaceholderGlyph`.
- WPF renderer coverage: `RenderParaWithMath_MatrixPlaceholder_UsesSharedPlcHidePlan_DoesNotThrow`.
- Avalonia renderer coverage: `RenderParaWithMath_MatrixPlaceholder_UsesSharedPlcHidePlan_DoesNotThrow`.

## Remaining Gap

This slice proves renderer-neutral WPF/Avalonia behavior for the OMML `m:plcHide` matrix placeholder decision. It does not claim PowerPoint-authoritative pixel parity. Exact OfficeMath placeholder glyph/chrome, full spacing-table typography, additional equation constructs/alignment semantics, and PowerPoint COM math visual baselines remain deferred to a COM-capable baseline lane.
