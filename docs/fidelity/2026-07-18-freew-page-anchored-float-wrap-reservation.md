# Page-Anchored Float Wrap Reservation

## Scope

`f2-01-float-wrap.docx` has two page-anchored images above the top content
margin: a left square-wrapped image and a right tight-wrapped image. Their
serialized wrap distances are zero. FreeW copied their visual-only wrap bands
into the first flow paragraph, but shortened each WPF `Figure` by 17 DIPs.
With two figures on the same row, that host-specific width adjustment moved
both Word text exclusion boundaries inward.

The visual-only `Figure` now retains the measured image width. Its height
continues to use the existing vertical calibration. The model anchor remains
in its source paragraph and is still suppressed from creating a second wrap
reservation.

## Matching Word COM Evidence

The persistent Word COM baseline and the current WPF composite are 816 x 1056.

| Region | Before | After | Change |
| --- | ---: | ---: | ---: |
| Whole page | 6.2271% | 5.9114% | -0.3157 pp |
| Left wrap `(90,65)-(490,205)` | 7.0379% | 3.4453% | -3.5926 pp |
| Right wrap `(490,65)-(725,205)` | 5.3724% | 3.2192% | -2.1532 pp |
| Below-image body `(90,205)-(725,295)` | 14.9042% | 14.9042% | stable |

Fresh `object-format-position-size-style.docx` and
`drawing-objects-complex.docx` controls are pixel-identical before and after
the change. Their SHA-256 values are respectively
`FF8709DE30CD3B82D7DDC814969ED923FFCCD9B1EB315FF358063E44FA894A20` and
`E6B737FFA06DA129355AC84D4DC6AD15B953C6DAA5371CE9AE2FE156229E9D33`.

## Verification

- `FloatingImageRenderTests` passes 15/15 compiled and 15/15 with `--no-build`.
- The new right-anchor contract verifies that visual-only page-anchor figures
  preserve their authored 96-DIP width and survive commit without moving the
  source image.
- `FreeW.FidelityRender` Release builds with zero warnings and errors, then
  renders the target and both controls from the refreshed dependent artifact.
