# FreeW WPF table block-margin registration (2026-08-02)

## Result

Ordinary WPF flow tables now consume the same authored preferred-width/alignment margin plan as paginated table segments. The resolver reserves both leading and trailing slack for centered tables, trailing slack for left-aligned tables, and leading slack for right-aligned tables.

This also removes WPF's implicit ordinary-table block margin. On the measured `05-cell-shading.docx` fixture, the table top moved from y=138 to Word's y=126 while the title and below-table controls remained unchanged.

## Fresh Word evidence

All references were exported from Word 16.0 at 816x1056 through flat `C:\Temp` PDF staging. Whole-page mean channel deltas improved on every table fixture:

| Fixture | Before | After |
| --- | ---: | ---: |
| 01-banded-rows-header | 1.5497% | 1.2421% |
| 02-banded-columns-firstlast | 1.0725% | 0.9098% |
| 03-header-row-styling | 1.2731% | 1.1146% |
| 04-custom-borders | 1.5319% | 1.4741% |
| 05-cell-shading | 2.3604% | 1.4961% |
| 06-merged-cells | 1.3744% | 1.1871% |
| 07-text-direction | 1.1156% | 0.9173% |
| 08-content-alignment | 1.2626% | 1.0841% |
| 09-wide-table | 1.4622% | 1.2985% |
| 10-nested-table | 1.3315% | 1.1209% |
| 11-column-widths-autofit | 2.3470% | 2.1137% |

Targeted `05-cell-shading` table ROI `(80,110)-(740,270)` improved `18.8548% -> 11.8017%`. Title ROI remained `1.4891%`; below-table ROI remained pixel-identical.

## Verification

- Focused WPF block-margin contracts: 3/3 passed.
- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors.
- Fresh WPF composite renders: 11/11.
- Fresh Word COM exports: 11/11.

## Remaining residual

WPF still stretches ordinary table columns across its available surface and its automatic rows are taller than Word's. Column allocation and row cadence remain separate owner paths and were not changed in this slice.
