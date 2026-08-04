# Avalonia Parity Wave 142: FreeX Data Table Dialog

## Scope

`dialog.DataTable` was a valid paired FreeX residual with a retained WPF
authority at logical `360x210` and a prior triage score of `0.068`. The
Avalonia builder was semantically wired to the shared `DataTablePlanner`, but
its dialog layout stacked labels above bare text boxes and did not render the
WPF worksheet range-picker buttons.

## Change

- Rebuilt the Avalonia form as the WPF two-row label/editor layout at the same
  `360x210` dialog size.
- Reused the existing shared Avalonia dialog range-picker button and session
  contract for both row and column input cells.
- Switched Data Table labels, title, automation names, help text, and action
  labels to the existing shared localization resources, stripping WPF mnemonic
  markers at the Avalonia boundary.
- Added an evidence-only parity fixture that opens with the retained WPF
  values `E2` and `F2`. Normal production opening still defaults both inputs to
  blank and retains normal shared-planner validation on accept.
- Suppressed live validation while the populated parity fixture is first
  rendered, matching the retained WPF screenshot state; edits and OK still use
  the normal planner validation path.

## Evidence

Fresh Linux evidence was produced by the bounded Docker/Xvfb harness:

- `dialog.DataTable.png`: exact `360x210` at 96 DPI
- `app_exit=0`
- `capture_validated=true`
- nonblank PNG
- visible `E2`, `F2`, both `...` range-picker buttons, and no initial warning

The old canonical Avalonia PNG was a blank, stacked-label fixture and scored
`0.068` against the retained populated WPF PNG. That is not a valid before/after
product comparison because the states differed. The matched populated final
pair scores `0.101` under the repository triage metric. The increase is recorded
as fixture correction, not presented as a visual improvement claim.

## Verification

- `DataTableDialogParitySourceTests`: `2/2`
- Avalonia Release build: `0 warnings, 0 errors`
- Linux Docker capture: exact-size, nonblank, exit 0

## Residuals

The final pair still contains normal Linux/Avalonia versus WPF font metrics,
text antialiasing, and native text-box/button chrome differences. The retained
WPF raster remains the authority; no blank capture was promoted.
