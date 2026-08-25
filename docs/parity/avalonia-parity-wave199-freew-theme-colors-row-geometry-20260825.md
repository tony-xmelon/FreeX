# Wave 199 — FreeW Customize Theme Colors row geometry

## Scope

This pass aligns the Avalonia **Create New Theme Colors** dialog with the
existing WPF implementation. Ink/Draw behavior and map-chart fidelity remain
explicitly out of scope for the wider parity goal.

## Change

`CustomizeThemeColorsDialogVisualMetrics.AvaloniaColorRowHeight` is now 28 DIP
instead of 29.4 DIP. The prior value accumulated roughly 1.4 DIP of excess
height over each of the twelve color rows, moving the Name field and action row
below their WPF-authority positions.

## Evidence

Fresh paired captures are retained under
`artifacts/wave199-freew-customize-theme-colors`.

| Scenario | Changed pixels before | Changed pixels after | Mean channel delta before | after |
| --- | ---: | ---: | ---: | ---: |
| initial | 35,092 | 27,754 | 8.5505 | 5.9726 |
| populated | 35,092 | 27,754 | 8.5505 | 5.9726 |
| validation-error | 35,182 | 27,816 | 8.5872 | 5.9935 |

All three WPF/Avalonia states were captured; none are unsupported. The remaining
differences are native text/control rasterization and do not justify a broader
chrome rewrite.

## Verification

- WPF and Avalonia dialog harness builds: passed, zero warnings/errors.
- `DesignDialogPlannerTests`: 19/19 passed.
- `DesignDialogParityTests`: 9/9 passed.
- `DesignDialogParitySourceTests`: 2/2 passed.
