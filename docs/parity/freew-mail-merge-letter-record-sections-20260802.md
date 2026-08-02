# FreeW mail merge letter record sections

## Gap

Finish & Merge in Letters mode appended each merged record behind a page-break flag. The combined document
therefore kept only the first record's final-section header/footer, so a header such as `Recipient «Name»`
showed the first recipient on every letter.

## Result

`MailMerge.CombineMergedRecords` now ends each completed letter with a real next-page section boundary.
The completed section owns that record's page settings and all six merged header/footer stories; the combined
document's final section is then advanced to the next record's settings and stories. A paragraph ending the
record carries the boundary directly, while table/other terminal content gets a dedicated empty boundary
paragraph. Directory mode remains continuous and unchanged.

The generated DOCX was written and reopened through `DocxWriter`/`DocxReader`; its first and second sections
retained `Recipient Ada` and `Recipient Grace` respectively, proving package ownership rather than only an
in-memory model shape.

## Verification

- focused record-boundary model contracts: 3/3;
- full mail-merge model lane: 101/101;
- focused package write/reopen contract: 1/1;
- full section header/footer package lane: 13/13; and
- Avalonia mailings engine lane, including Finish & Merge section assertions: 29/29.

## Residual

Complete-and-pause still reports aggregate errors rather than pausing at each individual failing record.
Directory output intentionally keeps one continuous section, matching its catalog/list output semantics.
