# FreeP OMML Manual Line Breaks - 2026-07-06

## Scope

This slice closes a shared FreeP math-layout gap for PowerPoint-authored OMML equations that use manual line breaks:

- `m:r/m:rPr/m:brk`
- `m:box/m:boxPr/m:brk`
- direct `m:brk` fallback handling

The implementation is renderer-neutral. It lives in the shared OMML parser and math layout engine under `freep/FreeP.App.Presentation/Math`, so WPF and Avalonia consume the same parsed `MathNode.EqArray` and the same arranged math boxes.

## Behavior

- A manual break before a run or box starts a new displayed equation row.
- The parsed rows reuse the existing shared equation-array layout path.
- `m:brk@m:alnAt` is retained as an equation-array alignment point index when present.
- Bare `m:brk` nodes are ignored as content instead of flowing to the unknown-node fallback.
- Empty unknown/fallback math glyphs are zero-width and no longer index an empty string during layout.

## Evidence

- `OmmlParserTests.Parse_RunManualBreak_StartsNewEquationArrayRow`
- `OmmlParserTests.Parse_BoxManualBreak_StartsNewEquationArrayRowAndReadsAlnAt`
- `OmmlParserTests.Parse_DirectManualBreak_DoesNotCreateUnknownNode`
- `MathLayoutEngineTests.OmmlManualBreak_LayoutsAsStackedEquationArrayRows`
- `MathLayoutEngineTests.EmptyFallbackGlyph_DoesNotThrowOrReserveWidth`
- `SlideCanvasMathBaselineTests.RenderParaWithMath_ManualBreakAlignment_UsesSharedMathBoxPlan_DoesNotThrow` in WPF and Avalonia test projects.

## Command Inventory

Tracked as workflow evidence row `freep.omml.manual-break-alignment` in the generated FreeP command/evidence inventory.

## Remaining

This is not a full PowerPoint math baseline. Remaining OMML parity still includes broader break-distribution heuristics, OfficeMath paragraph alignment, broader structure/layout coverage, and PowerPoint-authored visual baselines for complex equations.
