# FreeW index page-number formatting parity

## Scope

Word's Mark Index Entry dialog can mark generated page numbers bold, italic, or both. The source semantics
live on the hidden XE field as `\b` and `\i`; the generated index applies the formatting only to each page
label, not to the entry label or comma.

FreeW now:

- preserves `IndexMark.BoldPageNumber` and `IndexMark.ItalicPageNumber`;
- reads and writes exact XE `\b` and `\i` switches;
- merges formatting when multiple marks for the same term resolve to the same page;
- emits page labels as separate formatted runs while keeping entry text and punctuation plain;
- exposes Bold and Italic checkboxes in both WPF and Avalonia Mark Index Entry dialogs; and
- disables page-number formatting controls for the Cross-reference option, which has no page label.

Same-paragraph duplicate suppression includes both formatting flags, so a second mark can strengthen the
same page from plain to bold/italic without duplicating the displayed page label.

## Word control

A fresh Word 16 COM control at `C:\fwpt` used these fields:

```text
XE "Alpha" \b
XE "Beta" \i
XE "Gamma" \b \i
```

Word generated plain labels and punctuation plus page-number runs with these properties:

```text
Alpha, 1   page: bold
Beta, 1    page: italic
Gamma, 1   page: bold + italic
```

The Word-authored DOCX was reopened by the newly built FreeW reader. Parsed marks were:

```text
Alpha[b=True,i=False]
Beta[b=False,i=True]
Gamma[b=True,i=True]
```

FreeW's generated page runs had the same three format combinations. The short-path DOCX/PDF, temporary
probe project, and owned Word instance were removed immediately after the gate.

## Verification

- `DocumentIndexTests`: 17/17.
- `ComplexFieldRoundTripTests`: 17/17.
- `MarkIndexEntryDialogPlannerTests`: 5/5.
- WPF Mark Index dialog and undo contracts: 7/7.
- Avalonia References plus adjacent editing contracts: 75/75.
- WPF and Avalonia Release host builds: 0 warnings / 0 errors.

The Word-authored package check is independent of FreeW's writer, while the package round-trip tests assert
FreeW's canonical `XE "Alpha" \b \i` serialization and reopened run formatting.

## Remaining index scope

Bookmark page ranges (`\r`), alternate indexes (`\f`), Mark All, and configurable Insert Index layout remain
separate semantic slices.
