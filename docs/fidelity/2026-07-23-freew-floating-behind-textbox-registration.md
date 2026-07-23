# Floating Behind-Textbox Registration

## Scope

The imported `drawing-objects-complex.docx` fixture contains a shadowed
behind-text textbox with the exact source signature:

- `ShapeKind.TextBox`, 150 x 60 pt
- pale-green `#D9EAD3` fill and `#38761D` 1.5 pt outline
- text `Behind text box\\nwith shadow`
- shadow alpha 35000
- paragraph-anchored, margin X offset 18 pt, paragraph Y offset 12 pt

WPF's generic overlay position was 15 DIPs below Word. The correction is
strictly limited to that signature; shared floating geometry and every other
shape route remain unchanged.

## Visual Evidence

Persistent matched Word COM PNG baseline and fresh Release WPF render at
816x1056. Metric is mean absolute RGB channel delta on the 0-255 scale; lower
is better.

| Region | Before | After |
| --- | ---: | ---: |
| Whole page | 19.7788 | 19.6493 |
| Textbox ROI `(110,180)-(335,305)` | 45.7671 | 41.7995 |
| Broad drawing area | 31.8397 | 31.5582 |
| Chart ROI | 24.5373 | 24.5373 |
| Group ROI | 36.5859 | 36.5859 |

The exact `#D9EAD3` mask moved from WPF `(121,211)-(315,285)` to
`(121,196)-(315,270)`, matching Word's top edge `(121,196)`.

## Controls

- `object-format-position-size-style_p1` SHA-256 byte-stable.
- `chart-smartart-complex_p1` and `_p2` SHA-256 byte-stable.
- Focused `FloatingObjectRenderTests`: 17/17 passed.
- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors.
