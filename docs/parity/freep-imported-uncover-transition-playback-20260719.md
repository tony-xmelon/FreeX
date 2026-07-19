# FreeP imported Uncover transition playback

## Scope

Imported `p:uncover` transitions now keep the incoming slide underneath the outgoing snapshot and shrink the outgoing snapshot toward the authored travel edge. This models the PowerPoint-style Uncover distinction from Push/Cover: the new slide is exposed by the old slide leaving, rather than entering as a translated foreground slide.

The outgoing mask is shared by WPF and Avalonia through `SlideShowMaskGeometryPlanner`; host code only converts it to the native clip type and manages the snapshot layer's z-order.

## Verification

- Planner contracts cover the Uncover action/source kind, direction, duration, and outgoing mask geometry.
- WPF and Avalonia source guards cover the dedicated Uncover host route.
- No PowerPoint-authoritative frame capture was added in this slice; exact easing and raster parity remain follow-up work.
