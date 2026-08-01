# FreeP Avalonia Startup Dirty-State Investigation

Date: 2026-08-01
Scope: FreeP Avalonia startup document lifecycle, Wave 90 sidecar

## Result

The reported physical symptom remains open. It was not reproduced by the focused
window-attachment regression test, so no `MarkSaved`-on-`Opened` workaround was added.

## Regression Coverage

`freep/FreeP.App.Avalonia.Tests/StartupDocumentAttachmentTests.cs` creates a real
`.pptx` startup document containing speaker notes, constructs `MainWindow` with that
path, calls `Show()`, drains Avalonia render/background dispatcher work, and verifies:

- the startup document remains clean after visual-tree attachment and dispatcher settling;
- a subsequent `Editor.InsertSlide()` is dirty.

Focused result: `1 passed, 0 failed`.

## Event-Path Comparison

The normal Avalonia path is:

1. `Program.Main` filters lifecycle switches and forwards the document argument;
2. `App.OnFrameworkInitializationCompleted` creates `MainWindow` through
   `SisterAvaloniaAppBootstrap`;
3. `MainWindow` loads the startup package with
   `LoadPresentationAsSaved(...)`, then marks the file saved with its path;
4. the desktop lifetime attaches and shows the window;
5. genuine editor changes flow through `EditingSession.Changed`,
   `MainWindow.OnEditorChanged`, and `SisterAvaloniaFileCommandWorkflow.MarkDirty()`.

The Docker launcher supplies the document as `APP_DOCUMENT=/documents/<name>`; the
entrypoint appends that value to `APP_ARGUMENTS_B64` arguments before starting the
published executable. The native-picker probe performs no model mutation before its
initial owner capture, so its observed dirty marker cannot be attributed to the probe.

WPF uses the same saved-load ordering concept: its `FileCommands`/`LoadModel` path
marks the loaded document saved, while its notes refresh is guarded during programmatic
TextBox population. Avalonia has the analogous `_notesRefreshing` guard.

No deterministic post-Show `Editor.Changed` event was observed in the focused test,
including a non-empty startup notes body. The remaining physical-only discrepancy needs
an artifact with the exact launch arguments, environment, app log, and dirty-generation
transition to identify whether an opt-in validation seed, a stale published binary, or an
X11-specific interaction is involved. This work intentionally leaves that residual open.
