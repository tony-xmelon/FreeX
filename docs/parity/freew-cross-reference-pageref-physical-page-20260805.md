# FreeW cross-reference PAGEREF physical-page parity

## Gap

FreeW modeled `PAGEREF` cross-reference fields, but both `Update Fields` host paths called the shared
resolver without a page resolver. Every valid bookmark target therefore refreshed to page `1`, even
when an authored page or section break placed it later in the document.

## Change

`CrossReferences.ExplicitPageNumberAtBlock` now derives an exact 1-based physical page lower bound
from authored `PageBreakBefore`, page-break runs, and next/even/odd section boundaries. It returns no
value for an unpaginated document rather than inventing a page.

WPF and Avalonia build a page resolver only when the document contains a `PAGEREF`. Each host
combines its live placed-page result with the authored lower bound and passes that resolver into the
existing shared field engine. When live layout is unavailable, explicit package evidence remains
usable; an unresolved target retains the existing shared cached/default behavior. Ordinary `REF` and
`NOTEREF` routes are unchanged.

## Verification

- Shared cross-reference and undo contracts: 41/41.
- WPF cross-reference and Table of Authorities controls: 16/16.
- Avalonia complete References-tab controls: 61/61.
- WPF and Avalonia consuming Release builds: 0 warnings, 0 errors.

The host tests place a bookmarked target after an authored page break and assert that `Update Fields`
changes a stale cached `9` to `2` in both renderers. Shared planner coverage also verifies a second
`PageBreakBefore` advances to page 3, an `EvenPage` transition after page 1 starts on page 2, and an
`OddPage` transition after page 1 inserts the parity blank and starts on page 3.

## Boundary

This slice resolves physical pages. Section page-number restarts and non-Arabic page-number display
formats require a separate logical-page field contract; they are not inferred from physical layout.
