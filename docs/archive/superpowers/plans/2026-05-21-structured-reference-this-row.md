# Structured Reference This Row

## Scope

- [x] Resolve `#This Row` section-column references hosted inside table data-body formulas.
- [x] Resolve row-scoped column ranges such as `Sales[[#This Row],[Amount]:[Tax]]`.
- [x] Register dependencies only for the current row's referenced cells.
- [x] Preserve `#This Row` structured-reference syntax during formula serialization.
- [x] Keep `#This Row` references outside table data-body formulas and external workbook structured references out of scope.

## Architectural Decision

`#This Row` is resolved through the same evaluator current-cell context used for `[@Column]`. `StructuredReferenceResolver` accepts an optional formula-cell address for range references, but only uses it for `#This Row`; ordinary table, section, and multi-column selectors keep their workbook/table-relative behavior. Recalc dependency collection passes the formula cell into the same resolver path, so row-scoped formulas depend on only the cells in their own table row.

## Verification

- Red: `dotnet test FreeX\tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj --filter Recalculate_ThisRowStructuredReference_UsesFormulaCellTableRow --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal` failed because `Sales[[#This Row],[Amount]:[Tax]]` returned `#NAME?`.
- Green: `dotnet test FreeX\tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj --filter Recalculate_ThisRowStructuredReference_UsesFormulaCellTableRow --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal` passed 1 test.
