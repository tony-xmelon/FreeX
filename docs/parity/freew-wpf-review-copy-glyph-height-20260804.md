# FreeW WPF Review Copy glyph-height calibration

## Scope

The imported `wordart-watermark-stress` fixture contains a `Review Copy` WordArt object with the exact `FillGold` + `ArchUp` signature. WPF already routes this object through a narrow material-panel path, but its glyph raster was four pixels shorter than Word while the surrounding panel geometry was aligned.

The accepted change keeps the shared WordArt placement plan, Avalonia, the material panel, and all other WordArt signatures unchanged. WPF applies a 1.14 vertical glyph scale and a 1.5 DIP center-Y correction only to this exact imported object.

## Provenance

- Fixture SHA-256: `87DC80A76C398FA1DB14A3AE0EB50005B12D4F7EAFEB9BE2BC12FC80AB9904AE`
- Word PNG SHA-256: `08FC07DB49E17BDCB9C6841905F34DE6E5767EFFA228C97BB94914786645EB2B`
- Baseline WPF PNG SHA-256: `5BB23C1C3AFD90ABD7DC902A6ECAAC0C2A232B7FB9EB96965D0C9A719114A479`
- Accepted WPF PNG SHA-256: `928536A7241061BBD4F7DC544E44D34ED234ADB1A9F8CDC99568DD42BEBD3C61`
- Capture size: 816x1056
- Word reference: fresh `Render-WordBaseline.ps1` COM export using the short `C:\Temp\fw-*.pdf` staging path; Word reached ready state, opened, exported, closed, and quit normally.

## Visual evidence

Mean absolute RGB channel difference against the fresh Word PNG:

| Region | Baseline | Candidate | Delta |
| --- | ---: | ---: | ---: |
| Review Copy `(430,350)-(700,440)` | 9.7443% | 9.7299% | -0.0144 pp |
| Tight glyph `(442,365)-(679,425)` | 15.5377% | 15.5131% | -0.0246 pp |
| Whole page | 10.6723% | 10.6719% | -0.0004 pp |
| Blue banner control `(305,215)-(810,315)` | 15.6561% | 15.6561% | pixel-stable |

The black-glyph mask changed from a 145x25-pixel bounding box with 531 pixels to 145x28 with 639 pixels. Word's mask is 146x29 with 656 pixels. Candidate and final verification renders are byte-identical.

A 1.16 refinement was rejected: Review Copy regressed to 9.8731%, the tight glyph ROI to 15.7578%, and the whole page to 10.6760%. Its PNG SHA-256 was `2195DB0867BEAA4529B7D0F8BC552829E7CF35532C92E8F55DED63C36C2EBD92`.

## Verification

- Focused WPF floating-object and shared-placement contracts: 2/2 passed.
- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors.
- Final consuming-renderer output SHA-256 exactly matched the accepted candidate.

## Process rule

For transformed WordArt, calibrate only the exact source/effect signature after proving the effective renderer path. Require target ROI and whole-page improvement, a byte-stable independent object control, and a fresh Word reference from the same fixture before accepting a glyph-raster adjustment.
