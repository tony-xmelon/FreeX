# FreeP Wave72 Functional Depth Audit

Date: 2026-07-31

## Scope

This audit starts from `origin/main` commit `e433af1aa9c8dba6582fc2255b477bdc8b2ba845` and compares the FreeP WPF host with the Avalonia host for user-facing rich text, object, animation, review, and math workflows. Printing, video export, recording, and the active FreeW wrapping work are outside the audit.

The audit intentionally does not repeat Wave71 paragraph triple-click marker selection. It also leaves the separate active FreeP rotation and alignment branches untouched.

## Finding

No current, reproducible WPF-over-Avalonia functional gap was proven in this bounded area, so no production or test code change is warranted for Wave72.

The historical comments-pane report named an Avalonia key-tip ambiguity between `Blink=B` and `Blinds In=BI`. That residual is no longer present at this baseline: the complete Avalonia keyboard-context filter passes, including the nested animation-menu cases. Treating that stale report as an implementation target would invent behavior that is already covered.

## Evidence

| Area | WPF authority evidence | Avalonia evidence | Result |
|---|---|---|---|
| Rich text editing and formatting | `KeyboardContextParityTests`, `RichTextEditorTests`, and the WPF host portion of the focused feature lane | Full `FreeP.App.Avalonia.Tests` lane, including rich editor, table-cell, clipboard, hyperlink, keyboard, and command-routing coverage | No managed functional mismatch observed |
| Objects and embedded OLE | `OleMathRoundTripTests` plus the shared OLE activation/insertion contracts | Avalonia command/source coverage and shared `OleActivationService`/insertion paths; command inventory has no actionable host gap | Both hosts use the same model and activation contract; OS host availability remains an environment limitation |
| Animation pane and playback routing | `AnimationPaneTests` and the WPF portion of the focused feature lane | Avalonia full lane plus the existing physical animation-pane fixture contract | Managed route parity is covered; physical Linux proof is still narrower than full WPF interaction coverage |
| Review/comments | `ReviewWorkflowAdapterTests` and shared review planner contracts | Avalonia full lane, including comments pane/action/mention and keyboard routing coverage | No current managed mismatch observed |
| Math rendering | WPF `SlideCanvasMathBaselineTests`: 40/40 | Avalonia `SlideCanvasMathBaselineTests`: 41/41 | Shared math layout/draw contract is passing on both hosts |

The generated command inventory at this baseline reports **559 total, 559 shared, 0 WPF-only, 0 Avalonia-only, and 0 actionable missing commands**.

## Exact verification

- `dotnet test freep/FreeP.App.Avalonia.Tests/FreeP.App.Avalonia.Tests.csproj --configuration Release --filter "FullyQualifiedName~KeyboardContextParityTests" --logger "console;verbosity=minimal"` -> **17/17 passed**.
- `dotnet test freep/FreeP.App.Avalonia.Tests/FreeP.App.Avalonia.Tests.csproj --configuration Release --no-build --no-restore --logger "console;verbosity=minimal"` -> **496/496 passed**.
- `dotnet test freep/FreeP.App.Host.Tests/FreeP.App.Host.Tests.csproj --configuration Release --filter "FullyQualifiedName~KeyboardContextParityTests|FullyQualifiedName~ReviewWorkflowAdapterTests|FullyQualifiedName~CanvasEditingTests|FullyQualifiedName~RichTextEditorTests|FullyQualifiedName~OleMathRoundTripTests|FullyQualifiedName~AnimationPaneTests" --logger "console;verbosity=minimal"` -> **155/155 passed**.
- `dotnet test freep/FreeP.App.Rendering.Avalonia.Tests/FreeP.App.Rendering.Avalonia.Tests.csproj --configuration Release --filter "FullyQualifiedName~SlideCanvasMathBaselineTests" --logger "console;verbosity=minimal"` -> **41/41 passed**.
- `dotnet test freep/FreeP.App.Host.Tests/FreeP.App.Host.Tests.csproj --configuration Release --no-build --no-restore --filter "FullyQualifiedName~SlideCanvasMathBaselineTests" --logger "console;verbosity=minimal"` -> **40/40 passed**.

## Physical Linux baseline

After integration, the existing FreeP family X11 baseline passed **24/24**:

```text
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools/Run-FamilyLinuxInteractionValidation.ps1 -App FreeP -Port 6723 -OutputDir artifacts/freep-wave72-family-x11
```

The run covered the seeded animation-pane workflow, keyboard and key-tip routes, context entry,
backstage overlay, and pointer smoke checks. Its schema contract passed and the harness stopped and
removed its task-owned container. Evidence is under
`artifacts/freep-wave72-family-x11/freep/sessions/20260730T223922660Z/family-validation/`.

## Residual and next probe

This is not a claim of 100% Linux parity. The remaining high-value validation is a richer physical
fixture containing a rich-text shape, an embedded object with a safe registered test host, a review
comment thread, and an animation-pane row, with exact semantic transitions after real pointer and
key-tip input. A later probe should avoid launching real Office processes and report OLE activation
as unavailable when no registered Linux host exists.

PowerPoint-authoritative visual baselines, coauthor/notification behavior, and full physical parity across every ribbon/dialog remain evidence-limited and are not closed by this audit.
