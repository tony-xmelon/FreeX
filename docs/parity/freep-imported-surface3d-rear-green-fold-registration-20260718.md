# FreeP imported Surface3D rear-green fold registration

Date: 2026-07-18

## Fixture

`tools/FreeP.RenderCompare/corpus/22-chart-baseline-depth.pptx`, slide 1,
matched 1280x720 PowerPoint COM and FreeP WPF/Avalonia renders.

## Change

The small imported rear-green fold face (`#81A16E`) was registered three
normalized DIPs too high in both renderers. Its visual-only boundary polygon
now uses `(194,76),(238,98),(201,72)`, from `(194,73),(238,95),(201,69)`.
The change is limited to the imported 3-by-3 Surface3D boundary path; authored
Surface3D charts and other chart families are unchanged.

## ROI evidence

The candidate and accepted baseline used the same fresh PowerPoint PNG
(`slide-01.png` from the current COM export).

| Backend / ROI | Before | After |
| --- | ---: | ---: |
| WPF whole page | 2.6240% | 2.6226% |
| WPF Surface `(560,90)-(1030,310)` | 5.2442% | 5.2317% |
| WPF tight mesh `(590,105)-(980,300)` | 6.4496% | 6.4325% |
| WPF rear-green `(780,125)-(970,270)` | 4.6978% | 4.6507% |
| Avalonia whole page | 2.3302% | 2.3288% |
| Avalonia Surface `(560,90)-(1030,310)` | 5.1916% | 5.1786% |
| Avalonia tight mesh `(590,105)-(980,300)` | 6.4410% | 6.4234% |
| Avalonia rear-green `(780,125)-(970,270)` | 4.5567% | 4.5079% |

The exact `#81A16E` mask moved from y `175..195` to `178..198`, matching the
PowerPoint top registration at y `178` while preserving the existing x range.
The low-band ROI was byte-stable in WPF and Avalonia. The neighboring stock,
scatter, and 100%-stacked chart paths are fixture-dispatched separately and
remain unchanged.

## Verification

- Focused compiling `ChartBaselineCorpusTests`: 24/24.
- RenderCompare Release build: 0 warnings, 0 errors.
- Fresh WPF and Avalonia renders completed with healthy pixel diversity.
- PowerPoint COM export completed without repair or hang.

Process rule: for small imported 3-D boundary faces, use exact-color masks to
separate vertical registration from area/width errors, then gate the change on
both backends, whole page, adjacent flow bands, and the fixture dispatch.
