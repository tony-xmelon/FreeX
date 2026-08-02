# FreeW WordprocessingML `gutterAtTop` settings parity

## Audit scope

This slice audited the first-class document-setting paths in:

- `TextDocument` and `PageSettings` in `FreeW.Core.Model`;
- `DocxReader.ReadSettings`;
- `DocxWriter` settings-part creation and `BuildSettings` overlay logic;
- focused Core.Model/Core.IO package contracts.

FreeW already owns meaningful settings semantics for document protection, automatic hyphenation and its
sub-options, default tab stops, odd/even headers, mirrored margins, print-layout page-boundary visibility,
personal-information removal, spelling/grammar indicator visibility, linked-template style refresh, field
updates on open, revision tracking and its move/formatting policies, embedded TrueType fonts, page-background
display, and document-wide footnote/endnote numbering. Unknown settings remain preserved through
`PreservedParts.OriginalSettings` rather than being discarded.

The audit also found settings that are preserved but not yet exposed as model semantics, including printing
forms data, subset/system-font embedding policy, page-border alignment/header/footer treatment, forms-design
mode, style locks, book-fold/two-up printing, XML validation/display options, preview-picture policy, and image
compression policy. The already completed `hideSpellingErrors`, `hideGrammaticalErrors`, `linkStyles`, and
`doNotDisplayPageBoundaries` settings were excluded from selection.

## Selected semantic

`w:gutterAtTop` was selected because it completes an existing page-layout contract rather than adding a
passive flag. FreeW already reads and writes each section's `w:pgMar/@w:gutter` as `PageSettings.GutterPt`.
This document-wide on/off setting tells Word whether that gutter belongs on the top edge instead of the normal
side edge.

The [Open XML `GutterAtTop` contract](https://learn.microsoft.com/en-us/dotnet/api/documentformat.openxml.wordprocessing.gutterattop)
specifies that omission means the gutter is not positioned at the top. Word determines the binding edge
automatically for mirror-margin, book-fold, reverse-book-fold, and two-up printing modes.

## Implemented contract

- `PageSettings.GutterAtTop` defaults to `false`.
- The setting survives `PageSettings.Clone()` and `SetPageSettingsCommand` apply/revert snapshots.
- The reader accepts an empty element plus all six `ST_OnOff` lexical values: `1`, `true`, `on`, `0`, `false`,
  and `off`.
- The writer emits canonical `<w:gutterAtTop/>` only when enabled.
- A nonzero ordinary side gutter does not force `word/settings.xml` while the setting is off.
- A Word-authored explicit-off value is canonicalized to omission, while unrelated preserved settings remain.
- Overlay insertion is between `w:bordersDoNotSurroundFooter` and `w:hideSpellingErrors`, matching
  `CT_Settings` schema order.
- Reopen and second-save tests prove model stability and exact `settings.xml` stability.
- `PageLayout.MarginsDip` applies the gutter to the top edge when requested, to the left edge by default,
  and to the alternating inside edge for mirrored pages. `ContentAreaDip` therefore drives the same effective
  printable geometry through editor layout, pagination, preview, and PDF consumers.
- The document-global setting is propagated to non-final section page settings after `settings.xml` is read.
- Visual-evidence page snapshots preserve the setting instead of silently reverting to a side gutter.
- The shared Page Setup planner exposes Left/Top gutter position, and both WPF and Avalonia dialogs seed,
  edit, and apply it through the existing one-step page-settings command.

## Verification

- `dotnet test freew/FreeW.Core.Model.Tests/FreeW.Core.Model.Tests.csproj --configuration Release --filter FullyQualifiedName~GutterAtTop`: 2/2 passed.
- `dotnet test freew/FreeW.Core.Model.Tests/FreeW.Core.Model.Tests.csproj --configuration Release --filter "FullyQualifiedName~PageLayoutTests|FullyQualifiedName~GutterAtTopModelTests"`: 16/16 passed.
- `dotnet test freew/FreeW.Core.IO.Tests/FreeW.Core.IO.Tests.csproj --configuration Release --filter FullyQualifiedName~GutterAtTop`: 10/10 passed.
- Neighboring settings and preservation regression filter: 110/110 passed.
- Shared Page Setup planner: 6/6 passed; WPF Page Setup: 3/3 passed; Avalonia Page Setup: 29/29 passed.
