# FreeW Wave127 Dialog Action Semantics

Date: 2026-08-03
Scope: FreeW WPF/Avalonia parity

## Gap selected

The current dashboard contains 183 paired rows (28 pass, 155 mismatch) and 105 Avalonia-only artifact rows across 36 route families. The command inventory reports zero actionable command-ID gaps, but that is routing evidence only and was not treated as parity evidence.

The highest-impact internally testable residual in the generated evidence was a functional dialog-action cluster:

- `cross-reference`: default/cancel roles and action order differed.
- `document-inspector`: labels, default/cancel roles, and action order differed.
- `watermark`: default/cancel roles differed.

These differences were reported by the harness as semantic differences, rather than being inferred from pixels or an external Word-authoritative baseline.

## Implementation

`FreeW.App.Presentation` now owns the `DialogActionButtonPlan` contract and exposes route-specific action plans for these three dialogs. WPF consumes the plans through its existing `DialogButtonRowFactory`; Avalonia consumes the same labels, ordering, and Enter/Escape roles while retaining its native callbacks and controls. WPF still resolves shared display labels `OK` and `Cancel` through `ShellStrings.Current.Ok` and `ShellStrings.Current.Cancel`, preserving localized text and Alt-key accelerators. A source-boundary test proves both hosts reference the shared planners.

The Avalonia document inspector now exposes the same `Close` action row as WPF in all captured states, including the clean initial state. The Watermark and Cross-Reference dialogs now set the same default and cancel roles in both hosts.

## Fresh evidence

A uniquely named Wave127 capture root was used:
`%TEMP%\\freex-wave127-freew-dialog-action-semantics-20260803`

The focused inventory contained 18 scenarios: three states for each of the three routes in each host. Both hosts captured 9/9 scenarios with 0 unsupported. The compare run reported 9/9 `genuine-visual-mismatch` rows, so this change did not reclassify mismatches as passes or remove them from the comparison.

| Route state | Previous semantic difference | Fresh semantic difference | Fresh changed ratio | Fresh mean channel delta |
| --- | --- | --- | ---: | ---: |
| Cross Reference x3 | `default-button,action-button-order` | none | 9.505% | 5.763 |
| Document Inspector x3 | `default-button,cancel-button,action-button-order` | none | 6.218% | 4.934 |
| Watermark initial | `default-button,cancel-button` | none | 5.220% | 5.075 |
| Watermark populated | `default-button,cancel-button` | none | 5.324% | 5.247 |
| Watermark validation-error | `default-button,cancel-button` | none | 5.326% | 5.270 |

The host manifests also agree on the concrete action rows:

- Cross Reference: default `OK`, cancel `Cancel`, order `OK,Cancel`.
- Document Inspector: default `Remove Selected`, cancel `Close`, order `Remove Selected,Close`.
- Watermark: default `OK`, cancel `Cancel`, order `OK,Remove Watermark,Cancel`.

No external Word baseline was used.

The 9 current-source rows were promoted into the canonical comparison by three route-only merges (`cross-reference`, `document-inspector`, and `watermark`) using the existing baseline merge contract. The canonical artifacts are now refreshed:

- `docs/parity/freew-dialog-harness/freew_dialog_visual_comparison.json`
- `docs/parity/freew-dialog-harness/freew_dialog_visual_comparison.md`
- `docs/parity/freew-dialog-harness/freew_dialog_visual_comparison.html`
- `docs/parity/freew-dialog-harness/freew_dialog_visual_freshness.json`
- `docs/parity/avalonia-wpf-cross-app-dashboard.json`
- `docs/parity/avalonia-wpf-cross-app-dashboard.md`

The promoted dashboard remains 183 paired rows (28 pass, 155 mismatch) plus 105 Avalonia-only artifact rows across 36 route families; the 9 targeted rows remain genuine visual mismatches rather than being reclassified away.

## Verification

- `dotnet test freew\\FreeW.App.Presentation.Tests\\FreeW.App.Presentation.Tests.csproj --configuration Release --filter FullyQualifiedName~DialogActionButtonPlanTests`: 1/1 passed.
- `dotnet test freew\\FreeW.App.Avalonia.Tests\\FreeW.App.Avalonia.Tests.csproj --configuration Release --filter FullyQualifiedName~WatermarkDialogTests`: 3/3 passed.
- `dotnet test freew\\FreeW.App.Host.Tests\\FreeW.App.Host.Tests.csproj --configuration Release --filter FullyQualifiedName~SharedPresentationBoundarySourceGuardTests`: 4/4 passed.
- WPF harness: 9 captured, 0 unsupported.
- Avalonia harness: 9 captured, 0 unsupported.
- Compare: 9 genuine visual mismatches retained.
- Canonical inventory `--check`: passed.
- Canonical comparison `--check`: passed.
- Cross-app dashboard generation, `-Check`, and `Test-CrossAppParityDashboard.ps1`: passed.
- WPF shared-factory localization test: 1 passed; localized `OK`/`Cancel` text and `Alt+` accelerators preserved.

## Remaining residuals

The broader dashboard remains 155 paired mismatches plus 105 Avalonia-only artifacts. This slice closes only the action-semantic cluster for the three named route families. Raster differences remain in all nine targeted rows, and other semantic clusters remain, including 13 focus differences and action-order/default-cancel differences in other routes. The generated evidence still has no external Word-authoritative baseline.
