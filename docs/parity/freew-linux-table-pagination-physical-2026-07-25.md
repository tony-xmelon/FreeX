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
`deterministic-shared-plan` and `evidenceLevel` `focused-test`. Its evidence
contains both basename-only files `shared-plan-test.txt` and
`avalonia-table-structure-test.txt`; both focused tests must report a passing
summary. Each row is `passed` or `failed`; the promoted contract requires five
passed rows, zero failed rows, and total five.

## Evidence limits

The physical rows prove visible-window discovery, generated-fixture hash
integrity, a geometry-derived physical click inside the document body, and two
stable `Ctrl+End` inputs to the deterministic three-page endpoint. The
automated change comparison starts from the post-click page crop so the focus
click itself cannot satisfy the navigation check. The shared-plan row proves
both the deterministic planner contract and the Avalonia table-structure
rendering test used by the table-page composition path.

The final full screenshot and `final-status-bar-crop.png` are retained for
manual review of the rendered status area; they are not OCR evidence.

This evidence does not include OCR and makes no Word pixel-parity claim. It
also does not claim exhaustive table pagination or general visual parity: the
physical proof is limited to the exercised X11 navigation and rendered state,
while the shared-plan proof is deterministic and focused.
