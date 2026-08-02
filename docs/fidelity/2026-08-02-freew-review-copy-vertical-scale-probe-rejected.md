# FreeW Review Copy Vertical Scale Probe Rejected

## Provenance

- Fixture: `wordart-watermark-stress.docx`
- Fixture SHA-256: `173F9E23A8BE200E864EFDDA99540868B7A7DA38234AA5F7AC188EFB8CD2A9CA`
- Word reference: isolated visible Word 16.0 COM, short input/output paths, read-only open,
  `ExportAsFixedFormat`, 96-DPI PDF raster
- Word PNG SHA-256: `08FC07DB49E17BDCB9C6841905F34DE6E5767EFFA228C97BB94914786645EB2B`
- Current-main WPF PNG SHA-256: `5BB23C1C3AFD90ABD7DC902A6ECAAC0C2A232B7FB9EB96965D0C9A719114A479`
- Candidate WPF PNG SHA-256: `BAD3E71F115CBEDE47CAC6DD3244189E40F6C10CB112724DEDAB2ADFA65DA48B`
- Capture size: 816x1056

Word COM was responsive: it created its isolated instance, opened the document, exported the PDF in
about 1.3 seconds, closed the read-only document, and quit its owned process. No manual PDF save or
screen capture was used.

## Current Residual

Current WPF versus Word normalized mean absolute RGB-channel deltas are:

- whole page: 4.1852%
- exact GlowBlue/Wave1 banner ROI `(310,215)-(806,310)`: 6.4014%
- banner text ROI `(325,228)-(795,294)`: 6.9322%
- exact FillGold/ArchUp Review Copy ROI `(430,350)-(690,430)`: 4.4030%

Most hot 96x96 tiles are body text, confirming a broader Word-versus-WPF glyph-raster floor. The two
WordArt objects remain narrow source-signature owners and must be scored independently.

## Rejected Probe

The exact `Text="Review Copy" + FillGold + ArchUp + 34-DIP` path changed only its WPF glyph vertical
scale from 1.0 to 1.25. The raw black-ink bbox grew from y=350..392 to y=350..396, matching Word's
measured bottom edge, while the GlowBlue banner remained metric-stable.

The candidate nevertheless regressed:

- whole page: 4.1852% -> 4.2124% (+0.0272 pp)
- Review Copy ROI: 4.4030% -> 5.5267% (+1.1237 pp)
- banner ROI: 6.4014% -> 6.4014% (stable)

The product change was reverted. Matching an ink bbox is not acceptance evidence for transformed text;
the added pixels had the wrong glyph-path raster and worsened both the target ROI and whole page. Future
work should target the ArchUp text-path/rotation model or material ownership, not baseline-centered
vertical scaling.

