# FreeP bullets autofit centered vertical probe rejected - 2026-07-18

## Scope

The current `17-bullets-autofit.pptx` WPF body has taller raw glyph bands than
PowerPoint while preserving the same line cadence. A WPF-only probe applied a
`0.80` vertical raster scale to the exact eight-paragraph 18pt Aptos
`a:noAutofit` body, centered within each measured `FormattedText` line. The
existing horizontal fit, paragraph positions, title, and Avalonia routes were
unchanged.

## Matched evidence

Fresh 1280x720 PowerPoint PNGs and the current Release artifact:

| WPF metric | Current baseline | Centered vertical probe |
| --- | ---: | ---: |
| Slide 1 title control | 1.0498% | 1.0498% |
| Slide 2 whole page | 3.2245% | 3.5142% |

The candidate was rejected by the complete target-page gate and reverted.

## Conclusion

The body residual is not safely corrected by a draw-time vertical scale even
when the raw ink bands suggest symmetric height error. Future work needs a
font-aware WPF raster path or a layout-preserving text implementation rather
than additional scalar glyph transforms.

## Verification

- FreeP renderer Release build: 0 warnings, 0 errors.
- Candidate render completed both slides.
- Source restored to the accepted renderer after scoring.
