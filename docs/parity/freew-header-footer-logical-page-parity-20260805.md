# FreeW header/footer logical page parity

Date: 2026-08-05

## Scope

When different odd/even headers are enabled, Microsoft Word uses the section's page-number starting
value to decide whether its first page is odd or even. FreeW selected the slot from the ordinal page
within the section, so a section restarted at page 2 incorrectly displayed the default/odd header on
its first page.

## Change

`HeaderFooterPagePlanner.ResolveSlots` now accepts the effective logical page number for parity
selection. `DifferentFirstPage` remains authoritative before parity, and callers without a logical
number retain the section-relative fallback.

The WPF paginated build, both WPF rebuild paths, synthetic endnote page, Avalonia page layout, and
shared visual-evidence planner now pass the logical number already computed by
`PageNumberFormatDialogPlanner`.

## Evidence

- section-relative page 1 restarted at logical page 2 selects the even header;
- section-relative page 2 displayed as logical page 3 selects the default/odd header;
- first-page header precedence and the existing section-relative fallback remain covered controls.
- focused shared planner tests: 15/15;
- focused WPF paginated header/footer tests: 43/43;
- focused Avalonia header/footer tests: 11/11.

Source contract: Microsoft [MS-OE376] 2.1.298 states that Word uses the `pgNumType/@start` value for
the parent section to determine whether its first page is even or odd.
