# FreeP Avalonia Default Animation Timing

Date: 2026-08-09

PowerPoint COM authored a fresh one-shape fade animation without `accel` or
`decel` attributes in the resulting `p:timing` XML (`animEffect transition=in
filter=fade`). The shared `SlideShowPlaybackPlanner` treats omitted timing as
linear, and the WPF playback path already consumes that contract.

Avalonia previously substituted its legacy `EaseInOut` curve when both timing
attributes were absent. Its timing-aware animation helper now always delegates
to `SlideShowPlaybackPlanner.ApplyTimingEasing`, preserving authored
acceleration/deceleration values while aligning the omitted/default case across
Avalonia, WPF, and the renderer-neutral planner.

Focused verification:

- `FreeP.App.Avalonia.Tests`: `AvaloniaShapePlayback_UsesAuthoredAccelerationAndDecelerationEasing`, 1/1.
- `FreeP.App.Presentation.Tests`: `TimingEasing`, 1/1.
- `FreeP.App.Host.Tests`: `WpfShapePlayback_UsesAuthoredAccelerationAndDecelerationEasing`, completed from the owned Release test run.
