# FreeP PDF Picture Crop Export Evidence

Date: 2026-07-13

## Scope

This slice extends the shared FreeP fixed-layout PDF path after the picture-frame clipping and alpha slices. It covers source-image crop rectangles that FreeP already preserves in the model as `PictureFormat` crop fields from `a:srcRect`:

- Picture shapes with modeled left/top/right/bottom crop margins now carry those margins into the shared `PdfImage` draw op.
- The dependency-free portable PDF writer keeps the original image resource intact and emits a destination clip plus expanded image transform so the cropped source region fills the authored picture bounds.
- The Skia PDF writer applies the same crop through native source/destination image drawing.
- Pictures without source crop continue to export through the existing uncropped image placement path.

The implementation stays in the no-COM shared PDF export path used by WPF and Avalonia FreeP surfaces. It does not add host-specific rendering, arbitrary image effects, or PowerPoint automation.

## Evidence

Focused regression coverage:

- `tests/Free.Shared.Pdf.Tests/PortablePdfWriterTests.cs`
  - `Write_EmitsSourceCroppedImagePlacementWithDestinationClip`
- `freep/FreeP.App.Host.Tests/PresentationPdfExporterTests.cs`
  - `BuildDocument_CarriesPictureCropToPdfImageSourceCrop`

These tests prove that modeled FreeP picture source crop reaches the shared PDF draw-op model and is serialized into concrete PDF clip/transform operators without requiring PowerPoint COM.

## Remaining Work

This slice does not claim PowerPoint-authoritative visual parity. Remaining PDF/export fidelity gaps include grayscale/brightness/contrast picture effects, shape fill/outline transparency, shadow/glow/soft-edge effects, arbitrary custom/freeform geometry clipping, and broader real-deck PDF comparisons against PowerPoint on a COM-capable machine.
