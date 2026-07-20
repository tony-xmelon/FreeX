# FreeP Airplane transition playback

Airplane now routes through the shared direction-aware Flythrough projection.
This preserves the motion-through-space silhouette, scale collapse, and
direction in WPF and Avalonia instead of reducing Airplane to a fade. The
projection is intentionally the existing 2-D perspective model and does not
claim a full 3-D airplane mesh.

The transition and perspective planner contracts cover the mapping. No
PowerPoint COM raster export was issued for this function-focused slice.
