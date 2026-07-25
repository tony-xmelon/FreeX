# FreeW Avalonia Floating Text-Box Editing

The Avalonia editor now has a bounded PowerPoint-style text-edit route for a selected floating
`TextBox` shape:

- `Enter` changes a selected text box from object selection to a collapsed caret at the end of its
  first text run.
- Text input, left/right/home/end, backspace, and delete operate on that run instead of falling
  through to the document body.
- `Escape` exits text editing while retaining object selection.
- Each mutation uses the shared `SetShapeTextRunCommand`, so undo and redo retain normal command-bus
  semantics.

This slice intentionally covers one paragraph and one run. Rich text spans, multi-paragraph text-box
navigation, selection painting, and a native rich-text widget remain follow-up work.

Verification:

- `dotnet build freew/FreeW.App.Avalonia/FreeW.App.Avalonia.csproj --configuration Release --no-restore`
- `dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release --no-build --filter FullyQualifiedName~DocumentViewFloatingShapeTests`
- Result: build clean; focused floating-shape lane 18/18.
