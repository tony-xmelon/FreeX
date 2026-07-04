# FreeP Shape Rich Inline Editor Evidence - 2026-07-04

This slice advances the FreeP rich inline text editing workflow-depth lane by giving shape in-canvas edits the same renderer-neutral rich-run and initial-selection evidence already used by table-cell editing.

Parity improved:

- `InCanvasTextEditStartPlan` now carries initial selection, rich-run offsets, suggested editor style, selection style, and mixed-formatting flags for shape text bodies.
- Avalonia shape text overlays consume that shared plan, tag the live editor with the rich-run metadata, project the first-run style onto the TextBox, select the full initial text range, and refresh the shared rich plan after active shape formatting commands.
- WPF remains on the same shared shape edit start plan while continuing to use its RichTextBox conversion path for editable rich text.

Verification evidence:

- `freep/FreeP.App.Presentation.Tests/InCanvasTextEditPlannerTests.cs` covers mixed-run shape edit start plans.
- `freep/FreeP.App.Rendering.Avalonia.Tests/SlideCanvasAvaloniaTests.cs` covers Avalonia shape-overlay projection and refreshed selected-run style evidence.

Remaining gaps:

- Avalonia still lacks a true editable rich-text control equivalent to WPF RichTextBox; mixed runs are modeled and adapter-visible, but the live TextBox can only display one projected style at a time.
- PowerPoint-authoritative visual baselines for rich inline shape editing still require a COM-capable machine.
