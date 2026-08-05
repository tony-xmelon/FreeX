# FreeW Table of Figures page-reference parity

## Gap

FreeW generated Table of Figures, Tables, Equations, and custom-caption indexes with caption text only.
Microsoft Word entries also carry a right-aligned dotted leader and the caption's displayed page label.
The omission made the generated index functionally incomplete and prevented section restarts or
Roman/letter numbering from appearing at all.

## Change

`TableOfFigures.Build` now emits three-run entries: caption text, tab, and page label. Each entry has a
right-aligned dotted tab stop at the document's writable page width. An optional block-to-page-label
resolver supplies live logical labels; authored page breaks provide the deterministic decimal fallback.

WPF and Avalonia now use the same generated-page resolver for Table of Contents and Table of Figures.
Physical caption placement comes from the host, while `PageNumberFormatDialogPlanner` remains the sole
owner of section continuation/restarts, Roman or letter formats, and chapter prefixes. Built-in and
custom caption-label selection, insertion position, region refresh, and undo grouping are unchanged.

## Verification

- Table of Figures and Table of Contents model contracts: 29/29.
- Page-number and header/footer planner controls: 22/22.
- WPF caption/generated-reference/cross-reference controls: 13/13.
- Avalonia complete References-tab controls: 63/63.
- WPF and Avalonia consuming Release test builds: 0 warnings, 0 errors.

Both real-host fixtures start page numbering at 4 in upper Roman format, place a figure caption after
an authored page break, and assert that refresh emits `Figure 1: Architecture\tV`. Shared model tests
also prove custom writable-width tab placement, a supplied lower-Roman `iv` label, null-label decimal
fallback, and explicit-break progression from page 1 to page 2.

## Evidence boundary

This is deterministic generated-index behavior and does not require a Word raster baseline. The page
reference structure and logical text now match Word's functional contract; typography, leader density,
and final pagination remain visual-comparison concerns.
