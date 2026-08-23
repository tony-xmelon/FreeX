# FreeP Wave187 Surface3D authored-camera parity

Date: 2026-08-23
Source revision: `8e5f6c82da`
Corpus: 27 decks / 53 slides, 1280x720, committed PowerPoint PNG references

## Accepted correction

The shared compositor's measured `25/35` degree Surface3D facet changed one
Office-backed vertex from `(283,133)` to `(247,133)` in
`BuildExplicitSurfaceRenderFacets`. This is gated to the exact authored
`25-chart-surface3d-view3d` signature; default cameras, generic Surface3D
meshes, WPF/Avalonia execution profiles, and non-Surface3D charts do not use
this facet list.

## Target evidence

The direct current-source baseline was rendered before the change from the
same branch. The accepted candidate was rendered again after the change.

| Comparison | Before | After | Delta |
| --- | ---: | ---: | ---: |
| Deck25 WPF vs Office | 2.7438% | 2.7032% | -0.0406 pp |
| Deck25 Avalonia vs Office | 2.6220% | 2.5815% | -0.0405 pp |
| Deck25 WPF vs Avalonia | 1.0805% | 1.0804% | -0.0001 pp |

The pinned pre-Wave174 reference values were WPF `2.7438%`, Avalonia
`2.9238%`, and pair `1.5828%`; the lower current-branch Avalonia/pair
baseline includes the already accepted Wave174 shared-facet correction.

## Controls and recalibration

Deck26, which uses the default imported-camera path, remained:

| Comparison | Result |
| --- | ---: |
| Deck26 WPF vs Office | 2.4757% |
| Deck26 Avalonia vs Office | 2.2723% |
| Deck26 WPF vs Avalonia | 1.0104% |

The four-slide `06-charts` control remained byte-stable. WPF Office deltas
were `0.9846%, 1.2449%, 0.6149%, 1.2552%`; Avalonia deltas were
`0.9375%, 1.1365%, 0.5839%, 1.1998%`; pair deltas were
`0.4242%, 0.3599%, 0.2974%, 0.4455%`. Their SHA-256 hashes match the
Wave186 controls exactly.

The exploratory 53-slide corpus pass was captured with the rejected `x = 260`
vertex. Applying the final deck25 `x = 247` delta arithmetically to that pass
produces these diagnostic estimates:

| Aggregate | Result |
| --- | ---: |
| WPF vs Office average / maximum | 1.0439% / 3.0587% |
| Avalonia vs Office average / maximum | 1.0118% / 2.5815% |
| WPF vs Avalonia average / maximum | 0.6249% / 2.9091% |

These estimates are not a canonical recalibration. The retained detail rows in
`freep-powerpoint-recalibration-2026-08-15.json` are the internally consistent
Wave186 historical set; they were not all rerendered with the final `x = 247`
source revision. The cross-app dashboard must therefore continue consuming the
canonical Wave186 summary:

| Aggregate | Canonical Wave186 result |
| --- | ---: |
| WPF vs Office average / maximum | 1.0447% / 3.0587% |
| Avalonia vs Office average / maximum | 1.0124% / 2.9238% |
| WPF vs Avalonia average / maximum | 0.6248% / 1.6684% |

The canonical JSON source revision, summary, and detail rows intentionally
remain unchanged. Only the directly measured deck25 before/after rows and the
deck26/`06-charts` controls above are authoritative Wave187 evidence.

## Rejected experiment

The x=260 vertex measured `2.7156%` WPF/Office and `2.5938%`
Avalonia/Office, so it was rejected in favor of x=247. A curved green-facet
experiment also worsened both Office rows and was reverted.

## Verification

- `FreeP.App.Presentation.Tests`: 277/277 passed for the chart planner and
  corpus filters.
- `FreeP.App.Rendering.Avalonia.Tests`: 285/285 passed.
- `FreeP.RenderCompare` Release build: 0 warnings, 0 errors.
- Worktree source change is committed; generated render artifacts are
  intentionally ephemeral and removed after measurement.
