# FreeP OMML Group Character Parity

Date: 2026-07-13

## Scope

This slice strengthens shared WPF/Avalonia coverage for OMML `m:groupChr` constructs:

- Missing `m:groupChrPr/m:chr` now resolves to a position-aware default group glyph.
- Top/default group characters use U+23DE; bottom-position group characters use U+23DF.
- Explicit `m:chr` values remain preserved.
- Shared `MathLayoutEngine` places top group characters above the base and bottom group characters below the base while keeping the baseline contract renderer-neutral.
- Wide grouped expressions now grow the group-character glyph size in shared layout before WPF or Avalonia draws it.
- WPF and Avalonia consume the same `MathBoxRenderPlanner` glyph plan without host-specific math policy.

No PowerPoint COM visual baseline was generated on this machine.

## Evidence

- Parser coverage: `OmmlParserTests.GroupChr_WithNoChrAndNoPos_DefaultsToTopCurlyBrace`
- Parser coverage: `OmmlParserTests.GroupChr_WithBottomPosAndNoChr_DefaultsToBottomCurlyBrace`
- Parser coverage: `OmmlParserTests.GroupChr_WithTopPosAndNoChr_DefaultsToTopCurlyBrace`
- Parser coverage: `OmmlParserTests.GroupChr_WithExplicitChr_PreservesRequestedGlyph`
- Layout coverage: `MathLayoutEngineTests.GroupChr_Above_PlacesBraceAboveBaseAndGrowsAscent`
- Layout coverage: `MathLayoutEngineTests.GroupChr_Below_PlacesBraceBelowBaseAndKeepsBaseBaseline`
- Layout/render-plan coverage: `MathLayoutEngineTests.GroupChr_WithWideBase_GrowsBraceGlyphTowardBaseWidth`
- WPF renderer coverage: `SlideCanvasMathBaselineTests.RenderParaWithMath_GroupChr_UsesSharedGlyphPlan_DoesNotThrow`
- Avalonia renderer coverage: `SlideCanvasMathBaselineTests.RenderParaWithMath_GroupChr_UsesSharedGlyphPlan_DoesNotThrow`

## Command Inventory

No generated FreeP command inventory update was made. This slice is shared OMML parsing/layout/render planning, not a command workflow surface.

## Remaining Work

PowerPoint-authoritative math visual baselines remain blocked until a COM-capable machine is available. Broader OfficeMath work still needs exact font metrics, full spacing-table behavior, richer function/nesting typography, and additional PowerPoint-authored equation fixtures.
