# Avalonia parity wave 177 integration

Date: 2026-08-22
Base: `1c93796b91503457bf6afe4a601268e6c669c5bc`

## Integrated slices

### FreeX formula interaction and synchronous dialogs

Both assigned Linux physical-input selectors now pass at 1280x820 and 96 DPI.

- `formula-bar-point-mode-multi-area-edit` committed the exact quoted cross-sheet formula, calculated `30`, and retained `Revenue Data!J7` as the pointed selection.
- `formula-reference-grip-multi-area-physical` moved only the second formula-reference area, committed `=SUM('Sheet2'!B2:C3,'Sheet2'!D4:F6)`, calculated `15`, accepted the real `Possible Data Loss` prompt, and reached a clean saved document.

The repeated prompt failure exposed a shared production defect rather than a probe-only issue. `AvaloniaSynchronousDialogHost` used `Dispatcher.RunJobs`, which does not process pending operating-system events. It now uses a nested `DispatcherFrame`, exits primarily from the dialog's `Closed` event, and retains a low-frequency completion timer for generic synchronous callers. The final physical X11 run proves keyboard/pointer delivery reaches the owned Avalonia prompt.

Detailed evidence: `docs/parity/avalonia-parity-wave177-freex-formula-physical-20260822.md`.

### FreeW multilevel-list dialog

The Avalonia `multilevel-list` dialog was aligned to its WPF authority with route-local metrics and a corrected validation fixture. All three WPF/Avalonia captures are 380x437 pixels and retain pHash distance 0.

| State | Before | After | Mean channel delta after |
| --- | ---: | ---: | ---: |
| initial | 16.1195% | 3.9546% | 4.0341 |
| populated | 16.1195% | 3.9546% | 4.0341 |
| validation-error | 16.2779% | 4.1696% | 4.2713 |

The canonical inventory remains honest: 141 genuine visual mismatches, 80 passes, and 70 Avalonia extensions across 291 paired/extension rows. The remaining route-local delta is dominated by host text rasterization and a one-pixel content offset.

Detailed evidence: `docs/parity/avalonia-parity-wave177-freew-multilevel-list-20260822.md`.

### FreeP bullets/autofit renderer audit

The largest current WPF/Avalonia renderer pair, `17-bullets-autofit/slide-02`, was re-rendered at 1280x720 against the committed Office authority. Fresh deltas are 3.0587% for WPF versus Office, 3.1232% for Avalonia versus Office, and 3.1324% for WPF versus Avalonia.

Four bounded Avalonia font/scale/spacing candidates all worsened the Office comparison, so no unsupported production calibration was shipped. The residual is concentrated in glyph rasterization for unavailable proprietary Aptos resources rather than bullets, autofit, or text-box geometry.

Detailed evidence: `docs/parity/freep-wave177-bullets-autofit-renderer-audit-20260822.md`.

## Focused verification

- FreeX shared synchronous-dialog tests: 5 passed.
- FreeX practical residual ownership tests: 9 passed.
- FreeX Linux physical selectors: 2 passed independently.
- FreeW Avalonia visual-parity tests: 3 passed.
- FreeW presentation tests: 8 passed.
- FreeW WPF host tests: 6 passed.
- FreeP Avalonia line-spacing tests: 14 passed.
- FreeP bullets/autofit tests: 56 passed.
- FreeW visual evidence consistency: passed.
- Cross-app parity dashboard generation check and aggregation guards: passed.

## Repository gate

- Repository preflight: passed, including generated documentation and evidence checks.
- `dotnet build FreeX.slnx --configuration Release`: passed with 0 warnings and 0 errors.
- `dotnet test FreeX.DefaultTests.slnx --configuration Release --no-build`: completed with one known headless-environment failure. `FreeX.App.Avalonia.Tests.GridCaptureTests.CaptureGridRange_WritesPngAndJsonLog_ForNewWorkbook` received an empty PNG from the Windows headless renderer; the remaining 2,148 tests in that project passed. This is the same environment residual recorded by wave 175 and is unrelated to the Wave177 changes.
