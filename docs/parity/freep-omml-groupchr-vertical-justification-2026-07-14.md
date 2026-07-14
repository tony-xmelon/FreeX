# FreeP OMML Group-Character Vertical Justification - 2026-07-14

Scope: bounded shared FreeP math-layout slice for PowerPoint-authored OMML group characters that use `m:groupChrPr/m:vertJc`.

## Coverage

- Parses `m:groupChrPr/m:vertJc` into shared `MathNode.GroupChr` metadata.
- Preserves the Open XML default where an absent `m:vertJc` means top alignment and a present `m:vertJc` without `m:val` means bottom alignment.
- Maps top and bottom vertical justification to shared `MathBox` ascent/baseline metrics before either host renders math.
- Carries the resolved group-character glyph and baseline metrics through `MathBoxRenderPlanner`, so WPF and Avalonia consume the same draw plan without renderer-local math policy.

## Verification

- `OmmlParserTests.GroupChr_WithBareVertJc_DefaultsAttributeToBottomJustification`
- `OmmlParserTests.GroupChr_WithVertJc_PreservesSharedBaselineJustification`
- `MathLayoutEngineTests.OmmlGroupChrVertJcTop_AlignsObjectTopToSharedBaseline`
- `MathLayoutEngineTests.OmmlGroupChrVertJcBottom_AlignsObjectBottomToSharedBaseline`
- `SlideCanvasMathBaselineTests.RenderParaWithMath_GroupChr_UsesSharedGlyphPlan_DoesNotThrow` in WPF and Avalonia test projects.

## Command Inventory

Tracked as workflow evidence row `freep.omml.groupchr-vertical-justification` in the generated FreeP command/evidence inventory.

## Remaining

This is shared structural/render-plan evidence only. It does not claim PowerPoint-authoritative math visual parity, exact stretched group-character glyph metrics, or complete OfficeMath group-character typography without COM-backed PowerPoint baselines.
