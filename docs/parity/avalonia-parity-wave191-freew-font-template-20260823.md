# Avalonia Parity Wave 191: FreeW Font Combo Template

Date: 2026-08-23
Scope: FreeW Avalonia Font dialog, the three canonical states at the existing 460 x 340 logical target
Authority: fresh FreeW WPF `FontDialog` captures

## Finding

The fresh pre-change pair retained the Wave190 Font geometry and grayscale policy, but the
selected Color combo still used Avalonia's flat `#F0F0F0` surface and shared `#B7BCC2` input
border. WPF's native compact combo template painted the selected surface with the standard
vertical `#F0F0F0` to `#E5E5E5` gradient and a `#ACACAC` neutral border. The WPF Color combo
also registered one pixel earlier than Avalonia's native template. This was an app-owned
route/template discrepancy, separate from the remaining checkbox and glyph rasterization tail.

## Correction and controls

The Avalonia Font route now owns the WPF-authority combo gradient and neutral input border
locally. Its Color combo uses an Avalonia-only `0/-1/0/9` margin, moving the selected template
up one DIP while preserving the existing downstream field cadence. The WPF renderer, WPF
metrics, shared compact-dialog chrome, shared text raster policy, semantic planner, and
validation behavior are unchanged. The focused Avalonia contract test protects the gradient,
border, and existing control heights; the presentation test protects the route-local margin.

## Fresh paired evidence

Fresh WPF and Avalonia route captures were produced after the correction. Both hosts captured
`3/3` states at `460 x 383` capture pixels, with exact painted bounds of `421 x 321` on both
sides in every state.

| State | Before changed | After changed | Delta | Before ratio | After ratio | Before mean | After mean | After p95 | pHash |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `font.initial` | 14,724 | 11,846 | -2,878 | 8.357362% | 6.723805% | 7.050153 | 6.649145 | 42 | 0 |
| `font.populated` | 14,881 | 12,003 | -2,878 | 8.446475% | 6.812919% | 7.138302 | 6.737293 | 48 | 0 |
| `font.validation-error` | 15,082 | 12,204 | -2,878 | 8.560563% | 6.927006% | 7.292939 | 6.891931 | 54 | 0 |
| **Aggregate** | **44,687** | **36,053** | **-8,634** | **8.454800%** | **6.821243%** | **7.160465** | **6.759456** |  |  |

The accepted change removes `8,634` changed pixels, a `19.321055%` relative reduction, and
lowers mean channel delta by `0.401008` in every state. All three rows remain
`genuine-visual-mismatch`: the native checkbox, action-button, tab-template, and glyph raster
differences are still measured rather than reclassified.

The canonical refresh preserved all `288` non-Font rows structurally and retained the `512`
scenario inventory, `221` WPF captures, `291` Avalonia captures, and `291` comparison rows.
Classifications remain `141` genuine mismatches, `80` passes, and `70` Avalonia extensions.
Only the three existing `font.*` rows were replaced.

Canonical evidence is independently reviewable in the [comparison JSON](freew-dialog-harness/freew_dialog_visual_comparison.json), [comparison Markdown](freew-dialog-harness/freew_dialog_visual_comparison.md), [comparison HTML](freew-dialog-harness/freew_dialog_visual_comparison.html), and [freshness record](freew-dialog-harness/freew_dialog_visual_freshness.json).

## Verification

- Fresh WPF route capture: `3/3` captured and content-gated.
- Fresh Avalonia route capture: `3/3` captured and content-gated.
- `FontDialogPlannerTests` plus `DialogTextRasterizationPolicyTests`: `35/35` passed.
- `FontDialogVisualParityTests`: `4/4` passed.
- `FontDialogPolicySourceGuardTests`: `2/2` passed.
- Canonical inventory `--check`: passed (`180` routes, `512` scenarios).
- Canonical comparison `--check`: passed (`comparison current`).
- FreeW evidence consistency guard: passed (`291` rows; `141/80/70` classification counts).
- `git diff --check`: passed.

## Next residual

The largest remaining app-owned Font residual is the checkbox/effect text and indicator native
raster tail. The action-row and tab-pane edges remain native template differences. The WPF and
Avalonia capture manifests remain separate from the tracked canonical aggregate and retain the
freshness identities below:

- Inventory: `1dc5393abf5669426312aa2cb49a4a7a682d6d3e0fff26f11fc7fa3323b02f3c`
- WPF: `20f989245e53e7cb02ccd0302b784b9207c4e7ba5766c066b12e99e90e849af4`
- Avalonia: `97abb3649d348bdba48e0e547bba3bc2f471e12689db4029bd8cbcdc507cc496`
