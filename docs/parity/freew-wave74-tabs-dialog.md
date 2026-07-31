# FreeW Wave74 Tabs Dialog Parity

Date: 2026-07-31
Base: `7f9768116b` (`origin/main`)
Route: `tabs`
WPF authority: `freew/FreeW.App.Host/TabsDialog.cs`
Avalonia target: `freew/FreeW.App.Avalonia/ParagraphCommandDialogs.cs`

## Changes

- Replaced the Avalonia-only stacked layout with the WPF authority's 340 px,
  seven-row, two-column grid and 14 px outer margin.
- Matched the WPF labels, 120 px stop-list height, 120 px field minimum widths,
  action-row placement, 72 px action widths, and 6 px action spacing.
- Kept the visual and logical action order as `Set`, `Clear`, `Clear All`, `OK`,
  `Cancel` through the shared Avalonia button-row factory.
- Restored shared default/cancel behavior and the WPF initial focus/select-all
  target on the tab-position field.
- Replaced the Avalonia-only inline validation status with the WPF-equivalent
  modal warning surface for both Set and OK validation.
- Removed duplicate row allocation that would otherwise leave five extra auto
  rows in the Avalonia grid.

## Focused Coverage

`TabsDialogWpfAuthorityParityTests` adds three focused tests covering:

- WPF geometry, labels, dimensions, row count, populated ordering, and default
  tab-stop text.
- Logical action ordering, raw mnemonic content, visible automation labels,
  default/cancel roles, selection projection, and initial select-all focus.
- Shared chrome/button/focus helpers and modal warning validation routing.

## Fresh Paired Evidence

A route-scoped inventory contained exactly six scenarios: three fresh WPF
authority states and their three matching Avalonia states. Both capture hosts
reported 3/3 captured and zero unsupported rows. The comparison retained all
three rows as genuine visual mismatches while removing every semantic
difference.

| State | Before ratio / mean | After ratio / mean | pHash | Semantic difference |
| --- | ---: | ---: | ---: | --- |
| initial | 13.9932% / 6.6748 | 11.3568% / 5.7367 | 9 -> 0 | `action-button-order` -> none |
| populated | 14.0208% / 6.7064 | 11.3848% / 5.7709 | 9 -> 0 | `action-button-order` -> none |
| validation-error | 14.1292% / 6.8451 | 11.4890% / 5.8992 | 9 -> 0 | `action-button-order` -> none |

The three-state average changed-pixel ratio improved from 14.0477% to 11.4102%
(18.78% relative reduction), mean channel delta improved from 6.7421 to 5.8023,
and changed pixels fell from 141,601 to 115,015.

The fresh route-scoped report is under
`artifacts/freew-dialog-harness/wave74-tabs/comparison/`. The canonical tracked
comparison was not replaced: these intentionally scoped manifests contain
3 WPF and 3 Avalonia captures, while the canonical report records 187 WPF and
279 Avalonia captures. Promoting scoped top-level counts would misstate full
harness coverage.

## Residuals

All semantic contracts now match. WPF painted bounds are 517x331 and Avalonia
painted bounds are 516x346 for each state. The remaining 11.36-11.49% pixel
delta is concentrated in native WPF versus Avalonia/Skia control templates,
text rasterization, and the 15 px aggregate painted-height difference. The
shared `FreeWDialogWindow` open path already applies compact Windows-style
textbox, combo-box, list-box, font, and button metrics, so no route-local
metric override was added.

## Verification

```text
dotnet build freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1
  succeeded, 0 warnings, 0 errors

dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release --no-build --filter FullyQualifiedName~TabsDialogWpfAuthorityParityTests
  3 passed, 0 failed

WPF route-scoped harness
  3 captured, 0 unsupported

Avalonia route-scoped harness using the fresh WPF authority manifest
  3 captured, 0 unsupported
```
