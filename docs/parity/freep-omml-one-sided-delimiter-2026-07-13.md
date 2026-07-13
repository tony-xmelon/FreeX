# FreeP OMML One-Sided Delimiter Layout - 2026-07-13

## Scope

This slice tightens shared FreeP layout for OMML delimiters with an explicit empty side:

- `m:dPr/m:begChr m:val=""` suppresses the opening delimiter without reserving an invisible bracket slot.
- `m:dPr/m:endChr m:val=""` suppresses the closing delimiter without reserving an invisible bracket slot.
- The fix lives in `MathLayoutEngine`, so WPF and Avalonia consume the same `MathBoxRenderPlanner` bracket plan.

## Evidence

- Layout coverage: `MathLayoutEngineTests.Delim_WithExplicitEmptyBegChr_DoesNotReserveOpenBracketSlot`
- Layout coverage: `MathLayoutEngineTests.Delim_WithExplicitEmptyEndChr_DoesNotReserveCloseBracketSlot`
- WPF renderer coverage: `SlideCanvasMathBaselineTests.RenderParaWithMath_OneSidedDelimiters_UseSingleSharedBracketPlan_DoesNotThrow`
- Avalonia renderer coverage: `SlideCanvasMathBaselineTests.RenderParaWithMath_OneSidedDelimiters_UseSingleSharedBracketPlan_DoesNotThrow`

## Remaining Work

PowerPoint-authoritative OMML visual baselines remain blocked on this machine because PowerPoint COM is not available. This slice proves shared WPF/Avalonia one-sided delimiter layout behavior, not full OfficeMath typography or exact PowerPoint bracket metrics.
