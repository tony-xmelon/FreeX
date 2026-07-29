# FreeP chart-object protection on shape commands

Date: 2026-07-29

PowerPoint chart protection uses the `c:protection/@chartObject` flag to make the
chart object itself non-editable and `c:protection/@selection` to protect chart
elements from editor selection. FreeP already enforced the related data and
formatting flags inside chart commands, but the generic shape move, resize, rotate,
and delete commands could still change a protected chart frame and selection could
still enter a protected chart.

The shared command path now treats `chartObject=true` as a no-op for those four
geometry/object mutations. The command bus retains normal undo/redo behavior: a blocked
command cannot mutate the chart during apply, undo, or redo. The selection flag is
enforced by the shared editing session, including Select All. Absent or false flags
keep existing behavior.

Verification:

- `FreeP.App.Presentation.Tests` focused command tests: 82/82
- `FreeP.App.Presentation.Tests` full project: 2,994/2,994
- `FreeP.App.Host.Tests` `ChartTests`: 102/102
