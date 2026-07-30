# Avalonia Table Page-Surface Capture

The table visual-evidence scenarios load their serialized DOCX fixtures, but
were omitted from `PageLayoutShot`'s Word-comparable page-surface capture list.
Avalonia therefore emitted its diagnostic viewport (`960x1600` or `960x900`)
while Word and WPF emitted the physical page surface (`816x1056` or `816x528`).
Those comparisons were resized and could not diagnose table fidelity.

`table-layout-complex`, `table-pagination-repeat-header`, and
`table-page-composition-stress` now use the existing physical-page crop path.
The change is capture-only: it does not modify the table model, pagination plan,
or renderer pixels inside a page surface.

## Fresh Evidence

`table-current-word-proof-20260730` exported all three package fixtures through
Word COM successfully (3/3) and rendered all six Avalonia table pages. The
corrected captures have the same dimensions as their exact Word PNGs:

| Scenario | Avalonia / Word surface |
| --- | --- |
| `table-layout-complex` p1 | `816x1056` |
| `table-pagination-repeat-header` p1-p2 | `816x528` |
| `table-page-composition-stress` p1-p3 | `816x528` |

The shared WPF/Avalonia semantic plans already agree for both paginated tables:
page counts, repeated-header pages, keep-row behavior, table signatures, and
pagination signatures are identical. Remaining image deltas are now valid
renderer-fidelity work, not an invalid viewport rescale.

Focused `VisualEvidencePageLayoutShotSourceTests` passed 10/10. A package-backed
WordArt control remained byte-identical after the table-only capture change.
