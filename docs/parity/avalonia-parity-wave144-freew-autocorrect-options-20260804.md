# FreeW AutoCorrect Options Parity Wave 144

Date: 2026-08-04

## Scope and retained evidence

This slice targets the `options.tab-auto-correct` WPF/Avalonia pair. The retained canonical comparison
is a genuine visual mismatch, not blank evidence: both hosts pass the content gate, the WPF painted
content is `517 x 387`, and the Avalonia painted content was `518 x 387`. The retained pair reports
`35,234 / 336,000` changed pixels (`0.10486309523809524`), mean channel delta `8.714455357143978`,
and no semantic difference. Thresholds and classification were not changed.

The source audit found matching shared planner text, three tabs with AutoCorrect selected by the route,
the WPF grid/table contract, compact checkbox metrics, replacement-table geometry, and OK/Cancel policy.
WPF and Avalonia focused tests also cover initial focus/select behavior, replacement commit behavior,
default OK, cancel Cancel, and the action order. Avalonia's Fluent template exposes button content through
`AccessText`, so the paired test reads its user-facing text instead of comparing the template wrapper type.

## Closed divergence

The retained one-pixel width difference was in Avalonia's selected tab content host. The WPF authority
paints the AutoCorrect pane one pixel narrower at the same outer capture size. The shared
`OptionsDialogPlanner` now records `AutoCorrectTabPaneRightInset = 1`; Avalonia applies that inset to the
route's selected content presenter while preserving the existing WPF-equivalent negative template inset.
WPF product layout and shared AboutDialog files are unchanged.

The fresh Avalonia-only capture after the change remained valid and measured:

| Evidence | Value |
| --- | ---: |
| Painted content bounds | `x=14, y=14, width=517, height=387` |
| Content pixel ratio | `0.09143452380952381` |
| Default action | `OK` |
| Cancel action | `Cancel` |
| Capture SHA-256 | `6A39A3D0E969E1983CADA9C65E23CE953D93AA89E18B50C1C3CF63BB3E8F54BB` |

The local WPF visual harness invocation produced a blank RenderTargetBitmap and failed its content gate;
that output was treated as invalid and was not promoted into the canonical comparison. The retained WPF
comparison evidence remains the authority for the paired visual row.

## Verification

- `dotnet build freew/tools/FreeW.DialogVisualHarness.Wpf/FreeW.DialogVisualHarness.Wpf.csproj --configuration Release -m:1 -p:NodeReuse=false /nr:false`: passed, 0 warnings, 0 errors.
- `dotnet build freew/tools/FreeW.DialogVisualHarness.Avalonia/FreeW.DialogVisualHarness.Avalonia.csproj --configuration Release -m:1 -p:NodeReuse=false /nr:false`: passed, 0 warnings, 0 errors.
- `dotnet test freew/FreeW.App.Host.Tests/FreeW.App.Host.Tests.csproj --configuration Release --filter "FullyQualifiedName~FreeW.App.Host.Tests.OptionsDialogParityTests" -m:1 -p:NodeReuse=false /nr:false --logger "trx;LogFileName=wave144-wpf-final.trx"`: passed, 4/4.
- `dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release --filter "FullyQualifiedName~FreeW.App.Avalonia.Tests.OptionsDialogVisualParityTests" -m:1 -p:NodeReuse=false /nr:false --logger "trx;LogFileName=wave144-avalonia-after2.trx"`: passed, 6/6.
- Focused Avalonia harness capture for `avalonia.options.tab-auto-correct`: passed content validation; bounds and action semantics are recorded above.
