# FreeW native INDEX field ownership (2026-08-05)

## Scope

FreeW-generated indexes now retain Word's native complex-field ownership across every cached-result
paragraph. The first paragraph writes `w:fldChar begin`, the exact INDEX instruction, and
`w:fldChar separate`; the final paragraph writes the matching `w:fldChar end`.

The reader recovers the field owner across body paragraphs and block content-control/custom-XML
wrappers. Result text remains ordinary styled paragraph content. Single-paragraph fields and other
Word stories retain their existing reader paths.

## Word COM gate

The final source was built into a short-path probe at `C:\fwix3\i.docx`, then opened, updated, saved,
and reopened using Word 16 COM.

- FreeW-authored SHA-256: `D958A5854573D7DD710BCEBAFAD04BFB0F7CBB75B46A310A7153408D90C00683`
- Word-saved SHA-256: `26FD812D51BA04CE4D849D64F2359847CA25D9C81A0CF42C38786A2C12E6AEE6`
- Word `Indexes.Count`: `1`
- Cached result before update: `A | Alpha, 1 | B | Beta, 1`
- Cached result after update: `A | Alpha, 1 | B | Beta, 1`

Word rewrote entry styles to built-in `Index1` and placed the closing field marker in a trailing
result paragraph. FreeW reopened that package as five INDEX-owned paragraphs with exactly one start,
one end, and five default-identifier matches. Refresh therefore uses semantic field ownership rather
than mutable result style ids.

## Focused gates

- `DocumentIndexTests`: 25/25
- `DocumentMergeTests`, `DocumentCompareTests`, `DocumentCombineTests`, and `DocumentIndexTests`:
  101/101 combined
- `ComplexFieldRoundTripTests`: 20/20
- WPF `IndexEntryUndoParityTests`: 7/7
- Avalonia `ReferencesTabTests`: 81/81

## Process rule

For Word-generated multi-paragraph results, preserve the serialized field owner separately from the
cached paragraph styles. A successful COM update is not sufficient until the Word-saved package
reopens with one coherent owner, one start/end pair, and identifier-aware host refresh behavior.
