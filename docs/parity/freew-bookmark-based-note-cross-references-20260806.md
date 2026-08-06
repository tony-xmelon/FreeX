# FreeW bookmark-based note cross-references (2026-08-06)

## Scope

Word does not resolve a `NOTEREF` field from a numeric footnote/endnote id. It targets a bookmark whose
range encloses the physical `w:footnoteReference` or `w:endnoteReference` marker. FreeW previously
authored numeric operands such as `NOTEREF 3`, which Word could update to `Error! Reference source not
found.`

This slice makes newly inserted note cross-references use Word's marker-bookmark ownership while keeping
legacy numeric fields readable inside FreeW.

## Product behavior

- Footnote/endnote targets locate their physical marker, including markers in table-cell paragraphs.
- An existing bookmark is reused only when its range contains exactly one note marker.
- A missing anchor allocates `_RefN` and adds exact run-relative bookmark boundaries around only the
  marker run. The bookmark and field insertion are one undoable command.
- Note number uses `NOTEREF _RefN`; note page uses `PAGEREF _RefN`; note position uses
  `NOTEREF _RefN \p`.
- Word's position result includes the note number (`1 above` / `1 below`), not only the relative word.
- Field refresh compares run order when the note and field share a paragraph.
- Imported numeric `NOTEREF` remains resolvable and now uses the physical marker for position when one
  exists. Orphan note-store entries without a body marker are not offered as insertion targets.

## Exact package contract

`CrossReferenceRoundTripTests` asserts that the serialized body order is:

1. `w:bookmarkStart w:name="_RefNote"`
2. the run containing `w:footnoteReference`
3. the paired `w:bookmarkEnd`

It also asserts exact field instructions, reopened bookmark boundaries, and the reopened modeled field.

## Word COM evidence

The final product package was generated through `CrossReferences.PlanInsertion`,
`InsertCrossReferenceCommand`, and `DocxWriter` at the short path `C:\fwnr\note.docx`.

- FreeW package SHA-256: `6C870CAC43C818A27136C583BA6575F07A7A09A891BB23D6045A47A47879E890`
- Word-saved package SHA-256: `7DD13BB9B8D01BF09053748BE7E13391D030F65D792000ED2BDACD6FDFAE86BB`
- Word readiness gate: `Application.Ready`, one open document, and exactly three body fields.
- Save path: `C:\fwnr\word3.docx`, `SaveAs2` format 16 after all fields updated.

Word reported all three `Field.Update()` calls as successful:

| Field code | FreeW cached result | Word result |
| --- | --- | --- |
| `NOTEREF _Ref1 \h` | `1` | `1` |
| `NOTEREF _Ref1 \p` | `1 above` | `1 above` |
| `PAGEREF _Ref1` | `1` | `1` |

The first live calibration showed that Word's `\p` result is `1 above`; the initial FreeW cache was only
`above`. That probe was not accepted. The final package above includes the corrected exact behavior.

## Verification

- `CrossReferencesTests|CrossReferenceCommandTests`: 50/50
- `CrossReferenceRoundTripTests`: 9/9
- WPF `CrossReferenceEditorTests`: 6/6
- Avalonia `ReferencesTabTests.InsertCrossReference*`: 3/3
- Final acceptance reran all four lanes with `--no-build` against the freshly built Release artifacts.

## Process rule

For Word fields, valid XML is necessary but not sufficient. Use a short-path exact package, wait on Word
readiness rather than a fixed sleep, run the real `Field.Update()`, and compare both the field code and
Word's resulting display text. A broad bookmark that happens to contain a note marker is not valid owner
evidence when it contains more than one marker.
