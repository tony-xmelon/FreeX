# Avalonia Parity Wave 190: FreeW Font Cadence

Date: 2026-08-23
Scope: FreeW Avalonia Font dialog, the three canonical states at the existing 460 x 340 logical target
Authority: fresh FreeW WPF `FontDialog` captures

## Selection and finding

The fresh pre-change pair retained the Wave189 Font residual after grayscale text rendering and
painted-bounds alignment. The largest app-owned residual was the Font-tab vertical cadence:
Avalonia labels accumulated a one-pixel row loss, the effects rows used a larger trailing cadence,
and the action row was shorter/registered early relative to the WPF control templates. The issue
was isolated to Font realization metrics; shared compact chrome and Legal Notices were left alone.

## Correction

The shared `FontDialogVisualMetrics` contract now gives Avalonia a 17-DIP label line box, a 2-DIP
Font-tab top compensation, Font effects-label margins of `2/1` DIP, a 2-DIP Avalonia-only effect
row trailing margin, a 13-DIP action-row top margin, and the WPF-painted 26-DIP action-button
height. The existing WPF `EffectBottomMargin` remains `4` DIP; the Avalonia compensation is a
separate metric so the authority is not changed. The Font route-local grayscale policy remains
explicit. Paragraph and other compact dialogs retain the shared rasterization/template policy.

## Fresh paired evidence

Evidence is route-local and ignored by Git:

- Before WPF: `artifacts/wave190-freew-before/wpf`
- Before Avalonia: `artifacts/wave190-freew-before/avalonia`
- Before comparison: `artifacts/wave190-freew-before/compare`
- Final WPF: `artifacts/wave190-freew-final3/wpf`
- Final Avalonia: `artifacts/wave190-freew-final3/avalonia`
- Final comparison: `artifacts/wave190-freew-final3/compare`

Both paired runs captured `3/3` WPF and `3/3` Avalonia states at `460 x 383` capture pixels.
Every final state has exact WPF/Avalonia painted bounds of `421 x 321`.

| State | Before changed | After changed | Delta | Before ratio | After ratio | Before mean | After mean |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `font.initial` | 19,013 | 14,724 | -4,289 | 10.791804% | 8.357362% | 9.382329 | 7.050153 |
| `font.populated` | 19,177 | 14,881 | -4,296 | 10.884890% | 8.446475% | 9.481988 | 7.138302 |
| `font.validation-error` | 19,430 | 15,082 | -4,348 | 11.028494% | 8.560563% | 9.677039 | 7.292939 |
| **Aggregate** | **57,620** | **44,687** | **-12,933** | **10.901729%** | **8.454800%** | **9.513785** | **7.160465** |

The accepted change removes `12,933` changed pixels, a `22.4453%` relative reduction. All three
states improve in both changed-pixel count and mean channel delta. The rows remain
`genuine-visual-mismatch`: this is a measured Font geometry/template improvement, not a claim of
complete WPF/Avalonia raster parity. Native framework glyph and control rasterization residuals
remain. The route-local compare still reports the intentionally supplied 512-row inventory scope
with `3` genuine mismatches, `70` invalid-capture-content rows outside the captured route, and
`218` product-parity-gap rows outside this route; those counts are not a canonical dashboard refresh.

## Verification

- WPF harness Release build: passed, 0 warnings, 0 errors.
- Avalonia harness Release build: passed, 0 warnings, 0 errors.
- Fresh WPF route capture: `3/3` captured and content-gated.
- Fresh Avalonia route capture: `3/3` captured and content-gated.
- Route-local compare: `3` genuine mismatches; all three improved; bounds exact at `421 x 321`.
- `FontDialogPlannerTests` plus rasterization source guards: `35/35` passed.
- `FontDialogVisualParityTests` plus `LegalNoticesDialogVisualParityTests`: `18/18` passed.
- `git diff --check`: passed.

The next measured FreeW residual remains the Legal Notices glyph/template tail. Cross-app dashboard
and integration notes were not edited.
