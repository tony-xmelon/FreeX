# FreeP Function-First Slice: Hide Slide

Date: 2026-07-24

PowerPoint's slide-pane Hide Slide action now has a complete FreeP path. The
shared presentation command is undoable and redoable, the action text and
checked state switch between Hide Slide and Show Slide, and both WPF and
Avalonia slide-pane context menus route through the shared planner.

The existing `Slide.IsHidden` package read/write and slide-show route already
provided the persistence and playback behavior. This slice closes the
missing editing entry point without changing rendering or layout code.

Focused verification:

- `FreeP.App.Presentation.Tests`: 97 focused tests passed.
- Avalonia hide/show headless test: compile and no-build passed.
- WPF shared context-menu test: compile and no-build passed.
