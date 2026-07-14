# FreeP Animation Pane PowerPoint Baseline Readiness - 2026-07-14

This no-COM slice prepares PowerPoint-authoritative animation-pane and playback visual evidence by adding a shared capture-readiness contract.

Shared status:

- `AnimationPanePlanner.BuildVisualBaselineReadinessPlan` now projects stable pane and playback checkpoint capture requests from the shared animation-pane timeline and slideshow playback frame checkpoint plans.
- Each requested surface has paired PowerPoint, WPF, and Avalonia capture IDs, so a COM-capable baseline machine can capture Microsoft PowerPoint evidence and compare it against the same WPF/Avalonia shared-plan surfaces.
- The readiness plan records which requests require desktop PowerPoint COM while preserving deterministic WPF/Avalonia evidence on machines where PowerPoint COM is unavailable.
- Playback checkpoint requests reuse the renderer-neutral frame summaries for advanced effects such as wheel clips, preserving shared effect-kind, progress, opacity, transform, clip, band, and spoke evidence.

Verification:

- `freep/FreeP.App.Presentation.Tests/AnimationPanePlannerTests.cs` covers the PowerPoint/WPF/Avalonia capture matrix, stable capture IDs, COM-required flags, and advanced playback checkpoint summaries.

Remaining blockers:

- This slice does not capture Microsoft PowerPoint screenshots locally; the PowerPoint requests are readiness contracts for a COM-capable baseline host.
- Exact PowerPoint animation-pane UI baselines, easing curves, dissolve particle behavior, bounce/boomerang overshoot, and swivel/spiral 3D playback visuals still require the authoritative capture run.
