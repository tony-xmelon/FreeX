# FreeP Prestige transition playback

`TransitionKind.Prestige` now maps to a dedicated shared playback action in
both slideshow hosts. The incoming page appears through a compact diamond
aperture, expands with eased progress, and follows a direction-sensitive
diagonal offset before settling into the complete frame.

This is a deterministic 2-D projection of the Prestige family. It keeps WPF
and Avalonia on one geometry path without claiming a full PowerPoint 3-D
camera or lighting model.

Verification covers the shared planner, transition mapping, WPF/Avalonia host
source guards, and Release builds. No new PowerPoint COM raster export was
issued for this transition-function slice.
