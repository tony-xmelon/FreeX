# Phase 3 ODS Open Support Research

**Status:** Historical research; superseded by the in-house ODS adapter now registered in `WorkbookFileAdapterCatalog`.
**Last reviewed:** 2026-06-21

## Recommendation

Retain this document as the original May 2026 decision record and dependency survey. It is no longer the active product position: current FreeX mainline includes an in-house ODS adapter with read/write support and test coverage. New ODS work should extend that adapter, corpus coverage, and documented known-gap rows rather than revisit a proprietary dependency proof by default.

The options below remain useful only as historical context if a future ODF-fidelity effort needs to compare the in-house path against commercial or external ODF libraries.

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
