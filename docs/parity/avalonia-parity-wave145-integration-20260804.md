# Avalonia parity Wave 145 integration

Date: 2026-08-04

## Accepted slices

- FreeP authored Titled Matrix SmartArt now emits the flat title/body topology expected by the shared layout engine and preserves it through PPTX round-trip. Focused presentation, WPF, and Avalonia renderer contracts cover the exact family boundary.
- Shared dialog action labels now use one `ShellStringText` contract for mnemonic escaping, visible text, automation names, and accelerator lookup. Avalonia exposes a stable action-label snapshot instead of requiring tests to inspect framework object `ToString()` values.
- FreeW Footnote/Endnote, Tabs, and Page Setup dialog tests now verify visible labels and default/cancel semantics through the shared Avalonia action-label inspector. The integrated focused set passes 19/19.
- FreeX Insert Hyperlink now uses the shared Windows-style list template with compact four-row metrics and a local inactive-selection override. Against the valid current-source baseline, the paired score improved from `0.076517` to `0.074729` (2.34%) at exact `560x300` dimensions.

## Integration review

The shared and FreeW workers initially produced parallel label-extraction switches. Integration removed the app-local duplication and routed all affected FreeW assertions through `AvaloniaActionLabelInspector`. A missing namespace import was caught by the first integrated build and corrected before the focused suite passed.

The first FreeX result compared a candidate against a stale pre-Wave-141 raster. Integration rejected that comparison and required the candidate to be judged against the freshly captured current-source baseline instead.

## Evidence boundary

This wave proves only the named dialog-label, SmartArt-family, and targeted visual surfaces. It does not claim complete SmartArt, dialog, or cross-app parity, and it does not replace missing authoritative WPF/Office captures.
