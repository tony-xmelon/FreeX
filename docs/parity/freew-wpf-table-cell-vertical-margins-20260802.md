# FreeW WPF table cell vertical margins (2026-08-02)

## Result

Ordinary WPF table cells now consume authored per-cell vertical margins, then table-default margins, then Word's implicit zero-point top/bottom margins. The paginated-segment path retains its existing dedicated spacing ownership.

This replaces the ordinary WPF-only hard-coded 2-DIP top and bottom padding that inflated every automatic row even when the DOCX carried no vertical cell margin.

## Fresh Word evidence

Against the same fresh 816x1056 Word COM corpus, whole-page mean channel deltas improved on all 11 table fixtures:

| Fixture | Before | After |
| --- | ---: | ---: |
| 01-banded-rows-header | 1.2421% | 1.0055% |
| 02-banded-columns-firstlast | 0.9098% | 0.8331% |
| 03-header-row-styling | 1.1146% | 0.9852% |
| 04-custom-borders | 1.4741% | 1.2074% |
| 05-cell-shading | 1.4961% | 1.0946% |
| 06-merged-cells | 1.1871% | 1.1392% |
| 07-text-direction | 0.9173% | 0.8431% |
| 08-content-alignment | 1.0841% | 1.0014% |
| 09-wide-table | 1.2985% | 1.1907% |
| 10-nested-table | 1.1209% | 1.0530% |
| 11-column-widths-autofit | 2.1137% | 1.8701% |

On `05-cell-shading`, the table ROI `(80,110)-(740,270)` improved `11.8017% -> 8.5255%`. Word's horizontal borders are y=126/160/194/228; WPF moved from y=126/163/202/238 to y=126/159/194/226. Title ROI remained `1.4891%`, and the below-table control stayed pixel-identical.

## Verification

- Focused ordinary/paginated WPF margin contracts: 2/2 passed.
- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors.
- Fresh WPF composite renders: 11/11.
- Reused exact fresh Word COM references from the same source corpus and dimensions.

## Remaining residual

The row cadence is now within two pixels of Word on the measured fixture. WPF still distributes ordinary table columns differently from Word content autofit, which remains a separate geometry owner.
