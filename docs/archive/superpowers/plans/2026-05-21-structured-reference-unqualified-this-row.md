# Structured Reference Unqualified This Row

## Scope

- [x] Parse standalone `[[#This Row],[Column]]` and `[[#This Row],[Start]:[End]]` selectors.
- [x] Bind unqualified `#This Row` references to the containing table for formulas hosted inside table data rows.
- [x] Preserve unqualified `#This Row` syntax during formula serialization.
- [x] Keep unqualified structured references outside table data rows and external workbook references out of scope.

## Architectural Decision

Standalone `#This Row` selectors are represented as `StructuredReferenceNode` with an empty table name. The resolver only allows an empty table name when a formula-cell address is available and the formula cell is inside a modeled table data row. This keeps ordinary table references name-based while supporting Excel calculated-column syntax that omits the table name.

## Verification

- Red: `dotnet test FreeX\tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj --filter Recalculate_UnqualifiedThisRowStructuredReference_UsesContainingTableRow --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal` failed because standalone `[[#This Row],[Amount]:[Tax]]` parsed to `#VALUE!`.
- Green: `dotnet test FreeX\tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj --filter Recalculate_UnqualifiedThisRowStructuredReference_UsesContainingTableRow --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal` passed 1 test.
