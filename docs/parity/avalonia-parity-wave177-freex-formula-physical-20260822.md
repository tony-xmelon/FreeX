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

`formula-reference-grip` did not pass the final save assertion. The authoritative run is `20260822T080731Z`.

- Manifest: `artifacts/linux-interactive/freex/interaction-validation/20260822T080731Z/x11-validation/x11-input-results.json`
- Postcondition: `artifacts/linux-interactive/freex/interaction-validation/20260822T080731Z/x11-validation/formula-reference-grip-postcondition.txt`
- Evidence: `formula-reference-grip-before.png`, `formula-reference-grip-dragging.png`, `formula-reference-grip-committed.png`, and `formula-reference-grip-save-confirm.png` in that directory.
- Exact formula and result assertions passed: `=SUM('Sheet2'!B2:C3,'Sheet2'!D4:F6)` and `15`.
- The real production `Possible Data Loss` dialog was captured, but the X11 probe could not close the nested Avalonia dialog. Therefore `save-confirmation=not-closed` and `save-clean=false`; no pass is claimed.

## Classification

No production defect was established in the assigned formula behavior. The grip moved the second reference area and committed the exact formula/result. The remaining failure is probe input delivery to the production-owned synchronous Avalonia confirmation dialog. The probe change in this commit preserves the exact formula, result, prompt screenshot, and clean-title assertions while adding active-focus keyboard/pointer delivery attempts.

## Verification and cleanup

- `bash -n tools/LinuxInteractiveDocker/run-freex-input-probes.sh` passed inside the harness image `freex-linux-interactive:ubuntu24.04`.
- `git diff --check -- tools/LinuxInteractiveDocker/run-freex-input-probes.sh` passed.
- Wave177 container `freex-linux-interactive-freex-6185` is stopped; no Wave177 container remains.
- The exact Wave177 app image is removed after commit cleanup.

Residual: rerun `formula-reference-grip` after improving X11 delivery for the nested confirmation dialog; the product formula/grip path itself has physical evidence, but the selector is not yet a complete pass.
