# FreeW Backstage Home/Save As Visual Parity Wave 94

Date: 2026-08-01

## Scope

Audited the Avalonia Home and Save As pane renderers against the WPF
authority in `freew/FreeW.App.Host/Backstage/BackstageView.cs` and the shared
WPF composer in `shared/Free.Shared.Shell.Wpf/BackstagePaneComposer.cs`.

Home already uses the same generic stacked action-row shape as WPF. The
bounded fix targets the Save As file-type rows only.

## Implementation

WPF Save As uses its compact `LinkButton` row: 13px text, zero padding, left
alignment, and a sibling 11px description. Avalonia was routing these rows
through the larger Home-style renderer: 14px text, a stretched button, and a
nested label stack.

Added `BuildSaveAsActionRow` and routed `AddSaveAsActionGroup` through it. The
existing Save As inline editor and callback behavior are unchanged.

## Evidence

Fresh paired capture:

`C:\Users\anton\AppData\Local\Temp\wave94-home-saveas-compact-20260801`

- Route: `backstage-save-as.open`
- WPF: captured, content gate passed, 560x600 at 96 DPI
- Avalonia: captured, content gate passed, 560x600 at 96 DPI
- Changed pixels: `9.829%` before (Wave 93 evidence) -> `9.1845%` after
- Mean channel delta: `8.302` before -> `7.5029` after
- pHash distance: `0` after
- Classification remains `genuine-visual-mismatch`; the metric is evidence,
  not a claim of complete native-template parity.

## Verification

- `dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release --filter FullyQualifiedName~BackstageView_SaveAs_actions_keep_direct_WPF_action_content --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1` - 1 passed.
- `dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release --filter FullyQualifiedName~BackstageViewTests --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1` - 35 passed.
- WPF focused harness capture - 1/1 captured.
- Avalonia focused harness capture - 1/1 captured.
- Focused comparison - 1/1 paired row captured; comparison returned its expected non-zero status because the row remains a genuine visual mismatch.

## Residuals

Avalonia and WPF still differ in native text/control rasterization, scrollbar
rendering, and small button/control geometry. Home was not changed in this
slice because its generic action rows already mirror the WPF composer path.
