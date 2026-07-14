# FreeP Slideshow Playback Readiness - 2026-07-14

This no-COM slice deepens FreeP slideshow playback parity evidence by adding a shared readiness manifest for animation-step playback.

Shared status:

- `SlideShowPlaybackFramePlanner.BuildAnimationStepPlaybackReadinessPlan` aggregates the shared animation-step checkpoint frames into a compact playback-readiness plan.
- The plan records slide and step identity, animation entry count, checkpoint count, delayed-entry count, visual track coverage, clip/mask coverage, and paired WPF/Avalonia host evidence rows.
- WPF and Avalonia slideshow windows retain the shared readiness plan when playing an animation step, keeping host adapters thin over the same planner contract.
- The evidence is deterministic and does not require desktop PowerPoint COM; PowerPoint-authoritative visual capture remains a separate baseline task.

Verification:

- `freep/FreeP.App.Presentation.Tests/SlideShowPlaybackPlannerTests.cs` covers the no-COM readiness manifest, paired WPF/Avalonia host rows, delayed-entry evidence, and track/clip coverage.
- `freep/FreeP.App.Host.Tests/SlideShowHostPolicySourceTests.cs` verifies WPF consumes the shared readiness planner.
- `freep/FreeP.App.Avalonia.Tests/SlideShowHostPolicySourceTests.cs` verifies Avalonia consumes the same shared readiness planner.

Remaining blockers:

- This is FreeP/WPF/Avalonia deterministic readiness evidence, not a PowerPoint-authoritative visual baseline.
- Exact PowerPoint frame timing, easing curves, and screenshot comparison still require a COM-capable PowerPoint baseline machine.
