# FreeW index subentry and cross-reference parity

## Scope

FreeW's durable XE index marks previously retained only one flat term and generated a page list for every
mark. Word also stores colon-delimited subentries and a `\t` cross-reference whose text replaces the page
number. The References > Mark Entry command exposed neither semantic.

This slice adds:

- structured `IndexMark` main-entry, subentry, and cross-reference payloads;
- exact XE serialization such as `XE "Animals:Cats"` and
  `XE "Transportation" \t "See Vehicles"`;
- recursive generated index rows with Word-measured 12-point hanging levels;
- cross-reference rows without a spurious current-page number;
- owner-modal Mark Index Entry dialogs in WPF and Avalonia, seeded from selected text; and
- undoable structured insertion plus case-insensitive same-paragraph duplicate suppression in both hosts.

The simple `DocumentIndex.MarkRun(string)` and selection-only Avalonia fallback remain compatible.

## Word control

A fresh Word 16 COM control was generated at the short path `C:\fwpt` after confirming no pre-existing
WINWORD owner. Word created DOCX and PDF outputs in about six seconds. The clean control contained:

- `XE "Animals:Cats"`
- `XE "Animals:Dogs"`
- `XE "Transportation" \t "See Vehicles"`

Word's updated index text was:

```text
Animals
  Cats, 1
  Dogs, 1
Transportation. See Vehicles
```

Word reported 12-point level registration: Index 1 used left 12 / first-line -12 points and Index 2 used
left 24 / first-line -12 points.

The Word-authored DOCX was then opened by the newly built `DocxReader`, not by a FreeW round-trip. FreeW
reported the three semantic marks as:

```text
Animals|Cats|
Animals|Dogs|
Transportation||See Vehicles
```

and generated:

```text
Index|Animals|Cats, 1|Dogs, 1|Transportation. See Vehicles
```

The short-path control, temporary probe project, owned Word process, and build servers were removed after
the evidence gate.

## Verification

- `DocumentIndexTests`: 15/15.
- `ComplexFieldRoundTripTests`: 16/16.
- `MarkIndexEntryDialogPlannerTests`: 4/4.
- WPF Mark Index dialog and undo contracts: 6/6.
- WPF focused References/Index ribbon contract: 1/1.
- Avalonia References plus adjacent editing contracts: 74/74.
- Focused WPF and Avalonia Release consuming-artifact builds: clean through their test projects.

The first broad combined no-build command exceeded its four-minute output bound. It left no worktree-owned
dotnet/testhost process. The same gates were rerun separately and produced the attributable passing results
above.

## Remaining index scope

This does not yet implement XE bookmark page ranges (`\r`), alternate index identifiers (`\f`), Mark All,
or the configurable Insert Index layout dialog. Bold and italic page-number switches are covered by the
follow-up `freew-index-page-number-formatting-20260805.md` slice.
