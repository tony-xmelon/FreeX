# FreeP PDF Picture Frame Export Evidence

Date: 2026-07-13

## Scope

This slice extends the shared FreeP fixed-layout PDF path after the ellipse/oval PDF export slice. It covers picture-frame clipping for PowerPoint picture presets that FreeP already preserves and renders in WPF/Avalonia:

- `ellipse` picture frames export as clipped bitmap images instead of rectangular image boxes.
- `roundRect` picture frames export as clipped bitmap images using the same `min(width,height) * 0.18` radius used by the WPF and Avalonia slide renderers.
- `rect` and unknown picture-frame presets continue to export as unmasked rectangular images.

The implementation stays in the no-COM path. It adds a shared `PdfImageClipKind` to the portable PDF draw-op model, maps `SlideShape.PictureFrameGeometry` in `PresentationPdfExporter`, and emits equivalent clipping in both `PortablePdfWriter` and `SkiaPdfWriter`.

## Evidence

Focused regression coverage:

- `tests/Free.Shared.Pdf.Tests/PortablePdfWriterTests.cs`
  - `Write_ClipsImageToEllipse`
  - `Write_ClipsImageToRoundedRectangle`
- `freep/FreeP.App.Host.Tests/PresentationPdfExporterTests.cs`
  - `BuildDocument_CarriesPictureFrameGeometryToPdfImageClip`

These tests prove that WPF/Avalonia shared FreeP PDF export preserves the model's non-rectangular picture-frame intent down to concrete PDF clipping operators without requiring PowerPoint COM.

## Remaining Work

This slice does not claim PowerPoint-authoritative visual parity. Remaining PDF/export fidelity gaps include source-image crop rectangles, picture alpha/color effects in fixed-layout PDF output, arbitrary custom/freeform geometry clipping, richer shape effects, and broader real-deck PDF comparisons against PowerPoint on a COM-capable machine.
