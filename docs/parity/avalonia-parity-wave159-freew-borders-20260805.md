# Avalonia Parity Wave 159: FreeW Borders And Shading Action Row

Date: 2026-08-05
Worktree: `codex-avalonia-parity-wave159-freew-20260805`
Authority: app-owned FreeW WPF dialog harness at 96 DPI

## Selected paired state

`borders-and-shading.validation-error` was selected from the canonical genuine-visual-mismatch
rows after a fresh WPF/Avalonia capture. Both real harness captures passed the full and target
pixel-content gates.

Before the fix, the state measured **11.2935% changed pixels**, **6.6573 mean channel delta**,
and **pHash distance 15**.

## Bounded visual fix

WPF renders the OK/Cancel action row at 26 px high in this compact dialog. Avalonia's dialog
style used a 21 px button height, leaving the action row 5 px shorter and 5 px lower in the
paired capture. `BordersAndShadingDialog` now uses the WPF-measured 26 px action-button height;
other dialogs retain their existing shared chrome metrics.

The focused Avalonia regression asserts both action buttons realize a 26 px rendered height
after the real dialog opens. After the fix, the route measured **10.7661% changed pixels**,
**6.3618 mean channel delta**, and **pHash distance 13**. Initial and populated states also
improved from **11.1902% / 6.4982 / 15** to **10.6628% / 6.2028 / 13** because they share the
same action row.

## Evidence and verification

The route was refreshed into the canonical comparison with the real harness using:

```powershell
dotnet run --project freew/tools/FreeW.DialogVisualHarness.Wpf/FreeW.DialogVisualHarness.Wpf.csproj --configuration Release --no-build --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 -- --inventory docs/parity/freew-dialog-harness/freew_dialog_evidence_inventory.json --output artifacts/freew-wave159-borders/wpf-all
dotnet run --project freew/tools/FreeW.DialogVisualHarness.Avalonia/FreeW.DialogVisualHarness.Avalonia.csproj --configuration Release --no-build --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 -- --inventory docs/parity/freew-dialog-harness/freew_dialog_evidence_inventory.json --wpf-authority artifacts/freew-wave159-borders/wpf-all/wpf_dialog_capture_manifest.json --output artifacts/freew-wave159-borders/avalonia-all
dotnet run --project freew/tools/FreeW.DialogVisualHarness/FreeW.DialogVisualHarness.csproj --configuration Release --no-build --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 -- compare --inventory docs/parity/freew-dialog-harness/freew_dialog_evidence_inventory.json --wpf artifacts/freew-wave159-borders/wpf-all/wpf_dialog_capture_manifest.json --avalonia artifacts/freew-wave159-borders/avalonia-all/avalonia_dialog_capture_manifest.json --output docs/parity/freew-dialog-harness --baseline artifacts/freew-wave159-borders/baseline/freew_dialog_visual_comparison.json --refresh-route borders-and-shading
```

Focused test: `BordersAndShadingDialogVisualParityTests` rendered-height assertion passed. The
same focused class had one unrelated pre-existing failure in its button-content stringification
assertion (`AccessText` type name versus localized text); six of seven tests passed.

`Test-CrossAppParityDashboard.ps1` and `Test-FreeWDialogVisualEvidence.ps1` passed. No
classification threshold or evidence image was edited by hand.

## Residuals

The three refreshed rows remain genuine visual mismatches because Avalonia and WPF still rasterize
Segoe UI text and compact control templates differently. The canonical aggregate remains
158 genuine visual mismatches, 25 passes, 105 Avalonia extensions, and 7 state-not-applicable
rows; Avalonia-only extensions remain outside the parity gap count.
