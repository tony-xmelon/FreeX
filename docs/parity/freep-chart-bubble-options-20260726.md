# FreeP Bubble Chart Options

## Scope

FreeP now exposes the modeled PowerPoint bubble-chart settings through the shared editing workflow in both desktop hosts:

- bubble scale, clamped to 0-300 percent;
- whether bubble size represents area or width;
- whether negative bubbles are shown.

The workflow uses one shared planner and undoable presentation command. WPF and Avalonia dialogs are host-specific shells over that planner, and the command preserves the existing `c:bubbleScale`, `c:sizeRepresents`, and `c:showNegBubbles` package fields.

## Verification

- Presentation planner/command and PPTX round-trip: 2/2 focused tests.
- WPF dialog and command-routing contracts: 2/2 focused tests.
- Avalonia dialog commit: 1/1 focused test.
- Avalonia test project Release build: 0 warnings, 0 errors.

This is a functional parity slice; no raster calibration is claimed.
