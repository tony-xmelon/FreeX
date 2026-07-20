# FreeP Peel Off transition playback

Peel Off now maps to the shared single-fold page-curl projection. This keeps
the page-edge peel silhouette, direction, and folded-page timing in WPF and
Avalonia instead of reducing the transition to a fade. The projection is
intentionally 2-D and reuses the existing page-curl geometry; it does not
claim a full perspective page-surface simulation.

The mapping is covered by the shared transition planner and playback-plan
tests. No PowerPoint COM raster export was issued for this function-focused
slice.
