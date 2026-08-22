# FreeW Avalonia parity Wave175: Page Setup focus chrome

Date: 2026-08-22

## Scope

This slice targeted the six current canonical `page-setup` mismatch rows:
`initial`, `populated`, `validation-error`, `tab-margins`, `tab-paper`, and
`tab-layout`. WPF remained the visual authority. Wave174 symbol-picker evidence was
excluded.

## Diagnosis and implementation

Fresh source captures showed a product-side focus-chrome mismatch. WPF keeps the
keyboard-focused compact input border blue (`#569DE5`) even while the product button
accent is themed. Avalonia was substituting the FreeW brand accent for that input ring.

The shared compact-dialog authority now exposes `FocusedInputBorderHex` as `#569DE5`,
and the Avalonia Page Setup chrome consumes it. WPF behavior and the comparison
thresholds were unchanged.

## Evidence

Fresh route-only evidence:

- Before WPF: `artifacts/wave175-freew-page-setup-20260822/before/wpf/wpf_dialog_capture_manifest.json`
- Before Avalonia: `artifacts/wave175-freew-page-setup-20260822/before/avalonia/avalonia_dialog_capture_manifest.json`
- Before comparison: `artifacts/wave175-freew-page-setup-20260822/before/compare/freew_dialog_visual_comparison.json`
- After WPF: `artifacts/wave175-freew-page-setup-20260822/after/wpf/wpf_dialog_capture_manifest.json`
- After Avalonia: `artifacts/wave175-freew-page-setup-20260822/after/avalonia/avalonia_dialog_capture_manifest.json`
- After comparison: `artifacts/wave175-freew-page-setup-20260822/after/compare/freew_dialog_visual_comparison.json`

Both fresh routes captured 6/6 scenarios with 0 unsupported captures.

| Pair | Before changed ratio | After changed ratio | Before mean channel delta | After mean channel delta |
| --- | ---: | ---: | ---: | ---: |
| `page-setup.initial` | 9.6771% | 9.6634% | 6.257370 | 6.097939 |
| `page-setup.populated` | 9.6771% | 9.6634% | 6.257370 | 6.097939 |
| `page-setup.validation-error` | 9.7827% | 9.7690% | 6.373618 | 6.214187 |
| `page-setup.tab-margins` | 9.6771% | 9.6634% | 6.257370 | 6.097939 |
| `page-setup.tab-paper` | 4.4592% | 4.4592% | 2.988298 | 2.988298 |
| `page-setup.tab-layout` | 6.6881% | 6.6881% | 4.588944 | 4.588944 |

The canonical report remains 141 genuine visual mismatches, 80 passes, and 70 Avalonia
extensions across 291 rows. The six Page Setup rows remain genuine mismatches; the
remaining delta includes native template and text rasterization differences.

## Verification

- WPF harness build: succeeded, 0 warnings, 0 errors.
- Avalonia harness build: succeeded, 0 warnings, 0 errors.
- Focused `PageSetupDialogVisualParityTests`: 7 passed, 0 failed.
- Canonical comparison merge: generated JSON, Markdown, HTML, and freshness evidence
  through `compare --refresh-route page-setup`; expected exit 1 because unrelated
  canonical mismatches remain.
- No threshold or hand-edited generated JSON changes were made.
