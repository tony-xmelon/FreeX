# Avalonia GlowBlue Wave1 Width Registration

The imported FreeW CONFIDENTIAL GlowBlue/Wave1 WordArt banner used the
generic 80 percent width cap. Its white glyph mask was only 377 pixels wide
(373..749) while the matching Word PNG was 456 pixels wide (332..787).

The exact imported signature now fills 97 percent of its authored rectangle.
Unlike the normal fit-only path, this measured signature may enlarge text
whose natural width is below the cap. The resulting Avalonia glyph mask is
334..789, within two pixels of Word's horizontal registration. Other WordArt
signatures retain the existing fit-only policy.

Fresh matching Word PNG evidence at 816x1056:

| Metric | Before | After |
| --- | ---: | ---: |
| Whole page | 5.0550% | 5.0188% |
| Primary WordArt ROI (300,215)-(810,315) | - | 16.1362% |

The whole-page improvement is accepted alongside the exact horizontal glyph
registration. The broad ROI remains dominated by the black banner and glow
rasterization, so the local raw glyph mask is the more specific ownership
measure for this width-only slice.

A 1.25 vertical glyph-scale follow-up produced a nearly matching raw height
but regressed the primary ROI from 16.1362% to 17.1891% and the whole page
from 5.0188% to 5.0811%; it was reverted. The remaining vertical difference
is a Wave1 glyph-rasterization model gap, not a safe scale calibration.

The independent picture-watermark WordArt fixture was byte-stable.

Verification:

- dotnet build freew\tools\FreeW.PageLayoutShot\FreeW.PageLayoutShot.csproj --configuration Release (0 warnings, 0 errors)
- fresh source-backed render against the matching cached Word PNG corpus.
