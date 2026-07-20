# FreeW tracked revision change bars

## Scope

Word's `f2-tracked-changes` All Markup capture contains two one-pixel black gutter bars at
`x=48`: `y=161..178` for the first inline revision group and `y=208..264` for the two adjacent
changed paragraphs. The FlowDocument paginator provides no public line-rectangle API after its
visual is detached for headless composition, so this belongs to the fidelity composite layer.

## Change

After the body page is rasterized, `FreeW.FidelityRender` locates the already-painted revision
author colors, joins nearby bands into one change group, and paints the Word-measured gutter marker
at half the left page margin. Documents with no revision authors return before the pixel scan and
remain on their existing render path.

## Matched Word evidence

Persistent Word COM baseline and WPF composite candidate were both `816x1056`.

| Page | Before | After | Result |
| --- | ---: | ---: | --- |
| `f2-tracked-changes` page 1 | 2.3649% | 2.3562% | -0.0087 pp |
| `f2-tracked-changes` page 2 | 1.2799% | 1.2799% | SHA-256 stable |

The candidate gutter bands exactly match Word: `161..178` and `208..264` at `x=48`.

## Verification

- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors.
- Fresh tracked-change render emitted both pages through the `composite` path.
- Page 2 SHA-256: `E0B3E655C951300D75BECDE54454F5645ADB5B9E5306DACF1B816DF7176255FE`.
