# FreeW Mail Merge Print Documents Parity (2026-08-04)

## Scope

`Mailings > Finish & Merge > Print Documents` now supports Word-style recipient selection:

- All records
- Current record
- One-based From/To ranges

`Send E-mail Messages` remains explicitly unavailable until a delivery pipeline exists.

## Behavior

Both WPF and Avalonia build the selected merged output with the existing composite-field,
merge-rule, skipped-record, Letters, and Directory semantics. Printing uses a temporary merged
document and does not replace the visible preview, discard the stored template, reset the current
record, or mutate recipient/mapping state. Canceling printer selection preserves the same state.

WPF feeds a temporary `DocumentView` into the existing page-aware paginator and native print dialog.
Avalonia exports a temporary `DocumentView` to PDF, submits it through the platform print service,
and deletes the temporary PDF after submission or failure.

## Verification

- Shared finish planner: 13/13 focused tests passed.
- WPF command and preservation contracts: 3/3 focused tests passed.
- Avalonia mail-merge and print lifecycle: 41/41 focused tests passed.
- Avalonia fake-spool test confirms the selected record reached the submitted PDF and the temporary
  PDF was deleted afterward.
- `git diff --check` passed.
