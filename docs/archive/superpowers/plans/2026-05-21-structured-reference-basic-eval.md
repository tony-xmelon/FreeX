# Structured Reference Basic Evaluation

## Scope

- [x] Add parser/evaluator support for basic table data-body column references, e.g. `Sales[Amount]`.
- [x] Register dependencies on the resolved data-body cells so recalculation responds to table data edits.
- [x] Preserve structured-reference formula text instead of rewriting formulas to A1 references.
- [x] Document exclusions: rich selectors (`[#Headers]`, `[#Totals]`, `[@Column]`, multi-column selectors), external workbook references, and full table-style theme semantics.

## Architectural Decision

Structured references resolve through `StructuredReferenceResolver` against `StructuredTableModel` metadata during evaluation and dependency collection. The formula AST carries a `StructuredReferenceNode`, which keeps formula text close to Excel syntax and avoids losing table identity by converting the expression to raw A1 ranges.

## Verification

- Red: `dotnet test FreeX\tests\FreeX.Core.Formula.Tests\FreeX.Core.Formula.Tests.csproj --filter StructuredReferenceFormulaTests --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal` failed because `[` was not tokenized.
- Green: `dotnet test FreeX\tests\FreeX.Core.Formula.Tests\FreeX.Core.Formula.Tests.csproj --filter StructuredReferenceFormulaTests --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal` passed 2 tests.
- Green: `dotnet test FreeX\tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj --filter StructuredReferenceDependencyTests --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal` passed 1 test.
