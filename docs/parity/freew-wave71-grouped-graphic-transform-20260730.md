# FreeW Wave 71: Grouped Graphic Transforms

FreeW's grouped-child command accepted local rotation and flip edits for pictures, shapes, WordArt, and nested groups, but silently rejected charts and SmartArt. The residual was functional: undo/redo had no model mutation and DOCX `a:xfrm` omitted the child transform. This slice adds the chart/SmartArt model fields, shared command handling, Avalonia transform lookup, and DOCX read/write persistence.

Validation is managed-only in this slice. The previous Linux probe was removed because it had no
deterministic authored fixture or semantic UI readback and always returned a blocked result; no physical
Linux evidence is claimed.
