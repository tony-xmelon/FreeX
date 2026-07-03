# FreeP Print Output Options - 2026-07-03

## Scope

This slice adds shared FreeP print-output option metadata for the Backstage print planner and printable PDF package plan. It stays in FreeP app presentation and the WPF Backstage adapter; native printer-dialog execution remains deferred.

## Improvement

- `PresentationPrintRequest` now carries PowerPoint-style option intent for copies, collation, color/grayscale output, framed slides, hidden slides, and comments/ink markup.
- `PresentationPrintPlan`, `PresentationPrintOutputPackagePlan`, and `PresentationPrintBackstagePlan` expose one normalized `PresentationPrintOptionsPlan` with display and line summaries.
- Copies are clamped to a bounded 1-999 range, color mode is normalized, and the WPF Backstage print pane projects the shared option summary instead of inventing host-local text.

## Verification

- `dotnet test freep\FreeP.App.Presentation.Tests\FreeP.App.Presentation.Tests.csproj --configuration Release --filter "FullyQualifiedName~PresentationExportPlannerTests|FullyQualifiedName~PresentationPrintBackstagePlannerTests" --logger "trx;LogFileName=freep-print-options-presentation.trx" -m:1 /nr:false -p:BuildInParallel=false -p:UseSharedCompilation=false` passed 46/46.
- `dotnet test freep\FreeP.App.Host.Tests\FreeP.App.Host.Tests.csproj --configuration Release --filter "FullyQualifiedName~BackstageHostDedupSourceTests" --logger "trx;LogFileName=freep-print-options-host.trx" -m:1 /nr:false -p:BuildInParallel=false -p:UseSharedCompilation=false` passed 1/1.
- `powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\Generate-FreePCommandParityInventory.ps1` rewrote the generated inventory with no diff; the command surface remains 102 total, 94 shared, 0 actionable WPF/Avalonia missing, 8 platform-only.

## Remaining Gaps

- Native printer dialog handoff, actual printer device settings, and PowerPoint-measured print-preview visual baselines remain deferred.
- Avalonia has the shared package/backstage plan available through existing command state, but a richer visible print-pane projection remains a follow-up.
