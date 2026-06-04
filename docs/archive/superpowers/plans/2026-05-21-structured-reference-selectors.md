# Structured Reference Selector Evaluation

## Scope

- [x] Add formula coverage for table section selectors: `#Headers`, `#Data`, and `#All`.
- [x] Teach `StructuredReferenceResolver` to resolve whole-table section selectors from `StructuredTableModel`.
- [x] Include `#Totals` resolver support when the modeled table has a totals row.
- [x] Keep current-row `[@Column]`, combined selectors such as `[[#Totals],[Amount]]`, multi-column selectors, and external workbook references out of scope.

## Architectural Decision

Structured-reference section selectors use the same `StructuredReferenceResolver` path as `Table[Column]`, so evaluation, dependency collection, and formula auditing share one range-resolution rule. The AST still carries the original selector text rather than lowering to A1 references.

## Verification

- Red: `dotnet test FreeX\tests\FreeX.Core.Formula.Tests\FreeX.Core.Formula.Tests.csproj --filter StructuredReferenceFormulaTests --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal` failed with `#NAME?` for `#Headers`, `#Data`, and `#All`.
- Green: `dotnet test FreeX\tests\FreeX.Core.Formula.Tests\FreeX.Core.Formula.Tests.csproj --filter StructuredReferenceFormulaTests --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal` passed 5 tests after clearing a transient Roslyn compiler-server failure.
