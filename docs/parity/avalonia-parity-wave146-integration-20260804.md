# Avalonia parity Wave 146 integration

Date: 2026-08-04

## Accepted slices

- FreeX Data Table dialog action spacing now matches the WPF authority's 8-pixel
  separation. A valid nonblank Docker/Xvfb capture at 360x210 improved the
  current-source score from `0.100622` to `0.099370`.
- FreeW Paragraph dialog line-and-page-breaks content now uses the WPF section
  and checkbox spacing contract. The focused Avalonia capture passed its target
  and full-frame gates at 560x600; the unsupported blank WPF capture was excluded.
- FreeP authored Grid Matrix SmartArt now uses flat Level 0 quadrant components
  and preserves the live layout through PPTX writer/reader round-trip.
- Shared tabbed-dialog chrome now defines one host-neutral one-pixel pane frame,
  adjacent-tab overlap, and selected-tab/content overlap contract consumed by
  both WPF and Avalonia.

## Integration review

Each worker used a disjoint worktree and committed a bounded slice. Integration
rebased onto current `origin/main` before accepting the commits and reran the
focused FreeP, FreeW, shared Avalonia, and shared WPF contracts from the combined
tree.

Focused verification passed: FreeX Data Table `2/2`, FreeP Grid Matrix `1/1`,
FreeW paragraph spacing `1/1`, shared Avalonia tab chrome `1/1`, and shared WPF
tab chrome `1/1`.

The current-source repository preflight passed across 125 projects, 92 main
solution entries, 22 default-test entries, and 11,020 conflict-marker-scanned
text files. It also confirmed 33/33 current FreeP whole-window evidence pairs.
The upstream ChartEx series-layout command required deterministic regeneration
of the FreeP command inventory (`649/649`) and its cross-app dashboard view.
After the final `origin/main` merge, repository preflight passed again and the
92-project `FreeX.slnx` Release build completed with zero warnings and zero
errors.

## Evidence boundary

This wave proves only the named dialog, Grid Matrix authoring, and shared tab
chrome contracts. It does not claim complete dialog, SmartArt, or cross-platform
visual parity, and a blank or unsupported authority capture is not counted as
visual evidence.
