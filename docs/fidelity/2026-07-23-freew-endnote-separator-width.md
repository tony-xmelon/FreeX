# Endnote separator width parity

## Scope

The WPF composite renderer built the endnote separator as an unconstrained `Border`, despite `DocumentNoteRegionPlanner` already carrying the Word separator width. The result was a full printable-width rule in `f2-endnotes` page 2 where Word paints a short rule.

## Source evidence

The fixture package contains both endnote references and `word/endnotes.xml`; its body frame aligns with Word. This is a compositor ownership issue, not missing note data. Word's separator is approximately `x=96..287` at `y=506`; the previous WPF rule was `x=96..719` near `y=501`.

## Change

`RenderNoteRegion` now consumes `notePlan.SeparatorWidthDip`, left-aligns the endnote separator, and applies the measured 7-DIP top lead. Footnotes remain on their existing path.

## Matched Word evidence

Fresh Release renders used the unchanged 816x1056 Word baseline.

| Fixture/page | Whole mean channel delta | Changed pixels | Target ROI mean channel delta |
| --- | ---: | ---: | ---: |
| `f2-endnotes` p2 | 6.0092 -> 5.6081 | 4.1906% -> 4.0061% | 27.1627 -> 20.9197 |
| `f2-endnotes` p1 body control | byte-stable | byte-stable | byte-stable |
| `f2-footnotes` p1/p2 controls | byte-stable | byte-stable | byte-stable |

An authored footnote paragraph-spacing probe was rejected: it worsened `f2-footnotes` p1 whole 9.4198 -> 9.8964 and its note ROI 15.9328 -> 22.4225. The renderer must not flatten source spacing into a generic note-row margin without a page-fragment model.

## Verification

`FreeW.FidelityRender` Release build completed with 0 warnings and 0 errors. The focused `VisualEvidenceFidelityRenderSourceTests` lane currently has one pre-existing failure: it expects the unrelated source token `thisPixW - 2 * ins`, which is absent from `origin/main` as well as this change.
