# FreeP Chart Axis Display Options

## Scope

The shared Chart Axis Options workflow now exposes the axis display and crossing controls already modeled and supported by the OOXML reader/writer:

- major and minor tick mark placement: automatic, none, inside, outside, or cross;
- tick-label position: automatic, none, low, high, or next to the axis;
- axis crossing mode: automatic, automatic zero, minimum, or maximum;
- an explicit numeric `crossesAt` value.

WPF and Avalonia dialogs use the same `ChartAxisOptionsPlanner`, and edits continue through `SetChartAxisOptionsCommand` for one-step undo. A numeric crossing takes precedence over the enum crossing mode because OOXML serializes those as mutually exclusive `crossesAt` and `crosses` elements.

## Verification

- Presentation planner: `ChartAxisOptionsPlanner_UsesWorkingCopyAndBuildsScaleOptions` passed.
- Presentation command: `SetChartAxisOptions_ChangesRoundTripFieldsAndUndoRestoresThem` passed.
- WPF dialog/source contracts: 2/2 passed.
- Avalonia dialog contract: 1/1 passed.
- Host and Avalonia Release builds: 0 warnings, 0 errors.
