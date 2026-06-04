# Structured Reference Current Row

## Scope

- [x] Parse standalone `[@Column]` current-row structured references.
- [x] Parse table-qualified current-row references such as `Sales[@Column]`.
- [x] Evaluate current-row references as scalar values when the formula cell is inside the table data body.
- [x] Register recalculation dependencies against the same row and target column.
- [x] Preserve current-row structured-reference syntax during formula serialization.
- [x] Keep multi-column current-row selectors, current-row references outside a table data row, and external workbook references out of scope.

## Architectural Decision

Formula evaluation now carries the address of the formula cell in `IEvalContext`. `StructuredReferenceResolver` uses that address plus `StructuredTableModel` metadata to resolve `[@Column]` to the cell in the same data-body row, while dependency collection uses the same resolver path. The AST keeps a dedicated `StructuredCurrentRowReferenceNode`, which avoids lowering formulas to A1 references and lets serialization preserve the user-facing table formula.

## Verification

- Red: `dotnet test FreeX\tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj --filter StructuredReferenceCurrentRowTests --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal` failed because `[@Amount]` evaluated as `#VALUE!`.
- Green: `dotnet test FreeX\tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj --filter StructuredReferenceCurrentRowTests --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal` passed 1 test.
- Green: `dotnet test FreeX\tests\FreeX.Core.Formula.Tests\FreeX.Core.Formula.Tests.csproj --filter "Serialize_CurrentRowStructuredReference|Serialize_TableQualifiedCurrentRowStructuredReference" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal` passed 2 tests.
