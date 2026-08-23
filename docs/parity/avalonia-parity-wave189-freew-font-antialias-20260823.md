# Avalonia Parity Wave 189: FreeW Font Text Raster

Date: 2026-08-23  
Scope: FreeW Avalonia Font dialog, the three canonical states at the existing harness target  
Authority: FreeW WPF `FontDialog`

## Finding

Fresh current-source captures showed that WPF's `RenderTargetBitmap` Font dialog uses grayscale
text edges, while Avalonia's shared compact-dialog default used subpixel antialiasing. The
Avalonia capture contained hundreds of colored fringe colors that are absent from the WPF
authority. This was a route-specific rendering mismatch, not a planner or geometry mismatch.

## Correction

The Avalonia Font dialog now requests `TextRenderingMode.Antialias`, the Avalonia grayscale
equivalent, at its window boundary. Shared compact dialogs retain their existing subpixel
policy. The focused visual contract test records this route-local exception.

## Fresh paired evidence

WPF was captured before the Avalonia-only correction and reused as the authority for both
comparisons. Avalonia was captured before and after from the same checkout, at the same target
size and with the same three harness states.

| State | Before changed | After changed | Delta | Before mean | After mean |
| --- | ---: | ---: | ---: | ---: | ---: |
| `font.initial` | 19,358 | 19,013 | -345 | 9.381018 | 9.382329 |
| `font.populated` | 19,533 | 19,177 | -356 | 9.478664 | 9.481988 |
| `font.validation-error` | 19,814 | 19,430 | -384 | 9.673406 | 9.677039 |
| **Aggregate** | **58,705** | **57,620** | **-1,085** | **9.511029** | **9.513785** |

The changed-pixel count falls by `1.848%` in aggregate, and every state improves. Mean channel
delta increases by `0.002756` in aggregate, so this is recorded as a changed-pixel and raster-
palette improvement rather than a claim that every similarity metric improves. The three rows
remain `genuine-visual-mismatch`; no parity classification was weakened.

## Verification

- Fresh WPF capture: `3/3` captured, content gates passed.
- Fresh Avalonia before/after captures: `3/3` captured in each run, content gates passed.
- Focused `FontDialogVisualParityTests`: `4/4` passed.
- Focused `FontDialogPlannerTests`: `31/31` passed.
- Route-scoped canonical comparison: `512` scenarios retained; `141` genuine mismatches, `80`
  passes, and `70` Avalonia extensions.
- Authoritative generated files refreshed only under `docs/parity/freew-dialog-harness/`.

Next FreeW residual remains the Font control-template/text raster tail and then the Legal Notices
glyph/template tail; both remain measured mismatches.
