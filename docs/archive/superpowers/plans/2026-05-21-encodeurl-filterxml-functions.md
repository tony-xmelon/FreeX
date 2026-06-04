# ENCODEURL and FILTERXML Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Move `ENCODEURL` and `FILTERXML` from excluded to implemented while keeping `WEBSERVICE` and `RTD` excluded.

**Architecture:** Add both functions to the existing `BuiltInFunctions` registry. `ENCODEURL` is a pure UTF-8 percent encoder. `FILTERXML` parses XML locally with secure `XmlReaderSettings`, evaluates XPath without external resolution, returns a scalar text value for one match and a vertical `RangeValue` for multiple matches.

**Tech Stack:** C#/.NET formula engine, xUnit formula tests, existing parity catalog docs.

---

### Task 1: Failing Tests

**Files:**
- Modify: `FreeX/tests/FreeX.Core.Formula.Tests/FunctionLibraryTests.cs`

- [x] **Step 1: Add ENCODEURL and FILTERXML tests**

Add tests covering spaces/reserved/unicode URL text, scalar XPath matches, multi-node XPath matches, and invalid XML/no-match errors.

- [x] **Step 2: Run focused tests to verify red**

Run:

```powershell
dotnet test FreeX\tests\FreeX.Core.Formula.Tests\FreeX.Core.Formula.Tests.csproj --filter "FullyQualifiedName~Encodeurl_|FullyQualifiedName~Filterxml_" /p:OutputPath=.tmp-encodeurl-filterxml-red-20260521\ /p:UseSharedCompilation=false /m:1 /nr:false -v:minimal
```

Expected: tests fail with `#NAME?`.

### Task 2: Implementation

**Files:**
- Modify: `FreeX/src/FreeX.Core.Formula/BuiltInFunctions.cs`

- [x] **Step 1: Register functions**

Add `ENCODEURL` and `FILTERXML` to the function registry.

- [x] **Step 2: Implement pure URL encoding**

Use `Uri.EscapeDataString` over the coerced text argument.

- [x] **Step 3: Implement secure XML filtering**

Use `XmlReaderSettings` with `DtdProcessing = Prohibit` and `XmlResolver = null`; evaluate XPath; return `#VALUE!` for malformed XML, invalid XPath, non-matches, or unsupported result types.

### Task 3: Catalog and Docs

**Files:**
- Modify: `FreeX/tests/FreeX.Core.Formula.Tests/FormulaParityCatalogTests.cs`
- Modify: `FreeX/docs/FUNCTION_PARITY.md`
- Modify: `FreeX/docs/NEXT_PHASES_PLAN.md`
- Modify: `FreeX/docs/OUTSTANDING_BUILD.md`

- [x] **Step 1: Remove only ENCODEURL and FILTERXML from exclusions**

Keep `WEBSERVICE` and `RTD` excluded.

- [x] **Step 2: Update totals**

Move formula parity from `343/343` to `345/345`, and excluded count from `9` to `7`.

### Task 4: Verification and Integration

- [ ] **Step 1: Run focused tests**
- [ ] **Step 2: Run full formula test project**
- [ ] **Step 3: Commit**
- [ ] **Step 4: Merge latest `origin/main`, rerun formula tests, and push to `main`**
