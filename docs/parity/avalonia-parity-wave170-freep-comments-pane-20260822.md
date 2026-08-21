# FreeP comments pane parity, wave170

## Scope

The sole FreeP dialog/pane target in this wave was `review.comments-pane.seeded`,
captured as an 1100x100 logical-96-DPI crop with a 1280x760 shell-context pair.
The comparison threshold and classification were left unchanged.

## Change

`FreeP.App.Avalonia.MainWindow` now realizes the comments-pane close, new-comment,
and review-action controls through a FreeP-specific style derived from the shared
`AvaloniaCompactDialogChrome` contract. The style consumes shared
`PresentationCommentPaneVisualMetrics` geometry and WPF-authority button/input
colors. The pane host also uses the shared `PaneBorder` role, matching the WPF host.

## Evidence

| Lane | Before | After | Result |
| --- | ---: | ---: | --- |
| Target changed pixels | 23.1255% | 13.7055% | Pass (max 20%) |
| Target mean channel delta | 13.4869 | 8.2594 | Pass (max 18) |
| Shell-context changed pixels | 12.2590% | 10.6567% | Pass (max 20%) |
| Shell-context mean channel delta | 8.3632 | 7.5225 | Pass (max 18) |

The post-change capture paired all 28 dialog/pane scenarios. The owned target is
classified `Pass`; its remaining pixel differences are primarily native text
rasterization and small template anti-aliasing differences. The full lane still
contains unrelated existing mismatches in header/footer, find/replace, hyperlink,
and slide-pane scenarios.

## Verification

- `dotnet test freep/FreeP.App.Avalonia.Tests/FreeP.App.Avalonia.Tests.csproj --configuration Release --filter FullyQualifiedName~ReviewCommentPaneVisualParitySourceTests`: 2/2 passed.
- `dotnet build freep/TestSupport/VisualEvidence.Avalonia/FreeP.VisualEvidence.Avalonia.csproj --configuration Release`: 0 warnings, 0 errors.
- `dotnet build freep/TestSupport/VisualEvidence.Wpf/FreeP.VisualEvidence.Wpf.csproj --configuration Release`: 0 warnings, 0 errors.
- `dotnet run --project tools/FreeP.RenderCompare/FreeP.RenderCompare.csproj --configuration Release -- --dialog-pane-visual-evidence docs/parity/freep-dialog-pane-visual-evidence --timeout-seconds 45`: 28/28 paired, target pass.
