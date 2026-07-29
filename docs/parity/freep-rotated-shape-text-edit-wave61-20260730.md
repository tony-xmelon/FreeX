# FreeP Wave 61: Rotated Shape Text Editing

## Residual proof

This was an actual FreeP residual, not only a FreeW report residual.

- `freep/FreeP.App.Rendering.Wpf/SlideCanvas.cs` and `freep/FreeP.App.Rendering.Avalonia/SlideCanvas.cs` already rendered shape text inside `ShapeTransformPlanner.PlanShapeRenderTransform`, including rotation.
- `freep/FreeP.App.Presentation/InCanvasTextEditPlanner.cs` previously planned only an axis-aligned screen rectangle for the editor.
- `freep/FreeP.App.Rendering.Wpf/InCanvasTextEditor.cs` and `freep/FreeP.App.Rendering.Avalonia/AvaloniaInCanvasTextEditor.cs` previously set `Canvas.Left`/`Canvas.Top` without applying shape rotation or flips to the editor overlay.
- Shared shape entry hit testing was already rotation-aware, and Avalonia's rich editor already supplied logical hit testing, selection, and caret state. The missing link was transformed editor placement and its lifecycle.
- The existing FreeP physical probe (`Run-FreePRichTextShortcutValidation.ps1`) used the unrotated `21-comments-notes.pptx` fixture and asserted only soft-break text persistence, so it supplied no physical rotated-shape proof.

## Implementation

`InCanvasEditorPlacement` now carries rotation, horizontal/vertical flips, and the unexpanded shape center used as the transform origin. Both renderers consume the same placement contract:

- WPF applies `ScaleTransform` and `RotateTransform` to the rich editor overlay.
- Avalonia applies the equivalent `MatrixTransform` and relative transform origin.
- Both paths retain selection, typing, commit, undo, and model persistence behavior.
- Both paths guard cancellation against `LostFocus` re-entering commit while the native editor is removed.

## Physical contract

`tools/Run-FreePRotatedShapeTextEditValidation.ps1` generates a deterministic copy of `02-autoshapes.pptx` with shape ID 2 set to:

- name `Wave61 Rotated Text`
- bounds `x=2857500 y=1428750 cx=2286000 cy=1524000` EMU
- rotation `30` degrees
- text `Rotate me`

The X11 probe enters at slide DIP `(290,236)`, a point inside the rotated polygon after inverse rotation but outside the unrotated left edge and outside the overlapping orange sibling. It uses real pointer double-click, selection replacement, keyboard typing, outside-pointer commit, save, a second edit, and Escape cancellation. Every checkpoint inspects the saved package for exact text, bounds, and rotation and records editor focus/window state.

## Verification

Commands and results:

```text
dotnet test freep\FreeP.App.Presentation.Tests\FreeP.App.Presentation.Tests.csproj --configuration Release --filter "FullyQualifiedName~SlideCanvasGeometryPlannerTests|FullyQualifiedName~InCanvasTextEditPlannerTests" --logger "console;verbosity=minimal"
Passed 19/19

dotnet test freep\FreeP.App.Host.Tests\FreeP.App.Host.Tests.csproj --configuration Release --filter "FullyQualifiedName~RichTextEditorTests" --logger "console;verbosity=minimal"
Passed 50/50

dotnet test freep\FreeP.App.Rendering.Avalonia.Tests\FreeP.App.Rendering.Avalonia.Tests.csproj --configuration Release --filter "FullyQualifiedName~InCanvasTextEditor|FullyQualifiedName~AvaloniaRichTextEditorTests" --logger "console;verbosity=minimal"
Passed 26/26

powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\Run-FreePRotatedShapeTextEditValidation.ps1 -Replace -OutputDir artifacts\freep-rotated-shape-text-edit-wave61-final
Manifest contract validation: passed
Results: 5 passed, 0 failed, 5 total
```

Physical evidence:

`artifacts/freep-rotated-shape-text-edit-wave61-final/freep/sessions/20260729T223436679Z/freep-rotated-shape-text-edit-validation/results.json`

The manifest records exact saved text `Typed rotated text`, unchanged bounds, unchanged rotation `30`, and successful Escape preservation in `after-cancel.json`.

## Residuals

Rotated ordinary shape text editing is now managed- and physically-proven for FreeP. Table-cell text overlays and grouped-child editing are separate workflows and remain outside this bounded shape-text slice; no claim is made for their rotated physical parity here.
