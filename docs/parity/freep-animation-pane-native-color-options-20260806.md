# FreeP Native Color Animation Pane Options

Date: 2026-08-06

Imported PowerPoint Change Fill Color, Change Line Color, and Change Font Color
animations already retained their native `p:animClr` behavior groups, but the
Animation Pane exposed no editable effect options for them. The shared pane
planner now offers Accent 1 through Accent 6 for supported theme-color
destinations and rewrites only the native `p:to/a:schemeClr` destination. Fill
setters, line setters, target metadata, and the original behavior structure are
preserved; the edit remains undoable and round-trips through PPTX.

This is a functional package/editing slice. It does not claim text-only color
raster parity during playback.

Verification:

- Full `FreeP.App.Presentation.Tests`: 3850/3850.
- Animation Pane focused shared tests: 108/108.
- WPF host contracts: 18/18.
- Avalonia host contracts: 4/4.
- WPF and Avalonia Release builds: 0 warnings, 0 errors.
