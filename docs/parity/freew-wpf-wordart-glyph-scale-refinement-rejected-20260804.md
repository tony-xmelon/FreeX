# WPF WordArt Glyph Scale Refinement Rejected

## Scope

After the accepted right-edge glow registration, the exact imported
`FreeW CONFIDENTIAL` / `GlowBlue` / `Wave1` / 32-point WPF path still differed
from Word by roughly one pixel at the top and bottom of its white glyph mask.
A renderer-local vertical-scale refinement from `1.78` to `1.79` tested whether
that residual was a simple draw-time height calibration.

## Provenance

- Fixture SHA-256: `757A232A0411105B1144CB315FAA34B686543C4B6FA3E5E750AC50F13B1BBA50`
- Word PNG: 816x1056, SHA-256
  `08FC07DB49E17BDCB9C6841905F34DE6E5767EFFA228C97BB94914786645EB2B`
- Accepted `1.78` baseline SHA-256:
  `6FB11A9C2A8BECE62481CC36D589E89546B25F5D1386E654D59D88B689EC17E5`
- Rejected `1.79` candidate SHA-256:
  `7D9382F2DDD9D7A8CDA9523438F7C7F0E3C12E146B3F20AF5036DB6DCDF681A7`

## Result

Mean absolute RGB channel delta against the matching Word PNG:

| Region | Baseline | Candidate | Change |
|---|---:|---:|---:|
| Whole page | 4.1830% | 4.1892% | +0.0062 pp |
| Banner | 6.1047% | 6.2098% | +0.1050 pp |
| Tight glyph | 6.7440% | 6.9158% | +0.1718 pp |
| Top glow | 2.5620% | 2.5620% | byte-stable |
| Bottom glow | 5.7332% | 5.7332% | byte-stable |
| Right glow | 3.5872% | 3.5872% | byte-stable |
| Review Copy control | 3.8157% | 3.8157% | byte-stable |
| Lower-body control | 6.6474% | 6.6474% | byte-stable |

The candidate changed 3,437 pixels, all inside the exact glyph path. It was
reverted, and the accepted `1.78` source value remains authoritative.

## Conclusion

A one-pixel transformed-text mask mismatch is not evidence for another uniform
vertical scale change. The remaining glyph residual belongs to text-path shape or
host rasterization and should not block independent functional or visual slices.
