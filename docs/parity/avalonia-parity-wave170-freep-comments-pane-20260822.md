# FreeP comments pane parity, wave170

## Scope

The sole FreeP dialog/pane target in this wave is `review.comments-pane.seeded`,
captured as an 1100x100 logical-96-DPI crop with a 1280x760 shell-context pair.
The comparison thresholds and classification rules were not changed.

## Change

`FreeP.App.Avalonia.MainWindow` now realizes the comments-pane close,
new-comment, and review-action controls through a FreeP-specific style derived
from the shared `AvaloniaCompactDialogChrome` contract. The style consumes shared
`PresentationCommentPaneVisualMetrics` geometry and WPF-authority button/input
colors. The pane host also uses the shared `PaneBorder` role, matching the WPF
host.

## Controlled same-environment A/B

The parent and candidate legs used the same WPF authority executable, the same
`FreeP.RenderCompare` command, 45-second timeout, 1280x760 shell capture, and
1100x100 target crop. The WPF target hash was identical in both legs
(`dee0198148ddd2af7b2c341eba59963f25b1b5098f5526160f77f1ffce93f79b`), as was
the WPF shell-context hash
(`7ffd89636ff3d94792a76dddf52d72cc5e4a129ba1494cc73dac3ff487c30bbc`).

| Lane | Parent (`81d8f989d1`) | Candidate (`8c1343ebb9`) | Result |
| --- | ---: | ---: | --- |
| Target changed pixels | 23.6609% | 13.7055% | Candidate pass (max 20%) |
| Target mean channel delta | 13.3763 | 8.2594 | Candidate pass (max 18) |
| Shell-context changed pixels | 11.7762% | 10.6567% | Both pass (max 20%) |
| Shell-context mean channel delta | 8.1016 | 7.5225 | Both pass (max 18) |

The parent target is the controlled baseline for this run; it is not the older
23.1255% value from the prior full recapture. The candidate's remaining target
differences are primarily native text rasterization and small template
anti-aliasing differences.

## Canonical evidence status

The full canonical evidence tree and cross-app dashboard were restored to the
parent state after the prior full recapture changed unrelated rows. The committed
canonical dialog lane therefore remains the parent result: 28 paired captures,
27 pass, 1 mismatch, 0 limitations. This document does not claim canonical
28/28 all-pass. The controlled A/B captures were written only to temporary
directories and are not presented as canonical evidence.

## Verification

- `dotnet test freep/FreeP.App.Avalonia.Tests/FreeP.App.Avalonia.Tests.csproj --configuration Release --filter FullyQualifiedName~ReviewCommentPaneVisualParitySourceTests`: 2/2 passed.
- `dotnet build freep/TestSupport/VisualEvidence.Wpf/FreeP.VisualEvidence.Wpf.csproj --configuration Release`: 0 warnings, 0 errors.
- `dotnet build freep/TestSupport/VisualEvidence.Avalonia/FreeP.VisualEvidence.Avalonia.csproj --configuration Release`: 0 warnings, 0 errors.
- Controlled A/B: 28/28 paired captures in each leg; parent 19 pass / 9 mismatch, candidate 20 pass / 8 mismatch. These temporary full-lane counts are context only; canonical evidence was restored as described above.
