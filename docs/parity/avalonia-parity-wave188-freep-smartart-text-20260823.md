# FreeP Wave188 SmartArt text parity

Date: 2026-08-23
Correction revision: `0d4cff3637`
Gate revision: `b36d867805`
Corpus: 27 decks / 53 slides, 1280x720, committed PowerPoint PNG references

## Accepted correction

The compositor now assigns an explicit draw-op raster flag only to text-bearing
rectangle children of an authoritative imported `IncreasingCircleProcess`
cache with the canonical richer topology: live layout support is false, the
cache has exactly 12 children, and its geometry is exactly three ellipses,
three chords, and six rectangles, of which exactly four rectangles carry
visible text. The gate never examines label strings.

WPF consumes that flag to change only the imported Aptos text raster scale from
the general policy to X `1.0` and Y `0.94`; Avalonia keeps its existing policy.
Ordinary authored `Phase A`, `Phase B`, `Phase C`, and `Phase D` rectangles are
covered by a negative compositor control and retain the generic text path.

## Target evidence

These are direct current-source renders compared with the committed Office PNG
reference at
`tools/FreeP.RenderCompare/corpus/pptx-ref/15-smartart-grouped-list/slide-09.png`.
The before render is at
`artifacts/parity/wave188-freep-before-target`; fresh gate-revision renders are
at `artifacts/parity/wave188-semantic-gate-target-wpf` and
`artifacts/parity/wave188-semantic-gate-target-avalonia`.

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
`1.3451%, 1.5158%, 0.7149%, 1.7017%`, Avalonia
`1.3124%, 1.5689%, 0.7043%, 1.7286%`, and pair
`1.1567%, 1.0093%, 0.2878%, 0.5210%` across slides 01-04. Within the target
deck, neighboring slides 08 and 10 remained WPF/Avalonia/pair
`1.1608% / 1.1313% / 0.4828%` and
`1.7356% / 1.5956% / 1.6302%`, respectively.

`OrdinaryAuthoredPhaseLabels_DoNotUseImportedIncreasingCircleTextRaster`
composes four ordinary authored rectangles with the literal phase labels,
checks that their text survives unchanged, and proves that all four draw ops
leave the imported-cache raster flag false.

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

- `FreeP.App.Presentation.Tests`: 5389/5389 passed, Release.
- `FreeP.App.Rendering.Avalonia.Tests`: 285/285 passed, Release.
- `FreeP.RenderCompare` Release build: 0 warnings, 0 errors.
- Focused render artifacts are under
  `artifacts/parity/wave188-semantic-gate-target-wpf`,
  `artifacts/parity/wave188-semantic-gate-target-avalonia`,
  `artifacts/parity/wave188-semantic-gate-control06-wpf`,
  `artifacts/parity/wave188-semantic-gate-control06-avalonia`,
  `artifacts/parity/wave188-semantic-gate-control14-wpf`,
  `artifacts/parity/wave188-semantic-gate-control14-avalonia`,
  `artifacts/parity/wave188-semantic-gate-control26-wpf`, and
  `artifacts/parity/wave188-semantic-gate-control26-avalonia`.

## Next residual

Avalonia retains the slide-09 Office residual at `1.6879%`; WPF retains
`0.9662%`. The remaining difference is primarily native text antialiasing and
the imported SmartArt circle/text raster tail, with the canonical corpus still
requiring a full consistent rerender before any aggregate update.
