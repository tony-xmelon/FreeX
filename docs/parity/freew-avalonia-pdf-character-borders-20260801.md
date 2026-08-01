# FreeW Avalonia PDF character borders

## Result

The Avalonia direct-PDF path now exports character borders from the shared run
decoration plan and exact placed-run rectangle. Each authored edge is an
independent PDF path contour, so top/left/bottom/right selection and
bottom-only ownership remain intact. Single, dashed, and dotted styles retain
their live DIP cadence after conversion to PDF points.

Borders paint after glyphs and before underline/strikethrough, matching the
live Avalonia draw order. Run grouping now includes the complete border
signature so adjacent, differently bordered runs cannot merge.

## Verification

- `FreeW.App.Avalonia` Release build: 0 warnings, 0 errors.
- `FreeW.App.Avalonia.Tests` Release build: 0 warnings, 0 errors.
- `DocumentViewPdfExportTests|RunDecorationVisualPlannerTests`: 31/31 passed
  from the freshly rebuilt test assembly.
- The focused contract verifies left+bottom-only ownership, dotted dash
  cadence, 1.5 pt width, open one-segment contours, post-text ordering, and
  portable PDF serialization.

## Remaining scope

Clickable hyperlink annotations and review/proofing overlays remain distinct
functional PDF owners.
