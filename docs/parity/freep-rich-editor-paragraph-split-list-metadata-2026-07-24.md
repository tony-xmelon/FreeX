# FreeP Rich Editor Paragraph Split/List Metadata - 2026-07-24

## Reproduced discrepancy

The Avalonia `InCanvasRichTextEditBuffer` preserves the current paragraph template when a text replacement inserts a newline. The WPF `TextBodyFlowDocumentConverter.FromFlowDocument` previously restored list metadata only while the edited paragraph index was still within the original paragraph count. Enter in a single list paragraph therefore left newly created WPF paragraphs with `BulletKind.None` and default numbering.

## Shared contract

`InCanvasRichTextParagraphEditPlanner` defines the bounded paragraph-edit rule used by both hosts:

- splitting one source paragraph clones its paragraph/list metadata to every resulting paragraph;
- joining paragraphs keeps the leading paragraph's metadata;
- existing multi-paragraph edits retain index-based metadata mapping.

The planner copies numbering type/start, bullet kind/character/image, level, indentation, bullet styling, spacing, and tab-stop metadata while leaving edited runs intact.

## Verification

- `FreeP.App.Presentation.Tests`: `InCanvasRichTextEditBufferTests` - 11 passed.
- `FreeP.App.Host.Tests`: `RichTextEditorTests` - 31 passed, including a WPF FlowDocument Enter-split reproduction.
- `FreeP.App.Rendering.Avalonia.Tests`: `AvaloniaRichTextEditorTests` - 7 passed, including the host-buffer Enter-split path.

This slice intentionally does not change deeper list editing such as splitting inside an existing multi-paragraph list, list continuation numbering policy, or native WPF/Avalonia list-marker rendering.
