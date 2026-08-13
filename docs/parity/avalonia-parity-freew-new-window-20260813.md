# FreeW New Window parity — 2026-08-13

## Gap closed

The WPF and Avalonia renderers previously implemented `freew.new-window` independently:

- WPF reopened the saved file from disk, so unsaved edits were absent and an unsaved document opened
  as a blank window.
- Avalonia cloned the live document, but the clone lost its current path/dirty state and its manually
  assigned `: 2` title disappeared on the next file-workflow update.

## Shared contract

`FreeWDocumentWindowPlanner` now owns the renderer-neutral behavior:

- clone the live `TextDocument` through the canonical DOCX reader/writer;
- carry the current save target and dirty state;
- allocate monotonically increasing window numbers and title suffixes.

`FileCommandWorkflow.ApplyDocumentState` owns the shared path/dirty matrix without duplicating recent
file entries. The Avalonia title workflow now accepts the same shared window/group suffix inputs already
supported by the WPF title binder.

The native hosts are limited to their renderer responsibilities: WPF commits its `RichTextBox` model,
each host constructs a native window, loads the shared snapshot, and shows it.

## Verification

- `dotnet test freew/FreeW.App.Presentation.Tests/FreeW.App.Presentation.Tests.csproj --configuration Release`
  — 1,453 passed, 0 failed.
- `dotnet build freew/FreeW.App.Host/FreeW.App.Host.csproj --configuration Release`
  — succeeded with 0 warnings and 0 errors.
- `dotnet build freew/FreeW.App.Avalonia/FreeW.App.Avalonia.csproj --configuration Release`
  — succeeded with 0 warnings and 0 errors.

No UI, startup, capture, headless-Avalonia, or screenshot tests were run.
