# FreeP Crush transition playback

`TransitionKind.Crush` now maps to a dedicated shared playback action in both
slideshow hosts. The incoming page starts as a narrow, slightly offset panel
and expands anisotropically toward the full frame; horizontal and vertical
directions select the crush axis and reverse directions preserve the initial
offset sign.

This is a deterministic 2-D projection of the Crush family. It keeps WPF and
Avalonia on the same aperture geometry path without claiming a full
PowerPoint 3-D surface-compression implementation.

Verification covers the shared planner, transition mapping, WPF/Avalonia host
source guards, and Release builds. No new PowerPoint COM raster export was
issued for this transition-function slice.
