# FreeX UI Performance Review - 2026-05-28

## Scope

Reviewed the app with a focus on UI responsiveness during window resize, grid repaint, chart repaint, resize drag, and selection drag. The work used subagent scouting for ribbon/layout, grid rendering, instrumentation gaps, resize-preview correctness, and remaining hotspots.

All implemented changes were measured before and after with focused WPF tests. Timings are local debug-test telemetry, intended for relative comparison rather than release-grade benchmarking.

## Implemented Optimizations

| Area | Before | After | Impact |
| --- | ---: | ---: | --- |
| Ribbon compact planner | `RIBBON_FORCE_COMPACT` 48.34 ms measured compact mean, 112.92 ms p95, 267.0 MB allocated | 2.79 ms measured compact mean, 5.34 ms p95, 27.5 MB allocated | Preserves the new layout engine while reducing repeated layout writes and fallback churn. Full window `UpdateLayout` during resize remains a separate bottleneck. |
| Column resize preview | `COLUMN_RESIZE_PREVIEW` 2422.45 ms total, 24.22 ms mean, 31.05 ms p95, 52.4 MB allocated | 4.46 ms total, 0.04 ms mean, 0.05 ms p95, 126 KB allocated, `viewport_gets=0` | Stops rebuilding viewport and mutating sheet dimensions on every drag tick. Commit still updates once. |
| Text-heavy grid repaint, default background/gridline batching | `GRID_RENDER_TEXT_HEAVY` 2972.28 ms total, 247.67 ms mean, 1151.61 ms p95, 356.1 MB allocated | 1766.45 ms total, 147.19 ms mean, 210.31 ms p95, 198.6 MB allocated | Draws sheet background and gridlines once instead of per-cell. |
| Text-heavy grid repaint, default text layout cache | 5061.63 ms total, 421.77 ms mean, 602.71 ms p95, 198.6 MB allocated | 2997.66 ms total, 249.77 ms mean, 430.46 ms p95, 109.2 MB allocated | Reuses unstyled default-font `FormattedText` for repeated paints of the same viewport. |
| Text-heavy grid repaint, viewport lookup cache | 3615.69 ms total, 301.28 ms mean, 572.46 ms p95, 109.2 MB allocated | 2845.23 ms total, 237.10 ms mean, 375.78 ms p95, 107.3 MB allocated | Reuses row, column, style, and occupied-cell lookups while the viewport object is unchanged. |
| Chart repaint | `GRID_RENDER_CHART` 2385.52 ms total, 298.18 ms mean, 563.18 ms p95, 34.0 MB allocated | 798.73 ms total, 99.83 ms mean, 116.86 ms p95, 17.4 MB allocated | Caches exported chart images across grid repaints for unchanged chart, viewport, theme, and size. |
| Selection drag status refresh | `SELECTION_DRAG_STATUS` 636.40 ms total, 7.95 ms mean, 15.85 ms p95, 21.6 MB allocated | 278.32 ms total, 3.48 ms mean, 3.73 ms p95, 23.2 MB allocated | Defers status-bar aggregate recalculation until mouse-up during drag selection. |

## Correctness Fixes During Optimization

- Row/column resize previews now keep workbook dimensions unchanged until commit.
- Resize preview ranges are cleared when mouse capture is lost, preventing stale multi-row or multi-column preview ranges from affecting a later commit.
- Object data is omitted from viewport creation when objects are hidden or placeholders-only, avoiding chart data extraction when it cannot be rendered.

## Biggest Remaining Bottlenecks

1. **Full WPF window resize layout is still expensive.**
   The final standalone ribbon/window resize sequence measured `RIBBON_RESIZE` at 18030.15 ms total, 273.18 ms mean, and 631.31 ms p95 across 66 width changes. The compact planner itself is no longer the dominant cost; the remaining work is full WPF `Width + UpdateLayout` invalidation across the window. The next investigation should instrument layout/render phases separately around the main window chrome, ribbon host, formula bar, grid, scrollbars, and status bar.

2. **Grid text rendering is still expensive.**
   Even with default text layout caching, WPF `FormattedText` and `DrawingContext.DrawText` dominate text-heavy repaint cost. A larger improvement likely requires a safer text-rendering strategy, such as caching immutable glyph runs for common unstyled text or splitting static grid content from dynamic overlays. Raw `FormattedText` caching must remain UI-thread-local.

3. **Grid repaint still redraws the whole visible grid for many small visual changes.**
   Selection, marching ants, formula traces, and resize adorners still invalidate the same main grid visual. The next major improvement is likely layering: keep static cells/gridlines/charts in a retained bitmap or child drawing visual, then repaint lightweight overlays separately.

4. **Viewport recomputation still does display text and conditional-format work per refresh.**
   Resize idle refreshes and scrolls still rebuild display cell data. A viewport cache keyed by sheet revision, request bounds, zoom/display options, and object-display mode could help, but needs a workbook invalidation model before it is safe.

5. **Chart cache invalidation is conservative.**
   The implemented cache is safe for repeated repaints of unchanged chart objects and viewports. More durable caching across new viewport instances would need a chart data/theme/style signature or sheet revision.

6. **Status-bar drag selection still allocates heavily.**
   Deferring aggregation reduced p95 latency, but selection range updates and visual invalidation still allocate. A deeper fix would separate selection overlay repaint from cell repaint and avoid rebuilding non-contiguous selection lists on every drag tick.

## Measurement Commands

- Host/ribbon/resize/status tests: `dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --filter ... --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1`
- UI render tests: `dotnet test tests\FreeX.App.UI.Tests\FreeX.App.UI.Tests.csproj --filter ... --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1`

## Recommendation

The biggest next step is to split static grid rendering from dynamic overlays. Most remaining resize and interaction jank now comes from repainting too much for small visual changes; further micro-optimizing individual loops will likely produce smaller returns than separating cells/charts from selection, cursor, clipboard, and drag adorners.
