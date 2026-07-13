# FreeP OMML Function Name Parity

Date: 2026-07-13

## Scope

This slice strengthens shared WPF/Avalonia coverage for OMML `m:func` constructs:

- `m:func/m:fName` runs now normalize to upright function-name glyphs even when the authored run omits `m:nor` or `m:sty`.
- Bold metadata on the function name is preserved.
- Function arguments keep ordinary math-run styling, so variables remain italic by default.
- WPF and Avalonia consume the same `MathBoxRenderPlanner` glyph plan without host-specific math policy.

No PowerPoint COM visual baseline was generated on this machine.

## Evidence

- Parser coverage: `OmmlParserTests.Func_FunctionNameDefaultsToUprightRun`
- Parser coverage: `OmmlParserTests.Func_FunctionNameNormalizationPreservesBoldMetadata`
- Layout/render-plan coverage: `MathLayoutEngineTests.Func_FunctionName_RenderPlanIsUprightAndArgumentStaysItalic`

## Command Inventory

No generated FreeP command inventory update was made. This slice is shared OMML parsing/layout/render planning, not a command workflow surface.

## Remaining Work

PowerPoint-authoritative math visual baselines remain blocked until a COM-capable machine is available. Broader OfficeMath work still needs exact font metrics, full spacing-table behavior, and additional PowerPoint-authored equation fixtures for nested functions and function spacing.
