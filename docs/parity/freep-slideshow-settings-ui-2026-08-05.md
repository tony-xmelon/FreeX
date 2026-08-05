# FreeP Set Up Slide Show Function Slice - 2026-08-05

FreeP now exposes PowerPoint's presentation-level slide-show settings from the
Slide Show ribbon in both desktop hosts. The shared `SlideShowSettingsPlanner`
and existing undoable editing session own the mutation; WPF and Avalonia only
provide the native dialog surface.

Implemented options:

- Use slide timings, persisted as `p:showPr/@useTimings`.
- Show animations, persisted as `p:showPr/@showAnimation`.
- Loop until stopped, persisted as `p:showPr/@loop`.

PowerPoint-compatible defaults are preserved when attributes are omitted:
timings and animations enabled, looping disabled. The settings continue through
PPTX read/write, undo/redo, the shared slide-show controller, and both WPF and
Avalonia playback windows.

Verification on the isolated Release branch:

- `dotnet build FreeP.slnx --configuration Release`: 0 warnings, 0 errors.
- `dotnet test FreeP.slnx --configuration Release --no-build`: all eight FreeP
  test projects passed, totaling 6,790 tests.
- Focused WPF host lane: 128/128.
- Focused Avalonia dialog/ribbon lane: 369/369.
- Presentation suite: 3,720/3,720.
- Ribbon definitions: 28/28; localization: 21/21.

This closes the reachability gap for the previously persisted show properties;
it does not claim PowerPoint-native presenter/recording or OS-dialog parity.
