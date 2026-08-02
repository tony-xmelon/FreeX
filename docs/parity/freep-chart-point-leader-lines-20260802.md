# FreeP chart point leader-line authoring - 2026-08-02

FreeP already preserved point-level `c:dLbls/c:showLeaderLines` state in the
chart model and package writer, but the point-options workflow did not expose
that state. The shared point options model and planner now carry the nullable
PowerPoint automatic/on/off value, and both WPF and Avalonia dialogs expose it
as a three-state control.

The command path applies the value to the selected point's data-label override,
preserves an explicit value through PPTX write/reopen, and remains undoable.
The change is function-only; no renderer calibration or visual claim is made.

Verification:

- `ChartDataDialogPlannerTests` + `ChartDataCommandTests`: 116/116
- WPF `ChartDataDialogTests`: 44/44
- Avalonia point/series dialog checks: 2/2
- All focused lanes passed both compile and `--no-build` runs.
