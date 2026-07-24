# FreeP Rich Editor Paragraph Split/List Metadata - 2026-07-24

## Reproduced discrepancy

The Avalonia `InCanvasRichTextEditBuffer` preserves the current paragraph template when a text replacement inserts a newline. The WPF `TextBodyFlowDocumentConverter.FromFlowDocument` previously restored list metadata only while the edited paragraph index was still within the original paragraph count. Enter in a single list paragraph therefore left newly created WPF paragraphs with `BulletKind.None` and default numbering.

## Shared contract

`InCanvasRichTextParagraphEditPlanner` defines the bounded paragraph-edit rule used by both hosts:

- splitting one source paragraph clones its paragraph/list metadata to every resulting paragraph;
- joining paragraphs keeps the leading paragraph's metadata;
- WPF round-trip recovery uses ordered exact paragraph-text anchors, so duplicate source
  paragraphs remain distinct and unmatched fragments inherit only the source paragraph in
  their aligned gap;
- Avalonia keeps the paragraph templates already carried by its token lineage and does not
  run a metadata post-pass over the rebuilt paragraphs.

The planner copies numbering type/start, bullet kind/character/image, level, indentation, bullet styling, spacing, and tab-stop metadata while leaving edited runs intact.

## Verification

- `FreeP.App.Presentation.Tests`: `InCanvasRichTextEditTests` - 16 passed, including first/middle
  splits, duplicate paragraphs, empty split lines, and rewritten fragments.
- `FreeP.App.Host.Tests`: `RichTextEditorTests` - 36 passed, including the same WPF FlowDocument cases.
- `FreeP.App.Rendering.Avalonia.Tests`: `AvaloniaRichTextEditorTests` - 7 passed, including the host-buffer Enter-split path.

This slice intentionally does not change deeper list editing such as list continuation numbering
policy or native WPF/Avalonia list-marker rendering.
