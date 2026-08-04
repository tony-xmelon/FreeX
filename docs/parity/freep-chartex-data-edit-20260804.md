# FreeP native ChartEx data editing - 2026-08-04

FreeP already preserved native non-waterfall ChartEx chart parts, but an accepted
chart-data edit only changed the in-memory `ChartShape`; the writer then copied
the original `cx:chartData` unchanged. That made editing an imported histogram,
Pareto, or similar single-series ChartEx chart appear successful until save/reopen.

The ChartEx writer now synchronizes categories, numeric values, and the series
name when the existing chart is marked dirty by a chart-data command. The update
is intentionally guarded to the reader's proven shape: one `cx:series`, one
string dimension, and one numeric dimension. Family-specific nodes such as a
histogram binning extension and the native `layoutId` remain untouched. Ambiguous
multi-series payloads continue through the verbatim preservation path rather than
being silently rewritten as a generic classic chart.

No-edit open/save behavior remains unchanged because synchronization is gated by
the existing `RegenerateWorkbookOnSave` dirty flag. Focused host tests cover both
the unchanged non-waterfall preservation path and an edited histogram payload.
