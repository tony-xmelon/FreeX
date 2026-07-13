# FreeP Animation Pane Workflow Depth - 2026-07-06

This slice advances FreeP animation-pane workflow depth by moving pane evidence into a shared WPF/Avalonia planner contract.

Shared status:

- `AnimationPanePlanner.BuildWorkflowEvidencePlan` now projects selected-row state, timing editor coverage, effect-option row coverage, reorder availability, playback readiness, and evidence lines from the same timeline plan both hosts render.
- WPF `AnimationPane` exposes the shared evidence plan through its thin host seam instead of deriving pane workflow state locally.
- Avalonia `MainWindow` stores the shared evidence plan while rendering the pane, so headless tests verify the same row summaries and playback-control readiness as WPF.

Verification:

- `freep/FreeP.App.Presentation.Tests/AnimationPanePlannerTests.cs` covers the shared workflow evidence contract.
- `freep/FreeP.App.Host.Tests/AnimationPaneTests.cs` verifies the WPF pane exposes shared evidence lines and keeps timing/playback policy in the planner.
- `freep/FreeP.App.Avalonia.Tests/MainWindowHeadlessTests.cs` verifies the Avalonia pane renders from the same evidence plan.

Remaining blockers:

- PowerPoint-authoritative animation-pane UI baselines still require a machine with desktop Microsoft PowerPoint COM registered.
- Exact PowerPoint-authoritative advanced effect playback visuals remain deferred until their baseline corpus is added on a COM-capable machine.
