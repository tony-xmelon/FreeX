# Avalonia parity Wave 151 integration

Date: 2026-08-04

Final upstream base: `d1751f1e08b3`.

## Accepted slices

- FreeX Avalonia Print Preview now provides an Entire Workbook page stream in
  visible-sheet order, including configured print areas, running page numbers,
  aggregate totals, comments-at-end appendix pages, empty-sheet handling,
  scope repagination, and matching PDF export routing.
- FreeW Avalonia Print Layout now applies Justified page vertical alignment to
  multi-column body flow. Floating and inline geometry uses the owning block's
  flow column, so visually cross-column objects, nested groups, wrap zones,
  selection geometry, caret stops, and hit testing remain aligned.
- Shared WPF and Avalonia popup adapters now consume one keyboard interaction
  planner. Avalonia context menus focus the first enabled item, traverse while
  skipping disabled items and separators, open and close nested submenus, and
  restore focus when dismissed.
- FreeP's source parity audit found no remaining non-external WPF-over-Avalonia
  functional divergence for this wave. Its remaining boundaries require native
  or external evidence rather than another source-only host patch.

## Integration review

The FreeW slice was revised before acceptance so object offsets are keyed to
the anchor block rather than `Rect.X`. Regression coverage includes both a
left-column anchor positioned into the right column and a right-column anchor
positioned back into the left column.

FreeX moved the former WPF-only printed-comment filter into shared presentation
without changing its policy. The WPF renderer and Avalonia workbook preview now
use the same filter and page-count inputs.

## Evidence boundary

FreeX preview still uses platform-native page viewers and text rasterization,
so viewer chrome can differ even though pagination and painting instructions
are shared. FreeW's model still exposes document-wide page settings rather than
full section-specific metrics. FreeP still needs native recording, OLE, device
media, and PowerPoint-authoritative visual evidence. Toolkit-specific popup
composition remains native beyond the shared interaction policy.

## Verification

Integration-focused verification passed before the repository-wide lane:

- shared popup interaction: `3/3`;
- FreeX workbook pagination: `4/4`;
- FreeX Avalonia workbook preview: `2/2`;
- FreeW worker verification: `75/75` Avalonia geometry tests and `11/11`
  planner tests, plus a zero-warning Release build.

Repository preflight passed across `220` JSON files, `261` XML-backed files,
`125` .NET projects, `92` solution entries, and `11,098` text files. FreeP
evidence remains current at `28/28` dialog/pane pairs and `33/33` whole-window
pairs. The full Release solution build completed with zero warnings and zero
errors.

The default non-UI projects cover `36,480` executed tests and `134` skipped
benchmark or explicit cases. The repaired Avalonia assembly passed `2,043/2,043`
standalone. Aggregate WPF host runs exposed three unrelated OS-clipboard flakes;
each failing case passed immediately in isolation (`3/3`), and no Wave 151
slice changes clipboard code. The final upstream FreeP Zoom and FreeW native
pagination changes passed `282/282` focused tests after the last sync.

Detailed slice notes:

- `freex-avalonia-entire-workbook-print-preview-wave151-20260804.md`
- `freew/docs/parity/freew-avalonia-justified-multicolumn-wave151-20260804.md`
- `shared/Free.Shared.Ribbon/wave-151-popup-interaction-parity.md`
