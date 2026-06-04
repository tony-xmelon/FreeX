# Structured Reference Multi-Column Ranges

## Scope

- [x] Resolve data-body multi-column references like `Sales[[Amount]:[Tax]]`.
- [x] Resolve section-scoped multi-column references like `Sales[[#Data],[Amount]:[Tax]]`.
- [x] Support header-section column counts such as `COLUMNS(Sales[[#Headers],[Amount]:[Tax]])`.
- [x] Preserve multi-column structured-reference syntax during formula serialization.
- [x] Keep external workbook structured references and full table style theme semantics out of scope.

## Architectural Decision

`StructuredReferenceResolver` now treats structured-reference column ranges as a first-class selector shape rather than expanding formulas to A1 notation. It parses either a direct column range selector or a section plus column-range selector, resolves the column indexes from `StructuredTableModel`, and returns a rectangular `GridRange`. Evaluation, dependency registration, and auditing continue to consume the same range abstraction already used for single-column structured references.

## Verification

- Red: `dotnet test FreeX\tests\FreeX.Core.Formula.Tests\FreeX.Core.Formula.Tests.csproj --filter MultiColumnStructuredReference_ResolvesColumnRange --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v normal` failed because multi-column selectors returned `#NAME?`.
- Green: `dotnet test FreeX\tests\FreeX.Core.Formula.Tests\FreeX.Core.Formula.Tests.csproj --filter "MultiColumnStructuredReference_ResolvesColumnRange|Serialize_MultiColumnStructuredReference" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal` passed 4 tests.
