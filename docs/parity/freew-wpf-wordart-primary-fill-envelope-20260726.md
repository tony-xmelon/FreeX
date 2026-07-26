# Imported Primary WordArt Fill Envelope

## Scope

Only imported `FreeW CONFIDENTIAL` GlowBlue/Wave1 WordArt at 32 pt uses this WPF-local
fill-layer calibration. Glyph placement, glyph scale, outer glow, and every other WordArt
signature are unchanged.

## Evidence

The manually saved Word PDF reference is 816x1056 (PNG SHA-256
`FB14B510BD45BE4C30A6CEDF249EDCC308FC247788DE576D5EA56BA360BCAD26`). Its dark
material panel spans pixels `x=323..798`; the prior WPF fill spanned `x=325..796`.

The fill envelope changes from `canvas + 8`, left `-4`, to `canvas + 12`, left `-6`.
Fresh Release composite evidence:

| Region | Before | After |
| --- | ---: | ---: |
| Whole page | 4.9070% | 4.8965% |
| Primary WordArt ROI | 7.2512% | 7.2317% |
| Banner ROI | 7.1161% | 6.9541% |
| Glyph ROI | 9.2735% | 9.2735% |
| Review Copy ROI | 4.0495% | 4.0495% |

The dark material edge matches Word at the left and ends one antialiased pixel short on the
right. The candidate is accepted only because the target ROIs and whole page improve while
the independent glyph and Review Copy controls are byte-stable.
