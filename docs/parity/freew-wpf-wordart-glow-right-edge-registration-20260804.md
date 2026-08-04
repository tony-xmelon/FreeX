# WPF WordArt Glow Right-Edge Registration

## Scope

The exact imported `FreeW CONFIDENTIAL` / `GlowBlue` / `Wave1` / 32-point WPF path
painted one DIP too much outer glow on its right edge. The ring keeps its measured
six-DIP left extent and all vertical geometry, but reserves one DIP less on the right.
Glyphs, fill, shared planning, Avalonia, and other WordArt signatures are unchanged.

## Provenance

- Fixture: `wordart-watermark-stress.docx`
- Fixture SHA-256: `757A232A0411105B1144CB315FAA34B686543C4B6FA3E5E750AC50F13B1BBA50`
- Word PNG: 816x1056, SHA-256
  `08FC07DB49E17BDCB9C6841905F34DE6E5767EFFA228C97BB94914786645EB2B`
- Current WPF baseline SHA-256:
  `928536A7241061BBD4F7DC544E44D34ED234ADB1A9F8CDC99568DD42BEBD3C61`
- Candidate WPF SHA-256:
  `6FB11A9C2A8BECE62481CC36D589E89546B25F5D1386E654D59D88B689EC17E5`

## Evidence

Mean absolute RGB channel delta against the matching Word PNG:

| Region | Before | After | Change |
|---|---:|---:|---:|
| Whole page | 4.1851% | 4.1830% | -0.0020 pp |
| Banner | 6.1397% | 6.1047% | -0.0349 pp |
| Tight glyph | 6.7468% | 6.7440% | -0.0028 pp |
| Right edge | 4.4689% | 3.5872% | -0.8817 pp |
| Top edge | 2.5823% | 2.5620% | -0.0203 pp |
| Bottom edge | 5.7546% | 5.7332% | -0.0214 pp |
| Left edge | 8.8652% | 8.8652% | byte-stable |
| Review Copy control | 3.8157% | 3.8157% | byte-stable |
| Lower-body control | 6.6474% | 6.6474% | byte-stable |

The accepted candidate changes 238 pixels, all inside the primary banner region.
A symmetric six-to-seven-DIP expansion regressed the banner by 0.9200 pp and was
reverted. A one-DIP bottom trim improved the combined banner but regressed its own
bottom-edge ROI, so only the independently supported right trim was retained.

## Verification

- Focused WPF WordArt contracts: 26/26 passed.
- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors.
- Exact current-artifact render: 1/1 page.

## Process Rule

Treat each side of an effect envelope as a separate physical owner. Preserve aligned
edges, split combined probes when one subregion regresses, and require target, whole-page,
and independent-object controls before accepting a one-DIP raster calibration.
