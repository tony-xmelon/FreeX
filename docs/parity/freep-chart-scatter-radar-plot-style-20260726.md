# FreeP Scatter/Radar Plot Style

## Scope

FreeP now exposes the modeled PowerPoint plot styles for Scatter and Radar charts through the shared editing workflow in both desktop hosts:

- Scatter: markers, lines and markers, lines, smooth lines, or smooth lines and markers;
- Radar: standard, marker, or filled.

The workflow uses one working-copy planner and one undoable command. Each host disables the control that does not apply to the selected chart family. The existing `c:scatterStyle` and `c:radarStyle` reader, writer, and render paths remain authoritative.

## Verification

- Presentation planner, command, PPTX round-trip, and undo: 2/2 focused tests.
- WPF dialog and command-routing contracts: 2/2 focused tests.
- Avalonia dialog commit: 1/1 focused test.
- Affected Release project builds: 0 warnings, 0 errors.

This is a functional parity slice; no raster calibration is claimed.
