# FreeP Wave192 renderer residual decision

Date: 2026-08-23
Branch: `codex/parity-wave192-freep-20260823`
Base: `62fa14b152`
Corpus: 27 decks / 53 slides, 1280x720, committed PowerPoint PNG references

## Decision

No new runtime rendering change is retained in Wave192. Deck25 remains the
largest Avalonia/Office residual at `2.5815%`, but its imported model is already
on the bounded authored-camera path: `Surface3D`, a 3x3 mesh with the imported
blank value, `rotX=25`, `rotY=35`, `depth=125`, `perspective=54`,
`rAngAx=false`, and explicit `wireframe=0`. The existing renderer-neutral
semantic gate also requires the imported category and series topology and all
nine modeled values. WPF and Avalonia consume the same explicit facet plan.

The fresh deck25 heatmap shows the remaining error across the authored
projection envelope and chart frame, rather than a missing model vertex or an
ordinary chart-family leak. The committed corpus has no additional Surface3D
topology with which to validate a general camera/material correction. Adding
another coordinate or material overlay would therefore be fixture-specific and
was rejected. No file name, visible label, screenshot hash, or corpus-only
coordinate is used by the retained runtime.

Wave192 switched its investigation to the remaining IncreasingCircleProcess
slide09 residual. A probe that applied Avalonia's existing unhinted/grayscale
text policy to the already semantic `UseImportedIncreasingCircleTextRaster`
route was rejected: Avalonia/Office changed from `0.8675%` to `0.8775%`.
Slides 08 and 10 remained unchanged. The probe was reverted; the existing
Wave191 semantic black-color gate, topology gate, font scale, and origin
correction remain the measured best path.

## Measurements

Mean channel difference as a percentage of the maximum channel range:

| Comparison | Deck25 Surface3D | Slide09 IncreasingCircle |
| --- | ---: | ---: |
| WPF vs Office | 2.7032% | 0.9662% |
| Avalonia vs Office | 2.5815% | 0.8675% |
| WPF vs Avalonia | 1.0804% | 0.8540% |

Worker-run corpus measurement and all 159 row comparisons (the render count is
reported by the worker run; the generated 106-image render set is not retained
in this evidence bundle):

| Aggregate | Average | Maximum slide residual |
| --- | ---: | ---: |
| WPF vs Office | 1.0309% | 3.0587% |
| Avalonia vs Office | 0.9962% | 2.5815% |
| WPF vs Avalonia | 0.6097% | 2.9091% |

Controls remained unchanged: `06-charts` Avalonia/Office is
`0.9375%, 1.1365%, 0.5839%, 1.1998%`; `14-smartart-live` is
`1.3124%, 1.5689%, 0.7043%, 1.7286%`; deck26 default Surface3D is
`2.2723%`; and deck15 slides 08 and 10 are `1.1313%` and `1.5956%`.
The WPF slide09 PNG is byte-stable against the Wave191 evidence hash
`285e9f4aa9014e704a01df1ede731e2f63e448245cf8b04d642f2bd727967e70`.

Machine-readable rows, target images, heatmaps, and SHA-256 integrity checks
are committed under
`docs/parity/evidence/avalonia-parity-wave192-freep-evidence-20260823/`.
The committed PowerPoint reference mapping and provenance are recorded in
`references.json` in that directory.

## Verification

- `dotnet build tools/FreeP.RenderCompare/FreeP.RenderCompare.csproj --configuration Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false -p:BuildInParallel=false /nr:false -m:1`: 0 warnings, 0 errors.
- Focused `FreeP.App.Rendering.Avalonia.Tests`: 108/108 passed.
- Focused chart/SmartArt/model `FreeP.App.Presentation.Tests`: 732/732 passed.
- Focused `FreeP.RenderCompare.Tests`: 21/21 passed.
- Full `FreeP.App.Rendering.Avalonia.Tests`: 290/290 passed.
- Worker-run claim: 106/106 WPF/Avalonia renders and 159/159 reference and pair diffs; this render count is not independently reproducible from the retained bundle.
- `Test-Integrity.ps1`: 53 unique rows across 27 decks / 53 slides, all 159 comparisons, recomputed aggregates, target/control equality, 9/9 evidence PNG hashes and dimensions, 53/53 committed reference mappings with hashes and dimensions, and actual WPF hash equality against both Wave191 and Wave192 stability hashes.
- PowerPoint COM was unavailable; committed Office PNGs are the authority.

## Evidence proof boundary

The retained evidence proves the 53-row metric table, its three comparisons
per row, the declared aggregate values within the documented four-decimal
rounding, target/control consistency, the nine retained Wave192 PNGs, the
WPF increasing-circle stability hash, and the one-to-one mapping to 53 tracked
PowerPoint reference PNGs at 1280x720. It does not prove that 106 current-source
WPF/Avalonia renders were performed because those generated render outputs and
their per-render provenance are not retained. That number remains a worker-run
claim and is intentionally not asserted by `Test-Integrity.ps1`.

## Remaining residual

Deck25 Surface3D remains the largest Avalonia/Office residual. The next honest
Surface3D slice needs a committed PowerPoint-authored fixture with a genuinely
new mesh or blank-cell topology before changing the general camera, frame, or
material projection. Slide09's remaining difference is native text
antialiasing and small shape/text raster variation, not a missing semantic gate.
