# FreeP PDF Custom Geometry Arc Export Evidence

Date: 2026-07-13

## Scope

This slice tightens FreeP fixed-layout PDF export for authored custom/freeform geometry that already exists in the model as `CustomSegmentKind.ArcTo`:

- `PresentationPdfExporter` now converts custom-geometry arcs into cubic `PdfPathSegment` draw ops instead of flattening each arc to a straight line.
- The shared `PdfPath` model and both shared PDF writers already serialize cubic Bezier segments, so WPF and Avalonia exports use the same path.
- Existing line, cubic, quadratic-to-cubic, fill, and stroke behavior remains unchanged.

## Evidence

Focused regression coverage:

- `freep/FreeP.App.Host.Tests/PresentationPdfExporterTests.cs`
  - `BuildDocument_ExportsCustomGeometryArcAsCubicPdfPath`

This proves authored custom geometry arc segments reach the shared PDF draw-op path as curves without requiring PowerPoint COM.

## Remaining Work

This slice does not claim PowerPoint-authoritative visual parity. Remaining PDF/export fidelity gaps include shape fill/outline transparency once model support exists, portable-writer JPEG color-effect pixel rewriting without adding non-portable decoder dependencies, richer shape-effect baselines, custom picture clip masks, and broader real-deck PDF comparisons against PowerPoint on a COM-capable machine.
