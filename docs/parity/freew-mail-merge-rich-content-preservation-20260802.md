# FreeW Mail Merge Rich-Content Preservation

## Scope

FreeW's legacy mail-merge clone path rebuilt paragraphs, runs, and tables from a small property subset. It preserved ordinary text and images, but could discard equations, shapes, WordArt, SmartArt, charts, embedded objects, ruby text, preserved drawings, drawing groups, and newer table/cell metadata. Runs could also retain footnote, endnote, or comment ids while the merged document omitted the referenced annotation stories.

## Result

- Plain and rule-aware record merges now start from `DocumentMerge.CloneBlock`, the authoritative deep-clone path.
- Merge substitution reaches shape text, WordArt, SmartArt node trees, ruby fragments, drawing-group children, and every section header/footer story.
- Document properties, theme, protection/view/proofing/revision/save settings, multilevel numbering, note numbering, bibliography state, index/authority marks, embedded fonts, and preserved package parts carry into each record.
- Footnotes, endnotes, comments, and comment replies are independently cloned and receive the same record substitution.
- Combining Letters or Directory output now uses annotation-aware document merge, remapping recipient annotation ids and transferring referenced package graphs instead of appending raw blocks.
- The Avalonia source contract now asserts the effective Check for Errors call introduced by the earlier execute/pause policy slice.

## Package Evidence

The focused DOCX contracts write and reopen merged documents containing:

- equation, text-box shape, WordArt, SmartArt, and drawing-group payloads;
- a substituted footnote referenced from the body;
- a preserved chart part, chart relationship part, and dependent media part; and
- two combined letter recipients whose originally identical footnote ids reopen as distinct ids with recipient-specific text.

## Verification

- `FreeW.Core.Model.Tests`, `FullyQualifiedName~MailMerge`: 104/104.
- `MailMergeRichContentRoundTripTests`: 3/3.
- `FreeW.App.Presentation.Tests`: 1180/1180.
- Avalonia `Mailings|MailMerge`: 39/39.
- WPF host `Mailings|MailMerge|W21LabelCellAndSectionHfTests`: 13/13.

This is a functional/package-fidelity slice. It does not alter renderer geometry or claim a visual-diff improvement.
