# Custom Number Format Fidelity Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Improve Excel-like custom number format fidelity for conditional sections, color+condition prefixes, escaped literals, and comma scaling.

**Architecture:** Keep `NumberFormatter` as the formatting boundary. Add small private parsing helpers that turn each format section into color, optional condition, and cleaned format text, then reuse existing numeric/date/fraction/scientific helpers.

**Tech Stack:** C# 12, .NET 10, xUnit, FluentAssertions where existing tests use it.

---

### Task 1: Conditional Section Selection

**Files:**
- Modify: `tests/FreeX.Core.Calc.Tests/NumberFormatterTests.cs`
- Modify: `src/FreeX.Core.Calc/NumberFormatter.cs`

- [x] **Step 1: Write failing tests**

Add tests proving `[>100]`, `[<=100]`, and zero fallback pick the correct section:

```csharp
[Theory]
[InlineData("[>100]0.0;[<=100]0.00", 125, "125.0")]
[InlineData("[>100]0.0;[<=100]0.00", 25, "25.00")]
[InlineData("[<0]0.0;[=0]\"zero\";0.00", 0, "zero")]
public void CustomNumberSubset_UsesConditionalSections(string format, double value, string expected)
{
    var result = NumberFormatter.Format(new NumberValue(value), format);

    Assert.Equal(expected, result);
}
```

- [x] **Step 2: Run the red test**

Run:

```powershell
dotnet test tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj --no-restore -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter FullyQualifiedName~NumberFormatter
```

Expected: at least one new conditional-section case fails because conditions are currently stripped after positional section selection.

- [x] **Step 3: Implement minimal section condition parsing**

Add a private parsed-section record and condition matcher in `NumberFormatter`. Conditions should recognize `>`, `>=`, `<`, `<=`, `=`, and `<>` followed by an invariant-culture number.

- [x] **Step 4: Run green test**

Run the same `NumberFormatter` command and confirm all tests pass.

### Task 2: Color, Escaped Literals, and Comma Scaling

**Files:**
- Modify: `tests/FreeX.Core.Calc.Tests/NumberFormatterTests.cs`
- Modify: `src/FreeX.Core.Calc/NumberFormatter.cs`

- [x] **Step 1: Write failing tests**

Add tests for color+condition combinations, escaped literals, and trailing comma scaling:

```csharp
[Theory]
[InlineData("[Red][<0]0.00;[Blue]0.00", -2.5, "-2.50", "#FF0000")]
[InlineData("[Red][<0]0.00;[Blue]0.00", 2.5, "2.50", "#0070C0")]
public void CustomNumberSubset_ReturnsColorFromConditionalSections(string format, double value, string expectedText, string expectedColor)
{
    var result = NumberFormatter.FormatWithColor(new NumberValue(value), format);

    Assert.Equal(expectedText, result.Text);
    Assert.Equal(expectedColor, result.ColorHex);
}

[Theory]
[InlineData("0\\ kg", 12, "12 kg")]
[InlineData("\\#0", 12, "#12")]
[InlineData("0\\,", 12, "12,")]
[InlineData("0,,", 1234567, "1")]
[InlineData("0.0,", 12345, "12.3")]
public void CustomNumberSubset_HandlesEscapedLiteralsAndCommaScaling(string format, double value, string expected)
{
    var result = NumberFormatter.Format(new NumberValue(value), format);

    Assert.Equal(expected, result);
}
```

- [x] **Step 2: Run the red test**

Run the same focused `NumberFormatter` test command. Expected: escaped literals and comma scaling fail under the current direct .NET format delegation.

- [x] **Step 3: Implement escaped literal and comma scaling support**

Unescape backslash literals outside quotes before final rendering, and detect trailing comma scale placeholders outside quotes to divide the value by `1000^n` while removing those scale commas from the format pattern.

- [x] **Step 4: Run focused tests**

Run:

```powershell
dotnet test tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj --no-restore -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter FullyQualifiedName~NumberFormatter
```

Expected: all `NumberFormatter` tests pass.

### Task 2B: Indexed Color Prefixes

**Files:**
- Modify: `tests/FreeX.Core.Calc.Tests/NumberFormatterTests.cs`
- Modify: `src/FreeX.Core.Calc/NumberFormatter.cs`

- [x] **Step 1: Write failing tests**

Extend the color-section tests to cover Excel indexed color prefixes such as `[Color3]`, `[Color5]`, and `[Color6]`.

- [x] **Step 2: Implement indexed color mapping**

Map the custom-format indexed color prefixes `Color1` through `Color56` to FreeX's default indexed display palette.
This keeps the current invariant display model and avoids pretending to support workbook palette/theme overrides.

- [x] **Step 3: Run focused tests**

Run:

```powershell
dotnet test tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj --no-restore -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter FullyQualifiedName~NumberFormatter
```

Expected: all `NumberFormatter` tests pass.

### Task 2C: Date/Time And Text Section Colors

**Files:**
- Modify: `tests/FreeX.Core.Calc.Tests/NumberFormatterTests.cs`
- Modify: `src/FreeX.Core.Calc/NumberFormatter.cs`

- [x] **Step 1: Write failing tests**

Add focused tests proving a date/time section such as `[Color9]m/d/yyyy` returns both formatted text and color metadata,
and a fourth text section such as `0;0;0;[Red]@` strips the color token while returning the text color.

- [x] **Step 2: Route non-numeric sections through parsed section metadata**

Use the existing section parser for `DateTimeValue` and fourth-section `TextValue` formatting so color tokens are not
duplicated as literal display text and `FormatWithColor` returns the section color.

- [x] **Step 3: Run focused tests**

Run:

```powershell
dotnet test FreeX\tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj --no-restore -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter FullyQualifiedName~NumberFormatter
```

Expected: all `NumberFormatter` tests pass.

### Task 2D: Date/Time Conditional Section Selection

**Files:**
- Modify: `tests/FreeX.Core.Calc.Tests/NumberFormatterTests.cs`
- Modify: `src/FreeX.Core.Calc/NumberFormatter.cs`

- [x] **Step 1: Write failing tests**

Add tests proving `DateTimeValue` uses the first matching bracketed condition and falls back to the first unconditional
date/time section when no condition matches.

- [x] **Step 2: Implement date/time section selection**

Reuse the parsed section metadata for date/time values so invariant numeric conditions are evaluated against the serial
date value before formatting the chosen section.

- [x] **Step 3: Run focused tests**

Run:

```powershell
dotnet test FreeX\tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj --no-restore -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter FullyQualifiedName~NumberFormatter
```

Expected: all `NumberFormatter` tests pass.

### Task 3: Documentation and Integration

**Files:**
- Modify: `docs/COMMAND_SURFACE_PARITY.md`
- Modify: `docs/MENU_TOOLBAR_PARITY.md`
- Modify: `docs/ARCHITECTURE.md`
- Modify: `docs/DECISIONS/007-commands-parity-closeout.md`

- [x] **Step 1: Update docs**

Document that custom number formats now include conditional sections, color prefixes, escaped literals, and comma scaling while full locale/LCID/accounting fidelity remains partial.

- [x] **Step 2: Run verification**

Run:

```powershell
dotnet test tests\FreeX.Core.Calc.Tests\FreeX.Core.Calc.Tests.csproj --no-restore -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter FullyQualifiedName~NumberFormatter
dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --no-restore -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "CommandParityStatusTests|MainWindowXamlKeyTipTests"
```

Expected: both commands pass.

- [ ] **Step 3: Commit and merge**

Commit the slice, merge it back to `main`, push `main` and the feature branch to `GitHub-tony-xmelon`, then start the next priority slice from updated `main`.
