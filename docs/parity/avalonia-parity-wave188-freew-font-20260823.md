# Avalonia Parity Wave 188: FreeW Font Dialog

Date: 2026-08-23
Scope: FreeW Avalonia Font dialog, three canonical states at 460 x 340 logical pixels
Authority: FreeW WPF `FontDialog`

## Selection

Wave187's remaining Legal Notices tail was tested first using fresh current-source pairs. A
one-pixel Avalonia read-only document trailing reserve was applied to both compact and
overflowing notices. The six-state aggregate changed pixels moved from `324,946` to `324,955`
and the long states were unchanged, so the probe was rejected as framework raster noise and
fully reverted. Its evidence remains in the ignored route-local artifacts for audit:
`artifacts/wave188-freew-legal-before-comparison` and
`artifacts/wave188-freew-legal-after-comparison`.

Font was the next bounded product-owned family. The fresh before pair showed WPF painted bounds
of `421 x 321` and Avalonia bounds of `423 x 313` in all three states, with an aggregate of
`61,396` changed pixels.

## Correction

The shared `FontDialogVisualMetrics` contract now gives Avalonia the measured WPF-equivalent
right lane, bottom tab cadence, and action-row cadence. Avalonia field and effects labels use a
16 DIP line box, matching the WPF label registration. WPF layout, shared semantic planners,
control behavior, and validation behavior are unchanged.

## Fresh paired evidence

Fresh WPF and Avalonia captures were produced from this checkout after the correction at the
same 460 x 340 logical target. The final route-local comparison is in
`artifacts/wave188-freew-font-final2-comparison`; final manifests are in
`artifacts/wave188-freew-font-final2-wpf` and
`artifacts/wave188-freew-font-final2-avalonia`.

| State | Before changed | After changed | Before ratio | After ratio | Before mean | After mean | Bounds after |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| `font.initial` | 20,255 | 19,358 | 11.496765% | 10.987626% | 9.883220 | 9.381018 | WPF/AV `421 x 321` / `421 x 321` |
| `font.populated` | 20,430 | 19,533 | 11.596095% | 11.086957% | 9.980866 | 9.478664 | WPF/AV `421 x 321` / `421 x 321` |
| `font.validation-error` | 20,711 | 19,814 | 11.755591% | 11.246452% | 10.175608 | 9.673406 | WPF/AV `421 x 321` / `421 x 321` |
| **Aggregate** | **61,396** | **58,705** | **11.616150%** | **11.107012%** | **10.013231** | **9.511029** | **exact painted bounds** |

The accepted change removes `2,691` changed pixels, a `4.3830%` relative reduction, and lowers
average mean channel delta by `0.502202`. All three states improve identically. They remain
`genuine-visual-mismatch` rows because native WPF/Avalonia text and control rasterization still
differs; this is not a claim of complete visual parity.

## Verification

- Avalonia `FontDialogVisualParityTests` plus `LegalNoticesDialogVisualParityTests`: 17/17 passed.
- Shared `FontDialogPlannerTests`: 31/31 passed.
- Avalonia dialog harness Release build: 0 warnings, 0 errors.
- Fresh final WPF route capture: 3/3 captured, 0 unsupported.
- Fresh final Avalonia route capture: 3/3 captured, 0 unsupported/content failures.
- Canonical route refresh: 512 scenarios, 221 WPF captures, 291 Avalonia captures; 141 genuine visual mismatches, 80 passes, and 70 Avalonia extensions.
- `tools/Test-FreeWDialogVisualEvidence.ps1`: passed.

Next residual: the remaining Font native text/control rasterization, followed by the Legal Notices
glyph/template tail and the classified pagination, drawing/object, chart, table, and WordArt
families.
