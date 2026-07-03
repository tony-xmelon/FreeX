# FreeP Print Output Option Choice UI - 2026-07-03

## Slice

FreeP print/backstage workflow depth now exposes PowerPoint-style output option choices through the shared `PresentationPrintBackstagePlanner`, instead of leaving WPF and Avalonia to project only a flat selected-options summary.

## Parity Improvement

- `PresentationPrintBackstagePlan.OutputOptionChoices` describes copies, collation, color mode, hidden-slide inclusion, slide framing, and comments/ink markup as shared rows with group, label, description, selected state, and availability.
- WPF Backstage renders those shared rows in the Print pane's Output Options section.
- Avalonia's print-options pane renders the same shared rows and its headless test captures the projected option lines from the shared planner model.

Native printer dialog handoff remains deferred; this slice improves the visible output-option UI model and keeps policy centralized for both hosts.

## Verification

- `dotnet test freep\FreeP.App.Presentation.Tests\FreeP.App.Presentation.Tests.csproj --configuration Release --filter "FullyQualifiedName~PresentationPrintBackstagePlannerTests|FullyQualifiedName~PresentationExportPlannerTests" --logger "trx;LogFileName=freep-print-options-presentation.trx" -m:1 /nr:false -p:BuildInParallel=false -p:UseSharedCompilation=false`
- `dotnet test freep\FreeP.App.Avalonia.Tests\FreeP.App.Avalonia.Tests.csproj --configuration Release --filter "FullyQualifiedName~MainWindowHeadlessTests|FullyQualifiedName~FilePickerPlannerSourceTests" --logger "trx;LogFileName=freep-print-options-avalonia.trx" -m:1 /nr:false -p:BuildInParallel=false -p:UseSharedCompilation=false`
- `dotnet test freep\FreeP.App.Host.Tests\FreeP.App.Host.Tests.csproj --configuration Release --filter "FullyQualifiedName~BackstageHostDedupSourceTests|FullyQualifiedName~ReviewWorkflowAdapterTests|FullyQualifiedName~FileLifecycleTests" --logger "trx;LogFileName=freep-print-options-wpf.trx" -m:1 /nr:false -p:BuildInParallel=false -p:UseSharedCompilation=false`
- `dotnet build FreeP.slnx --configuration Release -m:1 /nr:false -p:BuildInParallel=false -p:UseSharedCompilation=false`
