# Duplicate Drawing Identity SmartArt Suppression

## Scope

`chart-smartart-complex.docx` has two inline charts followed by two SmartArt
drawings. Its `wp:docPr/@id` values are `1`, `2`, `1`, and `2`: the diagrams
reuse the identities already claimed by the charts. The Word PNG reference at
816x1056 leaves both diagrams visually blank while retaining their inline
extent and page breaks.

FreeW previously rehydrated the diagram data models as normal editable
SmartArt and painted their hierarchy and pyramid surfaces. That did not match
Word's visible source behavior and shifted the page composition.

## Change

The DOCX reader marks every duplicate document-story drawing identity. An
imported SmartArt with a duplicate identity retains its parsed dimensions for
inline layout, carries its original diagram payload as a preserved drawing for
round-trip, and is omitted by both WPF and Avalonia renderers. Normal SmartArt
continues through the editable model and visual planner unchanged.

## Evidence

Fresh Release WPF composite renders used the existing same-fixture Word PNG
reference and emitted the same two-page sequence.

| Page | Before | After | Change |
| --- | ---: | ---: | ---: |
| 1 | 5.8281% | 4.4378% | -1.3903 pp |
| 2 | 6.4484% | 1.0720% | -5.3764 pp |

The page-1 hierarchy label remains at the same source location but its
incorrect SmartArt surface is gone. Page 2 retains the Word page break and no
longer paints the incorrect pyramid. The remaining page-1 difference belongs
to the two chart renderers, not the suppressed diagrams.

## Package Guard

`SmartArtRoundTripTests` verifies that a duplicate diagram identity preserves
the source data part and duplicate `wp:docPr` values across save/reopen while
keeping a nonzero inline extent and the Word-suppression marker.
