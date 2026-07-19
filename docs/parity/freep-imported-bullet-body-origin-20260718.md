# FreeP imported bullet body origin calibration

Date: 2026-07-18  
Corpus: `tools/FreeP.RenderCompare/corpus/17-bullets-autofit.pptx`  
Host: WPF `FreeP.RenderCompare` Release artifact  
Reference: fresh PowerPoint COM export, 1280x720, 2/2 slides

## Change

The imported six-paragraph Aptos bullet body is translated upward by 6 DIP in
the WPF renderer only. The path is guarded by the exact body signature:
`spAutoFit`, six paragraphs, Aptos 18pt regular runs, and a non-empty bullet
kind on every paragraph. The title and the eight-paragraph no-autofit body on
slide 2 do not use the correction.

## Evidence

| Surface | Before | After | Result |
| --- | ---: | ---: | --- |
| Slide 1 whole page | 1.0498% | 0.8672% | improved |
| Slide 1 body ROI `(60,100)-(550,350)` | 6.7991% | 5.4232% | improved |
| Slide 2 whole page | 3.2245% | 3.2245% | SHA-256 stable |
| Slide 2 body ROI `(60,100)-(550,350)` | 11.3038% | 11.3038% | SHA-256 stable |

The WPF average changed from 2.1372% to 2.0459%. Avalonia remains unchanged;
its fresh comparison was 0.9643% / 3.3054% for slides 1 / 2. Raw ink bands
identified the issue before the probe: PowerPoint slide 1 begins at y=117,
154, ... while WPF began at y=123, 160, ... with the same cadence.

## Verification

- Focused WPF source contract: 1/1.
- Related shared text-layout source contracts: 10/10.
- `FreeP.RenderCompare` Release build: 0 warnings, 0 errors.
- Fresh PowerPoint COM export: 2/2 slides.
- The slide 2 WPF PNG SHA-256 remained
  `626BFD156B67D87EC152FF3A9198ABF8829FAC14F0161BFB231B1A0FCE5C544B`.
