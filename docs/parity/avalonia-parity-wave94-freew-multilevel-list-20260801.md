# FreeW Multilevel List Parity Wave 94

Date: 2026-08-01

## Scope

Refreshed the WPF-authority comparison for the Define New Multilevel List
dialog after the Wave91 Avalonia chrome alignment. The previous canonical
report still contained the pre-alignment roughly 14% mismatch and therefore
overstated the remaining FreeW visual work.

## Result

Fresh paired WPF/Avalonia captures at 96 DPI classify all three states as
`pass`:

| State | Changed pixels | Mean channel delta | pHash distance |
| --- | ---: | ---: | ---: |
| Initial | 2.77% | 2.45 | 0 |
| Populated | 2.77% | 2.45 | 0 |
| Validation error | 2.92% | 2.65 | 0 |

The tracked report was refreshed only for the `multilevel-list` route. The
Avalonia dialog continues to use the WPF authority's 380px outer width,
compact control metrics, combo-box chrome, action-row spacing, default/cancel
semantics, and validation focus behavior.

## Verification

- WPF focused captures: 3/3 captured.
- Avalonia focused captures: 3/3 captured.
- Focused dialog tests: `MultilevelListDialogVisualParityTests`, 3 passed.
- Canonical `--baseline --refresh-route multilevel-list --check`: passed with
  one focused WPF manifest and one focused Avalonia manifest, each containing
  all three states. The manifests are intentionally temporary, matching the
  established dialog-evidence workflow; their hashes are recorded in the
  tracked freshness sidecar.
- No Docker or broad solution build was used.

The separate full inventory `--check` remains stale before this slice: the
tracked inventory has 158 routes and 466 scenarios, while current source
regenerates 161 routes and 475 scenarios. That inventory drift is outside this
route refresh and was not folded into this commit.

## Residuals

The remaining pixel delta is limited to native frame reservation,
Avalonia/WPF text rasterization, and the control-template color palette. No
functional or state mismatch remains in this dialog route. The broader FreeW
report still contains unrelated dialog mismatches; those are outside this
slice.
