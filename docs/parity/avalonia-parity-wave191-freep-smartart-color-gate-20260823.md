# FreeP Wave191 IncreasingCircleProcess color-gate parity

Date: 2026-08-23
Corpus: `tools/FreeP.RenderCompare/corpus/15-smartart-grouped-list.pptx`, slide 09, 1280x720
Office authority: committed PowerPoint PNG at `tools/FreeP.RenderCompare/corpus/pptx-ref/15-smartart-grouped-list/slide-09.png`

## Decision

The remaining IncreasingCircleProcess slide-09 residual was selected over a
new Surface3D topology. Wave175 found no new authored Surface3D mesh or blank
pattern in the committed corpus, while slide 09 exposed a concrete renderer
bug: Wave190's final text-color predicate required white, but the
Office-authored cache has no direct run color and the resolved compositor
layout is black, matching the Office pixels. The impossible predicate disabled
the already measured Avalonia font-scale and origin correction.

Wave191 changes only that semantic gate from white to black. The existing
topology, source-layout, font, geometry, effects, spacing, and text-shape
guards remain unchanged. The route still requires the compositor's
`UseImportedIncreasingCircleTextRaster` flag and does not inspect visible
strings, file names, or screenshot hashes. WPF code and authority are
unchanged.

## Target metrics

Mean channel difference, percent of 255:

| Comparison | Before | After | Delta |
| --- | ---: | ---: | ---: |
| Slide 09 WPF vs Office | 0.9662% | 0.9662% | 0.0000 pp |
| Slide 09 Avalonia vs Office | 1.6879% | 0.8675% | -0.8204 pp |
| Slide 09 WPF vs Avalonia | 1.6009% | 0.8540% | -0.7469 pp |

The before image is the fresh current source with the impossible white gate;
the after image is the same source with the black semantic gate. Fresh WPF and
Avalonia deck-15 renders completed for all 10 slides. WPF is byte-stable for
10/10 slides; the nine non-target Avalonia slides are byte-stable, and slides
08 and 10 remain:

| Slide | WPF vs Office | Avalonia vs Office | WPF vs Avalonia |
| --- | ---: | ---: | ---: |
| 08 | 1.1608% | 1.1313% | 0.4828% |
| 10 | 1.7356% | 1.5956% | 1.6302% |

## 53-slide corpus

Fresh after renders covered 27 decks and 53 slides. Every WPF/Avalonia render
and all 159 reference/pair diffs completed successfully.

| Aggregate | Before | After |
| --- | ---: | ---: |
| WPF vs Office average / maximum | 1.0309% / 3.0587% | 1.0309% / 3.0587% |
| Avalonia vs Office average / maximum | 1.0117% / 2.5815% | 0.9962% / 2.5815% |
| WPF vs Avalonia average / maximum | 0.6238% / 2.9091% | 0.6097% / 2.9091% |

Unchanged control families from the after corpus:

| Corpus | Slides | WPF vs Office | Avalonia vs Office | WPF vs Avalonia |
| --- | --- | --- | --- | --- |
| `06-charts` | 01-04 | 0.9846%, 1.2449%, 0.6149%, 1.2552% | 0.9375%, 1.1365%, 0.5839%, 1.1998% | 0.4242%, 0.3599%, 0.2974%, 0.4455% |
| `14-smartart-live` | 01-04 | 1.3451%, 1.5158%, 0.7149%, 1.7017% | 1.3124%, 1.5689%, 0.7043%, 1.7286% | 1.1567%, 1.0093%, 0.2878%, 0.5210% |
| `26-chart-surface3d-default-tall-frame` | 01 | 2.4757% | 2.2723% | 1.0104% |

The full row-level before/after metrics are in `metrics.json` beside this
report. The durable images are the Avalonia before/after target renders, the
after WPF target render, and the after Avalonia/Office heatmap.

## Verification

- `dotnet build tools/FreeP.RenderCompare/FreeP.RenderCompare.csproj --configuration Release --no-restore`: 0 warnings, 0 errors.
- `FreeP.App.Rendering.Avalonia.Tests`: 290/290 passed.
- `PptxRepairCorpusValidityTests`: 22/22 passed, including the resolved black source-color assertion and existing topology/negative controls.
- `SmartArtFixtureEvidenceTests`: 7/7 passed.
- Full corpus: 106/106 WPF and Avalonia renders; 159/159 WPF/Office, Avalonia/Office, and WPF/Avalonia diffs.
- PowerPoint COM was unavailable on this host; the committed Office PNG is the authority.

## Remaining residual

Slide 09 remains at 0.8675% Avalonia/Office and 0.8540% WPF/Avalonia. The
remaining difference is native text antialiasing plus small shape/text raster
differences, not a pixel-identity claim. The largest Avalonia/Office residual
in the fresh corpus is `25-chart-surface3d-view3d` at 2.5815%; it has no new
Wave191 source topology evidence for a principled promotion. The largest
WPF/Avalonia residual is `17-bullets-autofit` slide 02 at 2.9091%.
