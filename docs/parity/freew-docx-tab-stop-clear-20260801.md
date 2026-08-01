# FreeW DOCX tab-stop clear parity (2026-08-01)

## Gap

Word uses `w:tab w:val="clear"` to remove a tab stop inherited from a paragraph style. FreeW discarded the token while reading, so reopening or saving the document restored the inherited stop and changed tabbed layout.

## Slice

- Preserve clear operations in `TabStop` with their authored position.
- Read and write `w:val="clear"` without a leader attribute.
- Preserve style-level tab stops in `styles.xml`.
- Resolve stops in source order for rendering: a clear removes the stop at the same position, while a later concrete stop can replace it.
- Apply the same inheritance rule in the Avalonia paragraph-style cascade.

## Verification

- Focused package contracts: 3/3 passed. These assert source XML, saved XML, reopened direct formatting, and style-stop/direct-clear separation.
- `DocxRoundTripTests|StyleRoundTripTests`: 234/234 passed.
- `ParagraphTabStopLayoutPlannerTests`: 7/7 passed.
- `FreeW.App.Avalonia` Release build: 0 warnings, 0 errors.

This is package and layout-semantic parity. It does not calibrate tab glyph rasterization or modify unrelated default-tab behavior.
