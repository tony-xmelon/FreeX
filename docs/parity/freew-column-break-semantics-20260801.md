# FreeW column-break semantics (2026-08-01)

## Gap

The Layout > Breaks > Column Break command inserted a paragraph with `PageBreakBefore=true`. That moved content to a new page and saved as a page break instead of Word's `w:br w:type="column"` semantic.

## Slice

- Add a distinct textless column-break run to the shared document model.
- Make the command factory insert that run rather than a page-break approximation.
- Read/write `w:br w:type="column"` in DOCX and `\column` in RTF.
- Preserve page and column break marks through merge, mail merge, compare/combine, revisions, content-control transforms, and comment undo clones.
- Map the run to WPF `Paragraph.BreakColumnBefore` and retain it through edit/commit.
- Advance Avalonia print layout to the next column slot; in a one-column section this advances to the next page. Web and Draft remain continuous single-column views.

## Verification

- DOCX/RTF break contracts: 5/5 passed.
- WPF page/column break render and commit contracts: 5/5 passed.
- Avalonia complete column-layout class: 12/12 passed.
- Focused model contracts: 24/24 passed.
- Complete Core Model suite: 1,546/1,546 passed.

The layout behavior is paragraph-scoped, matching FreeW's existing break-only insertion command. Imported mid-paragraph break splitting remains a separate fidelity refinement.
