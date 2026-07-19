# FreeP bullets autofit body vertical raster probe rejected - 2026-07-18

## Scope

The current WPF `17-bullets-autofit.pptx` slide 2 body contains eight fixed
18pt Aptos paragraphs in an `a:noAutofit` text box. A WPF-only probe applied a
0.86 vertical raster scale and a -2 DIP translation to that exact eight-line
signature, leaving the accepted title calibration and Avalonia unchanged.

## Matched COM evidence

Fresh PowerPoint COM export and current Release render at 1280x720:

| Backend / ROI | Before | Candidate |
| --- | ---: | ---: |
| WPF slide 1 whole-page control | 1.0498% | 1.0498% |
| WPF slide 2 whole page | 3.2806% | 3.6323% |
| Avalonia slide 2 whole page | 3.1232% | 3.1232% |

The candidate was rejected because the body raster adjustment worsened the
complete affected slide despite matching the broad raw ink-band diagnosis.
The title and slide-1 control remained stable, so the probe was isolated. It
was reverted; no shared text planner or Avalonia change is warranted.

## Verification

- Focused compiling presentation tests: 113 passed, 0 failed.
- `FreeP.RenderCompare` Release build: 0 warnings, 0 errors.
- Fresh COM export: 2/2 slides exported successfully.
- Candidate and control renders were produced from the rebuilt Release artifact.
