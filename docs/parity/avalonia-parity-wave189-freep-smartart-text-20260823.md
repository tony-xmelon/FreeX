# FreeP Wave189 SmartArt text parity

Date: 2026-08-23
Correction: semantic Avalonia Aptos fallback calibration for imported
`IncreasingCircleProcess` text
Corpus: `15-smartart-grouped-list.pptx`, slide 09, 1280x720, committed Office PNG

## Accepted correction

Avalonia now consumes the existing compositor flag
`UseImportedIncreasingCircleTextRaster` for the same authoritative imported
cache topology established by Wave188. The Avalonia renderer applies a
`0.930` Aptos-to-Arial font scale only when every visible run in that flagged
text layout is Aptos. Measurement and paint use the same scale. Ordinary text,
mixed-font text, Aptos Display text, and all unflagged shapes retain their
existing policies.

The correction does not inspect label strings and does not change WPF. Wave188's
semantic topology gate remains the source of the flag: unsupported live layout,
the `/IncreasingCircleProcess` identity, exactly 12 cached shapes, the
3-ellipse/3-chord/6-rectangle topology, and four text-bearing rectangles.

## Target evidence

The before render is the unchanged `origin/main` renderer. The after render is
the Wave189 source after the correction. Both use the committed Office reference
at `tools/FreeP.RenderCompare/corpus/pptx-ref/15-smartart-grouped-list/slide-09.png`.

| Comparison | Before | After | Delta |
| --- | ---: | ---: | ---: |
| Slide 09 WPF vs Office | 0.9662% | 0.9662% | 0.0000 pp |
| Slide 09 Avalonia vs Office | 1.6879% | 1.5440% | -0.1439 pp |
| Slide 09 WPF vs Avalonia | 1.6009% | 1.3657% | -0.2352 pp |

The Avalonia/Office reduction is 8.52% relative; the WPF/Avalonia reduction is
14.69% relative. Fresh target artifacts are under
`artifacts/parity/wave189-baseline-15` and
`artifacts/parity/wave189-final-target-093`.

## Controls

The neighboring imported SmartArt rows in deck 15 are unchanged:

| Slides | WPF vs Avalonia before | WPF vs Avalonia after |
| --- | ---: | ---: |
| 08 | 0.4828% | 0.4828% |
| 10 | 1.6302% | 1.6302% |

Fresh deck-14 SmartArt control measurements remain:

| Slides | WPF vs Office | Avalonia vs Office | WPF vs Avalonia |
| --- | ---: | ---: | ---: |
| 01-04 | 1.3451%, 1.5158%, 0.7149%, 1.7017% | 1.3124%, 1.5689%, 0.7043%, 1.7286% | 1.1567%, 1.0093%, 0.2878%, 0.5210% |

The fresh deck-26 Surface3D control remains WPF `2.4757%`, Avalonia
`2.2723%`, and pair `1.0104%`. The ordinary authored phase-label negative
control and the Wave188 exact-topology contracts remain intact.

## Calibration probes

The nearby semantic values were rendered against the same Office reference:

| Avalonia scale | Slide 09 Avalonia vs Office |
| ---: | ---: |
| 0.920 | 1.5500% |
| 0.930 | 1.5440% |
| 0.935 | 1.5613% |

`0.930` is retained as the best measured point. No global or literal-text
calibration was accepted.

## Verification

- `FreeP.App.Rendering.Avalonia.Tests`: 286/286 passed, Release.
- `FreeP.App.Presentation.Tests --filter FullyQualifiedName~SmartArt`: 434/434 passed, Release.
- `FreeP.RenderCompare.Tests --filter FullyQualifiedName~SmartArtFixtureEvidenceTests`: 7/7 passed, Release.
- `FreeP.RenderCompare` Release build: 0 warnings, 0 errors.
- PowerPoint COM was not available on this host; the committed Office PNG is
  the reference authority.
