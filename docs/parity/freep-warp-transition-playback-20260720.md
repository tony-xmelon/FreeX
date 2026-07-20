# FreeP Warp transition playback

`TransitionKind.Warp` now maps to a dedicated shared playback action in both
slideshow hosts. The renderer-neutral planner reveals the incoming slide with
phase-shifted quadrilateral strips whose leading edge bends and tapers toward
the completed frame. Direction is preserved for horizontal and vertical
variants, and the final frame is a single full-slide rectangle.

This is a deterministic 2-D projection of the Warp family. It keeps the
geometry shared between WPF and Avalonia and does not claim a full PowerPoint
deforming-surface implementation.

Verification covers the shared planner, transition mapping, WPF/Avalonia host
source guards, and Release builds. No new PowerPoint COM raster export was
issued for this transition-function slice.
