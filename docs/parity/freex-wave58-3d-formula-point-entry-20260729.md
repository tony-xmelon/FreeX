# FreeX Wave 58: physical 3-D formula point entry

Date: 2026-07-29

## Scope

The FreeX Linux/X11 input harness previously proved inline and formula-bar
point mode on one worksheet. This slice adds a dedicated physical probe for a
multi-sheet 3-D reference. It is deliberately limited to the existing X11
probe script, its focused source-coverage test, and this evidence note.

## Physical workflow

The probe uses the production Avalonia workbook in the Linux Docker display and
real `xdotool` input to:

1. Click the production `+` sheet button twice to create two worksheets.
2. Physically select the created worksheets and seed `Sheet2!B2=10` and
   `Sheet3!B2=20`.
3. Return to the original sheet, focus the formula bar, enter `=SUM(`, and
   toggle formula-bar point mode through the existing keyboard route.
4. Physically select the `Sheet2` tab, Shift-click the `Sheet3` tab to extend
   the sheet span, physically select the shared `B2` cell on Sheet3, close the
   function, and commit.
5. Read the committed formula and result through the X11 clipboard, while
   retaining screenshots before creation, after creation, at each point-mode
   sheet selection, and after commit.

The credited formula is normalized only for case, spaces, quote marks, and
absolute-reference markers. The expected semantic result is
`=SUM(Sheet2:Sheet3!B2)` and `30`.

## Harness entry points

The dedicated `formula-3d-point` selector runs the row
`formula-bar-point-mode-3d-sheet-range` separately from the existing physical
rows. It is focused-only because the existing sheet-tab probe intentionally
uses fixed coordinates and a fresh one-sheet workbook. Focused iteration can run the dedicated slice in a running FreeX
container with:

```bash
FREEX_X11_PROBE_SELECTOR=formula-3d-point \
  bash /tmp/run-freex-input-probes.sh /work/x11-validation
```

The focused selector is intentionally implemented in the probe script only;
the existing aggregate PowerShell runner's required-row set remains unchanged.
Do not append this selector after the normal `all` lane: the two created sheets
would shift the existing sheet-tab probe's fixed `+` coordinates and its
11-sheet setup assumptions.

## Evidence and residual

The probe emits `formula-3d-*.png` screenshots and
`formula-3d-postcondition.txt` beside the schema-v2
`x11-input-results.json` manifest. A passing row proves physical X11 sheet-tab
switching, point selection across both source sheets, committed 3-D formula
text, and the calculated result. The postcondition records that commit was made
with Sheet3 visible and that the verification then switched to Sheet1 before
reading G10, preventing a false read of Sheet3 G10. It does not claim Office-authoritative pixel
parity, exhaustive 3-D formula grammar coverage, or native screen-reader
coverage. Those remain separate parity work.

## Verification

The source test asserts that the focused selector, physical row, formula
normalization, and 3-D reference contract remain present. Docker execution is
reported separately from source verification because it depends on a running
FreeX Linux validation container and X11 display.

Final evidence from this worktree:

- Focused Docker selector at `1280x820`: `artifacts/linux-interactive-wave58-freex-3d-point-focused/x11-input-results.json`, `1 passed / 0 failed / 1 total`.
- Focused postcondition: committed formula `=SUM(Sheet2:Sheet3!B2)`, result `30`, `commit-visible-sheet=Sheet3`, and `formula-read-sheet=Sheet1` in `formula-3d-postcondition.txt`.
- Full FreeX physical lane: `artifacts/linux-interactive/freex/interaction-validation/20260729T171417Z/x11-validation/x11-input-results.json`, `24 passed / 0 failed / 24 total`, calibration passed.
- Full FreeX managed report: `artifacts/linux-interactive/freex/sessions/20260729T171926150Z/validation/interaction-validation.json`, `705 passed / 705 total`.
- The owned validation container `freex-linux-interactive-freex-6093` was stopped through `Run-LinuxInteractiveDocker.ps1`; no container with that name remains.
