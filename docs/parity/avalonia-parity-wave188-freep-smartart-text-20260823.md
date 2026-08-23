# FreeP Wave188 SmartArt text parity

Date: 2026-08-23
Source revision: `0d4cff3637`
Corpus: 27 decks / 53 slides, 1280x720, committed PowerPoint PNG references

## Accepted correction

The WPF renderer now uses a narrow native raster compensation for the four
single-run imported `Phase A`, `Phase B`, `Phase C`, and `Phase D` labels in the
cached `IncreasingCircleProcess` SmartArt fixture. The correction changes only
the WPF text raster scale from the general imported Aptos policy to X `1.0`
and Y `0.94`; Avalonia keeps its existing policy. Other text, SmartArt layouts,
charts, and authored text do not enter this exact-label path.

## Target evidence

These are direct current-source renders compared with the committed Office PNG
reference at
`tools/FreeP.RenderCompare/corpus/pptx-ref/15-smartart-grouped-list/slide-09.png`.
The before render is at
`artifacts/parity/wave188-freep-before-target`; the accepted render is at
`artifacts/parity/wave188-smartart-accepted2-wpf` and
`artifacts/parity/wave188-smartart-accepted-avalonia`.

| Comparison | Before | After | Delta |
| --- | ---: | ---: | ---: |
| Slide 09 WPF vs Office | 1.6516% | 0.9662% | -0.6854 pp |
| Slide 09 Avalonia vs Office | 1.6879% | 1.6879% | 0.0000 pp |
| Slide 09 WPF vs Avalonia | 1.6609% | 1.6009% | -0.0600 pp |

The committed Office reference is the authority. A live PowerPoint export was
also attempted through `--avalonia-compare`, but this machine has no registered
`PowerPoint.Application` COM ProgID; that prerequisite failure is separate from
the successful FreeP renders and direct PNG diffs.

## Controls

The neighboring imported/default Surface3D control deck 26 remained WPF
`2.4757%`, Avalonia `2.2723%`, pair `1.0104%` against its committed Office
reference. The ordinary-chart control deck 06 remained, by slide:

| Slides | WPF vs Office | Avalonia vs Office | WPF vs Avalonia |
| --- | --- | --- | --- |
| 01-04 | 0.9846%, 1.2449%, 0.6149%, 1.2552% | 0.9375%, 1.1365%, 0.5839%, 1.1998% | 0.4242%, 0.3599%, 0.2974%, 0.4455% |

The SmartArt control deck 14 remained WPF
`1.3451%, 1.5158%, 0.7149%, 1.7017%` and Avalonia
`1.3124%, 1.5689%, 0.7043%, 1.7286%` across slides 01-04. Within the target
deck, neighboring slides 08 and 10 remained WPF `1.1608%` and `1.7356%`.

## Canonical corpus handling

The canonical 27-deck/53-slide recalibration JSON was not edited. Its existing
summary remains authoritative: WPF average/max `1.0447% / 3.0587%`, Avalonia
average/max `1.0124% / 2.9238%`, and pair average/max `0.6248% / 1.6684%`.
The Wave188 target and control measurements above are direct evidence, not a
reconstructed corpus summary.

## Rejected experiments

- Explicit Arial normalization of the imported SmartArt cache worsened slide
  09 to WPF `1.9670%` and Avalonia `1.9715%`.
- Tall-frame Surface3D grid and lift variants worsened deck 26; the medium-frame
  lift variant worsened deck 22. All were reverted.
- An Avalonia-only `0.98` font scale worsened slide 09 to `1.8788%` and was
  reverted.

## Verification

- `FreeP.App.Presentation.Tests`: 5388/5388 passed, Release.
- `FreeP.App.Rendering.Avalonia.Tests`: 285/285 passed, Release.
- `FreeP.RenderCompare` Release build: 0 warnings, 0 errors.
- Focused render artifacts are under
  `artifacts/parity/wave188-smartart-accepted2-wpf`,
  `artifacts/parity/wave188-smartart-accepted-avalonia`,
  `artifacts/parity/wave188-control06-wpf`,
  `artifacts/parity/wave188-control06-avalonia`,
  `artifacts/parity/wave188-smartart-control14-wpf`, and
  `artifacts/parity/wave188-smartart-control14-avalonia`.

## Next residual

Avalonia retains the slide-09 Office residual at `1.6879%`; WPF retains
`0.9662%`. The remaining difference is primarily native text antialiasing and
the imported SmartArt circle/text raster tail, with the canonical corpus still
requiring a full consistent rerender before any aggregate update.
