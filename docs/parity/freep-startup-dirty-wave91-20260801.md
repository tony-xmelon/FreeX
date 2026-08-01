# FreeP Avalonia Startup Dirty-State Correction

Date: 2026-08-01
Scope: FreeP Avalonia startup document lifecycle, Wave 91

## Result

Resolved. The production path loaded the startup presentation cleanly, but Avalonia
raised a late `TextChanged` for the notes TextBox after `window-opened`. The handler
unconditionally executed `SetSlideNotesCommand` even when the control value matched
the loaded model. That command raised `EditingSession.Changed`, advanced dirty
generation from 0 to 1, and added the title marker.

The handler now compares the control text with the current model text before creating
an undoable command. A real post-startup notes edit still creates the command and stays
dirty. No post-`Show` `MarkSaved` call was added.

## Deterministic Trace

The `--startup-dirty-trace <report>` startup contract runs through the real
`Program.Main -> App.OnFrameworkInitializationCompleted -> classic desktop lifetime`
path, waits for four dispatcher ticks after `Opened`, and records lifecycle stages with
`IsDirty` and `DirtyGeneration`.

Before the correction, the production executable produced:

- `window-opened`: clean, generation 0;
- `notes-text-changed`: clean before the handler mutation;
- `editor-changed`: dirty, generation 1;
- title: `01-title-slide.pptx * - FreeP`.

After the correction, the same executable produced a clean title, `IsDirty=false`,
and `DirtyGeneration=0`. The late notes event remains observable in the trace but no
longer creates an edit.

## Regression Coverage

`StartupDocumentAttachmentTests` now verifies the attached-window path keeps a loaded
notes value clean, keeps generation at 0 when that value is replayed, and marks a real
post-startup notes edit dirty at generation 1.

`StartupDirtyTraceTests` verifies the trace argument parser and launches the built FreeP
executable with a real `.pptx` startup argument, asserting the production lifetime path
ends clean with no title marker.

Docker validation remains orchestrator-owned and was not run here.
