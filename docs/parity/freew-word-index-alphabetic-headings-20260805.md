# FreeW Word index alphabetic heading parity

## Word evidence

A fresh short-path Word 16 COM probe created XE marks and inserted an index with `Indexes.Add`. The saved
DOCX and live COM object reported:

- `RightAlignPageNumbers = false`;
- `NumberOfColumns = 0` (automatic/default section columns);
- cached rows `A`, `Alpha, 1`, `B`, `Beta, 1`;
- paragraph styles `IndexHeading`, `Index1`, `IndexHeading`, `Index1`; and
- native instruction `INDEX \h "A" \z "1033"`.

A second probe with `!bang`, `1alpha`, `Éclair`, and `Zulu` produced headings and entries in this exact order:
`!`, `!bang, 1`, `1`, `1alpha, 1`, `E`, `Éclair, 1`, `Z`, `Zulu, 1`.

## FreeW behavior

Document-backed index generation now matches that visible default result:

- the synthetic `Index` title is no longer emitted by default;
- one identifier-specific `IndexHeading` row is emitted per normalized root initial;
- English collation ignores case and diacritics for ordering and grouping;
- symbols and digits retain their literal first-character heading; and
- page references remain Word's measured inline `term, page` form.

`IndexBuildOptions.LegacyTitleOnly` preserves the old title-only form for explicit compatibility callers.
Default and alternate generated regions continue to use distinct style IDs, so selective refresh ownership is
unchanged.

## Verification

- `DocumentIndexTests`: 25/25.
- `ComplexFieldRoundTripTests`: 20/20.
- WPF focused index/ribbon/dialog tests: 10/10.
- Avalonia complete `ReferencesTabTests`: 80/80.
- WPF and Avalonia Release host builds: 0 warnings, 0 errors.

The native `INDEX` field still needs cross-paragraph source ownership; that is the next package slice and is
not inferred from the visible heading result.
