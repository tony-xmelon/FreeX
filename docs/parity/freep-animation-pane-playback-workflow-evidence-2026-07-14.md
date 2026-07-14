# FreeP Animation Pane Playback Workflow Evidence - 2026-07-14

This no-COM slice deepens FreeP animation-pane playback parity evidence by tying pane playback commands to a shared workflow evidence plan.

Shared status:

- `AnimationPanePlanner.BuildPlaybackWorkflowEvidencePlan` records the pane command, running/stopped session state, selected start row, segment count, optional visual checkpoint coverage, track kinds, clip kinds, and paired WPF/Avalonia host evidence rows.
- WPF `AnimationPane` and Avalonia `MainWindow` retain the shared evidence plan whenever Preview, Play From Selected, Play All, or Stop routes through the shared playback session planner.
- The shared planner can merge pane session evidence with `SlideShowPlaybackFramePlanner` checkpoint plans, so visual track/clip coverage is represented without claiming a PowerPoint-authoritative baseline.
- The evidence is deterministic and does not require desktop PowerPoint COM; PowerPoint visual capture remains a separate baseline task.

Verification:

- `freep/FreeP.App.Presentation.Tests/AnimationPanePlannerTests.cs` covers pane playback workflow evidence with visual checkpoint track/clip coverage and paired WPF/Avalonia no-COM host rows.
- `freep/FreeP.App.Host.Tests/AnimationPaneTests.cs` verifies WPF retains the shared playback workflow evidence when Play From Selected runs.
- `freep/FreeP.App.Avalonia.Tests/MainWindowHeadlessTests.cs` verifies Avalonia retains the same shared playback workflow evidence when Play From Selected runs.

Remaining blockers:

- This is FreeP/WPF/Avalonia deterministic workflow evidence, not a PowerPoint-authoritative animation-pane visual or playback baseline.
- Exact PowerPoint animation pane UI capture, frame timing, easing curves, and screenshot comparison still require a COM-capable PowerPoint baseline machine.
