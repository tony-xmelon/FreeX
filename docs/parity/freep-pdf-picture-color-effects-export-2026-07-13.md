# FreeP PDF Picture Color Effects Export Evidence

Date: 2026-07-13

## Scope

This slice extends the shared FreeP fixed-layout PDF path after the picture crop and alpha slices. It covers picture color effects that FreeP already preserves in the model as `PictureFormat` fields from `a:blip` child effects:

- Picture shapes with grayscale, bi-level threshold, brightness, and contrast now carry those settings into the shared `PdfImage` draw op.
- The dependency-free portable PDF writer applies the effect math to decoded PNG pixels before embedding the image stream.
- The Skia PDF writer applies the same effect math to decoded image pixels before drawing through Skia.
- Pictures without pixel color effects continue through the existing image path without extra pixel processing.

The implementation stays in the no-COM shared PDF export path used by WPF and Avalonia FreeP surfaces. It does not add host-specific rendering or PowerPoint automation.

## Evidence

Focused regression coverage:

- `tests/Free.Shared.Pdf.Tests/PortablePdfWriterTests.cs`
  - `Write_AppliesPngImageColorEffectsBeforeEmbedding`
  - `PdfImageColorEffectPixels_AppliesBrightnessContrastAndBiLevelInRendererOrder`
- `tests/Free.Shared.Pdf.Tests/SkiaPdfWriterTests.cs`
  - `ApplyColorEffects_TransformsDecodedImagePixels`
- `freep/FreeP.App.Host.Tests/PresentationPdfExporterTests.cs`
  - `BuildDocument_CarriesPictureColorEffectsToPdfImage`

These tests prove that modeled FreeP picture color effects reach the shared PDF draw-op model and are applied in the shared PDF writers without requiring PowerPoint COM.

## Remaining Work

This slice does not claim PowerPoint-authoritative visual parity. Remaining PDF/export fidelity gaps include portable-writer JPEG color-effect pixel rewriting, shape fill/outline transparency, shadow/glow/soft-edge effects, arbitrary custom/freeform geometry clipping, and broader real-deck PDF comparisons against PowerPoint on a COM-capable machine.
