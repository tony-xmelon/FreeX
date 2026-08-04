# Avalonia Parity Wave 146: FreeX Data Table Dialog

`dialog.DataTable` was recaptured from the current Avalonia source in Linux
Docker/Xvfb against the retained WPF authority. The valid baseline was
`360x210` at 96 DPI, nonblank, with `app_exit=0` and
`capture_validated=true`; its triage score was `0.100622`.

The bounded fidelity correction adds the WPF-observed `8px` gap above the
OK/Cancel row in the Avalonia Data Table dialog. It leaves the WPF authority,
shared planner, input validation, and range-picker behavior unchanged. The
focused source test now guards the action-row spacing.

The edited current-source capture remains `360x210`, nonblank, and validated
with `app_exit=0`; its triage score is `0.099370` and sample delta is
`0.042124` (baseline `0.043377`).

Verification: `DataTableDialogParitySourceTests` passed `2/2`; targeted Linux
Docker/Xvfb capture passed exact-size and nonblank guards.
