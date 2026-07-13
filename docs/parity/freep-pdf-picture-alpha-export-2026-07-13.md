# FreeP PDF Picture Alpha Export Evidence

Date: 2026-07-13

## Scope

This slice extends the shared FreeP fixed-layout PDF path after the ellipse and picture-frame clipping slices. It covers authored picture opacity that FreeP already preserves in the model as `PictureFormat.AlphaModPct`:

- Picture shapes with `a:alphaModFix` export as semi-transparent PDF images instead of fully opaque image boxes.
- The dependency-free portable PDF writer emits a reusable `/ExtGState` alpha resource and applies it before drawing the image.
- The Skia PDF writer applies the same image opacity when drawing through Skia.
- Opaque pictures continue to export without extra transparency resources.

The implementation stays in the no-COM shared PDF path used by WPF and Avalonia FreeP surfaces. It does not add host-specific rendering, PowerPoint automation, or media/poster behavior.

## Evidence

Focused regression coverage:

- `tests/Free.Shared.Pdf.Tests/PortablePdfWriterTests.cs`
  - `Write_EmitsImageOpacityExtGState`
- `freep/FreeP.App.Host.Tests/PresentationPdfExporterTests.cs`
  - `BuildDocument_CarriesPictureAlphaToPdfImageOpacity`

These tests prove that modeled FreeP picture transparency reaches the shared PDF draw-op model and is serialized into concrete PDF graphics-state alpha operators without requiring PowerPoint COM.

## Remaining Work

This slice does not claim full PowerPoint visual parity for all effects. Remaining PDF/export fidelity gaps include source-image crop rectangles, grayscale/brightness/contrast picture effects, shape fill/outline transparency, shadow/glow/soft-edge effects, arbitrary custom/freeform geometry, and broader real-deck PDF comparisons against PowerPoint on a COM-capable machine.
