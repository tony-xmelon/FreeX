# FreeX Wave 186 AutoFilter Text Criteria Persistence

Date: 2026-08-23

## Scope

Production Linux/X11 validation of two broader worksheet AutoFilter criteria
workflows in the Avalonia shell:

- Text Filters -> Begins With (`North`) keeps `North,Northwest` visible.
- Text Filters -> Equals (`East`) keeps `East` visible.

Each workflow must operate the rendered criteria controls, read the visible
worksheet values, save cleanly, prove the worksheet `customFilter` XML, reopen
through the production Open route, and read the same visible values again.

## Implementation

Added `New-FreeXWave186AutoFilterTextFixture.ps1` and the
`autofilter-text-criteria-persistence` selector to the existing Wave184/185
Docker/X11 lane. The selector fails closed unless both criteria rows are
present and passed, with menu-open, visible-value, save-clean, package, and
reopen postconditions. The shared `FilterPromptPlanner`,
`WorksheetFilterWorkflowSession`, and `FilterConditionCommand` remain the
source of behavior for both WPF and Avalonia.

The load path now materializes worksheet `customFilters` directly, including
inline-string equality and wildcard text values, instead of relying on saved
row-hidden bits. Numeric comparison operators use the same persisted model
shape; existing date serialization and reconstruction coverage remains in
place.

## Evidence

Physical run: production Linux Docker/X11, port 62871, passed 2/2.

- Begins With: `begins-visible=North,Northwest,`,
  `begins-save-clean=true`, package `value=North*`, reopen
  `begins-reopened=North,Northwest,`.
- Equals: `equals-visible=East,,`, `equals-save-clean=true`, package
  `value=East`, reopen `equals-reopened=East,,`.

Both menu-open and dialog-open/closed postconditions passed. The exact
postcondition is recorded in
`artifacts/linux-interactive/freex/interaction-validation/20260823T031732Z/x11-validation/autofilter-text-postcondition.txt`.

Expected package signatures:

- `ref=A1:B5|colId=0|operator=|value=North*`
- `ref=A1:B5|colId=0|operator=|value=East`

## Remaining

Number, date, color, composite/multi-column, and criteria-clear/reapply
workflows remain outside this Wave186 evidence row.
