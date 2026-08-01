# FreeW Options Dialog Parity Wave 95

Date: 2026-08-01
Base evidence: `docs/parity/freew-dialog-harness/freew_dialog_visual_comparison.json`
Branch: `codex/freew-wave95-dialog-20260801`

## Scope

This slice aligns the Avalonia `Options` dialog to the WPF authority. `Options` was selected as an eligible, commonly used functional dialog outside the Wave 94 exclusions. The evidence identified the largest eligible Options deltas in the AutoCorrect and AutoFormat tabs, including an action-button-order semantic mismatch.

The Avalonia dialog now uses the shared WPF-equivalent OK/Cancel row contract with 84px buttons and automation names, selects the recent-files field on open, and presents AutoCorrect replacements as a keyboard-editable two-column Replace/With grid. A trailing blank row keeps the WPF DataGrid add-row workflow available; incomplete rows are ignored on commit, matching the WPF host behavior.

## Paired Evidence

The source evidence reported these pre-change genuine mismatches:

| Scenario | Changed ratio | Changed pixels | Semantic difference |
| --- | ---: | ---: | --- |
| `options.tab-auto-correct` | 11.881% | 39,920 | `action-button-order` |
| `options.tab-auto-format-as-you-type` | 11.288% | 37,926 | none |
| `options.populated` | 7.443% | 25,008 | none |
| `options.validation-error` | 7.540% | 25,334 | none |

The global comparison JSON and dashboards were intentionally not regenerated for this bounded implementation slice.

## Tests

- `dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release --filter FullyQualifiedName~OptionsDialogVisualParityTests --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --logger "console;verbosity=minimal"`
  - Passed: 5; failed: 0.

The focused test covers the 460px surface, two-column replacement geometry, 180px table height, default/cancel action semantics, automation names, initial selection, and replacement-row commit behavior.

## Residuals

No fresh WPF/Avalonia bitmap pair was generated in this slice, so post-change pixel counts remain unmeasured. Native WPF/Avalonia text rasterization and control-template rendering may continue to contribute to the remaining visual delta.
