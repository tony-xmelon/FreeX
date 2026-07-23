# Backstage Widow/Column Probe Rejected

## Finding

On `backstage-print-preview-fidelity` page 1, Word splits paragraph 8 across
the two columns with two lines in each column. FreeW instead moves the complete
four-line paragraph into the second column. The source paragraph has neither
`w:keepLines` nor `w:widowControl` in its serialized `w:pPr`.

The initial hypothesis was that the live WPF mapping of omitted/default widow
control to `Paragraph.KeepTogether` was responsible. Mapping only
`w:keepLines` to `KeepTogether` passed the focused paragraph-format contract,
but fresh matched renders of all three pages for both Backstage fixtures were
byte-identical to the current main baseline:

| Fixture | Pages | Whole-page baseline -> candidate |
| --- | --- | --- |
| Print Preview | 1-3 | 9.0412 / 8.0181 / 8.0209% -> unchanged |
| PDF Export | 1-3 | 9.0334 / 8.0038 / 8.0066% -> unchanged |

## Effective Owner

`FreeW.FidelityRender` has a second diagnostic paginator. It observes the
paragraph crossing a same-page column boundary and sets `KeepTogether` on the
production paragraph. This is the effective owner of the current raster.

Two bounded attempts to count source/continuation lines from that detached WPF
paginator were inconclusive: `TextPointer.GetCharacterRect` and
`GetLineStartPosition` returned no usable line fragments. They must not be
used as a zero-line signal to change pagination.

## Conclusion

The implementation was reverted. Correct parity needs a fragment-aware
pagination API or an explicit column-fragment compositor that can distinguish
a one-line widow/orphan from a valid two-line/two-line continuation. Do not
replace the heuristic with a text-length threshold or broad `KeepTogether`
change; both would be guesswork across ordinary document pagination.

The restored Print Preview page-1 SHA-256 is
`57633809F91E6470EA015AE2D23CB9BE0B91BB420FFB68D42E83DE5482ADA9F2`, equal to
the current-main render.
