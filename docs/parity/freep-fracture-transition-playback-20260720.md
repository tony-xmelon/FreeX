# FreeP Fracture transition playback

`TransitionKind.Fracture` now maps to a dedicated shared playback action in
both slideshow hosts. The renderer-neutral planner divides the incoming page
into a 4-by-6 grid, opens shards in a deterministic center-first order, and
keeps a small gap between fragments until each cell reaches its full extent.
Direction metadata reverses the shard order where applicable.

This is a deterministic 2-D shard projection of the Fracture family. It keeps
WPF and Avalonia on the same geometry path without claiming PowerPoint's full
per-fragment 3-D motion model.

Verification covers the shared planner, transition mapping, WPF/Avalonia host
source guards, and Release builds. No new PowerPoint COM raster export was
issued for this transition-function slice.
