# FreeW Linux table pagination physical evidence

This slice covers the `FreeW` Avalonia `table-page-composition-stress` surface
with physical X11 input and a deterministic shared-plan proof.

## Command

Run the host validation command on port `6096` by default:

```powershell
powershell -File tools/Run-FreeWTablePaginationValidation.ps1 -Port 6096
```

The resulting manifest must satisfy
`tools/LinuxInteractiveDocker/freew-table-pagination-validation.schema.json`
and record `contractValidation.status` as `passed` before host promotion.

## Contract

The manifest contains exactly these results, in this order:

1. `visible-window-discovery`
2. `generated-fixture-hash-integrity`
3. `physical-third-page-navigation`
4. `nonblank-final-page-render`
5. `shared-plan-proof`

The first four rows use category `physical-x11-table-pagination` and
`evidenceLevel` `physical-x11-input`. The final row uses category
`deterministic-shared-plan` and `evidenceLevel` `focused-test`. Each row is
`passed` or `failed`; the promoted
contract requires five passed rows, zero failed rows, and total five.

## Evidence limits

The physical rows prove visible-window discovery, generated-fixture hash
integrity, physical navigation to page three, and a nonblank final-page
render through X11 interaction. The shared-plan row proves the deterministic
planner/test contract used by the table-page composition path.

This evidence does not include OCR and makes no Word pixel-parity claim. It
also does not claim exhaustive table pagination or general visual parity: the
physical proof is limited to the exercised X11 navigation and rendered state,
while the shared-plan proof is deterministic and focused.
