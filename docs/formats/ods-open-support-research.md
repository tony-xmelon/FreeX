# Phase 3 ODS Open Support Research

**Status:** Parked; do not implement until ODS support is explicitly resumed.
**Last reviewed:** 2026-05-27

## Recommendation

Keep `.ods` support out of the active File formats implementation for now. FreeX should continue hardening `.xlsx/.xlsm/.xltx/.xltm`, delimited text, and read-only `.xls` before taking an ODS dependency.

If `.ods` is resumed, the preferred path is a small proof-of-concept adapter using GemBox.Spreadsheet behind an optional commercial dependency gate. That proof should validate basic values, dates, formulas-as-text/formulas-with-cached-results, merged cells, sheet names, and style loss expectations before any product integration. Avoid adding ODF Toolkit directly because it is Java-based, and avoid building an in-house ODS parser until there is a clear requirement for permissive licensing over fidelity and implementation speed.

## Options Reviewed

| Option | License / cost posture | Maintenance and platform fit | Read fidelity notes | Deployment impact | Fit for FreeX |
|---|---|---|---|---|---|
| GemBox.Spreadsheet | Free tier exists; full use requires a commercial developer license. | Current .NET library, no Microsoft Excel dependency, supports .NET / .NET Core / .NET Framework and WPF scenarios. | Official docs list ODS read and write alongside XLSX, XLS, XLSB, CSV, TSV, HTML, and SpreadsheetML. Best candidate for a fidelity proof. | Adds a proprietary package and license-management path. | Best technical fit if commercial licensing is acceptable. |
| Independentsoft ODF .NET | Commercial evaluation / purchase model. | Current .NET-focused ODF library; docs list .NET Framework 4.6+ and .NET 5 through .NET 10. | ODF-specific object model can parse spreadsheets, but it is not an XLSX-style workbook model. Mapping burden would remain high. | Adds proprietary package and a separate ODF model translation layer. | Viable fallback for ODF-native parsing, not first choice for XLSX-style fidelity. |
| Syncfusion XlsIO | Commercial or community-license route depending on eligibility; license key required for NuGet/trial assemblies. | Mature spreadsheet component with .NET packages. | Public comparison material lists XlsIO ODS support as absent while Interop has ODS support, so this is not a current ODS adapter candidate. | Would add a broad proprietary office suite dependency without satisfying the ODS need. | Not recommended for ODS open support. |
| ODF Toolkit | Apache-style open-source Java project under The Document Foundation. | Official project describes Java modules and Maven/JDK setup, not a .NET library. | Could parse ODF in a separate Java service or bridge, but that would be disproportionate for FreeX desktop file open support. | Requires Java runtime/process hosting or an interop bridge. | Not recommended for native FreeX integration. |
| NPOI / Apache POI lineage | NPOI targets Microsoft Office binary/Open XML formats. | Useful for Excel formats, but no primary ODS support path found. | ODS is outside the normal POI/NPOI spreadsheet scope. | No useful ODS deployment path. | Not recommended. |
| In-house ODS reader | FreeX-owned code. | Maximum control, no third-party runtime, but high maintenance cost. | Initial read-only support could map `content.xml` tables/cells, but formula, style, merged-cell, date, repeated-row/column, and namespace fidelity would need substantial corpus work. | No external license dependency; significant engineering and test-corpus cost. | Defer unless licensing rules exclude commercial libraries. |

## Minimum Resume Criteria

Before implementation resumes, choose one of these constraints explicitly:

- Commercial dependency allowed: prototype GemBox.Spreadsheet read-only `.ods` import.
- Commercial dependency not allowed: prototype a narrow in-house read-only ODS mapper and document unsupported surfaces up front.
- ODF-native fidelity required: prototype Independentsoft ODF .NET and compare mapping effort against GemBox.

Any resumed implementation should add an ODS-specific corpus folder with only generated or redistributable samples, plus expected-warning coverage for unsupported ODF features.

## Primary Sources

- GemBox.Spreadsheet product documentation: https://www.gemboxsoftware.com/spreadsheet
- GemBox.Spreadsheet NuGet package: https://www.nuget.org/packages/GemBox.Spreadsheet/49.0.1799
- Independentsoft ODF .NET documentation: https://www.independentsoft.de/odf/
- Syncfusion XlsIO NuGet/licensing documentation: https://help.syncfusion.com/file-formats/xlsio/nuget-packages-required
- Syncfusion XlsIO feature comparison: https://support.syncfusion.com/kb/article/6343/feature-comparison-of-interop-and-xlsio/
- ODF Toolkit project documentation: https://odftoolkit.org/
- ODF Toolkit source/build documentation: https://odftoolkit.org/source.html
