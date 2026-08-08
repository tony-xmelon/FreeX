# FreeX Native JSON Schema

FreeX `.fxl` files are UTF-8 JSON documents written by `NativeJsonAdapter`. The format is intended to be human-readable, stable enough for project fixtures, and explicit about reader compatibility. The current schema version is `2`.

## Compatibility Header

Every newly saved native JSON workbook writes these root properties:

| Property | Type | Meaning |
|---|---|---|
| `FileFormat` | string | Must be `FreeX.NativeJsonWorkbook` for versioned files. Legacy unversioned files may omit it. |
| `SchemaVersion` | number | Writer schema version. Current value: `2`. Bumped 1 -> 2 (R72-meta-1): schema version 2 marks the point at which an explicit conditional-format data-bar Min/Max threshold type is trusted as-is on load; only a loaded schema version still below 2 (a genuine pre-r70/legacy save) has its legacy Min/Max data-bar endpoint migrated to AutoMin/AutoMax. |
| `MinimumReaderVersion` | number | Oldest reader schema version that may safely load the file. Current value: `1`. |

Legacy unversioned files are accepted as pre-v1 documents (schema version is treated as `1` when the field is missing) and are migrated by save into the current header. Files with unsupported future versions are rejected until an explicit migration path is implemented.

## Workbook Root

The root object stores workbook-wide state:

| Property | Type | Notes |
|---|---|---|
| `Name` | string | Workbook display name. |
| `Theme` | object | Workbook theme colors and fonts. |
| `IsStructureProtected` | bool | Workbook structure protection state. |
| `StructureProtectionPassword` | string/null | Stored only when structure protection is enabled. |
| `WindowArrangement` | enum/null | Stored workbook window arrangement. Invalid values are ignored. |
| `CalculationMode` | enum/null | Workbook calculation mode. |
| `FullCalculationOnLoad` | bool | Workbook recalculation hint. |
| `DisabledFormulaErrorCodes` | string[] | Supported error-checking codes only. |
| `NamedRanges` | object[] | Workbook named ranges. |
| `WatchedCells` | object[] | Watch Window entries. |
| `Scenarios` | object[] | Scenario Manager definitions. |
| `CustomViews` | object[] | Workbook custom views. |
| `CellStyles` | object[]/null | Workbook-level cell style table. Cell and style-only entries may reference this table by zero-based `StyleId`. |
| `DefaultStyle` | object/null | The customized default style (style 0) when it differs from the built-in Calibri default — e.g. an XLSX whose workbook default font is "Aptos Narrow" with `FontScheme=Minor`. Restored into slot 0 on load so style-0 cells keep their font. Absent when the workbook uses the built-in default. |
| `Sheets` | object[] | Worksheet payloads. |

## Workbook Theme

`Theme` stores the workbook theme name, font family choices, effect-set name, and color slots. Colors are serialized as `#RRGGBB`; theme-color references use a color slot plus optional tint.

For XLSX fidelity, `Theme` also carries native DrawingML fragments when a workbook came from, or is intended to round-trip back to, `xl/theme/theme1.xml`:

| Property | Type | Notes |
|---|---|---|
| `NativeColorSchemeXml` | string/null | Preserved `<a:clrScheme>` XML, including custom transforms and scheme metadata. |
| `NativeFontSchemeXml` | string/null | Preserved `<a:fontScheme>` XML, including East Asian, complex-script, and script-specific font entries. |
| `NativeFormatSchemeXml` | string/null | Preserved `<a:fmtScheme>` XML, including effect, line, fill, and background-fill details; FreeX interprets the first `outerShdw`/`prstShdw` effect style for non-chart drawing-object theme shadows and preserves deeper details for XLSX save. |
| `NativeThemeSupplementXml` | string/null | Preserved theme-level DrawingML elements outside `themeElements`, such as object defaults, alternate color scheme lists, custom color lists, and extension lists. |
| `AlternateColorSchemes` | object[] | Modeled alternate color schemes plus optional native `<a:clrScheme>` XML for each scheme. |
| `HasObjectDefaults` / `ObjectDefaults` | bool/object | Modeled shape, line, and text defaults parsed from `<a:objectDefaults>` where supported, plus optional native object-default XML. |

When both modeled values and native XML are present, modeled values drive FreeX behavior while native XML preserves unsupported Office details for save round-trips.

## Sheets

Each sheet object stores worksheet state:

| Property Group | Notes |
|---|---|
| Identity | `Name`, visibility, tab color. |
| Protection | Sheet protection state, password, and allow-edit ranges. |
| Layout | Row heights, column widths, hidden rows/columns, outline levels, split/freeze pane state, zoom, worksheet view mode, gridline/headings/ruler/formula visibility. |
| Page setup | Print area, paper size, orientation, margins, headers/footers, print titles, page breaks, scale-to-fit, print quality and print options. |
| Content | Cells, style-only cells, merged regions, comments, hyperlinks, data validations, conditional formats, pictures, text boxes, drawing shapes, background image, sparklines, and charts. |
| Metadata | Custom properties, calculation properties, and phonetic properties. |

