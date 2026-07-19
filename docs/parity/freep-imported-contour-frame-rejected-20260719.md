# FreeP imported contour frame probe rejection

This probe tested a renderer-local replacement frame for the imported
`ContourOnly` shape in `11-bevel3d.pptx`. Raw PowerPoint bands suggested a
crisp five-pixel `#115AC5` frame around a `#1B698C` face, so the candidate
repainted that exact source signature after the generic contour pass.

The candidate was rejected. Fresh matched 1280x720 PowerPoint/WPF evidence:

| ROI | Accepted | Candidate |
| --- | ---: | ---: |
| Whole page | 1.0707% | 1.0751% |
| Contour + depth `(380,290)-(710,540)` | 1.8248% | 1.8731% |

Circle, relaxed-inset, angle, and cross ROIs were byte-stable. The raw frame
width intuition did not capture WPF's antialiasing and the authored depth
composition, so the product probe was reverted cleanly. Rule: exact edge-band
width is not sufficient evidence for a contour/depth owner; require the local
ROI and whole-page gate, then keep the existing path when either regresses.
