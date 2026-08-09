# FreeW native document-statistic fields (2026-08-09)

## Scope

- Refresh imported `NUMWORDS` and `NUMCHARS` fields on F9 in WPF and Avalonia.
- Cover both Word field encodings: complex `w:fldChar` sequences and `w:fldSimple`.
- Reuse the shared `WordCount.Of(TextDocument)` story counter; `NUMCHARS` uses characters without spaces.
- Keep field-picker insertion out of this slice because Word includes the inserted field result in its own document statistic. Exact initial insertion therefore needs caret-aware provisional-story counting rather than a guessed value.

## Word evidence

Microsoft documents `NUMWORDS` as the total number of words and `NUMCHARS` as the document character count from Advanced Properties statistics.

- https://support.microsoft.com/en-us/word/field-codes-numwords-field
- https://support.microsoft.com/en-us/word/field-codes-numchars-field

An owned in-memory Word COM probe on `Hello world.` established the remaining runtime contract:

- `NUMCHARS` result `13`, characters without spaces `13`, characters with spaces `14`.
- `NUMWORDS` result `3`, Word statistic `3`.
- Replacing a `NUMCHARS` result with `stale` yielded pre-update statistic `16`; the first update returned `16`, then the second returned the stabilized `13`.

FreeW therefore intentionally computes against the current cached story once per F9 traversal, matching Word's update behavior rather than solving to a fixed point.

## Acceptance

- Shared field engine recognizes both keywords and delegates to the existing shared counter.
- DOCX save/reopen retains both field forms and recomputes from the reopened story.
- WPF and Avalonia update fields in story order with the same results.
- Full FreeW Release solution build.
