# FreeP Chart Series Leader Lines - 2026-08-02

The shared chart-series planner already retained `ChartDataLabels.ShowLeaderLines`,
and the PPTX reader/writer and both renderers already consumed that value. The WPF
and Avalonia Chart Series Options dialogs did not expose it, so normal authoring
could not reach the existing semantic path.

This slice adds a tri-state `Leader lines` checkbox to both dialogs. The indeterminate
state preserves an omitted/automatic value, while checked and unchecked states author
explicit true and false values. The setting is carried through the existing undoable
`ApplyChartSeriesOptions` command and package path; no renderer calibration is involved.

Focused dialog tests verify that both desktop hosts produce a commit plan with
`ShowLeaderLines=true`. Existing chart package and rendering contracts remain the
authoritative persistence and display gates.
