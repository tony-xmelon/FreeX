# FillGold ArchUp Text-Path Registration

## Scope

`wordart-watermark-stress.docx` contains an imported floating DrawingML
`FillGold` `ArchUp` WordArt object with a 26-point source font (`Review Copy`).
Its gold panel was already registered with Word, but the WPF glyph path used the
generic 80% text-width cap and generic curve origin. The resulting ink was too
wide and low inside the unchanged panel.

## Change

The WPF warped WordArt adapter now recognizes only the imported `FillGold`,
`ArchUp`, 26-point signature. It uses the Word-measured 60% width cap and
applies a text-only `-23` DIP horizontal / `-20` DIP vertical placement
correction. The panel rectangle, shared placement planner, Avalonia renderer,
other WordArt styles, and Wave1 route remain unchanged.

## Matched Word Evidence

All PNGs were rendered at 816x1056 against the persisted Word COM export from
`FreeW-WordBaselineSurfaceRefresh-20260717`.

| Measurement | Before | After |
| --- | ---: | ---: |
| Full page WPF vs Word | 8.3230% | 8.3042% |
| Gold ArchUp ROI `(443,366)-(679,421)` | 8.9803% | 7.7348% |
| Wave1 ROI `(315,215)-(805,310)` | 30.3788% | 30.3788% |

The black glyph ink box moved from `(440,378)-(650,415)` to `(467,368)-(608,394)`;
Word is `(466,366)-(610,397)`. The independent
`wordart-picture-watermark-layout` ArchUp/DrawingML-picture control stayed
SHA-256 identical:

`98D465EE4F3A6C93A71CD2D5A25A9B64FFCA610A0656D7E25C163DD1CB481496`.

## Verification

- `FloatingOverlay_RendersWarpedWordArtWithContrastingTextAndFill` and
  `InlineOverlay_RendersArchUpWordArtThroughWarpedVisualAdapter`: 2/2 passed.
- `WordArtPlacementSourceGuardTests`: rerun with the narrow signature guard.
- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors.
