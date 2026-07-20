# FreeP Prism transition playback

`TransitionKind.Prism` now maps to a dedicated shared playback action in both
slideshow hosts. The incoming page is divided into three facets; the center
facet leads, side facets follow, and partial facets use angled edges before
settling into the complete frame. Horizontal and vertical direction metadata
selects the facet axis, with reverse directions mirrored in the shared plan.

This is a deterministic 2-D projection of the Prism family. It keeps WPF and
Avalonia on one geometry path without claiming a full PowerPoint 3-D prism
camera or per-panel perspective transform.

Verification covers the shared planner, transition mapping, WPF/Avalonia host
source guards, and Release builds. No new PowerPoint COM raster export was
issued for this transition-function slice.
