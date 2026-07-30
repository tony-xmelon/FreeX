# FreeW Wave 71: Grouped Graphic Transforms

FreeW's grouped-child command accepted local rotation and flip edits for pictures, shapes, WordArt, and nested groups, but silently rejected charts and SmartArt. The residual was functional: undo/redo had no model mutation and DOCX `a:xfrm` omitted the child transform. This slice adds the chart/SmartArt model fields, shared command handling, Avalonia transform lookup, and DOCX read/write persistence.

The Linux probe is fail-closed and does not start Docker. It records a blocked result when no visible FreeW window or authored physical fixture is available.
