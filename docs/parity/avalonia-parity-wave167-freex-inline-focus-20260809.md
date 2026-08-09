# FreeX Wave167: inline edit continuation focus

## Discrepancy

The focused Linux X11 validation command
`Run-FreeXLinuxInteractionValidation.ps1 -PhysicalOnly -PhysicalProbeSelector grid-drag`
reached the Avalonia workbook at 1280x820 and 96 DPI, but the deterministic seed sequence
could not reliably continue from the first committed edit to the next physical F2 edit. The
retained session evidence was `artifacts/linux-interactive/freex/sessions/20260809T102057249Z/x11-validation`;
its `grid-drag-postcondition.txt` reported `seeded=false`, and the captured grid showed the
first value committed while worksheet focus was not restored to the next active-cell control.
That prevents the subsequent WPF-equivalent fill-handle, selection-move, and Ctrl-copy gestures
from being exercised.

WPF returns focus to the worksheet after inline edit commit (`src/FreeX.App.Host/MainWindow.Editing.cs`),
so the next physical keyboard gesture continues in the grid rather than remaining on a detached
editor or generic shell host.

## Implementation

`MainWindow.CommitInlineCellEdit` now focuses the rebuilt active-cell border after the edit is
committed and Enter/Tab moves the active cell. This is the Avalonia realization of the WPF
worksheet focus handoff and keeps the next physical F2/text packet on the intended cell.

Focused regression coverage drives two consecutive F2 edits through the real inline editor,
asserting both committed values and focus on the next active-cell border between edits.

## Verification

- `git diff --check`: passed.
- The focused .NET test was intentionally deferred while host free RAM remained below 2 GB;
  no broad build or test process was started.
- The prior Docker session stopped its owned FreeX container cleanly. No unowned processes were
  touched.

## Remaining honest residuals

The physical `grid-drag` selector still needs one post-change Docker run when the host has at
least 6 GB free RAM. Its runner also reports missing drag screenshots on the early seed-failure
path; that packaging issue is separate from this behavior slice and remains open.
