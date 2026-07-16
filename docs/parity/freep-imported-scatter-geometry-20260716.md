# FreeP Imported Scatter Geometry

## Scope

PowerPoint COM parity for the imported scatter chart in `22-chart-baseline-depth.pptx`, slide 1.

## Finding

After the X-axis interval fix, the scatter grid still began about four pixels too far left and extended slightly too far right at the 1280x720 capture size. The mismatch was systematic across both WPF and Avalonia renders.

## Change

Adjusted the imported scatter plot's left and right insets to align its projected plot rectangle with PowerPoint while leaving the generic scatter frame unchanged. The corpus regression records the resulting frame geometry.

## Verification

- Focused chart tests: `181/181` passed.
- RenderCompare build: `0` warnings, `0` errors.
- WPF slide 1: `4.4334%` -> `4.4202%` mean channel diff.
- Avalonia slide 1: `4.4125%` -> `4.4014%` mean channel diff.
- Final renders and heatmaps: `artifacts/freep-scatter-geometry-tuned-20260716/`.
