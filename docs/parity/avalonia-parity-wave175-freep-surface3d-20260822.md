# FreeP Wave175 Surface3D expansion audit

Date: 2026-08-22

## Decision

No renderer-neutral/shared Surface3D change is retained in Wave175. The fresh
PowerPoint-reference measurements reproduce the Wave174 results, and the
committed corpus does not contain a new mesh or blank-cell pattern that could
justify promoting another shared facet plan. The existing shared
`AlternateRenderFacets` selection remains unchanged for the measured 22, 25,
and 26 signatures; generic cameras, styles, meshes, and non-Surface3D charts
remain on the general projection path.

## Corpus inventory

The committed `tools/FreeP.RenderCompare/corpus` contains exactly three
`surface3DChart` packages:

| Deck | Camera/style/wireframe | Mesh and blank pattern |
| --- | --- | --- |
| `22-chart-baseline-depth` | default camera; `varyColors=1`; no explicit wireframe | 3 series × 3 categories; `Low band/East` is blank |
| `25-chart-surface3d-view3d` | style 2; `rotX=25`, `rotY=35`, `depth=125`, `perspective=54`, `rAngAx=0`; `wireframe=0` | same 3 × 3 mesh and same `Low band/East` blank |
| `26-chart-surface3d-default-tall-frame` | default camera; `varyColors=1`; no explicit wireframe | same 3 × 3 mesh and same `Low band/East` blank |

Thus the corpus exercises default versus authored camera, style 2 versus
styleless, wireframe default versus explicit off, and the tall frame, but it
does not provide an additional mesh size or blank-cell arrangement.

## Fresh reference measurements

All rows were freshly rendered at 1280×720 from the Release
`FreeP.RenderCompare` artifact and diffed against the committed PNG under
`tools/FreeP.RenderCompare/corpus/pptx-ref`. Every generated/reference pair
was 1280×720 and completed successfully.

### Surface3D positives

| Deck | WPF mean channel diff | Avalonia mean channel diff | Wave174 Avalonia delta |
| --- | ---: | ---: | ---: |
| `22-chart-baseline-depth` | 2.3911% | 2.1353% | 0.0000 pp |
| `25-chart-surface3d-view3d` | 2.7438% | 2.6220% | 0.0000 pp |
| `26-chart-surface3d-default-tall-frame` | 2.4757% | 2.2723% | 0.0000 pp |

The WPF and Avalonia values are identical to the Wave174 baseline. There is
therefore no measured Avalonia improvement available for a new shared change,
and no WPF regression gate to trade against.

### Negative controls

The following committed references were rendered in the same run. They contain
ordinary chart families or 3-D shape effects, not Surface3D facet scenes, so
they guard against leaking the alternate Surface3D path into unrelated
rendering:

| Control | WPF mean channel diff | Avalonia mean channel diff |
| --- | ---: | ---: |
| `06-charts`, slides 1–4 | 0.9846%, 1.2449%, 0.6149%, 1.2552% | 0.9375%, 1.1365%, 0.5839%, 1.1998% |
| `18-chart-types`, slides 1–4 | 0.4397%, 0.7202%, 1.0160%, 0.6549% | 0.4139%, 0.7641%, 0.9960%, 0.6725% |
| `11-bevel3d`, slide 1 | 1.0278% | 0.9536% |

All 10 negative-control pairs rendered successfully with matching dimensions;
none is a candidate for the Surface3D facet plan.

## Existing focused contracts

No behavior changed, so no new code test was necessary. The existing focused
contracts already cover the evaluated boundaries:

- `ChartBaselineCorpusTests` reads the 22 and 25 PowerPoint packages and checks
  the default blank-cell frame, authored camera, style, and wireframe state.
- `ChartRenderPlannerTests` covers blank-cell span/triangle preservation,
  authored camera projection, right-angle axes, tall default frames, and the
  non-canonical imported mesh palette.
- `ChartRenderCommandPlannerTests.Plan_UsesSharedAlternateSurfaceFacetsForBothRenderers`
  verifies that WPF and Avalonia consume the same shared alternate facet list.

## Next concrete rendering slice

First add and commit one PowerPoint-authored reference fixture with a genuinely
new Surface3D topology: a 4×4 default-camera mesh with no blank values and
`varyColors=1`. Capture its 1280×720 PowerPoint reference, then measure the
shared projection and facet ownership against both WPF and Avalonia while
retaining 22, 25, 26, and the negative controls as gates. A follow-up fixture
should move the blank to a different series/category cell. Until those
references exist, changing the generic camera, mesh, blank fallback, or a
comparison threshold would be unsupported by corpus evidence.

## Verification

- `dotnet build tools/FreeP.RenderCompare/FreeP.RenderCompare.csproj --configuration Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false -p:BuildInParallel=false /nr:false -m:1`: passed, 0 warnings, 0 errors.
- Fresh `--freep-render` and `--avalonia-render` plus `--diff` runs for 22, 25,
  26, 06, 18, and 11: 13 WPF/Avalonia render pairs, 13 reference pairs,
  26/26 renders and diffs successful, all dimensions 1280×720.
- Focused chart contract filter: passed, 40/40. The repository default test
  lane was started but hung in this worktree for more than 12 minutes with no
  CPU progress (`vstest` PID 18916; child `testhost` PID 32924; testhost about
  1.2 GB). Those two owned processes were stopped child-first. The default
  lane is non-required for this note-only, no-code-change slice; it also
  surfaced the unrelated existing `GridCaptureTests.CaptureGridRange_WritesPngAndJsonLog_ForNewWorkbook`
  empty-PNG failure before the hang.
- Evidence root: `artifacts/freep-wave175-surface3d-20260822` (ignored generated
  output; the committed references remain under `tools/FreeP.RenderCompare/corpus/pptx-ref`).
