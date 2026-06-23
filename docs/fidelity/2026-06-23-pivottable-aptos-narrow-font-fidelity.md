# PivotTable Aptos Narrow Font Fidelity - 2026-06-23

## Scope

This pass continues local native PivotTable parity against desktop Microsoft Excel for the in-scope feature surface. External connections, Data Model pivots, and OLAP pivots remain excluded.

The native PivotTable corpus stores sheet cells with `font name="Aptos Narrow"` and `scheme="minor"`. Excel COM reports those visible cells as `Font.Name = Aptos Narrow`, even when the workbook theme's minor font is `Aptos`. FreeX previously resolved the theme scheme first, so rendered cells used the theme minor face and lost the explicit narrow face stored in the XLSX font record.

## Fixed Disparity

GridView font resolution now preserves explicit non-legacy font names that appear alongside a theme font scheme. Legacy `Calibri` placeholders still follow the workbook theme, preserving Theme Fonts behavior. When WPF cannot enumerate `Aptos Narrow`, the existing local fallback path maps it to `Arial Narrow` when the Office-compatible Windows font files are installed.

## Evidence

Excel COM probe on `Excel_native_pivot_basic_row_column_001.xlsx`:

```text
A5 text='East' bold=False name=Aptos Narrow size=11
B5 text='$2,360' bold=False name=Aptos Narrow size=11
E9 text='$28,730' bold=False name=Aptos Narrow size=11
```

Focused test:

```powershell
dotnet test tests\FreeX.App.UI.Tests\FreeX.App.UI.Tests.csproj --configuration Release --filter "FullyQualifiedName~GridViewThemeFontResolutionTests" --logger "trx;LogFileName=pivot-theme-font-resolution-tests.trx" --verbosity minimal
```

Result: `7 passed`.

Visual compare tool:

```powershell
dotnet build tools\FreeX.SheetGridImageCompare\FreeX.SheetGridImageCompare.csproj --configuration Release --no-restore
```

Result: `0 warnings`, `0 errors`.

Full native PivotTable visual corpus after the fix:

| Fixture | Diff |
| --- | ---: |
| Basic row/column | 5.8% |
| Calculated field/item | 2.2% |
| Date grouping | 7.5% |
| Filters/sorts | 3.3% |
| Grouping/show values | 4.4% |
| Layout options | 6.8% |
| Multiple pivots one cache | 2.0% |
| Report filters | 3.7% |
| Slicer/timeline | 2.4% |
| Table source filters | 4.4% |

Evidence root:

`C:\Users\ali\freex-xlsx-verify\visual\pivot-native-style-text-20260623\full-aptos-narrow`

All ten fixtures rendered with `Errors: 0` and exact Excel/FreeX PNG dimensions.

## Remaining Gaps

The one-decimal nearest-neighbor visual diffs remain unchanged. Exact-pixel counters improved in text-heavy cases, but the largest residuals still point to deeper WPF-vs-Excel text rasterization/placement differences and remaining PivotTable style-element details.
