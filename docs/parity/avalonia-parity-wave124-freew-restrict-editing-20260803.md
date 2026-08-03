# Wave124 FreeW Restrict Editing parity

## Scope

This slice aligns the Avalonia Restrict Editing dialog with the production WPF authority while preserving the shared protection planner and real start/stop/password behavior.

`RestrictEditingDialogPlanner.Presentation` now owns the dialog width, content margins, radio/input metrics, visible-content choice, action ordering, default/cancel contract, and initial-focus target. Both hosts consume that plan. Avalonia now uses the WPF vertical action layout, stretches password inputs to the content width, omits the Avalonia-only status line, and restores compact radio/input metrics after host chrome is applied.

## Fresh evidence

All captures are real app-owned dialogs rendered at `560x600`. WPF and Avalonia now both report no focused automation id, no default button, `Cancel` as the cancel button, and this action order:

`Start Enforcing Protection | Stop Protection | Cancel`

| Scenario | Changed pixels before -> after | Mean delta before -> after | P95 before -> after | pHash before -> after | Semantic difference |
| --- | ---: | ---: | ---: | ---: | --- |
| `restrict-editing.initial` | 10.57% -> 5.88% | 7.31 -> 4.24 | 51 -> 17 | 10 -> 1 | `default-button` -> none |
| `restrict-editing.populated` | 10.58% -> 5.90% | 7.32 -> 4.25 | 51 -> 17 | 10 -> 1 | `default-button` -> none |
| `restrict-editing.validation-error` | 10.61% -> 5.92% | 7.35 -> 4.28 | 51 -> 17 | 10 -> 1 | `default-button` -> none |

WPF painted bounds remain `517x333`; Avalonia moved from `512x531` to `518x329`. The content-height divergence therefore fell from 198 px to 4 px. The three rows remain classified as genuine visual mismatches because changed pixels remain above the unchanged 3% threshold; the residual is compact-control and text rasterization, not missing content, state, or action semantics.

Canonical route artifacts refreshed by the route-only comparison merge:

- `docs/parity/freew-dialog-harness/freew_dialog_visual_comparison.json`
- `docs/parity/freew-dialog-harness/freew_dialog_visual_comparison.md`
- `docs/parity/freew-dialog-harness/freew_dialog_visual_comparison.html`
- `docs/parity/freew-dialog-harness/freew_dialog_visual_freshness.json`

## Verification

- `dotnet test FreeW.App.Presentation.Tests/FreeW.App.Presentation.Tests.csproj --configuration Release --filter FullyQualifiedName~RestrictEditingDialogPlannerTests`: 9 passed.
- `dotnet test FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release --filter FullyQualifiedName~WpfAuthoritySurfaceParityTests`: 13 passed.
- `dotnet test FreeW.App.Host.Tests/FreeW.App.Host.Tests.csproj --configuration Release --filter FullyQualifiedName~RestrictEditingDialogPolicySourceGuardTests`: 2 passed.
- `dotnet build FreeW.App.Host/FreeW.App.Host.csproj --configuration Release`: succeeded with 0 warnings and 0 errors.
- WPF dialog harness: 3/3 captured, 0 unsupported.
- Avalonia dialog harness: 3/3 captured, 0 unsupported.

No named Restrict Editing Linux/X11 interaction probe exists under `tools`, so this bounded slice does not claim a Linux physical interaction result. The current-source Avalonia route harness completed all requested visual states on the Windows host.

No thresholds or classifications were weakened, and no global dashboard was edited.
