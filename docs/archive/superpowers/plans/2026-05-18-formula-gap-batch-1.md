# Formula Gap Batch 1 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Close the highest-value low-risk formula gaps that fit the existing evaluator architecture.

**Architecture:** Add pure built-in functions to `BuiltInFunctions.cs` and mark range-consuming functions as structured in `FormulaEvaluator.cs`. This batch avoids parser/runtime features such as `LAMBDA`, `LET`, and `OFFSET`, and focuses on functions that can be implemented from evaluated scalar/range arguments.

**Tech Stack:** C#/.NET 10, xUnit/FluentAssertions, existing `ScalarValue`/`RangeValue` formula engine.

---

### Task 1: Array and Math/Text Functions

**Files:**
- Modify: `src/FreeX.Core.Formula/BuiltInFunctions.cs`
- Modify: `src/FreeX.Core.Formula/FormulaEvaluator.cs`
- Modify: `tests/FreeX.Core.Formula.Tests/FunctionLibraryTests.cs`
- Modify: `docs/FUNCTION_PARITY.md`

- [x] Write failing tests for `TRANSPOSE`, `SQRTPI`, `DEVSQ`, `RANK.EQ`, `RANK.AVG`, `NUMBERVALUE`, `UNICODE`, and `UNICHAR`.
- [x] Register these functions in `BuiltInFunctions.cs`.
- [x] Add `TRANSPOSE`, `DEVSQ`, `RANK.EQ`, and `RANK.AVG` to `IsStructuredRangeFunction`.
- [x] Implement each function with existing `RangeValue`, `ToNumber`, `ToText`, and `NumberResult` helpers.
- [x] Run `dotnet test tests\FreeX.Core.Formula.Tests\FreeX.Core.Formula.Tests.csproj --filter "Transpose_|Sqrtpi_|Devsq_|RankEq_|RankAvg_|Numbervalue_|Unicode_|Unichar_"`.

### Task 2: International Workday Functions

**Files:**
- Modify: `src/FreeX.Core.Formula/BuiltInFunctions.cs`
- Modify: `src/FreeX.Core.Formula/FormulaEvaluator.cs`
- Modify: `tests/FreeX.Core.Formula.Tests/FunctionLibraryTests.cs`
- Modify: `docs/FUNCTION_PARITY.md`

- [x] Write failing tests for `WORKDAY.INTL` and `NETWORKDAYS.INTL` using a weekend mask and holiday range.
- [x] Register `WORKDAY.INTL` and `NETWORKDAYS.INTL`.
- [x] Add both functions to `IsStructuredRangeFunction` so holiday ranges arrive as `RangeValue`.
- [x] Implement weekend masks for Excel integer codes `1..7`, `11..17`, and 7-character weekend strings.
- [x] Run `dotnet test tests\FreeX.Core.Formula.Tests\FreeX.Core.Formula.Tests.csproj --filter "WorkdayIntl_|NetworkdaysIntl_"`.

### Task 3: Status and Verification

**Files:**
- Modify: `docs/FUNCTION_PARITY.md`
- Modify: `docs/NEXT_PHASES_PLAN.md`

- [x] Update implemented count and statuses for the functions completed in Tasks 1-2.
- [x] Leave remaining formula gaps grouped by complexity: distributions, bond math, reference-runtime features, lambda helpers, and excluded cloud/cube/locale features.
- [x] Also keep/verify the already-registered Phase A1 functions: `MULTINOMIAL`, `SERIESSUM`, `MMULT`, `MINVERSE`, `MDETERM`, `TYPE`, `ERROR.TYPE`, and database functions.
- [x] Run `dotnet test tests\FreeX.Core.Formula.Tests\FreeX.Core.Formula.Tests.csproj`.
- [x] Run `dotnet build FreeX.slnx`.
