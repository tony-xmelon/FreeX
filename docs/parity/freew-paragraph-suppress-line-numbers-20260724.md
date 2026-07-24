# Paragraph line-number suppression

Word stores paragraph-level line-number suppression in `w:pPr/w:suppressLineNumbers`. The element hides the number beside the paragraph but does not remove that paragraph's visual lines from the document-wide numbering sequence.

FreeW now preserves the distinction between an absent token and an explicit `w:val="0"` token. This lets direct paragraph formatting override a suppressing paragraph style during a DOCX round trip.

Both Paragraph dialogs expose **Suppress line numbers**. Applying the dialog creates an explicit paragraph override. The WPF print-layout editor skips the margin glyph for marked paragraph lines while continuing the sequence for following lines. Avalonia preserves and edits the package setting through the same dialog contract; its existing global line-number visual remains a separate renderer capability.

Verification: DOCX round-trip coverage asserts omitted, enabled, and explicit-off tokens. Presentation, WPF, and Avalonia dialog lanes verify the shared control path.
