# FreeW Table of Contents logical-page parity

## Gap

Generated Table of Contents entries always used decimal page numbers derived from authored page
breaks. A heading on physical page 2 in a section numbered `IV, V` therefore appeared as page `2`
in the TOC even though PAGE, Table of Authorities, and PAGEREF fields displayed `V`.

## Change

`TableOfContents.Build` now accepts an optional block-to-page-label resolver. WPF and Avalonia supply
the same host physical-page resolver and shared `PageNumberFormatDialogPlanner` label resolver used by
PAGEREF. TOC entries therefore follow live placement, section restarts and continuation, Roman/letter
formats, and chapter prefixes through one numbering owner.

The existing explicit-break decimal calculation remains the headless and unresolved-block fallback.
TOC structure, styles, dotted tab leaders, insertion position, and undo grouping are unchanged.

## Verification

- Complete Table of Contents model contracts: 15/15.
- Page-number and header/footer planner controls: 22/22.
- WPF generated-reference and cross-reference controls: 11/11.
- Avalonia complete References-tab controls: 62/62.
- WPF and Avalonia consuming Release test builds: 0 warnings, 0 errors.

The real-host fixtures start page numbering at 4 in upper Roman format, place a heading after an
authored page break, and assert that refresh replaces stale `9` with `V`. The model contract separately
proves that a supplied `iv` label is used while a null label retains decimal `1` fallback behavior.

## Evidence boundary

This slice changes deterministic generated-field text and needs no Word raster baseline. Physical
placement remains host-owned; page-label semantics remain shared. Pixel fidelity of TOC typography,
leaders, and pagination is a separate visual lane.
