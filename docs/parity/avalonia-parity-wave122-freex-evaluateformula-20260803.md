# Wave122 FreeX Evaluate Formula parity

Date: 2026-08-03

## Scope

This wave aligns the FreeX Avalonia Evaluate Formula dialog with the WPF authority and makes its capture evidence semantically comparable. It does not change the global parity summaries owned by integration.

## Fixture correction

The checked-in WPF `dialog.EvaluateFormula.png` was stale: it showed `Sheet1!B2`, `=A2+A3`, and result `20`. Current WPF source already seeded the intended `Sheet1!D6`, `=SUM(D2:D5)`, and result `469`, which matched the current Avalonia source image. Both capture hosts now consume `EvaluateFormulaDialogPlanner.CreateParitySummary`, so the fixture cannot drift independently again while the real `FormulaEvaluationSession` behavior remains intact.

The promoted WPF and Avalonia evidence is now 600x360 px at 96 DPI. Both manifests record the same formula, result, and first step (`SUM(D2:D5)` / `469`).

## Implementation

- Centralized dialog dimensions, margins, typography, button widths, button height, and action spacing in `EvaluateFormulaDialogPlanner`.
- Reused those metrics in both WPF and Avalonia dialog construction.
- Bound Avalonia `EvaluateFormulaDialogChromeStyle` `ButtonHeight` and `ControlHeight` to the shared 26-DIP metric; a headless runtime test measures an applied and arranged production button.
- Matched Avalonia formula rendering to WPF's localized prefix plus highlighted formula segment.
- Added a fixed 600x360 WPF client-frame capture contract so the fresh pair does not include a non-client-frame tail or a scale mismatch.
- Preserved Evaluate, Step In, Step Out, Restart, Close, Help, default/cancel button focus, and keyboard lifecycle behavior.

## Evidence and metrics

Fresh source captures:

- WPF: `artifacts/parity-wave122-freex-evaluateformula-20260803/wpf-r4/dialog.EvaluateFormula.png`
- Avalonia: `artifacts/parity-wave122-freex-evaluateformula-20260803/linux-out/dialog.EvaluateFormula.png`
- Targeted comparison: `artifacts/parity-wave122-freex-evaluateformula-20260803/compare-r4/parity-report.html`
- Promoted assets: `docs/parity/dialog-visual-assets/wpf-capture/dialog.EvaluateFormula.png` and `docs/parity/dialog-visual-assets/avalonia-capture/dialog.EvaluateFormula.png`

The fresh WPF/Avalonia target pair has a 1.7639% pixel diff and no targeted hard regression. The prior same-state comparison against the pre-change Avalonia asset was 1.4979%; that is a baseline only, not evidence of an improvement because it predates the Avalonia geometry/rendering changes and used a different capture provenance. The stale B2 WPF evidence could not provide a valid semantic baseline; the previous summary reported a logical sample-mean delta of 3.0305% and triage score of 8.9608% while comparing different fixture states and raw sizes.

The measurable evidence correction is therefore semantic and geometric: both current-source images now have identical 600x360 dimensions, 96-DPI provenance, and D6/SUM/469 fixture state. The pixel metric is reported without claiming that the current code change alone lowered it.

## Verification

- `dotnet test tests\\FreeX.App.Services.Tests\\FreeX.App.Services.Tests.csproj --configuration Release --filter FullyQualifiedName~EvaluateFormulaDialogPlannerTests --logger "console;verbosity=minimal"` — 5 passed.
- `dotnet test tests\\FreeX.App.Host.Tests\\FreeX.App.Host.Tests.csproj --configuration Release --filter FullyQualifiedName~FormulaAuditErrorCheckingDialogSourceTests --logger "console;verbosity=minimal"` — 5 passed.
- `dotnet test tests\\FreeX.App.Avalonia.Tests\\FreeX.App.Avalonia.Tests.csproj --configuration Release --filter "FullyQualifiedName~EvaluateFormulaDialogLayoutRuntimeTests|FullyQualifiedName~AvaloniaCompactDialogChromeClusterASourceTests" --logger "console;verbosity=minimal"` — 3 passed.
- `dotnet build src\\FreeX.App.Host\\FreeX.App.Host.csproj --configuration Release --no-restore` — succeeded with 0 warnings and 0 errors.

The parity comparison tool reports the targeted dialog pair correctly; its overall command remains non-zero because the intentionally targeted WPF manifest is being compared with the Avalonia full-capture manifest and the unrelated name-box contract is not part of this wave.
