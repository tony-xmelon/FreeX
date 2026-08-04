# Avalonia parity Wave 153 integration

Date: 2026-08-04

Upstream base after final implementation sync: `0eeed25b4d`.

## Accepted slices

- FreeW Avalonia Side-to-Side view now uses a live horizontal page strip. The
  normal paginator remains authoritative, then all page-owned render, hit-test,
  selection, caret, annotation, note, table, and drawing geometry is projected
  to horizontal page origins. The surface exposes horizontal extent, pair
  navigation advances two full page strides, and caret scrolling follows later
  pages horizontally. PDF/export keeps normal print coordinates.
- FreeX, FreeW, and FreeP Avalonia hosts now own and pass the shared
  `RibbonStateStore`. Live enabled, checked, and combo-value changes propagate
  through the same state contract used by WPF, and toggle/checkbox state is
  published before command execution. Contextual-tab bindings detach and rebind
  with their logical-tree lifecycle.

## Clean audits

- FreeX's Linux interaction paths for grid editing, autofill, selection-border
  dragging, formula pointing, context menus, keyboard shortcuts, and outlines
  have production implementations and harness probes. No reproducible
  nonexternal Avalonia-only gap was found in this bounded audit.
- FreeP retains complete shared command routing. Its remaining SmartArt,
  ChartEx, Zoom, media, and recording depth requires native PowerPoint or device
  evidence rather than another source-only patch.

## Remaining evidence

FreeW's generated dialog comparison still classifies `158` rows as genuine
visual mismatches and `105` as Avalonia extensions. The largest repeated
mismatch families are table properties, legal notices, page setup, options,
font, and paragraph. These are the next app-owned visual calibration queue;
authoritative Word baselines remain external evidence.

## Verification

- FreeW worker lane: `33/33` passed.
- Shared ribbon worker lane: `11/11` passed.
- FreeX production host state-store lane: `1/1` passed.
- Combined integration verification is recorded after final testing.

Detailed slice notes:

- `freew/docs/parity/freew-side-to-side-horizontal-page-grid-wave153-20260804.md`
- `shared/Free.Shared.Ribbon/wave-153-avalonia-state-refresh-parity.md`
