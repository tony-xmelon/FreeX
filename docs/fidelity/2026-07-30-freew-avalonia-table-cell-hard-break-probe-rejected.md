# Rejected Avalonia Table Cell Hard-Break Probe

`table-layout-complex.docx` contains `Q1` and `$1.20M` as raw newline whitespace inside a single `w:t` element, not as a `w:br` run. Word's 816x1056 reference renders that source as a single line with whitespace.

Treating every `\n` in `DocumentView.WrapCellLines` as a hard break made the Avalonia model semantically diverge from the serialized Word source. The probe was reverted even though its aggregate page metric moved from 10.6269 to 10.6021 mean channel delta: the visible cell content was no longer Word-equivalent.

Future table-line-break work must preserve the distinction between actual WordprocessingML `w:br` elements and whitespace carried inside `w:t`. The outstanding table residual remains row height, cell margins, cell spacing, and paragraph-after geometry.
