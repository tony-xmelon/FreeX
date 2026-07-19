# FreeP DrawingML picture luminance composition parity

This slice addresses `15-picture-crop.pptx`, whose third slide carries the
authored DrawingML transform `<a:lum bright="30000" contrast="20000"/>`.
The existing shared planner added brightness before clamping and then applied
contrast to the clamped value. PowerPoint keeps the centered contrast pass
unclamped until the additive brightness adjustment is complete.

## Change

`PictureColorEffectPlanner` now applies the centered contrast transform first,
then adds the combined brightness offset, and clamps once at the end. The
brightness offset is scaled by half the authored contrast, matching the
PowerPoint operation order for the imported `30%/20%` payload. Both WPF and
Avalonia consume this shared plan; crop, grayscale, alpha, and frame paths are
unchanged.

## Fresh matched COM evidence

Candidate and baseline use the same `1280x720` PowerPoint COM export and fresh
Release renderer artifact. The only corpus fixture with an authored `a:lum`
payload is `15-picture-crop.pptx`.

| Slide | WPF before | WPF after | Delta |
| --- | ---: | ---: | ---: |
| Crop | 0.2719% | 0.2719% | 0.0000 pp |
| Grayscale | 0.2220% | 0.2220% | 0.0000 pp |
| Brightness + contrast | 1.0336% | 0.5463% | -0.4873 pp |
| Average | 0.5092% | 0.3468% | -0.1624 pp |

The fresh candidate `--avalonia-compare` also completed with WPF/Avalonia/
PowerPoint scores of `0.3468%`, `0.2117%`, and `0.3122%` respectively; the
three Avalonia slide scores were `0.2394%`, `0.1111%`, and `0.2848%`.

## Verification

- Focused picture planner tests: `8/8` passed.
- `FreeP.RenderCompare` Release build: `0` warnings, `0` errors.
- Fresh matched COM `--compare` and `--avalonia-compare`: all three slides
  exported successfully.
