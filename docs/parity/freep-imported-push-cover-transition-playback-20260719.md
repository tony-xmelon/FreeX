# FreeP imported Push and Cover transition playback

## Scope

Imported `p:push` and `p:cover` transitions now use distinct playback semantics.

- `p:cover` keeps the outgoing snapshot stationary while the incoming slide translates over it.
- `p:push` translates the incoming slide into place while displacing the outgoing snapshot by the same signed slide offset.

The planner exposes separate actions and both native hosts consume the shared direction values. Other unresolved transition families remain on their existing fallback paths.

## Verification

- Presentation contracts distinguish Push and Cover source/action kinds and preserve direction/duration.
- WPF and Avalonia source guards cover both dedicated host routes.
- No PowerPoint-authoritative frame capture was added in this slice; exact easing and raster parity remain follow-up work.
