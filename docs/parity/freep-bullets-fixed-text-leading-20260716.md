# FreeP fixed-text leading parity - 2026-07-16

## Target

`tools/FreeP.RenderCompare/corpus/17-bullets-autofit.pptx`, compared with the
PowerPoint COM export at 1280x720. Slide 2 is a fixed-size body text box with
`a:noAutofit`; slide 1 uses `a:spAutoFit`.

## Change

Avalonia now uses a calibrated `1.20 * em` line height for `TextAutoFitKind.None`
text bodies. PowerPoint's `spAutoFit` and `normAutofit` paths retain the existing
`1.18 * em` leading. The `TextAutoFitKind` is passed through every Avalonia text
measurement/render path so the correction does not change autofit behavior.

## Evidence

| Backend / slide | Before | After |
| --- | ---: | ---: |
| Avalonia / 17 slide 1 | 1.0202% | 1.0202% |
| Avalonia / 17 slide 2 | 3.7221% | 3.6383% |
| Avalonia / 17 average | 2.3712% | 2.3292% |

The PowerPoint COM control `18-chart-types.pptx` was unchanged:

`0.6154%`, `1.0058%`, `1.2161%`, and `1.3679%` for slides 1-4.

Final artifacts are retained under:

- `artifacts/freep-bullets-selective-line120-final-20260716/`
- `artifacts/freep-chart-types-selective-line120-control-final-20260716/`

## Verification

- `SlideCanvasLineSpacingTests`: 10 passed.
- WPF/Avalonia/PowerPoint COM comparison completed for all slides in decks 17
  and 18.
- The focused render build completed as part of the test and comparison runs.
