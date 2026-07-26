# FreeP Pie/Doughnut Chart Options

## Scope

FreeP now exposes the modeled PowerPoint pie-family settings through the shared editing workflow in both desktop hosts:

- first-slice angle, from 0 to 359 degrees;
- doughnut hole size, from 10% to 90%.

The workflow uses one working-copy planner and one undoable command. WPF and Avalonia dialogs are host-specific shells over that planner, and the command preserves the existing `c:firstSliceAng` and `c:holeSize` package fields. The hole control is disabled for ordinary pie charts, where it has no effect.

## Verification

- Presentation planner, command, PPTX round-trip, and undo: 2/2 focused tests.
- WPF dialog and command-routing contracts: 2/2 focused tests.
- Avalonia dialog commit: 1/1 focused test.
- Affected Release project builds: 0 warnings, 0 errors.

This is a functional parity slice; no raster calibration is claimed.
