# FreeP chart-object protection on shape commands

Date: 2026-07-29

PowerPoint chart protection uses the `c:protection/@chartObject` flag to make the
chart object itself non-editable. FreeP already enforced the related data and
formatting flags inside chart commands, but the generic shape move, resize, rotate,
and delete commands could still change a protected chart frame.

The shared command path now treats `chartObject=true` as a no-op for those four
geometry/object mutations. The command bus retains normal undo/redo behavior: a blocked
command cannot mutate the chart during apply, undo, or redo. An absent or false
flag keeps existing chart geometry editing behavior.

Verification:

- `FreeP.App.Presentation.Tests` focused command tests: 81/81
- `FreeP.App.Presentation.Tests` full project: 2,993/2,993
- `FreeP.App.Host.Tests` `ChartTests`: 102/102
