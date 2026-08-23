# Avalonia Parity Wave 193: FreeX AutoFilter No Fill

Date: 2026-08-23
Branch: codex/parity-wave193-freex-20260823
Source commit: e1b0d85954028fc7f56e944d5622902bc251b6ce

## Result

The production Linux/X11 lane proves **Filter by No Fill** through the actual
Avalonia AutoFilter popup. The fixture contains filled North/East rows and
unfilled South/West rows. The physical lane clicked the rendered No Fill
swatch, observed South,West, saved, reopened through the production Open
picker, and observed the same rows and A4=East after reload.

Physical lane: **1 passed, 0 failed, 1 total**.

Exact postconditions:

* rendered No Fill gate: button (177,439,75,27), click (219,456), sample (193,452), before/sample #FFFFFF
* applied visible rows: South,West,
* clean save: true
* package: ref=A1:B5|colId=0|cellColor=1|dxfId=0|dxf=empty
* production reopen: dialog-open=true, dialog-closed=true
* reopened visible rows: South,West,
* reopened semantic A4: East

The retained XLSX was independently inspected from xl/worksheets/sheet1.xml
and xl/styles.xml. It contains filterColumn/colorFilter with cellColor="1",
a required dxfId, and an empty DXF, which is the general OOXML representation
used for No Fill rather than a fabricated color.

## Implementation And Regression Coverage

The production route reuses the existing shared menu plan, Avalonia color
panel, WorksheetFilterWorkflowSession, CellNoFillColorFilterCommand, and XLSX
color-filter DXF allocator. Wave193 adds the fixture, physical selector,
rendered-swatch gate, reopen diagnostics, source guards, and package tests.

Focused tests passed:

* dotnet test tests/FreeX.App.Avalonia.Tests/FreeX.App.Avalonia.Tests.csproj --configuration Release --filter FullyQualifiedName~Wave193AutoFilterNoFillPhysicalSourceTests: 3/3
* dotnet test tests/FreeX.Core.IO.Tests/FreeX.Core.IO.Tests.csproj --configuration Release --filter R89/R90/XlsxAutoFilterAndLeafCodecTests: 8/8

The new package tests cover mixed filled/unfilled rows, SourcePatch, reload
semantics, and a loaded all-No-Fill workbook where applying the criterion
produces no hidden-row delta but still persists the criterion.

## Evidence And Remaining Gaps

Evidence, diagnostics, saved packages, canonical-LF/raw hashes, and committed
source provenance are retained in
docs/parity/evidence/wave193-freex-autofilter-no-fill-20260823/manifest.json.
The clean production image was built from the source commit above; app image
id: sha256:561e22e144ac00be3c8fd8ab3634eb9649e85c6edbd03562d6292dcb0624f5c4.

This slice closes No Fill only. Remaining FreeX physical AutoFilter color gaps
are mixed-type columns, multi-column criteria, and color-filter change/clear
sequencing. Broader font/fill color gallery coverage and Excel-paired evidence
remain separate parity work. No full solution build was run.
