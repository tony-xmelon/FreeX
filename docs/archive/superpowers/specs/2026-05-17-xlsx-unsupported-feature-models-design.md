# XLSX Unsupported Feature Models Design

Date: 2026-05-17

## Goal

FreeX should open and save native `.xlsx` workbooks without dropping Excel features that FreeX does not fully implement yet. Unsupported package parts are already retained best-effort. This design adds typed model placeholders for the feature families we intend to implement in later phases, starting with PivotTables.

## Explicitly Out Of Scope

These feature classes remain excluded from FreeX behavior work. They may be retained as package parts, but FreeX should not model, render, edit, execute, or validate them beyond detection and warnings:

- Macros and VBA projects
- Embedded and OLE objects
- Power Query artifacts
- Data Model, Power Pivot, OLAP artifacts
- Linked data types and rich data
- Threaded comments
- Track changes and revision history
- ActiveX and form controls
- Digital signatures
- Custom Ribbon UI
- Office add-ins and web extensions
- Live web queries and web publish items
- Sensitivity labels in custom document properties

## In Scope For Model-First Fidelity

The following feature families should get typed metadata models so FreeX can read, save, inspect, and later implement them:

- PivotTables and pivot caches
- Slicers
- Timelines
- External workbook links
- Custom XML parts
- Unsupported chart package parts and unsupported chart formatting
- SmartArt diagrams
- Printer settings
- Structured tables
- Unsupported worksheet sheet types, represented as non-editable workbook inventory
- Unsupported conditional formatting rules
- Unsupported drawing objects
- Sparkline package metadata beyond the native sparkline model

## Architecture

Add an Excel compatibility inventory to `Core.Model`. The inventory should live on `Workbook` and hold workbook-level feature metadata. `Sheet` should hold sheet-local feature metadata where the feature is anchored to a worksheet.

Workbook-level model candidates:

- `PivotCaches`
- `ExternalLinks`
- `CustomXmlParts`
- `SmartArtParts`
- `UnsupportedChartParts`
- `UnsupportedSheetParts`
- `PackageFeatureParts`

Printer settings graduated from the unsupported-feature model: FreeX retains native `xl/printerSettings/*.bin`
parts and worksheet `pageSetup` relationships, so they should not be disclosed in unsupported-feature warnings.

Sheet-level model candidates:

- `PivotTables`
- `StructuredTables`
- `Slicers`
- `Timelines`
- `AdvancedConditionalFormats`
- `UnsupportedDrawingObjects`
- `SparklineGroups`

Each model should carry both parsed metadata and a package reference/raw preservation handle. Unknown attributes and child XML should remain intact until a later writer intentionally owns that part.

## PivotTable Model

PivotTables are now in scope and should be implemented in phases.

Initial metadata models:

- `PivotCacheModel`: cache id, source type, source range or table reference, external reference metadata when applicable, cache fields, refresh settings, package part references.
- `PivotTableModel`: name, worksheet id, target range, cache id, row fields, column fields, page/filter fields, data fields, layout/style flags, package part references.
- `PivotFieldModel`: source field name/index, orientation, subtotal flags, sort/filter metadata where available.
- `PivotDataFieldModel`: source field, display name, summary function, number format id/string if available.

Phase 1 does not need to refresh or calculate pivot output. It only needs to load metadata and preserve the package while normal workbook edits are saved.

## Load And Save Behavior

Load behavior:

- Parse package relationships and content types to identify in-scope feature parts.
- Populate typed metadata where straightforward.
- Keep raw package references for all in-scope feature parts.
- Continue detecting excluded feature classes for warnings.

Save behavior:

- Preserve raw source parts by default.
- Continue writing FreeX-owned workbook/worksheet parts from the model.
- When a later phase edits a modeled feature, its writer becomes authoritative for that feature's package parts.
- If a feature is only read but not edited, save should retain its original package parts and relationships.

## Testing

Phase 1 tests should prove:

- An XLSX with a PivotTable and pivot cache loads without losing ordinary workbook data.
- Saving after a normal cell edit retains pivot table parts, pivot cache parts, content types, and relationships.
- Pivot metadata extraction returns table names, cache ids, source ranges or table refs, and target ranges where present.
- Excluded feature classes remain warning-only and do not get behavior models.

Later tests should add slicer/timeline/table/chart/drawing/sparkline metadata coverage and then PivotTable refresh/render/edit behavior.

## Open Risks

Workbook and worksheet XML may contain embedded references to feature parts. Package-part preservation is not enough for every feature class if the model writer removes those references. Each feature family needs corpus tests that prove both the part and its referencing XML survive.

PivotTable implementation is larger than persistence. Refresh behavior needs aggregation semantics, cache invalidation, source data tracking, field layout, filters, grouping, and UI rendering. Those belong in later phased designs after model-first persistence is green.
