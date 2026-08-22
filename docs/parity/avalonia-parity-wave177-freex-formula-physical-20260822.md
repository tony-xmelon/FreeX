# FreeX Wave177 Formula Physical Checkpoint

Date: 2026-08-22
Platform: Avalonia Linux Docker/X11
Canonical geometry: 1280x820 at 96 DPI
Branch base: `1c93796b91503457bf6afe4a601268e6c669c5bc`

## Selector results

`formula-multi-area-edit` passed independently at `20260822T073308Z`.

- Manifest: `artifacts/linux-interactive/freex/interaction-validation/20260822T073308Z/x11-validation/x11-input-results.json`
- Postcondition: `artifacts/linux-interactive/freex/interaction-validation/20260822T073308Z/x11-validation/formula-multi-area-edit-postcondition.txt`
- Exact assertions: quoted cross-sheet formula, normalized formula, result `30`, and physical selection of `Revenue Data!J7`.
- Calibration passed with A1 at `(29,236)` and `64x20` cells.

`formula-reference-grip` passed independently in the final authoritative run `20260822T082607Z`.

- Manifest: `artifacts/linux-interactive/freex/interaction-validation/20260822T082607Z/x11-validation/x11-input-results.json`
- Postcondition: `artifacts/linux-interactive/freex/interaction-validation/20260822T082607Z/x11-validation/formula-reference-grip-postcondition.txt`
- Evidence: `formula-reference-grip-before.png`, `formula-reference-grip-dragging.png`, `formula-reference-grip-committed.png`, and `formula-reference-grip-save-confirm.png` in that directory.
- Exact formula and result assertions passed: `=SUM('Sheet2'!B2:C3,'Sheet2'!D4:F6)` and `15`.
- The real production `Possible Data Loss` dialog was captured and accepted through X11 after the nested-loop fix. The manifest records `save-confirmation=accepted` and `save-clean=true`.

## Classification

The formula behavior was correct; the production defect was in the shared synchronous Avalonia dialog host. It used `Dispatcher.UIThread.RunJobs(DispatcherPriority.Input)`, which Avalonia documents as ignoring pending OS events, so the real X11 Yes/No dialog could not consume keyboard or pointer input. The fix uses `Dispatcher.PushFrame` with the dialog's `Closed` event as the primary exit and a low-frequency completion timer for generic predicates. The probe retains exact formula, result, prompt screenshot, and clean-title assertions. The optional prompt screenshot is listed only when the prompt is actually shown.

## Verification and cleanup

- `bash -n tools/LinuxInteractiveDocker/run-freex-input-probes.sh` passed inside the harness image `freex-linux-interactive:ubuntu24.04`.
- `git diff --check -- tools/LinuxInteractiveDocker/run-freex-input-probes.sh` passed.
- Shared shell dialog tests passed: `5/5`.
- `FreeXPracticalResidualOwnershipTests` passed: `9/9`.
- Final physical selector passed: `1/1` at `1280x820 / 96 DPI`, with calibration passed and the exact prompt screenshot retained.
- Wave177 containers `freex-linux-interactive-freex-6187` and `freex-linux-interactive-freex-6189` are stopped; exact Wave177 images/temp resources are removed after commit cleanup.

Residual: the sibling `formula-multi-area-edit` pass remains authoritative at `20260822T073308Z`; no assigned selector remains unpassed.
