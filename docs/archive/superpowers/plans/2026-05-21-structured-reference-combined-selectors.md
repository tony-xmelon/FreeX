# Structured Reference Combined Selectors

## Scope

- [x] Parse nested Excel structured-reference selectors like `Sales[[#Data],[Amount]]`.
- [x] Resolve section-column intersections for `#Headers`, `#Data`, `#All`, and `#Totals`.
- [x] Preserve combined structured-reference syntax when serializing formula ASTs.
- [x] Keep current-row `[@Column]`, multi-column selectors, and external workbook references out of scope.

## Architectural Decision

The lexer keeps a combined selector as a single `StructuredReferenceSelector` token and preserves the inner bracketed selector text. `StructuredReferenceResolver` interprets the selector as a range intersection, so formula evaluation, dependency collection, formula auditing, and serialization keep using the same AST node instead of lowering to A1 references.

## Verification

- Red: `dotnet test FreeX\tests\FreeX.Core.Formula.Tests\FreeX.Core.Formula.Tests.csproj --filter StructuredReferenceFormulaTests --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal` failed on nested selector parsing.
- Red: `dotnet test FreeX\tests\FreeX.Core.Formula.Tests\FreeX.Core.Formula.Tests.csproj --filter Serialize_CombinedStructuredReference --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal` failed on over-escaped serializer output.
- Green: `dotnet test FreeX\tests\FreeX.Core.Formula.Tests\FreeX.Core.Formula.Tests.csproj --filter "StructuredReferenceFormulaTests|Serialize_CombinedStructuredReference" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal` passed 10 tests.
