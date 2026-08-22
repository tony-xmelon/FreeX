# FreeW Wave177 Multilevel List Parity

Date: 2026-08-22

## Scope

This slice aligns the Avalonia `multilevel-list` dialog with the WPF-authoritative
initial, populated, and validation-error states. The production change is route-local:
it uses the shared Windows-style dialog chrome and tokens, then applies only the
authority metrics that differ for this fixed prompt. The WPF visual harness now also
populates this route before capture so the validation fixture is paired with the
Avalonia `not-a-number` state instead of capturing the WPF default value.

## Result

Fresh captures were generated for all three states on both hosts at 380 x 437 pixels.
The route-local comparison changed as follows:

| State | Before | After | Mean channel delta after | pHash |
| --- | ---: | ---: | ---: | ---: |
| initial | 16.1195% | 3.9546% | 4.0341 | 0 |
| populated | 16.1195% | 3.9546% | 4.0341 | 0 |
| validation-error | 16.2779% | 4.1696% | 4.2713 | 0 |

The final canonical report is regenerated at
`docs/parity/freew-dialog-harness/freew_dialog_visual_comparison.json` (with its
generated Markdown, HTML, and freshness files). Aggregate classifications remain
141 genuine visual mismatches, 80 passes, and 70 Avalonia extensions across 512
scenarios; only these three route rows were refreshed.

## Verification

- `MultilevelListDialogVisualParityTests`: 3 passed.
- `FreeW.App.Presentation.Tests` filtered to `MultilevelListDialog`: 8 passed.
- `FreeW.App.Host.Tests` filtered to `MultilevelList`: 6 passed.
- WPF harness: 3 captured, 0 unsupported.
- Avalonia harness: 3 captured, 0 unsupported.

The canonical comparison intentionally remains classified as a genuine visual
mismatch: Avalonia and WPF use different text rasterizers. The residual is primarily
text antialiasing plus a one-pixel content-bound offset (WPF x14,y17,337x368;
Avalonia x14,y18,337x367). No semantic, focus, validation, or action-order difference
was observed.

No shared cross-app production files were changed for this slice.
