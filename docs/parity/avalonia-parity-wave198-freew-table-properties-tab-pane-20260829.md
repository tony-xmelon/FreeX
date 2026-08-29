# FreeW Avalonia parity Wave198: shared tab-pane trailing frame

Date: 2026-08-29

## Scope

This slice targets the shared classic dialog tab template, using the FreeW Table
Properties route as the highest-value unexhausted native tab residual. Waves
192-197 covered Font checkbox chrome, About cadence, Legal Notices registration,
and Page Setup selector fill; the existing Wave198 Mark Index Entry change is
already present in the starting branch and is not duplicated here.

## Finding and correction

Fresh WPF and Avalonia captures showed the selected Table Properties pane was one
pixel wider on Avalonia in every state: `517x537` WPF versus `518x537` Avalonia.
The shared `ApplyClassicTabChrome` realization already consumes route-specific
negative horizontal compensation, but clamped a negative right margin to zero.
It now retains the shared one-pixel WPF pane frame on that trailing edge while
leaving positive and zero authority margins unchanged. The WPF renderer and
dialog behavior are untouched.

## Fresh paired evidence

The WPF authority and Avalonia host each captured all seven Table Properties
states (`7/7`, no unsupported captures). The corrected Avalonia capture retained
the same content gates and bounds. The direct before/after comparison used the
same fresh WPF authority manifest and route inventory.

| State | Before changed | After changed | Before mean | After mean |
| --- | ---: | ---: | ---: | ---: |
| `initial` | 31,664 | 31,127 | 6.766810 | 6.582567 |
| `populated` | 31,664 | 31,127 | 6.766810 | 6.582567 |
| `tab-cell` | 39,948 | 39,574 | 7.688064 | 7.527721 |
| `tab-column` | 9,064 | 8,589 | 2.201034 | 2.023082 |
| `tab-row` | 15,328 | 14,828 | 3.750567 | 3.570661 |
| `tab-table` | 31,664 | 31,127 | 6.766810 | 6.582567 |
| `validation-error` | 32,037 | 31,500 | 6.904758 | 6.720516 |
| **Total** | **191,369** | **187,872** |  |  |

Every state improved. Changed pixels fell by `3,497` (`1.8270%` relative),
and no state regressed in changed ratio, mean, p95, or semantic classification.
The canonical inventory remains `291` rows with `141` genuine visual
mismatches, `80` passes, and `70` Avalonia extensions; this route-local evidence
does not rewrite the parent-owned aggregate.

## Adjacent control

The shared rule was also measured against Borders and Shading, the other route
using negative horizontal pane compensation. All three states captured `3/3`
on both hosts and improved in the same fresh comparison:

| State | Before changed | After changed | Before mean | After mean |
| --- | ---: | ---: | ---: | ---: |
| `initial` | 35,412 | 34,876 | 6.058991 | 5.876692 |
| `populated` | 35,412 | 34,876 | 6.058991 | 5.876692 |
| `validation-error` | 35,716 | 35,180 | 6.181889 | 5.999591 |

## Auditable capture identity

- WPF authority manifest: `artifacts/wave198-freew-table-properties-baseline-wpf/wpf_dialog_capture_manifest.json`, SHA-256 `7ead01d76eef4e4b9de296877ecad5aae2ce8ba0a8d8a277684ec4fd5f6dc26d`.
- Table Properties corrected Avalonia manifest: `artifacts/wave198-freew-table-properties-trailing-frame-avalonia/avalonia_dialog_capture_manifest.json`, SHA-256 `41a52dd3e7a22536f45520d2c8f5ced8a37e473e6d4b1c4957f19a4e8da1a502`.
- Borders and Shading corrected Avalonia manifest: `artifacts/wave198-freew-borders-control-avalonia/avalonia_dialog_capture_manifest.json`, SHA-256 `63c217784963e78e5befa4cacafdf674f9716d95dfef2baa3a4665d5f87e2df9`.

The PNGs and route manifests remain disposable local capture artifacts; this
tracked note records their identities and the inspectable before/after metrics.

## Verification

- `DialogTabChromeParityTests`: `3/3` passed.
- FreeW `WpfAuthoritySurfaceParityTests|CommonDialogChromeParityTests`: `31/31` passed.
- Focused WPF/Avalonia route captures: Table Properties `7/7` each; Borders and Shading `3/3` each.
