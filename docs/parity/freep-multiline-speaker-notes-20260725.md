# FreeP multiline speaker notes

The shared notes pane accepts multiline text in both desktop hosts. Previously,
`EditingSession.SetCurrentSlideNotesText` stored the entire value as one run, so
line breaks were not represented as PowerPoint paragraph boundaries when the file
was saved.

The mutation now normalizes CRLF/CR/LF input and creates one notes paragraph per
line, retaining intentional empty paragraphs. The operation remains a single
undoable `SetSlideNotesCommand`, and the existing PPTX writer/reader preserves the
resulting notes structure on reopen.

Verification: FreeP Release solution build succeeded with 0 warnings/errors;
the complete `NotesSlideTests` group passed 18/18.
