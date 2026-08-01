# FreeW Backstage Visual Parity Wave 90

Date: 2026-08-01
Base: `e44acd1c4f` (`Align native ribbon nested popup parity`)

## Scope And Source Audit

The authoritative paired routes are the real WPF and Avalonia FreeW Backstage
pane builders. The visual harness intentionally captures the pane in a neutral
host, so the outer Backstage rail is not part of these five comparisons.

WPF uses `BackstageVisualKit` and `Kit.Scroll`. Avalonia uses the corresponding
FreeW `BackstageView` pane builders. The Avalonia pane scroll host previously
left text rendering and inherited typography to Fluent defaults; the Print pane
also returned its content without that host. Pixel inspection showed colored
subpixel fringe colors in Avalonia captures while WPF authority pixels were
grayscale/standard antialiasing.

## Implementation

- Applied `TextRenderingMode.Antialias` to the FreeW Avalonia Backstage pane
  scroll host, matching existing WPF-parity Avalonia surfaces.
- Made the pane host inherit the WPF metrics explicitly: Segoe UI, 12 px,
  zero padding, vertical scrolling, and disabled horizontal scrolling.
- Stretched the Save As type selector to match the WPF action surface.
- Aligned the Print section heading with WPF authority (`Document`) and routed
  Print through the same pane scroll host.
- Added focused Avalonia coverage for the pane host contract and Print host.

No comparison math, threshold, evidence classification, or canonical report was
changed.

## Fresh Paired Evidence

WPF authority captures are in `artifacts/freew-backstage-wave90-after-wpf-*`.
Final Avalonia captures are in `artifacts/freew-backstage-wave90-final-avalonia-*`.
The per-scenario comparison reports are in
`artifacts/freew-backstage-wave90-final-compare-*`.

| Scenario | Before changed ratio | After changed ratio | Before mean delta | After mean delta | Mean improvement |
| --- | ---: | ---: | ---: | ---: | ---: |
| `backstage-home.open` | 17.741% | 14.486% | 15.438 | 12.326 | 3.112 |
| `backstage-export.open` | 18.229% | 15.291% | 14.826 | 12.282 | 2.544 |
| `backstage-open.open` | 20.786% | 19.002% | 17.979 | 16.872 | 1.107 |
| `backstage-save-as.open` | 15.557% | 14.372% | 12.643 | 11.405 | 1.238 |
| `backstage-print.open` | 13.914% | 13.199% | 10.675 | 10.289 | 0.387 |

All captures were 560x600 and passed the WPF/Avalonia content gates. All five
rows remain `genuine-visual-mismatch`; the residual is honest toolkit raster
and native-control variance.

## Verification

- `dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release --no-restore --filter FullyQualifiedName~FreeW.App.Avalonia.Tests.BackstageViewTests --logger "console;verbosity=minimal"` - 32 passed.
- WPF targeted capture for each `wpf.backstage-{home,export,open,save-as,print}.open`.
- Avalonia targeted capture for each `avalonia.backstage-{home,export,open,save-as,print}.open`.
- Per-scenario comparison through `FreeW.DialogVisualHarness`.
