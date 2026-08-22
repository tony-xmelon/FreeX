# FreeP Wave 183 SmartArt visual slice

Date: 2026-08-23
Branch: `codex/parity-wave183-freep-smartart`
Target: `15-smartart-grouped-list.pptx`, slide 10 (`vList6`)

## Correction

The cached SmartArt reader now folds the authored `txXfrm` bounds into text
insets only for the semantic right-arrow-with-bullets follow-node role. The
cached style boundary materializes the Office neutral follow-node fill and
outline (`#D1D6DC`) from the SmartArt role metadata. WPF uses a native filled
disc for the authored U+2022 marker in that same role because its standalone
Aptos fallback glyph is dropped during DrawingContext rasterization. Other
cached SmartArt shapes and ordinary bullets retain their prior paths. The
compositor assigns the explicit `FollowNode` draw role only while traversing
an authoritative cached SmartArt drawing; ordinary right-arrow bullets keep
the default `None` role.

## Exact target metrics

All values are RenderCompare `--diff` mean channel difference at 1280x720
against the committed PowerPoint PNG.

| Metric | Before | After | Change |
| --- | ---: | ---: | ---: |
| WPF vs Office, slide 10 | 4.4798% | 2.5120% | -1.9678 pp |
| Avalonia vs Office, slide 10 | 4.6698% | 2.3744% | -2.2954 pp |
| WPF vs Avalonia, slide 10 | 1.6263% | 1.6288% | +0.0025 pp |

For the complete ten-slide SmartArt deck, the exact averages changed as
follows:

| Metric | Before | After |
| --- | ---: | ---: |
| WPF vs Office | 2.0944% | 1.8977% |
| Avalonia vs Office | 2.1228% | 1.8932% |
| WPF vs Avalonia | 0.8896% | 0.8899% |

## Regression review

- The integration-scope correction rerendered all ten target slides. Fresh WPF
  and Avalonia PNGs are byte-identical to the prior corrected pass for every
  slide, and the fresh slide-10 metrics remain exactly `2.5120%`, `2.3744%`,
  and `1.6288%` respectively.
- Focused validation passed all `215/215` `SmartArtLayoutTests`, including
  positive cached-role and negative ordinary-right-arrow assertions, and all
  `6/6` `SmartArtFixtureEvidenceTests`.
- Slides 1-9 of the target deck are byte-identical before and after in both
  WPF and Avalonia.
- The pre-checkpoint corpus pass rendered all 27 decks and 53 slides in both
  hosts with zero renderer failures. The scope review reran the target deck,
  not the full corpus.
- That 53-slide pass recorded averages and maxima of WPF vs Office
  `1.1496% / 4.2659%`, Avalonia vs Office `1.1261% / 4.2721%`, and WPF vs Avalonia
  `0.6286% / 3.0952%`.
- No threshold, authority baseline, fixture signature, dashboard, or Wave 183
  integration note was edited.

## Authority and residuals

PowerPoint COM was unavailable because `PowerPoint.Application` is not
registered on this machine. The committed PowerPoint PNG tree was therefore
used as the Office authority, with fresh WPF and Avalonia renders compared
through the repository `--diff` implementation.

The remaining slide-10 residual is primarily host text measurement and glyph
rasterization. The cross-host metric is effectively flat and is `0.0025`
percentage points above the fresh pre-change value; the Office residuals are
substantially reduced while sibling slides remain unchanged.
