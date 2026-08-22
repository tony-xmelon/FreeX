# Avalonia Parity Wave178: FreeX Physical Linux Evidence

Date: 2026-08-22
Application: FreeX Avalonia Application host
Display: 1280x820 at 96 DPI
Source revision used by the final physical run: `27bd61472c4fd144f2e7d4eb8ac2a2c6b880baea`

## Authoritative Result

The bounded physical X11 command was:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools/Run-FreeXLinuxInteractionValidation.ps1 -PhysicalOnly -PhysicalProbeSelector all -TimeoutMinutes 20
```

The final runner exited `0` and reported `32 passed / 32 total`, with no skipped rows. The authoritative packaged manifest is:

`artifacts/linux-interactive/freex/interaction-validation/20260822T104255Z/x11-validation/x11-input-results.json`

The packaged HTML report is:

`artifacts/linux-interactive/freex/interaction-validation/20260822T104255Z/interaction-validation.html`

The raw session evidence is under:

`artifacts/linux-interactive/freex/sessions/20260822T104318865Z/x11-validation/`

It contains the raw `x11-input-results.json`, calibration captures, physical screenshots, postconditions, and 201 retained files. The final calibration status is `passed`; the manifest contains 32 physical X11 rows and no failures.

Progression was recorded without weakening or skipping rows: the initial full lane was `27/32` (`artifacts/linux-interactive/freex/sessions/20260822T085650497Z/x11-validation/x11-input-results.json`), cleanup produced `29/32` (`artifacts/linux-interactive/freex/sessions/20260822T092044521Z/x11-validation/x11-input-results.json`), the geometry/readback fixes produced `30/32` (`artifacts/linux-interactive/freex/interaction-validation/20260822T094024Z/x11-validation/x11-input-results.json`), the corrected physical Application launch and split cleanup produced `31/32` (`artifacts/linux-interactive/freex/interaction-validation/20260822T102102Z/x11-validation/x11-input-results.json`), and the corrected narrow scrollbar evidence produced the final `32/32` above.

## Wave178 Fixes

- Window-management cleanup now closes only the created window, restores the original calibrated/maximized geometry, waits for it, and gates the row on `cleanup-geometry-restored=true`.
- The split-pane probe physically re-toggles WSP, sends Ctrl+Home, proves the restored grid crop, and gates the mini-scrollbar row on `split-cleanup-restored=true`.
- The mini-scrollbar still uses a physical left-track click after the rightward Shift+wheel. Its narrow `top-right-content-scrollbar-band` crop records exact ImageMagick AE; the final run recorded `58` changed pixels against a threshold of `50`.
- Plain column outline readback uses exact logical addresses (`E2`, `B2`, `B2/C2/D2`) instead of whole-column clipboard text.
- The phase-one physical runner launches the packaged `FreeX` Application host. The separate TestSupport mapping remains available for managed validation and is covered by a source contract test.

## Verification

Focused split evidence passed `4/4` at `artifacts/linux-interactive/freex/interaction-validation/20260822T104004Z/x11-validation/x11-input-results.json`; its split postcondition recorded `mini-scrollbar-changed-pixels=367` and `split-cleanup-restored=true`.

Source contracts passed:

```powershell
dotnet test tests/FreeX.App.Services.Tests/FreeX.App.Services.Tests.csproj --configuration Release --filter FullyQualifiedName~LinuxFreeXInteractionValidationToolTests --logger "console;verbosity=minimal"
```

Result: `20 passed, 0 failed, 0 skipped`.

## Residuals

- The broad managed `ribbon-bindings` phase was bounded and bypassed after its owned container remained near-idle beyond the documented bound. The requested authority for this slice is the complete physical X11 `all` manifest above.
- Earlier pre-manifest attempts were harness/runtime failures: the Validation host selected `FreeX.Validation.Avalonia` and failed readiness with `MethodAccessException`; a separate five-minute command timeout sent SIGTERM during sheet-tab overflow before the probe could write a manifest. Neither is a product row failure.
- No managed/headless result was substituted for the physical X11 evidence.
