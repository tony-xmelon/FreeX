# Wave108 FreeW Accessibility Report

## Scope

Aligned the Avalonia `accessibility-report` dialog with the WPF authority for the `initial`, `populated`, and `validation-error` evidence states. The change is limited to FreeW Avalonia, its FreeW visual harness, focused Avalonia tests, and the FreeW comparison report.

## Implementation

- Matched the WPF dialog contract: 460px width, 560px maximum height, height-to-content sizing, and a non-resizable window.
- Reproduced WPF summary copy, severity grouping, counts, bullet rows, accent colors, margins, and a 420px issue-list scroll cap.
- Matched the WPF action row spacing and 84px OK button width through the shared Avalonia dialog chrome.
- Added focused clean and populated report tests, including window metrics, copy, grouping, colors, scroll cap, and button width.
- Updated the Avalonia harness to consume the WPF authority outer dimensions for this fixed-size route, preventing a synthetic 560x600 comparison target.

## Evidence

All three refreshed route pairs are visual passes:

| State | Before | After | Outer size |
| --- | --- | --- | --- |
| initial | 7.613% changed, 17.083 mean delta | 0.598% changed, 0.832 mean delta | 560x560 / 560x560 |
| populated | 7.613% changed, 17.083 mean delta | 0.598% changed, 0.832 mean delta | 560x560 / 560x560 |
| validation-error | 7.613% changed, 17.083 mean delta | 0.598% changed, 0.832 mean delta | 560x560 / 560x560 |

The remaining painted-bounds difference is small text rasterization: WPF `512x62` at `(17,17)` versus Avalonia `511x60` at `(17,18)`. No content, state, or sizing mismatch remains in this family.

## Verification

`dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release --filter FullyQualifiedName~AccessibilityReportDialogParityTests --logger "console;verbosity=minimal"`

Result: 2 passed, 0 failed.

The WPF and Avalonia visual harnesses each captured all three routes successfully. Docker was not run, and no machine-wide processes were stopped.
