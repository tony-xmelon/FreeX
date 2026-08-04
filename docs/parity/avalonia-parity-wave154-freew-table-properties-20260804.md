# Avalonia Parity Wave 154: FreeW Table Properties

Date: 2026-08-04  
Route: `table-properties`  
Authority: app-owned WPF `freew/FreeW.App.Host/TablePropertiesDialog.cs`  
Scope: `initial`, `populated`, `validation-error`, `tab-table`, `tab-row`, `tab-column`, and `tab-cell`

## Source finding

The WPF authority places the floating `Positioning` section inside the Cell tab. Avalonia had
placed that section inside the Table tab and omitted it from Cell. The Avalonia route also used
the platform Expander template, while the WPF dialog uses the shared classic WPF expander chrome.
That combination made the Table, populated, and validation states render the Positioning section
where WPF renders the table-margin section, and made the Cell state structurally different.

## Changes

- Moved `BuildFloatingPositioningPanel()` from the Table tab to the Cell tab, preserving field
  order, state wiring, automation IDs, and validation behavior.
- Applied the existing shared `AvaloniaCompactDialogChrome.ApplyWpfExpander` helper to the
  Positioning section so the header, arrow, content stretch, and focusable interaction match the
  WPF dialog contract.
- Matched the WPF 8 px spacing before the floating-text-distance section header.
- Kept the route-specific label-column measurements used by the existing WPF authority evidence.
- Added a focused regression assertion that Positioning exists only on the Cell tab.

## Fresh paired evidence

The before and after captures used the same temporary 14-row inventory and the same 560 x 600
logical surface for all seven states. WPF captures were rendered through its explicit
`RenderTargetBitmap(..., 96, 96, ...)` path; Avalonia captures used its 96 DPI headless surface.
Both hosts produced seven captured, nonblank states. The WPF manifest reports the host's
`VisualTreeHelper` DPI as 144, but the rendered comparison bitmap and logical dimensions are the
same 560 x 600 96-DPI authority surface.

`changedRatio` is the percentage of compared pixels with a difference; `meanAbsoluteChannelDelta`
is the mean RGB channel delta. Existing comparison thresholds were unchanged.

| State | Before ratio / mean | After ratio / mean | Classification after |
| --- | ---: | ---: | --- |
| initial | 37.1815% / 13.8026 | 9.0143% / 6.7693 | genuine-visual-mismatch |
| populated | 37.1815% / 13.8026 | 9.0143% / 6.7693 | genuine-visual-mismatch |
| tab-cell | 16.7940% / 8.2113 | 18.9515% / 10.8309 | genuine-visual-mismatch |
| tab-column | 2.6048% / 2.1040 | 2.6048% / 2.1040 | pass |
| tab-row | 4.3685% / 3.7749 | 4.3685% / 3.7749 | genuine-visual-mismatch |
| tab-table | 37.1815% / 13.8026 | 9.0143% / 6.7693 | genuine-visual-mismatch |
| validation-error | 37.2857% / 13.9435 | 9.1185% / 6.9102 | genuine-visual-mismatch |

The seven-state mean changed from **24.6568% / 9.9202** to **8.8694% / 6.2754**. The Cell row
remains a genuine visual mismatch because Avalonia and WPF still differ in native disabled-combo
painting, a few control-width pixels, and bottom clipping at the fixed evidence surface. It is
reported honestly; no row was relabeled and no threshold was weakened.

## Verification

```text
dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj -c Release --no-restore --disable-build-servers --filter "FullyQualifiedName~WpfAuthoritySurfaceParityTests.Table_properties|FullyQualifiedName~TablePropertiesDialogTests"
  4 passed, 0 failed

dotnet test freew/FreeW.App.Host.Tests/FreeW.App.Host.Tests.csproj -c Release --no-restore --disable-build-servers --filter "FullyQualifiedName~TablePropertiesDialogTests"
  3 passed, 0 failed
```

The disposable capture and comparison artifacts are under `artifacts/wave154-table-properties-*`
and are not part of the tracked change. The canonical aggregate dialog bundle was not regenerated
by this route-only slice.
