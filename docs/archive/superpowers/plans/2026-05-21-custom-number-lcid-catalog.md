# Custom Number LCID Catalog

## Goal

Keep custom-number locale handling maintainable as the modeled LCID list grows, while adding separator coverage for Norwegian Bokmal (`414`), Turkish (`41F`), Dutch Belgium (`813`), Portuguese Portugal (`816`), and English Canada date separators (`1009`).

## Implementation Notes

- Added red tests for numeric and date separators that previously fell back to invariant formatting.
- Replaced the formatter switch with a table-driven `LocaleFormatCatalog`.
- Architecture decision: the formatter stores deterministic resolved separators in the catalog instead of invoking OS culture services at render time, preserving cross-machine workbook display stability.