Loaders validate row and column bounds, skip malformed ranges, clamp invalid numeric layout values, and ignore unsupported enum values where possible.

## Cells

`Cells` entries contain:

| Property | Type | Notes |
|---|---|---|
| `Address` | string | A1 address on the containing sheet. |
| `Value` | string/null | Serialized scalar value. Omitted when the effective value is blank. |
| `ValueType` | string/null | Type tag used by `NativeJsonScalarValueMapper`. Omitted when the value is blank. |
| `Formula` | string/null | Formula text without the leading `=` convention enforced by the model. Omitted for literal cells. |
| `StyleId` | number/null | Zero-based index into the workbook `CellStyles` table. |
| `Style` | object/null | Legacy inline cell style DTO. New saves omit this when no inline style is needed; readers still accept it when `StyleId` is absent or invalid. |
| `IgnoreFormulaError` | bool | Per-cell formula warning suppression flag. New saves omit the default `false` value; readers treat missing values as `false`. |

## Cell Styles

`CellStyles` stores deduplicated workbook style DTOs once at the root. New saves write repeated cell styles through `StyleId` references, while readers continue accepting legacy inline `Style` objects on cells and style-only cells.

## Style-Only Cells

`StyleOnlyCells` preserve formatting for blank cells. Each entry has an `Address` plus either a `StyleId` reference into `CellStyles` or a legacy inline `Style` object. Invalid addresses are skipped during load.

## Comments

`Comments` entries store legacy note text by `Address`. `ThreadedComments` entries store root `Text`, `Author`, `IsResolved`, optional UTC `CreatedAtUtc`/`ModifiedAtUtc`, and `Replies`; each reply stores `Text`, `Author`, and optional UTC created/modified timestamps. Invalid addresses are skipped during load.

## Data Validations

`DataValidations` entries store `Range`, validation type, operator, formula/value fields, prompt/error UI flags, and dropdown visibility. Unsupported enum values or malformed ranges are skipped.

## Conditional Formats

`ConditionalFormats` entries store `AppliesTo`, priority, rule type, operator, threshold values, true-format style, and color-scale fields. Unsupported or malformed rules are skipped.

## Charts

`Charts` entries store object placement, chart type, data range, title, legend/axis/data-label settings, gridline state, trendlines, secondary-axis state, combo-line overlay state, per-series formats, per-point label formats, and optional pivot chart metadata. Load sanitization drops unsupported combinations and clamps invalid dimensions or label angles.

A chart is hosted on the sheet whose `Charts` array contains it, independent of where its data range lives. When the data range references a different sheet (a cross-sheet chart), `DataRangeSheetName` records that source sheet's name so the range rebinds to the correct sheet on load instead of the host sheet; it is absent for same-sheet charts.

## Pictures, Text Boxes, And Drawing Shapes

Visual objects are split into `Pictures`, `TextBoxes`, and `DrawingShapes`. Shared fields include placement, size, rotation, fill/line style, alt text, and name. Pictures may reference embedded image bytes, MIME type, crop percentages, and source-cell anchoring. Invalid object dimensions and rotations are normalized on load.

## Sparklines

`Sparklines` entries store target cell, source data range, sparkline kind, group id, color/style information, marker flags, axis options, and date-axis range. Invalid target cells, ranges, and kinds are skipped.

## Page Layout And Printing

Page layout fields include print area, title rows/columns, page margins, header/footer text, first/even page variants, page order, first page number, black-and-white/draft flags, print quality, comments/error output options, center-on-page flags, row/column page breaks, and scale-to-fit settings. Invalid numeric values fall back to safe defaults.

## Protection

Workbook structure protection and sheet protection are stored separately. Sheet-level `AllowEditRanges` are A1 ranges on the containing sheet. Invalid or cross-sheet allow-edit ranges are skipped.

## Named Ranges

`NamedRanges` entries include `Name`, `RefersTo`, and optional `Comment`/scope metadata. Malformed ranges are ignored so one bad name does not block the workbook.

## Watched Cells

`WatchedCells` entries store sheet name/id context and cell address. Invalid or missing sheet/cell references are ignored.

## Scenarios

`Scenarios` entries store scenario name, comment, hidden/locked flags, and changing-cell values. Scenario cell values use the same scalar value serialization and type tags as worksheet cells.

## Custom Views

`CustomViews` entries store view name, GUID, active sheet, print settings, row/column visibility, pane state, and per-sheet view overrides. Invalid pane state is sanitized on load.

## Migration Policy

Every schema version bump must add migration tests in `NativeJsonSchemaTests` covering:

1. Loading the previous schema version and saving it as the new current version.
2. Rejecting unsupported future versions.
3. Preserving legacy unversioned file loading unless an explicit breaking-change decision removes it.
4. Documenting the changed DTO fields in this schema reference.

Reader compatibility should advance `MinimumReaderVersion` only when older readers would misinterpret data rather than safely ignoring it.
