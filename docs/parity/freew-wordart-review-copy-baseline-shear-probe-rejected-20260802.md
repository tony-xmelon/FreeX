# FreeW Review Copy ArchUp shear probe rejected (2026-08-02)

## Scope

The exact current `wordart-watermark-stress.docx` fixture was regenerated and exported through an
isolated visible Word 16 COM instance using the short `C:\FWV4` staging path. Word completed create,
ready, open, export, close, and owned-process quit in about 2.5 seconds; the complete PDF raster run
finished in 7 seconds.

- Current fixture SHA-256: `C726C8F8BE40567F6112057120A93B5CD5FE8F8912829A6C35D2D6FBD93521C0`
- Word PNG SHA-256: `08FC07DB49E17BDCB9C6841905F34DE6E5767EFFA228C97BB94914786645EB2B`
- Restored WPF PNG SHA-256: `5BB23C1C3AFD90ABD7DC902A6ECAAC0C2A232B7FB9EB96965D0C9A719114A479`
- Candidate WPF PNG SHA-256: `F69444F904B2216EA0904CBEC8694235FE3ED09C961E48CD1DF748A1CAFF5E06`
- Every capture is 816x1056 and uses the current Release `FreeW.FidelityRender` composite path.

## Probe

The raw black-glyph mask in the Review Copy panel was already aligned horizontally. Its left band was
about five pixels higher than Word while the right band was about four pixels lower. A WPF-only,
exact-signature probe preserved the shared ArchUp curve and added a linear `0.27` left-to-right baseline
shear. It did not alter the material panel, object anchor, shared planner, other WordArt signatures, or
Avalonia.

## Result

| Region | Baseline | Candidate | Change |
| --- | ---: | ---: | ---: |
| Whole page | 4.1852% | 4.1950% | +0.0098 pp |
| Review Copy `(440,360)-(690,440)` | 4.4226% | 4.8428% | +0.4202 pp |
| Banner control `(310,215)-(810,315)` | 6.0459% | 6.0459% | byte-stable |
| Lower body `(50,440)-(780,850)` | 6.6474% | 6.6474% | byte-stable |

Focused `FloatingObjectRenderTests` plus `WordArtPlacementSourceGuardTests` passed 26/26, and the actual
FidelityRender Release build completed with zero warnings/errors. The candidate was rejected and product
source restored with no semantic diff.

## Process rule

A transformed-text mask envelope can suggest a baseline tilt while the actual mismatch belongs to glyph
path construction and host rasterization. Do not accept or sweep a linear ArchUp shear from bbox evidence;
require the exact object ROI plus whole-page improvement and byte-stable adjacent owners.
