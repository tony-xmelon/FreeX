# FreeP OMML Paragraph Justification - 2026-07-14

Scope: bounded shared FreeP math-layout evidence for PowerPoint-authored OMML equation paragraphs that use `m:oMathParaPr/m:jc`.

## Coverage

- Parses `m:oMathPara` wrappers into shared `MathNode.MathParagraph` nodes.
- Preserves `m:oMathParaPr/m:jc` values for left, center, right, and centerGroup equation alignment.
- Applies paragraph justification in `MathLayoutEngine` when a host supplies the available paragraph width.
- Carries the shifted glyph coordinates through `MathBoxRenderPlanner`, so WPF and Avalonia consume the same renderer-neutral plan without local equation-paragraph policy.

## Verification

- `OmmlParserTests.OMathPara_WithJustification_PreservesParagraphAlignmentMetadata`
- `OmmlParserTests.OMathPara_WithNoJustification_DefaultsToCenter`
- `MathLayoutEngineTests.OmmlParagraphJustification_RightAlignsContentInsideSharedParagraphWidth`
- `MathLayoutEngineTests.OmmlParagraphJustification_CenterGroupUsesCenteredSharedParagraphPlan`
- `SlideCanvasMathBaselineTests.RenderParaWithMath_OMathParaJustification_UsesSharedAlignedParagraphPlan_DoesNotThrow` in WPF and Avalonia test projects.

## Command Inventory

Tracked as workflow evidence row `freep.omml.paragraph-justification` in the generated FreeP command/evidence inventory.

## Remaining

This is shared structural/render-plan evidence only. It does not claim PowerPoint-authoritative math visual parity, exact text-box/frame width integration, full OfficeMath paragraph-distribution heuristics, or COM-backed PowerPoint math baselines.
