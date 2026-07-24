# FreeW WPF WordArt Wave1 raster frame - 2026-07-24

## Scope

The imported primary `FreeW CONFIDENTIAL` WordArt in
`wordart-watermark-stress.docx` is an exact `GlowBlue` / `Wave1` / 32pt
signature. Its serialized 476.16 by 68.27 DIP anchor frame was already correct,
but the FidelityRender `VisualBrush` fit the WPF effect descendants back into
that frame. The result vertically compressed the imported panel and glyph
raster.

The WPF fidelity compositor now gives only that imported signature a three-DIP
taller destination rectangle. Shared anchor geometry and WordArt placement are
unchanged; the secondary `Review Copy` WordArt remains the control.

## Evidence

The matched Word-visible manual PDF raster from 2026-07-23 was reused at
`816x1056`. After rebuilding the consuming Release `FreeW.FidelityRender`
artifact, WPF versus Word mean channel deltas improved as follows:

| Region | Before | After |
| --- | ---: | ---: |
| Whole page | 7.3682% | 7.2506% |
| Primary Wave1 ROI | 14.7111% | 12.9890% |
| Tight panel ROI | 20.2083% | 17.5962% |

The unaffected `Review Copy` ROI remained 4.8234% with an identical crop
SHA-256. A two-DIP candidate was weaker (primary 13.4298%), while four DIPs
regressed from the three-DIP optimum (primary 13.0603%).

Focused WPF fidelity source and composite contracts passed. The broad current
source-contract test suite has one pre-existing unrelated failure for an absent
`thisPixW - 2 * ins` string; it also fails before this slice.
