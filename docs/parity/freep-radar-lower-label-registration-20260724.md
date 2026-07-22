# FreeP imported radar lower-label registration, 2026-07-24

## Scope

The imported five-category radar in `18-chart-types.pptx` uses a nine-ring
PowerPoint radar plan. Its mesh and series geometry were already close, but WPF
placed the lower `Agility` and `Stamina` labels inside the angled spoke band.
Avalonia's shared plan was already the accepted output, so the correction stays
in the WPF radar paint route and is guarded by the nine-ring, five-label,
two-series plan signature.

## Evidence

Fresh 1280x720 PowerPoint COM comparison:

| Slide | WPF-vs-PP before | WPF-vs-PP after | WPF-vs-Avalonia after | Avalonia-vs-PP after |
| --- | ---: | ---: | ---: | ---: |
| 1 | 0.4348% | 0.4348% | 0.3365% | 0.4139% |
| 2 | 0.7188% | 0.7188% | 0.2233% | 0.7697% |
| 3 radar | 1.2063% | 1.1738% | 0.4686% | 1.1763% |
| 4 | 0.6742% | 0.6742% | 0.2463% | 0.7026% |
| Mean | 0.7585% | 0.7504% | 0.3187% | 0.7656% |

The WPF radar improvement is `0.0325` percentage points. All three unrelated
slides are unchanged. Avalonia-vs-PowerPoint remains `1.1763%` on the radar
slide, and Avalonia output for all four slides is SHA-256 identical to the
current-main control render.

## Verification

- PowerPoint COM export: 4/4 slides.
- RenderCompare Release build: 0 warnings, 0 errors.
- Focused renderer-neutral source contract: pending final test run.
