# Page Border Offset And Space Parity

FreeW now retains the serialized placement metadata for `w:sectPr/w:pgBorders` rather than reducing an imported frame to its color, width, and line style.

- `w:offsetFrom="page"|"text"` maps to `PageBorderOffsetFrom`.
- Per-edge `w:space` is retained as the uniform `PageBorder.SpacePt` value used by the current model and written back on all four edges.
- New FreeW frames remain Word-compatible `offsetFrom="page"` with `space="24"`.

## Word Probe

The controlled `wordart-watermark-stress.docx` variant used `offsetFrom="text"`, `space="0"`, a `#1F4E79` 2.25-point border, and no explicit header distance. Fresh Word COM export at 816x1056 showed the frame at `(93,45)-(722,962)`. The upper edge follows Word's omitted-header default of 36 points; the side and lower edges follow the text margins.

The rebuilt WPF composite matched that raw frame bounding box exactly. Against the matching Word PNG, full-page mean-channel delta was 4.8643% before the placement path and 4.5371% afterward; the frame ROI was 0.5716%. The normal page-relative 24-point path retains its existing geometry by construction (`SpacePt` defaults to 24 and `OffsetFrom` defaults to `Page`).

Focused verification:

- `DocxRoundTripTests` page-border filter: 14/14.
- WPF fidelity/source tests: 26/26.
- Avalonia DesignTab tests: 28/28.
- `FreeW.FidelityRender` and `FreeW.App.Avalonia` Release builds: 0 warnings, 0 errors.
