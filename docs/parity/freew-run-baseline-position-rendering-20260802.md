# FreeW run baseline-position rendering

## Scope

FreeW already retained and authored WordprocessingML `w:position` values in half-points. This slice makes
that model property visible in the WPF and Avalonia compositors and in Avalonia PDF export.

Positive values raise glyphs and negative values lower them. The shared planner converts points to the
host's downward-positive DIP coordinate system without changing line advance or line height.

## Owners

- WPF editable runs use a `TextEffect` translation, preserving FlowDocument wrapping and caret geometry.
- Avalonia body, notes, headers/footers, revision decorations, and proofing marks use the same planned offset.
- Floating shape glyphs and caret stops receive the offset in the shared drawing-text layout plan.
- Avalonia PDF run grouping includes `PositionPt`, and body/header/floating baselines preserve the authored
  point offset in PDF coordinates.
- The zero-position path adds no transform and retains existing geometry.

## Verification

- `RunBaselinePositionPlannerTests` and `DrawingObjectVisualPlannerTests`: 33/33.
- WPF `PagedEditRoundTripTests`: 10/10.
- Avalonia `DocumentViewPdfExportTests`: 69/69.
- Avalonia header/footer render and edit tests: 26/26.

No Word COM raster was required for this semantic slice: direction and units are defined by the serialized
`w:position` payload, while the existing DOCX round-trip tests already cover the package representation.
