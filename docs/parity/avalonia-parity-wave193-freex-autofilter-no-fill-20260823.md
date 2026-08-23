# Avalonia Parity Wave 193: FreeX AutoFilter No Fill

Date: 2026-08-23
Branch: codex/parity-wave193-freex-20260823
Source commit: 92507d139d6cd2c72b0538a67ba7b2266c56786d

## Result

The production Linux/X11 lane proves **Filter by No Fill** through the actual
Avalonia AutoFilter popup. The fixture contains filled North/East rows and
unfilled South/West rows. The physical lane proved the rendered No Fill target
appeared, clicked it, proved the target region returned to its pre-popup image,
observed South,West, saved, reopened through the production Open picker, and
observed the same rows and A4=East after reload.

Physical lane: **1 passed, 0 failed, 1 total**.

Exact postconditions:

* rendered No Fill gate: button (177,439,75,27), click (219,456), sample (193,452), #FFFFFF
* popup target transition: open 1905 pixels (minimum 300), dismissed 1905 pixels (minimum 300), restored 0 pixels (maximum 100)
* click acknowledgement: popup-open=true, popup-dismissed=true, signature-gate=true
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
bounded popup-open/dismissed gate, reopen diagnostics, source guards, and
package tests.

Focused tests passed:

* dotnet test tests/FreeX.App.Avalonia.Tests/FreeX.App.Avalonia.Tests.csproj --configuration Release --no-build --filter FullyQualifiedName~Wave193AutoFilterNoFillPhysicalSourceTests: 3/3
* dotnet test tests/FreeX.Core.IO.Tests/FreeX.Core.IO.Tests.csproj --configuration Release --no-build --filter R89/R90 color-filter DXF tests: 8/8

The new package tests cover mixed filled/unfilled rows, SourcePatch, reload
semantics, and a loaded all-No-Fill workbook where applying the criterion
produces no hidden-row delta but still persists the criterion.

## Evidence And Remaining Gaps

Evidence, diagnostics, saved packages, canonical-LF/raw hashes, and committed
source provenance and the three bounded target-region crops are retained in
docs/parity/evidence/wave193-freex-autofilter-no-fill-20260823/manifest.json.
The clean production image was built from the source commit above; app image
id: sha256:f10318df56fa3a634a7a9a8982ab763c6d203b6f675e90e3e4e2d47ee7e51345.

This slice closes No Fill only. Remaining FreeX physical AutoFilter color gaps
are mixed-type columns, multi-column criteria, and color-filter change/clear
sequencing. Broader font/fill color gallery coverage and Excel-paired evidence
remain separate parity work. No full solution build was run.
