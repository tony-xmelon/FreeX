# FreeP imported Wipe transition playback

## Scope

Imported `p:wipe` transitions now use the shared directional Reveal clip path. A Wipe reveals the incoming slide from its configured edge, while the prior slide remains visible outside the incoming clip. This matches the transition's edge-reveal semantics more closely than the generic translating PushLike fallback.

The change is planner-only: WPF and Avalonia already implement the shared Reveal clip geometry and animation path. Other unresolved transition families remain on their existing fallback paths.

## Verification

- Presentation transition planner and playback contracts pass for Wipe's Reveal action, source kind, direction, and duration.
- WPF and Avalonia host source guards remain green.
- No PowerPoint-authoritative frame capture was added in this slice; exact easing and raster parity remain follow-up work.
