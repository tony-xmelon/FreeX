# FreeW native Word artistic-preview ownership

## Scope

Word-authored Office 2010 artistic effects store an already-rendered preview in the normal `a:blip`
image part and the editable source in `a14:imgProps/a14:imgLayer`. FreeW previously read only its private
effect id. Hybrid/native packages could therefore apply the same artistic filter to Word's baked preview a
second time.

This slice:

- imports all modeled native `a14:imgEffect` element names;
- records baked-preview provenance on `InlineImage`;
- skips the duplicate artistic raster pass in WPF and Avalonia;
- retains that provenance through FreeW save/reopen and document-copy paths;
- emits native effect metadata only when the image bytes are already a baked preview;
- calibrates the exact WPF object-format reflection from 50% to 25% opacity for the native baked route.

FreeW-authored non-baked images continue to use the existing non-destructive renderer and private extension.
They do not claim to contain Word's native preview/source pair.

Reconstructing or re-encoding Word's editable HD Photo source relationship for a newly authored FreeW effect
remains a separate package-export slice. This change preserves native preview ownership and effect identity;
it does not treat a PNG as an interchangeable HD Photo source.

## Word evidence

- Source DOCX SHA-256: `04C152373C63660DF9329E21095A0143647700B4E3DD695E232A48655CA5B7D3`
- Native-only package variant SHA-256: `4FCCB0FA851E817A133E6A418AE459507E4748022C2521A3CB3DF4F0D8847600`
- Word PNG SHA-256: `9257F8FADF41BEFD33EF2BC4F5F598A7DD6E9E83C1AC5B54F7AE3BFD7EF009EB`
- Capture size: `816x1056`
- Export path: isolated visible Word COM, short `C:\Temp` PDF staging, then the repository PDF rasterizer

The native-only package removes `{FREEW-BLIP-EXT-2024}` and retains the Word-authored `a14` payload. Its
candidate WPF PNG is byte-identical to the hybrid package candidate, proving that native `a14` dispatch is
authoritative.

## Visual result

Mean absolute RGB channel delta against the same Word PNG:

| Region | Before | After | Delta |
| --- | ---: | ---: | ---: |
| Whole page | 14.3812 | 14.3647 | -0.0165 |
| Picture plus reflection `(320,245)-(515,490)` | 49.5468 | 49.3472 | -0.1996 |
| Reflection `(320,375)-(515,490)` | 43.8422 | 43.3548 | -0.4874 |
| Clean upper picture core `(340,265)-(500,315)` | 50.2310 | 43.3564 | -6.8746 |
| Header/control `(85,65)-(720,235)` | 14.3691 | 14.3691 | 0.0000 |

Changed-pixel ratio also improved for the whole page (`14.1298% -> 14.0177%`) and picture/reflection ROI
(`97.2161% -> 95.1941%`). The rejected 10-point reflection-distance probe worsened the reflection ROI and
was reverted.

## Verification

- `ArtisticEffectRoundTripTests`: 52/52
- `ArtisticEffectCommand_RestoresBakedPreviewProvenanceOnUndo`: 1/1
- WPF baked-preview/effect contracts: 2/2
- Avalonia baked-preview contract: 1/1
- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors

## Process rule

For native Office picture effects, inspect package ownership before tuning pixels. An `a14:imgLayer` effect
means the ordinary image part is a baked preview; do not apply the artistic filter again. Keep reflection and
other compositor effects as separate owners, require target-core plus full object plus whole-page improvement,
and keep unrelated controls byte-stable.
