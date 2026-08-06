# Avalonia Parity Wave 163: FreeW Table Properties

Date: 2026-08-06
Route: `table-properties`
Authority: `freew/FreeW.App.Host/TablePropertiesDialog.cs`
Scope: `tab-cell`, with `tab-column` retained as a pass

## Source alignment

The WPF Cell tab uses the native checkbox geometry for `Wrap text`, `Fit text`,
and the floating overlap control: zero left margin and an 8 px right margin for
the shared checkbox rows. Avalonia's route-local checkbox factory had added a
4 px left inset. Avalonia also allowed the Positioning panel's distance grid to
consume the full right edge; the WPF authority leaves a 4 px right inset.

Avalonia now uses the WPF checkbox margins and applies the 4 px right inset to
the Positioning panel's shared 137 px label column. The Column tab's layout and
classification are unchanged.

## Fresh paired evidence

The focused run captured all seven Table Properties states on both hosts at the
same 560 x 600 logical surface. The canonical comparison was refreshed only for
`table-properties`; thresholds and classifications were unchanged.

| State | Before ratio / mean | After ratio / mean | Classification |
| --- | ---: | ---: | --- |
| initial | 9.0143% / 6.7693 | 9.0348% / 6.7869 | genuine-visual-mismatch |
| populated | 9.0143% / 6.7693 | 9.0348% / 6.7869 | genuine-visual-mismatch |
| tab-cell | 11.4702% / 7.6023 | 11.3622% / 7.5789 | genuine-visual-mismatch |
| tab-column | 2.6048% / 2.1040 | 2.6226% / 2.1212 | pass |
| tab-row | 4.3685% / 3.7749 | 4.3839% / 3.7715 | genuine-visual-mismatch |
| tab-table | 9.0143% / 6.7693 | 9.0348% / 6.7869 | genuine-visual-mismatch |
| validation-error | 9.1185% / 6.9102 | 9.1390% / 6.9278 | genuine-visual-mismatch |

The targeted `tab-cell` changed-pixel ratio fell by 0.108 percentage points and
mean channel delta fell by 0.0234. The residual is native Avalonia/WPF control
and text rasterization, plus the remaining disabled-combo and bottom-viewport
differences; it remains honestly classified as a genuine visual mismatch.

## Verification

```text
dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj -c Release --no-restore --disable-build-servers --filter "FullyQualifiedName~WpfAuthoritySurfaceParityTests.Table_properties|FullyQualifiedName~TablePropertiesDialogTests"
  6 passed, 0 failed

dotnet test freew/FreeW.App.Host.Tests/FreeW.App.Host.Tests.csproj -c Release --no-restore --disable-build-servers --filter "FullyQualifiedName~TablePropertiesDialogTests"
  3 passed, 0 failed

tools/Test-FreeWDialogVisualEvidence.ps1
  passed: canonical rows, counts, scope, dashboard, and audit consistency
```

The disposable paired captures and route comparison are under
`artifacts/wave163-table-properties-*` and are not tracked.
