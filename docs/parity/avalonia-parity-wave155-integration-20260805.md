# Avalonia Parity Wave 155 Integration

Date: 2026-08-05

## Integrated slices

- FreeP rich inline table-cell editing now starts from the shared rich edit plan, preserves rich runs and metadata, supports the shared formatting shortcuts, cancels cleanly on Escape, and commits before Tab navigation.
- FreeW Thesaurus now exposes the WPF-authority Insert and Copy actions through the shared presentation plan, with command-bus-backed replacement and capability-based clipboard enablement.
- FreeW Table Properties Cell normalizes the four disabled Positioning combo surfaces without changing state, bindings, automation IDs, or behavior.
- FreeX Data Table now uses WPF-sized route-local controls, matching content insets and fixture values, and neutral label styling.
- WPF remains authoritative for the Thesaurus insert glyph; the integrated correction retains its existing glyph and makes Avalonia reuse it.

## Evidence

- FreeP Avalonia rich editor: 37 passed; shared `TableCellEditPlanner`: 54 passed.
- FreeW Avalonia Thesaurus and Table Properties parity: 8 passed; shared Thesaurus planner: 2 passed; WPF Table Properties: 3 passed.
- FreeX Avalonia Data Table and range selection: 8 passed; paired WPF Data Table host coverage: 178 passed.
- FreeX Data Table focused pixel diff improved from 2.6681% to 1.6709%; triage score improved from 0.076399 to 0.061774 at an exact nonblank 360x210, 96 DPI capture.
- FreeW Table Properties Cell improved from 18.95% / 10.83 to 12.21% / 8.07 ratio/mean; the seven-state average improved from 8.8695% / 6.2754 to 7.9064% / 5.8810. Column remains a pass at 2.60% / 2.10.

## Remaining

- FreeP inline table cells do not yet expose the complete WPF row, column, merge, split, and paragraph command surface, and their undo unit remains the enclosing shape edit.
- FreeW Table Properties still has native disabled-painting, control-width, and fixed-height clipping differences; six of seven paired states remain genuine visual mismatches.
- FreeX Data Table retains native WPF/Avalonia text and control-border rasterization differences.
- Physical clipboard pairing still requires an attached Avalonia `TopLevel.Clipboard`.
- The tracked FreeW aggregate report predates the Wave 154 and Wave 155 route improvements. Fresh route evidence is recorded in the wave notes; its aggregate counts must be regenerated before they are quoted as current parity totals.

This wave improves four scoped surfaces but does not claim complete Avalonia/WPF parity.
