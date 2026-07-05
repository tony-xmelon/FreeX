# FreeP Animation Pane Advanced Effect Options - 2026-07-05

This slice advances FreeP animation-pane workflow depth by sharing PowerPoint-style effect option metadata for advanced imported animations across WPF and Avalonia.

Shared status:

- `AnimationPanePlanner` now exposes renderer-neutral effect-option descriptors for advanced imported families already understood by slideshow playback: Blinds, Checkerboard, Box, Circle, Diamond, Plus, Wedge, Wheel, Peek, Crawl, and Strips.
- WPF `AnimationPane` and Avalonia `MainWindow` consume the same `AnimationPaneEffectOptionsPlan` and `AnimationPaneEffectOptionMutationPlan`, so option labels, selected state, mutation ids, and undoable model updates stay aligned.
- Direction choices map back to persisted `ShapeAnimation.Direction` values used by PPTX subtype import/export and slideshow playback planning.

Verification:

- `freep/FreeP.App.Presentation.Tests/AnimationPanePlannerTests.cs` covers the advanced option families, selected labels, and mutation ids.
- Existing WPF and Avalonia pane adapter tests continue to assert that host-local panes route through the shared planner instead of duplicating timing/effect-option policy.

Remaining blockers:

- PowerPoint-authoritative visual baselines for animation-pane UI and advanced effect playback still require a machine with desktop Microsoft PowerPoint COM registered.
- Unsupported imported effect families that do not have shared playback semantics yet remain disabled in the pane until their planner/playback contract is added.
