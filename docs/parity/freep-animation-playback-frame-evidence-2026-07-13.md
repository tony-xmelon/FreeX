# FreeP Animation Playback Frame Evidence - 2026-07-13

This no-COM slice deepens FreeP slideshow playback parity evidence by adding a shared, renderer-neutral visual frame plan for animation playback.

Shared status:

- `SlideShowPlaybackFramePlanner` now projects deterministic per-effect visual frame descriptors from the same playback plans used by WPF and Avalonia slideshow windows.
- Frame descriptors include normalized progress, opacity, scale, rotation, translate offsets in normalized and slide-DIP coordinates, clip/mask kind, clip progress, band counts, and wheel spoke counts.
- WPF and Avalonia slideshow hosts now touch the shared frame plan while executing shape animation steps, preserving thin host adapters over shared playback policy.
- Focused planner tests cover translate, motion-path, advanced clip/mask, scale, delayed step-frame, and evidence-summary behavior without requiring Microsoft PowerPoint COM.

Verification:

- `freep/FreeP.App.Presentation.Tests/SlideShowPlaybackPlannerTests.cs` covers the shared visual frame contract.
- `freep/FreeP.App.Host.Tests/SlideShowHostPolicySourceTests.cs` verifies WPF consumes the shared frame planner while executing animation steps.
- `freep/FreeP.App.Avalonia.Tests/SlideShowHostPolicySourceTests.cs` verifies Avalonia consumes the same shared frame planner while executing animation steps.

Remaining blockers:

- These frame descriptors are deterministic FreeP/WPF/Avalonia evidence, not PowerPoint-authoritative visual baselines.
- Exact PowerPoint easing curves, dissolve particle behavior, bounce/boomerang overshoot, 3D swivel/spiral nuance, and frame-by-frame screenshots still require a COM-capable PowerPoint baseline machine.
