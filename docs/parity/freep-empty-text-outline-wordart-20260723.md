# FreeP empty WordArt line semantics

PowerPoint's `13-wordart.pptx` `Wave Text` run contains an empty `a:ln`.
FreeP previously interpreted that empty line as a default black 0.75pt text
outline. PowerPoint renders the material without that outline. The DrawingML
reader now maps an empty line element with no attributes or children to the
existing `ShapeOutline.None` model value.

The corpus scan found this exact empty-line encoding only in
`13-wordart.pptx`; non-empty authored outlines continue through the existing
outline path.

## Fresh matched COM evidence

Candidate and baseline use the same Release renderer, 1280x720 PowerPoint COM
capture, and `composite/wpf-composite-renderer` provenance.

| Comparison | Before | Candidate | Delta |
| --- | ---: | ---: | ---: |
| WPF vs PowerPoint | 1.3383% | 1.3201% | -0.0182 pp |
| Avalonia vs PowerPoint | 1.3378% | 1.2832% | -0.0546 pp |
| Avalonia vs PowerPoint harness score | 1.5019% | 1.4588% | -0.0431 pp |

Only the Wave Text glyph region changed: WPF changed pixels were bounded to
`(504,400)-(746,432)` and Avalonia changes to `(503,399)-(712,432)`.

## Verification

- `WordArtTests`: 30 passed, 0 failed.
- `FreeP.RenderCompare` Release build: 0 warnings, 0 errors.
- Fresh `--avalonia-compare` PowerPoint export completed 1/1.
