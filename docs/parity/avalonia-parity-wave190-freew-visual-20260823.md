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

The accepted final captures were merged through the harness's canonical `--baseline` plus
`--refresh-route font` path. The committed evidence is independently reviewable in:

- [comparison JSON](freew-dialog-harness/freew_dialog_visual_comparison.json)
- [comparison Markdown](freew-dialog-harness/freew_dialog_visual_comparison.md)
- [comparison HTML](freew-dialog-harness/freew_dialog_visual_comparison.html)
- [freshness record](freew-dialog-harness/freew_dialog_visual_freshness.json)

The freshness record identifies the canonical inventory as
`fffe0fadc92c242ef1296748776322bff67179dc62536ba0463c51582c5c938f`, the fresh WPF
manifest as `be368ea90e71f8c960c07fe141498c30a86b8368f2f7c711b78657d9e2cda828`, and the
fresh Avalonia manifest as `2a6b3c03b81a171db44b2dd974f75ab50cd665fb57441a7d0cd47ad98951eb03`.

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
remain. The canonical refresh preserves all `288` non-Font rows structurally and retains the
`512`-scenario inventory, `221` WPF captures, `291` Avalonia captures, and `291` comparison rows.
Its classifications remain `141` genuine mismatches, `80` passes, and `70` Avalonia extensions;
only the three existing `font.*` rows were replaced. No dashboard claim or classification count
changed.

## Verification

- WPF harness Release build: passed, 0 warnings, 0 errors.
- Avalonia harness Release build: passed, 0 warnings, 0 errors.
- Fresh WPF route capture: `3/3` captured and content-gated.
- Fresh Avalonia route capture: `3/3` captured and content-gated.
- Route-local compare: `3` genuine mismatches; all three improved; bounds exact at `421 x 321`.
- Canonical route refresh: passed the 288-row non-Font structural-identity check and preserved
  `512/221/291/291` scenario, WPF capture, Avalonia capture, and row accounting.
- Canonical refresh generation exited `2` because the three rows remain genuine mismatches;
  the subsequent deterministic compare `--check` exited `0` (`comparison current`).
- Canonical inventory `--check`: exited `0` (`inventory current`) with `180` routes and
  `512` unchanged scenario bodies.
- FreeW evidence consistency guard: passed for `291` rows (`141` mismatch, `80` pass,
  `70` extension).
- `FontDialogPlannerTests` plus rasterization source guards: `35/35` passed.
- `FontDialogVisualParityTests` plus `LegalNoticesDialogVisualParityTests`: `18/18` passed.
- `git diff --check`: passed.

The next measured FreeW residual remains the Legal Notices glyph/template tail. Cross-app dashboard
and integration notes were not edited.
