# Avalonia parity Wave120 FreeP Reading Order - 2026-08-03

## Scope

This slice aligns the seeded FreeP Reading Order pane target at 320x578 while
preserving the shared selection, reorder, accessibility, focus, and keyboard
behavior. WPF remains the visual authority.

## Implementation

- `PresentationReadingOrderPaneVisualMetrics` now owns the pane width, heading
  and body sizes, content margins, button geometry, card geometry, and selected
  item inset consumed by both hosts.
- Avalonia disables scrollbar auto-hide on the item `ScrollViewer`. This uses
  the native reserved scrollbar gutter instead of a manual right margin, so
  cards and the scrollbar participate in layout like WPF.
- Avalonia uses explicit WPF-authority button dimensions and a measured two-DIP
  action-row compensation. WPF keeps its existing minimum-width and native
  auto-height behavior while consuming the same shared measurements.
- Card selection, click routing, move enablement, tooltips, focus, and pane
  accessibility contracts are unchanged.

## Evidence

The checked-in report measured 18.6035% changed pixels, 82.34% foreground
change, and 15.4021 mean channel delta. A fresh pre-change capture from the
current source measured 17.1783%, 80.10%, and 13.3298 respectively.

The accepted fresh paired capture measured:

| Target | Changed pixels | Foreground changed | Mean delta | Result |
| --- | ---: | ---: | ---: | --- |
| `review.reading-order-pane.seeded` | 13.2185% | 22.2642% | 11.7795 | pass |

Both target images were 320x578. Capture status, nonblank checks, focus,
button order, and enabled state all matched. The focused report intentionally
contains limitations for the other 27 scenarios because only this owned route
was captured; it was not promoted as a full-suite evidence refresh.

## Verification

- `dotnet build freep/FreeP.App.Host/FreeP.App.Host.csproj -c Release --no-restore -m:1`: succeeded with 0 warnings and 0 errors.
- `dotnet build freep/FreeP.App.Avalonia/FreeP.App.Avalonia.csproj -c Release --no-restore -m:1`: succeeded with 0 warnings and 0 errors.
- `dotnet test freep/FreeP.App.Avalonia.Tests/FreeP.App.Avalonia.Tests.csproj -c Release --filter FullyQualifiedName~ReadingOrderPane`: 5 passed.
- Focused WPF capture: 1/1 complete.
- Focused Avalonia capture: 1/1 complete.
- Focused paired comparison: pass, with no semantic assertion differences.

## Residuals

Native WPF and Avalonia text rasterization, button chrome, and card rendering
still differ. The remaining 13.22% target delta is recorded rather than hidden
by changing the existing 20% generic acceptance threshold.
