# Phase 4a Function Library Expansion

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add ~70 new Excel-compatible functions to `BuiltInFunctions.cs` and fix a pre-existing classification bug in `FormulaEvaluator.cs`.

**Architecture:** All new functions follow the existing `FormulaFunction` delegate pattern. Range-argument classification (structured vs. aggregate) in `FormulaEvaluator.cs` controls how range args reach each function. Two helper methods — `IsStructuredRangeFunction` and `IsAggregateFunction` — must be updated alongside every batch of new function registrations.

**Tech Stack:** C# 12 / .NET 10, xUnit + FluentAssertions, `dotnet test`

---

## File Map

| File | Change |
|------|--------|
| `src/FreeX.Core.Formula/BuiltInFunctions.cs` | Add ~70 function registrations + implementations |
| `src/FreeX.Core.Formula/FormulaEvaluator.cs` | Update `IsStructuredRangeFunction` and `IsAggregateFunction` |
| `tests/FreeX.Core.Formula.Tests/FunctionLibraryTests.cs` | Add test cases for all new functions |

---

## Task 0: Fix FormulaEvaluator.cs classification bug

**Files:**
- Modify: `src/FreeX.Core.Formula/FormulaEvaluator.cs`

`XLOOKUP`, `SUMIFS`, `COUNTIFS`, `AVERAGEIFS` are missing from `IsStructuredRangeFunction`. Their implementations call `if (args[0] is not RangeValue ...)` — they need `RangeValue` args but currently receive flat-expanded values.

- [ ] **Step 1: Write the failing test**

Add to `tests/FreeX.Core.Formula.Tests/FunctionLibraryTests.cs`:

```csharp
// ── Bug regression: SUMIFS must receive RangeValues ────────────────────────

[Fact]
public void Sumifs_RangeArg_WorksCorrectly()
{
    var sheet = MakeSheet(
        (1, 1, new NumberValue(10)), (2, 1, new NumberValue(20)), (3, 1, new NumberValue(30)),
        (1, 2, new TextValue("A")),  (2, 2, new TextValue("B")),  (3, 2, new TextValue("A")));
    // SUMIFS(A1:A3, B1:B3, "A") → 40
    var result = _eval.Evaluate("=SUMIFS(A1:A3,B1:B3,\"A\")", sheet);
    result.Should().Be(new NumberValue(40));
}

[Fact]
public void Xlookup_RangeArg_WorksCorrectly()
{
    var sheet = MakeSheet(
        (1, 1, new TextValue("A")), (2, 1, new TextValue("B")), (3, 1, new TextValue("C")),
        (1, 2, new NumberValue(1)), (2, 2, new NumberValue(2)), (3, 2, new NumberValue(3)));
    // XLOOKUP("B", A1:A3, B1:B3) → 2
    var result = _eval.Evaluate("=XLOOKUP(\"B\",A1:A3,B1:B3)", sheet);
    result.Should().Be(new NumberValue(2));
}
```

- [ ] **Step 2: Run to see current failure**

```
dotnet test tests/FreeX.Core.Formula.Tests --filter "Sumifs_RangeArg|Xlookup_RangeArg" -v n
```

- [ ] **Step 3: Fix `IsStructuredRangeFunction` in FormulaEvaluator.cs**

Replace the existing method body:

```csharp
private static bool IsStructuredRangeFunction(string name) =>
    name is "VLOOKUP" or "HLOOKUP" or "INDEX" or "MATCH"
         or "SUMIF" or "COUNTIF" or "AVERAGEIF"
         or "LARGE" or "SMALL" or "RANK"
         or "SUMIFS" or "COUNTIFS" or "AVERAGEIFS"
         or "XLOOKUP";
```

- [ ] **Step 4: Run test to verify it passes**

```
dotnet test tests/FreeX.Core.Formula.Tests --filter "Sumifs_RangeArg|Xlookup_RangeArg" -v n
```

Expected: PASS

- [ ] **Step 5: Commit**

```
git add src/FreeX.Core.Formula/FormulaEvaluator.cs tests/FreeX.Core.Formula.Tests/FunctionLibraryTests.cs
git commit -m "fix: add XLOOKUP/SUMIFS/COUNTIFS/AVERAGEIFS to IsStructuredRangeFunction"
```

---

## Task 1: Math and Trig functions (18 new)

**Functions:** SIN, COS, TAN, ASIN, ACOS, ATAN, ATAN2, DEGREES, RADIANS, PRODUCT, QUOTIENT, GCD, LCM, MROUND, COMBIN, PERMUT, ODD, EVEN

**Files:**
- Modify: `src/FreeX.Core.Formula/BuiltInFunctions.cs`
- Modify: `src/FreeX.Core.Formula/FormulaEvaluator.cs`
- Modify: `tests/FreeX.Core.Formula.Tests/FunctionLibraryTests.cs`

- [ ] **Step 1: Write failing tests**

Add to `FunctionLibraryTests.cs`:

```csharp
// ── Math / Trig ─────────────────────────────────────────────────────────────

[Fact] public void Sin_Zero_ReturnsZero() =>
    _eval.Evaluate("=SIN(0)", MakeSheet()).Should().Be(new NumberValue(0));

[Fact] public void Cos_Zero_ReturnsOne() =>
    _eval.Evaluate("=COS(0)", MakeSheet()).Should().Be(new NumberValue(1));

[Fact] public void Tan_Zero_ReturnsZero() =>
    _eval.Evaluate("=TAN(0)", MakeSheet()).Should().Be(new NumberValue(0));

[Fact] public void Asin_One_ReturnsHalfPi() =>
    ((NumberValue)_eval.Evaluate("=ASIN(1)", MakeSheet())).Value
        .Should().BeApproximately(Math.PI / 2, 1e-10);

[Fact] public void Acos_One_ReturnsZero() =>
    ((NumberValue)_eval.Evaluate("=ACOS(1)", MakeSheet())).Value
        .Should().BeApproximately(0, 1e-10);

[Fact] public void Atan_One_ReturnsQuarterPi() =>
    ((NumberValue)_eval.Evaluate("=ATAN(1)", MakeSheet())).Value
        .Should().BeApproximately(Math.PI / 4, 1e-10);

[Fact] public void Atan2_XY_ReturnsCorrect() =>
    ((NumberValue)_eval.Evaluate("=ATAN2(1,1)", MakeSheet())).Value
        .Should().BeApproximately(Math.PI / 4, 1e-10);

[Fact] public void Degrees_Pi_Returns180() =>
    ((NumberValue)_eval.Evaluate("=DEGREES(PI())", MakeSheet())).Value
        .Should().BeApproximately(180, 1e-10);

[Fact] public void Radians_180_ReturnsPi() =>
    ((NumberValue)_eval.Evaluate("=RADIANS(180)", MakeSheet())).Value
        .Should().BeApproximately(Math.PI, 1e-10);

[Fact] public void Product_Range_MultipliesAll()
{
    var sheet = MakeSheet((1,1,new NumberValue(2)),(2,1,new NumberValue(3)),(3,1,new NumberValue(4)));
    _eval.Evaluate("=PRODUCT(A1:A3)", sheet).Should().Be(new NumberValue(24));
}

[Fact] public void Quotient_5_2_Returns2() =>
    _eval.Evaluate("=QUOTIENT(5,2)", MakeSheet()).Should().Be(new NumberValue(2));

[Fact] public void Gcd_12_8_Returns4() =>
    _eval.Evaluate("=GCD(12,8)", MakeSheet()).Should().Be(new NumberValue(4));

[Fact] public void Lcm_4_6_Returns12() =>
    _eval.Evaluate("=LCM(4,6)", MakeSheet()).Should().Be(new NumberValue(12));

[Fact] public void Mround_14_5_Returns15() =>
    _eval.Evaluate("=MROUND(14,5)", MakeSheet()).Should().Be(new NumberValue(15));

[Fact] public void Combin_5_2_Returns10() =>
    _eval.Evaluate("=COMBIN(5,2)", MakeSheet()).Should().Be(new NumberValue(10));

[Fact] public void Permut_5_2_Returns20() =>
    _eval.Evaluate("=PERMUT(5,2)", MakeSheet()).Should().Be(new NumberValue(20));

[Fact] public void Odd_2_Returns3() =>
    _eval.Evaluate("=ODD(2)", MakeSheet()).Should().Be(new NumberValue(3));

[Fact] public void Even_3_Returns4() =>
    _eval.Evaluate("=EVEN(3)", MakeSheet()).Should().Be(new NumberValue(4));
```

- [ ] **Step 2: Run to see failures**

```
dotnet test tests/FreeX.Core.Formula.Tests --filter "Sin_Zero|Cos_Zero|Product_Range|Gcd_|Combin_|Odd_|Even_" -v n
```

Expected: FAIL (functions not found → returns ErrorValue.Name)

- [ ] **Step 3: Register functions in BuiltInFunctions.cs**

Add inside the `Functions` dictionary, after the `["CHAR"]` entry (before the closing `};`):

```csharp
        // ── Phase 4a: Math / Trig ────────────────────────────────────────────
        ["SIN"]      = (Sin, 1, 1),
        ["COS"]      = (Cos, 1, 1),
        ["TAN"]      = (Tan, 1, 1),
        ["ASIN"]     = (Asin, 1, 1),
        ["ACOS"]     = (Acos, 1, 1),
        ["ATAN"]     = (Atan, 1, 1),
        ["ATAN2"]    = (Atan2Func, 2, 2),
        ["DEGREES"]  = (Degrees, 1, 1),
        ["RADIANS"]  = (Radians, 1, 1),
        ["PRODUCT"]  = (Product, 1, 255),
        ["QUOTIENT"] = (Quotient, 2, 2),
        ["GCD"]      = (Gcd, 1, 255),
        ["LCM"]      = (Lcm, 1, 255),
        ["MROUND"]   = (Mround, 2, 2),
        ["COMBIN"]   = (Combin, 2, 2),
        ["PERMUT"]   = (Permut, 2, 2),
        ["ODD"]      = (Odd, 1, 1),
        ["EVEN"]     = (Even, 1, 1),
```

- [ ] **Step 4: Add implementations in BuiltInFunctions.cs**

Add a new section after the existing Phase 4.2 Math section (after the `Fact` method):

```csharp
    // ═══════════════════════════════════════════════════════════════════
    // Phase 4a  –  Math / Trig
    // ═══════════════════════════════════════════════════════════════════

    private static ScalarValue Sin(IReadOnlyList<ScalarValue> args, IEvalContext ctx)
    {
        if (args[0] is ErrorValue e) return e;
        return new NumberValue(Math.Sin(ToNumber(args[0])));
    }

    private static ScalarValue Cos(IReadOnlyList<ScalarValue> args, IEvalContext ctx)
    {
        if (args[0] is ErrorValue e) return e;
        return new NumberValue(Math.Cos(ToNumber(args[0])));
    }

    private static ScalarValue Tan(IReadOnlyList<ScalarValue> args, IEvalContext ctx)
    {
        if (args[0] is ErrorValue e) return e;
        return new NumberValue(Math.Tan(ToNumber(args[0])));
    }

    private static ScalarValue Asin(IReadOnlyList<ScalarValue> args, IEvalContext ctx)
    {
        if (args[0] is ErrorValue e) return e;
        double n = ToNumber(args[0]);
        if (n < -1 || n > 1) return ErrorValue.Num;
        return new NumberValue(Math.Asin(n));
    }

    private static ScalarValue Acos(IReadOnlyList<ScalarValue> args, IEvalContext ctx)
    {
        if (args[0] is ErrorValue e) return e;
        double n = ToNumber(args[0]);
        if (n < -1 || n > 1) return ErrorValue.Num;
        return new NumberValue(Math.Acos(n));
    }

    private static ScalarValue Atan(IReadOnlyList<ScalarValue> args, IEvalContext ctx)
    {
        if (args[0] is ErrorValue e) return e;
        return new NumberValue(Math.Atan(ToNumber(args[0])));
    }

    // ATAN2(x_num, y_num) – matches Excel argument order
    private static ScalarValue Atan2Func(IReadOnlyList<ScalarValue> args, IEvalContext ctx)
    {
        if (args[0] is ErrorValue e0) return e0;
        if (args[1] is ErrorValue e1) return e1;
        double x = ToNumber(args[0]);
        double y = ToNumber(args[1]);
        if (x == 0 && y == 0) return ErrorValue.DivByZero;
        return new NumberValue(Math.Atan2(y, x));
    }

    private static ScalarValue Degrees(IReadOnlyList<ScalarValue> args, IEvalContext ctx)
    {
        if (args[0] is ErrorValue e) return e;
        return new NumberValue(ToNumber(args[0]) * 180.0 / Math.PI);
    }

    private static ScalarValue Radians(IReadOnlyList<ScalarValue> args, IEvalContext ctx)
    {
        if (args[0] is ErrorValue e) return e;
        return new NumberValue(ToNumber(args[0]) * Math.PI / 180.0);
    }

    private static ScalarValue Product(IReadOnlyList<ScalarValue> args, IEvalContext ctx)
    {
        double result = 1.0;
        foreach (var a in args)
        {
            if (a is ErrorValue e) return e;
            if (a is NumberValue nv) result *= nv.Value;
        }
        return new NumberValue(result);
    }

    private static ScalarValue Quotient(IReadOnlyList<ScalarValue> args, IEvalContext ctx)
    {
        if (args[0] is ErrorValue e0) return e0;
        if (args[1] is ErrorValue e1) return e1;
        double d = ToNumber(args[1]);
        if (d == 0) return ErrorValue.DivByZero;
        return new NumberValue(Math.Truncate(ToNumber(args[0]) / d));
    }

    private static ScalarValue Gcd(IReadOnlyList<ScalarValue> args, IEvalContext ctx)
    {
        long result = 0;
        foreach (var a in args)
        {
            if (a is ErrorValue e) return e;
            long n = (long)Math.Abs(ToNumber(a));
            result = GcdCalc(result, n);
        }
        return new NumberValue(result);
    }

    private static long GcdCalc(long a, long b)
    {
        while (b != 0) { long t = b; b = a % b; a = t; }
        return a;
    }

    private static ScalarValue Lcm(IReadOnlyList<ScalarValue> args, IEvalContext ctx)
    {
        long result = 1;
        foreach (var a in args)
        {
            if (a is ErrorValue e) return e;
            long n = (long)Math.Abs(ToNumber(a));
            if (n == 0) return new NumberValue(0);
            long g = GcdCalc(result, n);
            result = result / g * n;
        }
        return new NumberValue(result);
    }

    private static ScalarValue Mround(IReadOnlyList<ScalarValue> args, IEvalContext ctx)
    {
        if (args[0] is ErrorValue e0) return e0;
        if (args[1] is ErrorValue e1) return e1;
        double n = ToNumber(args[0]);
        double m = ToNumber(args[1]);
        if (m == 0) return ErrorValue.DivByZero;
        if (n != 0 && (n < 0) != (m < 0)) return ErrorValue.Num;
        return new NumberValue(Math.Round(n / m, MidpointRounding.AwayFromZero) * m);
    }

    private static ScalarValue Combin(IReadOnlyList<ScalarValue> args, IEvalContext ctx)
    {
        if (args[0] is ErrorValue e0) return e0;
        if (args[1] is ErrorValue e1) return e1;
        int n = (int)ToNumber(args[0]);
        int k = (int)ToNumber(args[1]);
        if (n < 0 || k < 0 || k > n) return ErrorValue.Num;
        if (k > n - k) k = n - k;
        double result = 1;
        for (int i = 0; i < k; i++)
            result = result * (n - i) / (i + 1);
        return new NumberValue(Math.Round(result));
    }

    private static ScalarValue Permut(IReadOnlyList<ScalarValue> args, IEvalContext ctx)
    {
        if (args[0] is ErrorValue e0) return e0;
        if (args[1] is ErrorValue e1) return e1;
        int n = (int)ToNumber(args[0]);
        int k = (int)ToNumber(args[1]);
        if (n < 0 || k < 0 || k > n) return ErrorValue.Num;
        double result = 1;
        for (int i = 0; i < k; i++)
            result *= (n - i);
        return new NumberValue(result);
    }

    private static ScalarValue Odd(IReadOnlyList<ScalarValue> args, IEvalContext ctx)
    {
        if (args[0] is ErrorValue e) return e;
        double n = ToNumber(args[0]);
        if (n == 0) return new NumberValue(1);
        int sign = n > 0 ? 1 : -1;
        int abs = (int)Math.Ceiling(Math.Abs(n));
        if (abs % 2 == 0) abs++;
        return new NumberValue(sign * abs);
    }

    private static ScalarValue Even(IReadOnlyList<ScalarValue> args, IEvalContext ctx)
    {
        if (args[0] is ErrorValue e) return e;
        double n = ToNumber(args[0]);
        if (n == 0) return new NumberValue(0);
        int sign = n > 0 ? 1 : -1;
        int abs = (int)Math.Ceiling(Math.Abs(n));
        if (abs % 2 != 0) abs++;
        return new NumberValue(sign * abs);
    }
```

- [ ] **Step 5: Update `IsAggregateFunction` in FormulaEvaluator.cs**

Replace existing:
```csharp
private static bool IsAggregateFunction(string name) =>
    name is "SUM" or "AVERAGE" or "MIN" or "MAX" or "COUNT" or "COUNTA" or "AND" or "OR" or "CONCAT"
         or "STDEV" or "MEDIAN";
```

With:
```csharp
private static bool IsAggregateFunction(string name) =>
    name is "SUM" or "AVERAGE" or "MIN" or "MAX" or "COUNT" or "COUNTA" or "AND" or "OR" or "CONCAT"
         or "STDEV" or "MEDIAN"
         or "PRODUCT" or "XOR"
         or "VAR" or "VAR.S" or "VAR.P" or "STDEV.P"
         or "GEOMEAN" or "HARMEAN" or "AVEDEV"
         or "MODE" or "MODE.SNGL"
         or "CONCATENATE";
```

(Add all at once now to avoid touching this line multiple times.)

- [ ] **Step 6: Run tests**

```
dotnet test tests/FreeX.Core.Formula.Tests --filter "Sin_Zero|Cos_Zero|Tan_Zero|Asin_|Acos_|Atan_|Degrees_|Radians_|Product_Range|Quotient_|Gcd_|Lcm_|Mround_|Combin_|Permut_|Odd_|Even_" -v n
```

Expected: all PASS

- [ ] **Step 7: Commit**

```
git add src/FreeX.Core.Formula/BuiltInFunctions.cs src/FreeX.Core.Formula/FormulaEvaluator.cs tests/FreeX.Core.Formula.Tests/FunctionLibraryTests.cs
git commit -m "feat: add 18 math/trig functions (SIN/COS/TAN/ATAN2/PRODUCT/GCD/LCM/COMBIN/PERMUT/ODD/EVEN etc)"
```

---

## Task 2: Date and Time functions (10 new)

**Functions:** TIME, TIMEVALUE, DATEVALUE, EOMONTH, WEEKNUM, ISOWEEKNUM, WORKDAY, NETWORKDAYS, DAYS, YEARFRAC

**Files:**
- Modify: `src/FreeX.Core.Formula/BuiltInFunctions.cs`
- Modify: `src/FreeX.Core.Formula/FormulaEvaluator.cs`
- Modify: `tests/FreeX.Core.Formula.Tests/FunctionLibraryTests.cs`

WORKDAY and NETWORKDAYS accept an optional holidays range → must be in `IsStructuredRangeFunction`.

- [ ] **Step 1: Write failing tests**

```csharp
// ── Date / Time ──────────────────────────────────────────────────────────────

[Fact] public void Time_HMS_ReturnsFraction()
{
    // TIME(12, 0, 0) = 0.5 (half a day)
    ((NumberValue)_eval.Evaluate("=TIME(12,0,0)", MakeSheet())).Value
        .Should().BeApproximately(0.5, 1e-10);
}

[Fact] public void Timevalue_String_ReturnsFraction()
{
    ((NumberValue)_eval.Evaluate("=TIMEVALUE(\"12:00:00\")", MakeSheet())).Value
        .Should().BeApproximately(0.5, 1e-10);
}

[Fact] public void Datevalue_String_ReturnsSerial()
{
    // 2024-01-01 OADate
    double expected = new DateTime(2024, 1, 1).ToOADate();
    ((NumberValue)_eval.Evaluate("=DATEVALUE(\"2024-01-01\")", MakeSheet())).Value
        .Should().BeApproximately(expected, 1);
}

[Fact] public void Eomonth_Jan_ReturnsLastDayJan()
{
    // DATE(2024,1,15) + EOMONTH offset 0 → 2024-01-31
    double jan15 = new DateTime(2024, 1, 15).ToOADate();
    double jan31 = new DateTime(2024, 1, 31).ToOADate();
    var sheet = MakeSheet((1, 1, new NumberValue(jan15)));
    ((NumberValue)_eval.Evaluate("=EOMONTH(A1,0)", sheet)).Value
        .Should().BeApproximately(jan31, 1);
}

[Fact] public void Weeknum_Jan8_Returns2()
{
    double jan8 = new DateTime(2024, 1, 8).ToOADate();
    var sheet = MakeSheet((1, 1, new NumberValue(jan8)));
    _eval.Evaluate("=WEEKNUM(A1)", sheet).Should().Be(new NumberValue(2));
}

[Fact] public void Isoweeknum_Jan8_2024_Returns2()
{
    double jan8 = new DateTime(2024, 1, 8).ToOADate();
    var sheet = MakeSheet((1, 1, new NumberValue(jan8)));
    _eval.Evaluate("=ISOWEEKNUM(A1)", sheet).Should().Be(new NumberValue(2));
}

[Fact] public void Workday_5BusinessDays_SkipsWeekend()
{
    // 2024-01-08 (Monday) + 5 workdays = 2024-01-15 (Monday)
    double mon = new DateTime(2024, 1, 8).ToOADate();
    double expected = new DateTime(2024, 1, 15).ToOADate();
    var sheet = MakeSheet((1, 1, new NumberValue(mon)));
    ((NumberValue)_eval.Evaluate("=WORKDAY(A1,5)", sheet)).Value
        .Should().BeApproximately(expected, 1);
}

[Fact] public void Networkdays_MonToFri_Returns5()
{
    double mon = new DateTime(2024, 1, 8).ToOADate();
    double fri = new DateTime(2024, 1, 12).ToOADate();
    var sheet = MakeSheet((1, 1, new NumberValue(mon)), (1, 2, new NumberValue(fri)));
    _eval.Evaluate("=NETWORKDAYS(A1,B1)", sheet).Should().Be(new NumberValue(5));
}

[Fact] public void Days_EndMinusStart_ReturnsDifference()
{
    double d1 = new DateTime(2024, 1, 1).ToOADate();
    double d2 = new DateTime(2024, 1, 11).ToOADate();
    var sheet = MakeSheet((1, 1, new NumberValue(d2)), (1, 2, new NumberValue(d1)));
    _eval.Evaluate("=DAYS(A1,B1)", sheet).Should().Be(new NumberValue(10));
}

[Fact] public void Yearfrac_HalfYear_ReturnsApprox05()
{
    double jan1 = new DateTime(2024, 1, 1).ToOADate();
    double jul1 = new DateTime(2024, 7, 1).ToOADate();
    var sheet = MakeSheet((1, 1, new NumberValue(jan1)), (1, 2, new NumberValue(jul1)));
    ((NumberValue)_eval.Evaluate("=YEARFRAC(A1,B1,3)", sheet)).Value
        .Should().BeApproximately(182.0 / 365.0, 0.01);
}
```

- [ ] **Step 2: Run to see failures**

```
dotnet test tests/FreeX.Core.Formula.Tests --filter "Time_HMS|Timevalue_|Datevalue_|Eomonth_|Weeknum_|Isoweeknum_|Workday_|Networkdays_|Days_End|Yearfrac_" -v n
```

- [ ] **Step 3: Register new date/time functions**

Add to the `Functions` dictionary after the Phase 4a math block:

```csharp
        // ── Phase 4a: Date / Time ────────────────────────────────────────────
        ["TIME"]         = (TimeFunc, 3, 3),
        ["TIMEVALUE"]    = (Timevalue, 1, 1),
        ["DATEVALUE"]    = (Datevalue, 1, 1),
        ["EOMONTH"]      = (Eomonth, 2, 2),
        ["WEEKNUM"]      = (Weeknum, 1, 2),
        ["ISOWEEKNUM"]   = (Isoweeknum, 1, 1),
        ["WORKDAY"]      = (Workday, 2, 3),
        ["NETWORKDAYS"]  = (Networkdays, 2, 3),
        ["DAYS"]         = (Days, 2, 2),
        ["YEARFRAC"]     = (Yearfrac, 2, 3),
```

- [ ] **Step 4: Add `IsStructuredRangeFunction` entries for WORKDAY and NETWORKDAYS**

In `FormulaEvaluator.cs`, update `IsStructuredRangeFunction`:

```csharp
private static bool IsStructuredRangeFunction(string name) =>
    name is "VLOOKUP" or "HLOOKUP" or "INDEX" or "MATCH"
         or "SUMIF" or "COUNTIF" or "AVERAGEIF"
         or "LARGE" or "SMALL" or "RANK"
         or "SUMIFS" or "COUNTIFS" or "AVERAGEIFS"
         or "XLOOKUP"
         or "WORKDAY" or "NETWORKDAYS"
         or "CORREL" or "FORECAST" or "FORECAST.LINEAR"
         or "PERCENTILE" or "PERCENTILE.INC" or "PERCENTILE.EXC"
         or "QUARTILE" or "QUARTILE.INC"
         or "PERCENTRANK" or "PERCENTRANK.INC"
         or "LOOKUP"
         or "IRR";
```

(Add all upcoming structured functions at once.)

- [ ] **Step 5: Add date/time implementations**

Add a new section after the existing Phase 4.2 Date & time section:

```csharp
    // ═══════════════════════════════════════════════════════════════════
    // Phase 4a  –  Date / Time
    // ═══════════════════════════════════════════════════════════════════

    private static ScalarValue TimeFunc(IReadOnlyList<ScalarValue> args, IEvalContext ctx)
    {
        if (args[0] is ErrorValue e0) return e0;
        double h = ToNumber(args[0]), m = ToNumber(args[1]), s = ToNumber(args[2]);
        double frac = (h * 3600 + m * 60 + s) / 86400.0;
        return new NumberValue(frac - Math.Floor(frac));
    }

    private static ScalarValue Timevalue(IReadOnlyList<ScalarValue> args, IEvalContext ctx)
    {
        if (args[0] is ErrorValue e) return e;
        var text = ToText(args[0]);
        if (TimeSpan.TryParse(text, out var ts))
            return new NumberValue(ts.TotalDays % 1.0);
        if (DateTime.TryParse(text, out var dt))
            return new NumberValue(dt.TimeOfDay.TotalDays);
        return ErrorValue.Value;
    }

    private static ScalarValue Datevalue(IReadOnlyList<ScalarValue> args, IEvalContext ctx)
    {
        if (args[0] is ErrorValue e) return e;
        var text = ToText(args[0]);
        if (DateTime.TryParse(text, System.Globalization.CultureInfo.InvariantCulture,
                System.Globalization.DateTimeStyles.None, out var dt))
            return new NumberValue(Math.Floor(dt.ToOADate()));
        return ErrorValue.Value;
    }

    private static ScalarValue Eomonth(IReadOnlyList<ScalarValue> args, IEvalContext ctx)
    {
        if (args[0] is ErrorValue e0) return e0;
        if (args[1] is ErrorValue e1) return e1;
        var dt = DateTime.FromOADate(ToNumber(args[0]));
        int months = (int)ToNumber(args[1]);
        var target = dt.AddMonths(months + 1);
        var eomonth = new DateTime(target.Year, target.Month, 1).AddDays(-1);
        return new NumberValue(eomonth.ToOADate());
    }

    private static ScalarValue Weeknum(IReadOnlyList<ScalarValue> args, IEvalContext ctx)
    {
        if (args[0] is ErrorValue e) return e;
        var dt = DateTime.FromOADate(ToNumber(args[0]));
        int returnType = args.Count > 1 && args[1] is not BlankValue ? (int)ToNumber(args[1]) : 1;
        DayOfWeek firstDay = returnType == 2 ? DayOfWeek.Monday : DayOfWeek.Sunday;
        var jan1 = new DateTime(dt.Year, 1, 1);
        int jan1Dow = ((int)jan1.DayOfWeek - (int)firstDay + 7) % 7;
        int dayOfYear = (dt - jan1).Days;
        return new NumberValue((dayOfYear + jan1Dow) / 7 + 1);
    }

    private static ScalarValue Isoweeknum(IReadOnlyList<ScalarValue> args, IEvalContext ctx)
    {
        if (args[0] is ErrorValue e) return e;
        var dt = DateTime.FromOADate(ToNumber(args[0]));
        var cal = System.Globalization.CultureInfo.InvariantCulture.Calendar;
        int week = cal.GetWeekOfYear(dt,
            System.Globalization.CalendarWeekRule.FirstFourDayWeek,
            DayOfWeek.Monday);
        return new NumberValue(week);
    }

    private static ScalarValue Workday(IReadOnlyList<ScalarValue> args, IEvalContext ctx)
    {
        if (args[0] is ErrorValue e0) return e0;
        if (args[1] is ErrorValue e1) return e1;
        var current = DateTime.FromOADate(ToNumber(args[0]));
        int days = (int)ToNumber(args[1]);
        var holidays = new HashSet<DateTime>();
        if (args.Count > 2 && args[2] is RangeValue hRange)
            foreach (var v in hRange.Flatten())
                if (v is NumberValue nv)
                    holidays.Add(DateTime.FromOADate(nv.Value).Date);
        int sign = days < 0 ? -1 : 1;
        int remaining = Math.Abs(days);
        while (remaining > 0)
        {
            current = current.AddDays(sign);
            if (current.DayOfWeek != DayOfWeek.Saturday &&
                current.DayOfWeek != DayOfWeek.Sunday &&
                !holidays.Contains(current.Date))
                remaining--;
        }
        return new NumberValue(current.ToOADate());
    }

    private static ScalarValue Networkdays(IReadOnlyList<ScalarValue> args, IEvalContext ctx)
    {
        if (args[0] is ErrorValue e0) return e0;
        if (args[1] is ErrorValue e1) return e1;
        var startDt = DateTime.FromOADate(ToNumber(args[0])).Date;
        var endDt   = DateTime.FromOADate(ToNumber(args[1])).Date;
        var holidays = new HashSet<DateTime>();
        if (args.Count > 2 && args[2] is RangeValue hRange)
            foreach (var v in hRange.Flatten())
                if (v is NumberValue nv)
                    holidays.Add(DateTime.FromOADate(nv.Value).Date);
        int sign = startDt <= endDt ? 1 : -1;
        var lo = startDt <= endDt ? startDt : endDt;
        var hi = startDt <= endDt ? endDt   : startDt;
        int count = 0;
        for (var d = lo; d <= hi; d = d.AddDays(1))
            if (d.DayOfWeek != DayOfWeek.Saturday &&
                d.DayOfWeek != DayOfWeek.Sunday &&
                !holidays.Contains(d))
                count++;
        return new NumberValue(sign * count);
    }

    private static ScalarValue Days(IReadOnlyList<ScalarValue> args, IEvalContext ctx)
    {
        if (args[0] is ErrorValue e0) return e0;
        if (args[1] is ErrorValue e1) return e1;
        var endDt   = DateTime.FromOADate(ToNumber(args[0]));
        var startDt = DateTime.FromOADate(ToNumber(args[1]));
        return new NumberValue((endDt - startDt).Days);
    }

    private static ScalarValue Yearfrac(IReadOnlyList<ScalarValue> args, IEvalContext ctx)
    {
        if (args[0] is ErrorValue e0) return e0;
        if (args[1] is ErrorValue e1) return e1;
        var startDt = DateTime.FromOADate(ToNumber(args[0])).Date;
        var endDt   = DateTime.FromOADate(ToNumber(args[1])).Date;
        int basis = args.Count > 2 && args[2] is not BlankValue ? (int)ToNumber(args[2]) : 0;
        double totalDays = (endDt - startDt).TotalDays;
        double result = basis switch
        {
            1 => totalDays / (DateTime.IsLeapYear(startDt.Year) || DateTime.IsLeapYear(endDt.Year) ? 366.0 : 365.0),
            2 => totalDays / 360.0,
            3 => totalDays / 365.0,
            4 => Days30E360(startDt, endDt) / 360.0,
            _ => Days30US360(startDt, endDt) / 360.0
        };
        return new NumberValue(result);
    }

    private static double Days30US360(DateTime d1, DateTime d2)
    {
        int y1 = d1.Year, m1 = d1.Month, dd1 = d1.Day;
        int y2 = d2.Year, m2 = d2.Month, dd2 = d2.Day;
        if (dd1 == 31) dd1 = 30;
        if (dd2 == 31 && dd1 == 30) dd2 = 30;
        return 360.0 * (y2 - y1) + 30.0 * (m2 - m1) + (dd2 - dd1);
    }

    private static double Days30E360(DateTime d1, DateTime d2)
    {
        int y1 = d1.Year, m1 = d1.Month, dd1 = d1.Day;
        int y2 = d2.Year, m2 = d2.Month, dd2 = d2.Day;
        if (dd1 == 31) dd1 = 30;
        if (dd2 == 31) dd2 = 30;
        return 360.0 * (y2 - y1) + 30.0 * (m2 - m1) + (dd2 - dd1);
    }
```

- [ ] **Step 6: Run tests**

```
dotnet test tests/FreeX.Core.Formula.Tests --filter "Time_HMS|Timevalue_|Datevalue_|Eomonth_|Weeknum_|Isoweeknum_|Workday_|Networkdays_|Days_End|Yearfrac_" -v n
```

Expected: all PASS

- [ ] **Step 7: Commit**

```
git add src/FreeX.Core.Formula/BuiltInFunctions.cs src/FreeX.Core.Formula/FormulaEvaluator.cs tests/FreeX.Core.Formula.Tests/FunctionLibraryTests.cs
git commit -m "feat: add 10 date/time functions (TIME/TIMEVALUE/DATEVALUE/EOMONTH/WEEKNUM/WORKDAY/NETWORKDAYS etc)"
```

---

## Task 3: Statistical functions (14 new)

**Functions:** VAR/VAR.S, VAR.P, STDEV.P, PERCENTILE/PERCENTILE.INC, PERCENTILE.EXC, QUARTILE/QUARTILE.INC, GEOMEAN, HARMEAN, AVEDEV, PERCENTRANK/PERCENTRANK.INC, MODE/MODE.SNGL, CORREL, FORECAST/FORECAST.LINEAR

CORREL, FORECAST, PERCENTILE, PERCENTILE.EXC, QUARTILE, PERCENTRANK → `IsStructuredRangeFunction` (need RangeValue args to keep arrays separate/intact)
VAR, STDEV.P, GEOMEAN, HARMEAN, AVEDEV, MODE → `IsAggregateFunction` (flat expansion is correct)

- [ ] **Step 1: Write failing tests**

```csharp
// ── Statistical ──────────────────────────────────────────────────────────────

[Fact] public void VarS_ThreeValues_ReturnsSampleVariance()
{
    var sheet = MakeSheet((1,1,new NumberValue(2)),(2,1,new NumberValue(4)),(3,1,new NumberValue(6)));
    // mean=4, var.s = ((4+0+4)/2) = 4
    _eval.Evaluate("=VAR(A1:A3)", sheet).Should().Be(new NumberValue(4));
}

[Fact] public void VarP_ThreeValues_ReturnsPopulationVariance()
{
    var sheet = MakeSheet((1,1,new NumberValue(2)),(2,1,new NumberValue(4)),(3,1,new NumberValue(6)));
    // mean=4, var.p = (4+0+4)/3 = 8/3
    ((NumberValue)_eval.Evaluate("=VAR.P(A1:A3)", sheet)).Value
        .Should().BeApproximately(8.0 / 3.0, 1e-10);
}

[Fact] public void StdevP_ThreeValues_ReturnsStdDev()
{
    var sheet = MakeSheet((1,1,new NumberValue(2)),(2,1,new NumberValue(4)),(3,1,new NumberValue(6)));
    ((NumberValue)_eval.Evaluate("=STDEV.P(A1:A3)", sheet)).Value
        .Should().BeApproximately(Math.Sqrt(8.0 / 3.0), 1e-10);
}

[Fact] public void Percentile_Median_Returns4()
{
    var sheet = MakeSheet((1,1,new NumberValue(2)),(2,1,new NumberValue(4)),(3,1,new NumberValue(6)));
    _eval.Evaluate("=PERCENTILE(A1:A3,0.5)", sheet).Should().Be(new NumberValue(4));
}

[Fact] public void PercentileExc_Middle_ReturnsInterpolated()
{
    var sheet = MakeSheet((1,1,new NumberValue(1)),(2,1,new NumberValue(2)),(3,1,new NumberValue(3)),(4,1,new NumberValue(4)));
    // PERCENTILE.EXC([1,2,3,4], 0.4): rank = 0.4*5-1 = 1, index 1 → value 2
    _eval.Evaluate("=PERCENTILE.EXC(A1:A4,0.4)", sheet).Should().Be(new NumberValue(2));
}

[Fact] public void Quartile_Q1_Returns25th()
{
    var sheet = MakeSheet((1,1,new NumberValue(1)),(2,1,new NumberValue(2)),(3,1,new NumberValue(3)),(4,1,new NumberValue(4)));
    // QUARTILE([1,2,3,4], 1) = 25th percentile = 1.75
    ((NumberValue)_eval.Evaluate("=QUARTILE(A1:A4,1)", sheet)).Value
        .Should().BeApproximately(1.75, 1e-10);
}

[Fact] public void Geomean_TwoNumbers_ReturnsGeometricMean()
{
    var sheet = MakeSheet((1,1,new NumberValue(4)),(2,1,new NumberValue(9)));
    // geomean(4,9) = sqrt(36) = 6
    _eval.Evaluate("=GEOMEAN(A1:A2)", sheet).Should().Be(new NumberValue(6));
}

[Fact] public void Harmean_TwoNumbers_ReturnsHarmonicMean()
{
    var sheet = MakeSheet((1,1,new NumberValue(1)),(2,1,new NumberValue(4)));
    // harmean(1,4) = 2/(1+0.25) = 1.6
    ((NumberValue)_eval.Evaluate("=HARMEAN(A1:A2)", sheet)).Value
        .Should().BeApproximately(1.6, 1e-10);
}

[Fact] public void Avedev_ThreeValues_ReturnsAvgAbsDev()
{
    var sheet = MakeSheet((1,1,new NumberValue(2)),(2,1,new NumberValue(4)),(3,1,new NumberValue(6)));
    // mean=4, deviations=2,0,2 → avg=4/3
    ((NumberValue)_eval.Evaluate("=AVEDEV(A1:A3)", sheet)).Value
        .Should().BeApproximately(4.0 / 3.0, 1e-10);
}

[Fact] public void Mode_ReturnsValueWithHighestFrequency()
{
    var sheet = MakeSheet((1,1,new NumberValue(1)),(2,1,new NumberValue(2)),(3,1,new NumberValue(2)),(4,1,new NumberValue(3)));
    _eval.Evaluate("=MODE(A1:A4)", sheet).Should().Be(new NumberValue(2));
}

[Fact] public void Percentrank_FindsRank()
{
    var sheet = MakeSheet(
        (1,1,new NumberValue(1)),(2,1,new NumberValue(2)),(3,1,new NumberValue(3)),(4,1,new NumberValue(4)),(5,1,new NumberValue(5)));
    // PERCENTRANK([1..5], 3) = 0.5
    _eval.Evaluate("=PERCENTRANK(A1:A5,3)", sheet).Should().Be(new NumberValue(0.5));
}

[Fact] public void Correl_PerfectPositive_Returns1()
{
    var sheet = MakeSheet(
        (1,1,new NumberValue(1)),(2,1,new NumberValue(2)),(3,1,new NumberValue(3)),
        (1,2,new NumberValue(2)),(2,2,new NumberValue(4)),(3,2,new NumberValue(6)));
    ((NumberValue)_eval.Evaluate("=CORREL(A1:A3,B1:B3)", sheet)).Value
        .Should().BeApproximately(1.0, 1e-10);
}

[Fact] public void Forecast_LinearTrend_PredictsCorrectly()
{
    var sheet = MakeSheet(
        (1,1,new NumberValue(1)),(2,1,new NumberValue(2)),(3,1,new NumberValue(3)),
        (1,2,new NumberValue(2)),(2,2,new NumberValue(4)),(3,2,new NumberValue(6)));
    // FORECAST(4, A1:A3, B1:B3) — wait, args are (x, known_y, known_x)
    // known_y = A1:A3 = [1,2,3], known_x = B1:B3 = [2,4,6], predict y at x=8 → 4
    ((NumberValue)_eval.Evaluate("=FORECAST(8,A1:A3,B1:B3)", sheet)).Value
        .Should().BeApproximately(4.0, 1e-10);
}
```

- [ ] **Step 2: Run to see failures**

```
dotnet test tests/FreeX.Core.Formula.Tests --filter "VarS_|VarP_|StdevP_|Percentile_|PercentileExc_|Quartile_|Geomean_|Harmean_|Avedev_|Mode_|Percentrank_|Correl_|Forecast_" -v n
```

- [ ] **Step 3: Register statistical functions**

```csharp
        // ── Phase 4a: Statistical ────────────────────────────────────────────
        ["VAR"]              = (VarS, 1, 255),
        ["VAR.S"]            = (VarS, 1, 255),
        ["VAR.P"]            = (VarP, 1, 255),
        ["STDEV.P"]          = (StdevP, 1, 255),
        ["PERCENTILE"]       = (PercentileInc, 2, 2),
        ["PERCENTILE.INC"]   = (PercentileInc, 2, 2),
        ["PERCENTILE.EXC"]   = (PercentileExc, 2, 2),
        ["QUARTILE"]         = (QuartileInc, 2, 2),
        ["QUARTILE.INC"]     = (QuartileInc, 2, 2),
        ["GEOMEAN"]          = (Geomean, 1, 255),
        ["HARMEAN"]          = (Harmean, 1, 255),
        ["AVEDEV"]           = (Avedev, 1, 255),
        ["PERCENTRANK"]      = (PercentrankInc, 2, 3),
        ["PERCENTRANK.INC"]  = (PercentrankInc, 2, 3),
        ["MODE"]             = (ModeSngl, 1, 255),
        ["MODE.SNGL"]        = (ModeSngl, 1, 255),
        ["CORREL"]           = (Correl, 2, 2),
        ["FORECAST"]         = (Forecast, 3, 3),
        ["FORECAST.LINEAR"]  = (Forecast, 3, 3),
```

- [ ] **Step 4: Add statistical implementations**

```csharp
    // ═══════════════════════════════════════════════════════════════════
    // Phase 4a  –  Statistical
    // ═══════════════════════════════════════════════════════════════════

    private static ScalarValue VarS(IReadOnlyList<ScalarValue> args, IEvalContext ctx)
    {
        var nums = CollectNumbers(args);
        if (nums is ErrorValue e) return e;
        var list = (List<double>)nums;
        if (list.Count < 2) return ErrorValue.DivByZero;
        double mean = list.Average();
        return new NumberValue(list.Sum(x => (x - mean) * (x - mean)) / (list.Count - 1));
    }

    private static ScalarValue VarP(IReadOnlyList<ScalarValue> args, IEvalContext ctx)
    {
        var nums = CollectNumbers(args);
        if (nums is ErrorValue e) return e;
        var list = (List<double>)nums;
        if (list.Count == 0) return ErrorValue.DivByZero;
        double mean = list.Average();
        return new NumberValue(list.Sum(x => (x - mean) * (x - mean)) / list.Count);
    }

    private static ScalarValue StdevP(IReadOnlyList<ScalarValue> args, IEvalContext ctx)
    {
        var r = VarP(args, ctx);
        return r is NumberValue nv ? new NumberValue(Math.Sqrt(nv.Value)) : r;
    }

    // Shared helper: collect all NumberValues from flat args, returning List<double> or ErrorValue
    private static object CollectNumbers(IReadOnlyList<ScalarValue> args)
    {
        var list = new List<double>();
        foreach (var a in args)
        {
            if (a is ErrorValue e) return e;
            if (a is NumberValue nv) list.Add(nv.Value);
        }
        return list;
    }

    private static ScalarValue PercentileInc(IReadOnlyList<ScalarValue> args, IEvalContext ctx)
    {
        if (args[0] is not RangeValue rv) return ErrorValue.Value;
        if (args[1] is ErrorValue e) return e;
        double k = ToNumber(args[1]);
        if (k < 0 || k > 1) return ErrorValue.Num;
        var sorted = rv.Flatten().OfType<NumberValue>().Select(n => n.Value).OrderBy(x => x).ToList();
        if (sorted.Count == 0) return ErrorValue.Num;
        double rank = k * (sorted.Count - 1);
        int lo = (int)rank;
        if (lo >= sorted.Count - 1) return new NumberValue(sorted[^1]);
        return new NumberValue(sorted[lo] + (rank - lo) * (sorted[lo + 1] - sorted[lo]));
    }

    private static ScalarValue PercentileExc(IReadOnlyList<ScalarValue> args, IEvalContext ctx)
    {
        if (args[0] is not RangeValue rv) return ErrorValue.Value;
        if (args[1] is ErrorValue e) return e;
        double k = ToNumber(args[1]);
        if (k <= 0 || k >= 1) return ErrorValue.Num;
        var sorted = rv.Flatten().OfType<NumberValue>().Select(n => n.Value).OrderBy(x => x).ToList();
        int n = sorted.Count;
        if (n == 0) return ErrorValue.Num;
        double rank = k * (n + 1) - 1;
        if (rank < 0 || rank >= n) return ErrorValue.Num;
        int lo = (int)rank;
        if (lo >= n - 1) return new NumberValue(sorted[n - 1]);
        return new NumberValue(sorted[lo] + (rank - lo) * (sorted[lo + 1] - sorted[lo]));
    }

    private static ScalarValue QuartileInc(IReadOnlyList<ScalarValue> args, IEvalContext ctx)
    {
        if (args[0] is not RangeValue rv) return ErrorValue.Value;
        if (args[1] is ErrorValue e) return e;
        int quart = (int)ToNumber(args[1]);
        if (quart < 0 || quart > 4) return ErrorValue.Num;
        var sorted = rv.Flatten().OfType<NumberValue>().Select(n => n.Value).OrderBy(x => x).ToList();
        if (sorted.Count == 0) return ErrorValue.Num;
        if (quart == 0) return new NumberValue(sorted[0]);
        if (quart == 4) return new NumberValue(sorted[^1]);
        double rank = (quart / 4.0) * (sorted.Count - 1);
        int lo = (int)rank;
        if (lo >= sorted.Count - 1) return new NumberValue(sorted[^1]);
        return new NumberValue(sorted[lo] + (rank - lo) * (sorted[lo + 1] - sorted[lo]));
    }

    private static ScalarValue Geomean(IReadOnlyList<ScalarValue> args, IEvalContext ctx)
    {
        var logSum = 0.0;
        int count = 0;
        foreach (var a in args)
        {
            if (a is ErrorValue e) return e;
            if (a is NumberValue nv)
            {
                if (nv.Value <= 0) return ErrorValue.Num;
                logSum += Math.Log(nv.Value);
                count++;
            }
        }
        if (count == 0) return ErrorValue.Num;
        return new NumberValue(Math.Exp(logSum / count));
    }

    private static ScalarValue Harmean(IReadOnlyList<ScalarValue> args, IEvalContext ctx)
    {
        double recSum = 0;
        int count = 0;
        foreach (var a in args)
        {
            if (a is ErrorValue e) return e;
            if (a is NumberValue nv)
            {
                if (nv.Value <= 0) return ErrorValue.Num;
                recSum += 1.0 / nv.Value;
                count++;
            }
        }
        if (count == 0) return ErrorValue.Num;
        return new NumberValue(count / recSum);
    }

    private static ScalarValue Avedev(IReadOnlyList<ScalarValue> args, IEvalContext ctx)
    {
        var nums = new List<double>();
        foreach (var a in args)
        {
            if (a is ErrorValue e) return e;
            if (a is NumberValue nv) nums.Add(nv.Value);
        }
        if (nums.Count == 0) return ErrorValue.DivByZero;
        double mean = nums.Average();
        return new NumberValue(nums.Average(x => Math.Abs(x - mean)));
    }

    private static ScalarValue ModeSngl(IReadOnlyList<ScalarValue> args, IEvalContext ctx)
    {
        var freq = new Dictionary<double, int>();
        foreach (var a in args)
        {
            if (a is ErrorValue e) return e;
            if (a is NumberValue nv)
                freq[nv.Value] = freq.GetValueOrDefault(nv.Value) + 1;
        }
        if (freq.Count == 0) return ErrorValue.NA;
        return new NumberValue(freq.MaxBy(kv => kv.Value).Key);
    }

    private static ScalarValue PercentrankInc(IReadOnlyList<ScalarValue> args, IEvalContext ctx)
    {
        if (args[0] is not RangeValue rv) return ErrorValue.Value;
        if (args[1] is ErrorValue e) return e;
        double x = ToNumber(args[1]);
        int sig = args.Count > 2 && args[2] is not BlankValue ? (int)ToNumber(args[2]) : 3;
        var sorted = rv.Flatten().OfType<NumberValue>().Select(n => n.Value).OrderBy(v => v).ToList();
        int n = sorted.Count;
        if (n == 0 || x < sorted[0] || x > sorted[^1]) return ErrorValue.NA;
        int below = sorted.Count(v => v < x);
        int equal = sorted.Count(v => v == x);
        if (equal == 0) return ErrorValue.NA;
        double pctRank = n == 1 ? 0.0 : (double)below / (n - 1);
        double factor = Math.Pow(10, sig);
        return new NumberValue(Math.Floor(pctRank * factor) / factor);
    }

    private static ScalarValue Correl(IReadOnlyList<ScalarValue> args, IEvalContext ctx)
    {
        if (args[0] is not RangeValue rv1) return ErrorValue.Value;
        if (args[1] is not RangeValue rv2) return ErrorValue.Value;
        var xs = rv1.Flatten().OfType<NumberValue>().Select(n => n.Value).ToList();
        var ys = rv2.Flatten().OfType<NumberValue>().Select(n => n.Value).ToList();
        int n = Math.Min(xs.Count, ys.Count);
        if (n < 2) return ErrorValue.DivByZero;
        double xMean = xs.Take(n).Average();
        double yMean = ys.Take(n).Average();
        double cov = 0, varX = 0, varY = 0;
        for (int i = 0; i < n; i++)
        {
            double dx = xs[i] - xMean, dy = ys[i] - yMean;
            cov  += dx * dy;
            varX += dx * dx;
            varY += dy * dy;
        }
        if (varX == 0 || varY == 0) return ErrorValue.DivByZero;
        return new NumberValue(cov / Math.Sqrt(varX * varY));
    }

    private static ScalarValue Forecast(IReadOnlyList<ScalarValue> args, IEvalContext ctx)
    {
        if (args[0] is ErrorValue e) return e;
        if (args[1] is not RangeValue knownY) return ErrorValue.Value;
        if (args[2] is not RangeValue knownX) return ErrorValue.Value;
        double x    = ToNumber(args[0]);
        var ys      = knownY.Flatten().OfType<NumberValue>().Select(n => n.Value).ToList();
        var xs      = knownX.Flatten().OfType<NumberValue>().Select(n => n.Value).ToList();
        int n = Math.Min(xs.Count, ys.Count);
        if (n < 2) return ErrorValue.NA;
        double xMean = xs.Take(n).Average();
        double yMean = ys.Take(n).Average();
        double sXX = 0, sXY = 0;
        for (int i = 0; i < n; i++)
        {
            double dx = xs[i] - xMean;
            sXX += dx * dx;
            sXY += dx * (ys[i] - yMean);
        }
        if (sXX == 0) return ErrorValue.DivByZero;
        double b = sXY / sXX;
        double a = yMean - b * xMean;
        return new NumberValue(a + b * x);
    }
```

- [ ] **Step 5: Run tests**

```
dotnet test tests/FreeX.Core.Formula.Tests --filter "VarS_|VarP_|StdevP_|Percentile_|PercentileExc_|Quartile_|Geomean_|Harmean_|Avedev_|Mode_|Percentrank_|Correl_|Forecast_" -v n
```

Expected: all PASS

- [ ] **Step 6: Commit**

```
git add src/FreeX.Core.Formula/BuiltInFunctions.cs src/FreeX.Core.Formula/FormulaEvaluator.cs tests/FreeX.Core.Formula.Tests/FunctionLibraryTests.cs
git commit -m "feat: add 14 statistical functions (VAR/STDEV.P/PERCENTILE/QUARTILE/GEOMEAN/HARMEAN/CORREL/FORECAST etc)"
```

---

## Task 4: Financial functions (8 new)

**Functions:** PMT, PV, FV, NPER, RATE, NPV, IRR, SLN

IRR → `IsStructuredRangeFunction` (needs values array as RangeValue)
NPV → `IsAggregateFunction` (rate scalar + flat-expanded value args works perfectly)

Note: `IsAggregateFunction` was updated in Task 1 Step 5 (add "NPV" to that list if not already there — it was omitted; add it now).

- [ ] **Step 1: Write failing tests**

```csharp
// ── Financial ────────────────────────────────────────────────────────────────

[Fact] public void Pmt_MonthlyPayment_ReturnsNegative()
{
    // PMT(5%/12, 60, 10000) ≈ -188.71
    ((NumberValue)_eval.Evaluate("=PMT(0.05/12,60,10000)", MakeSheet())).Value
        .Should().BeApproximately(-188.71, 0.01);
}

[Fact] public void Pv_FutureValue_ReturnsPresent()
{
    // PV(5%/12, 60, 188.71) ≈ -10000
    ((NumberValue)_eval.Evaluate("=PV(0.05/12,60,188.71)", MakeSheet())).Value
        .Should().BeApproximately(-10000, 1.0);
}

[Fact] public void Fv_Savings_ReturnsAccumulated()
{
    // FV(5%/12, 12, -100) ≈ 1233.56
    ((NumberValue)_eval.Evaluate("=FV(0.05/12,12,-100)", MakeSheet())).Value
        .Should().BeApproximately(1233.56, 0.1);
}

[Fact] public void Nper_CountPeriods_Returns60()
{
    ((NumberValue)_eval.Evaluate("=NPER(0.05/12,-188.71,10000)", MakeSheet())).Value
        .Should().BeApproximately(60, 0.1);
}

[Fact] public void Rate_FindsInterestRate()
{
    // RATE(60, -188.71, 10000) ≈ 0.05/12
    ((NumberValue)_eval.Evaluate("=RATE(60,-188.71,10000)", MakeSheet())).Value
        .Should().BeApproximately(0.05 / 12, 1e-5);
}

[Fact] public void Npv_BasicCashflow_ReturnsNpv()
{
    var sheet = MakeSheet(
        (1,1,new NumberValue(-1000)),
        (2,1,new NumberValue(400)),
        (3,1,new NumberValue(400)),
        (4,1,new NumberValue(400)));
    // NPV(0.1, A2:A4) + A1 — simplest: NPV(0.1, A1:A4) treats all as equally spaced
    ((NumberValue)_eval.Evaluate("=NPV(0.1,A1:A4)", sheet)).Value
        .Should().BeApproximately(-1000.0/1.1 + 400.0/1.21 + 400.0/1.331 + 400.0/1.4641, 0.01);
}

[Fact] public void Irr_CashflowSeries_ReturnsRate()
{
    var sheet = MakeSheet(
        (1,1,new NumberValue(-1000)),
        (2,1,new NumberValue(300)),
        (3,1,new NumberValue(400)),
        (4,1,new NumberValue(500)));
    ((NumberValue)_eval.Evaluate("=IRR(A1:A4)", sheet)).Value
        .Should().BeApproximately(0.1822, 0.001);
}

[Fact] public void Sln_StraightLine_ReturnsAnnualDep()
{
    // SLN(10000, 1000, 9) ≈ 1000
    _eval.Evaluate("=SLN(10000,1000,9)", MakeSheet()).Should().Be(new NumberValue(1000));
}
```

- [ ] **Step 2: Run to see failures**

```
dotnet test tests/FreeX.Core.Formula.Tests --filter "Pmt_|Pv_|Fv_|Nper_|Rate_|Npv_|Irr_|Sln_" -v n
```

- [ ] **Step 3: Register financial functions + update IsAggregateFunction for NPV**

Add to Functions dictionary:

```csharp
        // ── Phase 4a: Financial ──────────────────────────────────────────────
        ["PMT"]  = (Pmt, 3, 5),
        ["PV"]   = (Pv, 3, 5),
        ["FV"]   = (Fv, 3, 5),
        ["NPER"] = (Nper, 3, 5),
        ["RATE"] = (Rate, 3, 6),
        ["NPV"]  = (Npv, 2, 255),
        ["IRR"]  = (Irr, 1, 2),
        ["SLN"]  = (Sln, 3, 3),
```

Also add `"NPV"` to `IsAggregateFunction` in `FormulaEvaluator.cs` (edit the string from Task 1):

```csharp
private static bool IsAggregateFunction(string name) =>
    name is "SUM" or "AVERAGE" or "MIN" or "MAX" or "COUNT" or "COUNTA" or "AND" or "OR" or "CONCAT"
         or "STDEV" or "MEDIAN"
         or "PRODUCT" or "XOR"
         or "VAR" or "VAR.S" or "VAR.P" or "STDEV.P"
         or "GEOMEAN" or "HARMEAN" or "AVEDEV"
         or "MODE" or "MODE.SNGL"
         or "CONCATENATE"
         or "NPV";
```

- [ ] **Step 4: Add financial implementations**

```csharp
    // ═══════════════════════════════════════════════════════════════════
    // Phase 4a  –  Financial
    // ═══════════════════════════════════════════════════════════════════

    private static ScalarValue Pmt(IReadOnlyList<ScalarValue> args, IEvalContext ctx)
    {
        if (args[0] is ErrorValue e0) return e0;
        double rate = ToNumber(args[0]);
        int    nper = (int)ToNumber(args[1]);
        double pv   = ToNumber(args[2]);
        double fv   = args.Count > 3 && args[3] is not BlankValue ? ToNumber(args[3]) : 0;
        double type = args.Count > 4 && args[4] is not BlankValue ? ToNumber(args[4]) : 0;
        if (nper == 0) return ErrorValue.DivByZero;
        if (Math.Abs(rate) < 1e-10)
            return new NumberValue(-(pv + fv) / nper);
        double rn  = Math.Pow(1 + rate, nper);
        double pmt = -(pv * rn + fv) * rate / ((1 + rate * type) * (rn - 1));
        return new NumberValue(pmt);
    }

    private static ScalarValue Pv(IReadOnlyList<ScalarValue> args, IEvalContext ctx)
    {
        if (args[0] is ErrorValue e0) return e0;
        double rate = ToNumber(args[0]);
        int    nper = (int)ToNumber(args[1]);
        double pmt  = ToNumber(args[2]);
        double fv   = args.Count > 3 && args[3] is not BlankValue ? ToNumber(args[3]) : 0;
        double type = args.Count > 4 && args[4] is not BlankValue ? ToNumber(args[4]) : 0;
        if (nper == 0) return ErrorValue.DivByZero;
        if (Math.Abs(rate) < 1e-10)
            return new NumberValue(-pmt * nper - fv);
        double rn = Math.Pow(1 + rate, nper);
        double pv = (-pmt * (1 + rate * type) * (rn - 1) / rate - fv) / rn;
        return new NumberValue(pv);
    }

    private static ScalarValue Fv(IReadOnlyList<ScalarValue> args, IEvalContext ctx)
    {
        if (args[0] is ErrorValue e0) return e0;
        double rate = ToNumber(args[0]);
        int    nper = (int)ToNumber(args[1]);
        double pmt  = ToNumber(args[2]);
        double pv   = args.Count > 3 && args[3] is not BlankValue ? ToNumber(args[3]) : 0;
        double type = args.Count > 4 && args[4] is not BlankValue ? ToNumber(args[4]) : 0;
        if (Math.Abs(rate) < 1e-10)
            return new NumberValue(-pv - pmt * nper);
        double rn = Math.Pow(1 + rate, nper);
        return new NumberValue(-pv * rn - pmt * (1 + rate * type) * (rn - 1) / rate);
    }

    private static ScalarValue Nper(IReadOnlyList<ScalarValue> args, IEvalContext ctx)
    {
        if (args[0] is ErrorValue e0) return e0;
        double rate = ToNumber(args[0]);
        double pmt  = ToNumber(args[1]);
        double pv   = ToNumber(args[2]);
        double fv   = args.Count > 3 && args[3] is not BlankValue ? ToNumber(args[3]) : 0;
        double type = args.Count > 4 && args[4] is not BlankValue ? ToNumber(args[4]) : 0;
        if (Math.Abs(rate) < 1e-10)
        {
            if (Math.Abs(pmt) < 1e-10) return ErrorValue.DivByZero;
            return new NumberValue(-(pv + fv) / pmt);
        }
        double pmtAdj = pmt * (1 + rate * type);
        double ratio  = (pmtAdj - fv * rate) / (pmtAdj + pv * rate);
        if (ratio <= 0) return ErrorValue.Num;
        return new NumberValue(Math.Log(ratio) / Math.Log(1 + rate));
    }

    private static ScalarValue Rate(IReadOnlyList<ScalarValue> args, IEvalContext ctx)
    {
        int    nper  = (int)ToNumber(args[0]);
        double pmt   = ToNumber(args[1]);
        double pv    = ToNumber(args[2]);
        double fv    = args.Count > 3 && args[3] is not BlankValue ? ToNumber(args[3]) : 0;
        double type  = args.Count > 4 && args[4] is not BlankValue ? ToNumber(args[4]) : 0;
        double guess = args.Count > 5 && args[5] is not BlankValue ? ToNumber(args[5]) : 0.1;
        double r = guess;
        for (int i = 0; i < 100; i++)
        {
            double rn   = Math.Pow(1 + r, nper);
            double rn1  = nper * Math.Pow(1 + r, nper - 1);
            double f, df;
            if (Math.Abs(r) < 1e-10)
            {
                f  = pv + pmt * nper + fv;
                df = pv * nper + pmt * nper * (nper - 1) / 2.0;
            }
            else
            {
                f  = pv * rn + pmt * (1 + r * type) * (rn - 1) / r + fv;
                df = pv * rn1
                   + pmt * type * (rn - 1) / r
                   + pmt * (1 + r * type) * (rn1 * r - (rn - 1)) / (r * r);
            }
            if (Math.Abs(df) < 1e-15) break;
            double delta = f / df;
            r -= delta;
            if (Math.Abs(delta) < 1e-10) break;
        }
        return double.IsNaN(r) || double.IsInfinity(r) ? ErrorValue.Num : new NumberValue(r);
    }

    private static ScalarValue Npv(IReadOnlyList<ScalarValue> args, IEvalContext ctx)
    {
        if (args[0] is ErrorValue e) return e;
        double rate   = ToNumber(args[0]);
        double result = 0;
        for (int i = 1; i < args.Count; i++)
        {
            if (args[i] is ErrorValue ev) return ev;
            if (args[i] is NumberValue nv)
                result += nv.Value / Math.Pow(1 + rate, i);
        }
        return new NumberValue(result);
    }

    private static ScalarValue Irr(IReadOnlyList<ScalarValue> args, IEvalContext ctx)
    {
        if (args[0] is not RangeValue valRange) return ErrorValue.Value;
        double guess = args.Count > 1 && args[1] is not BlankValue ? ToNumber(args[1]) : 0.1;
        var values = valRange.Flatten()
                             .OfType<NumberValue>()
                             .Select(n => n.Value)
                             .ToList();
        if (values.Count == 0) return ErrorValue.Value;
        double r = guess;
        for (int iter = 0; iter < 100; iter++)
        {
            double f = 0, df = 0;
            for (int i = 0; i < values.Count; i++)
            {
                double denom = Math.Pow(1 + r, i);
                f  += values[i] / denom;
                if (i > 0) df -= i * values[i] / (denom * (1 + r));
            }
            if (Math.Abs(f) < 1e-10) break;
            if (Math.Abs(df) < 1e-15) return ErrorValue.Num;
            double delta = f / df;
            r -= delta;
            if (Math.Abs(delta) < 1e-10) break;
        }
        return double.IsNaN(r) || double.IsInfinity(r) ? ErrorValue.Num : new NumberValue(r);
    }

    private static ScalarValue Sln(IReadOnlyList<ScalarValue> args, IEvalContext ctx)
    {
        if (args[0] is ErrorValue e0) return e0;
        double cost    = ToNumber(args[0]);
        double salvage = ToNumber(args[1]);
        double life    = ToNumber(args[2]);
        if (life == 0) return ErrorValue.DivByZero;
        return new NumberValue((cost - salvage) / life);
    }
```

- [ ] **Step 5: Run tests**

```
dotnet test tests/FreeX.Core.Formula.Tests --filter "Pmt_|Pv_|Fv_|Nper_|Rate_|Npv_|Irr_|Sln_" -v n
```

Expected: all PASS

- [ ] **Step 6: Commit**

```
git add src/FreeX.Core.Formula/BuiltInFunctions.cs src/FreeX.Core.Formula/FormulaEvaluator.cs tests/FreeX.Core.Formula.Tests/FunctionLibraryTests.cs
git commit -m "feat: add 8 financial functions (PMT/PV/FV/NPER/RATE/NPV/IRR/SLN)"
```

---

## Task 5: Logical and Text functions (11 new)

**Functions:** XOR, TRUE, FALSE, ISEVEN, ISODD, REPLACE, CONCATENATE, T, FIXED, CLEAN, DOLLAR

XOR → `IsAggregateFunction` (already added in Task 1 Step 5)
CONCATENATE → `IsAggregateFunction` (already added in Task 1 Step 5)

- [ ] **Step 1: Write failing tests**

```csharp
// ── Logical / Text ───────────────────────────────────────────────────────────

[Fact] public void Xor_TrueTrue_ReturnsFalse() =>
    _eval.Evaluate("=XOR(TRUE,TRUE)", MakeSheet()).Should().Be(new BoolValue(false));

[Fact] public void Xor_TrueFalse_ReturnsTrue() =>
    _eval.Evaluate("=XOR(TRUE,FALSE)", MakeSheet()).Should().Be(new BoolValue(true));

[Fact] public void TrueFunc_ReturnsTrue() =>
    _eval.Evaluate("=TRUE()", MakeSheet()).Should().Be(new BoolValue(true));

[Fact] public void FalseFunc_ReturnsFalse() =>
    _eval.Evaluate("=FALSE()", MakeSheet()).Should().Be(new BoolValue(false));

[Fact] public void Iseven_4_ReturnsTrue() =>
    _eval.Evaluate("=ISEVEN(4)", MakeSheet()).Should().Be(new BoolValue(true));

[Fact] public void Isodd_3_ReturnsTrue() =>
    _eval.Evaluate("=ISODD(3)", MakeSheet()).Should().Be(new BoolValue(true));

[Fact] public void Replace_Middle_ReplacesCorrectly() =>
    _eval.Evaluate("=REPLACE(\"Hello World\",7,5,\"Excel\")", MakeSheet())
        .Should().Be(new TextValue("Hello Excel"));

[Fact] public void Concatenate_TwoStrings_JoinsThem() =>
    _eval.Evaluate("=CONCATENATE(\"Hello \",\"World\")", MakeSheet())
        .Should().Be(new TextValue("Hello World"));

[Fact] public void T_Text_ReturnsText() =>
    _eval.Evaluate("=T(\"hello\")", MakeSheet()).Should().Be(new TextValue("hello"));

[Fact] public void T_Number_ReturnsEmpty() =>
    _eval.Evaluate("=T(42)", MakeSheet()).Should().Be(new TextValue(""));

[Fact] public void Fixed_TwoDecimals_ReturnsFormatted() =>
    _eval.Evaluate("=FIXED(1234.567,2,TRUE)", MakeSheet())
        .Should().Be(new TextValue("1234.57"));

[Fact] public void Clean_RemovesControlChars()
{
    var sheet = MakeSheet((1, 1, new TextValue("Hello\x01World")));
    _eval.Evaluate("=CLEAN(A1)", sheet).Should().Be(new TextValue("HelloWorld"));
}

[Fact] public void Dollar_FormatsAsCurrency() =>
    _eval.Evaluate("=DOLLAR(1234.5,2)", MakeSheet())
        .Should().Be(new TextValue("$1,234.50"));
```

- [ ] **Step 2: Run to see failures**

```
dotnet test tests/FreeX.Core.Formula.Tests --filter "Xor_|TrueFunc_|FalseFunc_|Iseven_|Isodd_|Replace_|Concatenate_|T_Text|T_Number|Fixed_|Clean_|Dollar_" -v n
```

- [ ] **Step 3: Register logical/text functions**

```csharp
        // ── Phase 4a: Logical / Text ─────────────────────────────────────────
        ["XOR"]         = (Xor, 1, 255),
        ["TRUE"]        = (TrueFunc, 0, 0),
        ["FALSE"]       = (FalseFunc, 0, 0),
        ["ISEVEN"]      = (Iseven, 1, 1),
        ["ISODD"]       = (Isodd, 1, 1),
        ["REPLACE"]     = (Replace, 4, 4),
        ["CONCATENATE"] = (Concatenate, 1, 255),
        ["T"]           = (TFunc, 1, 1),
        ["FIXED"]       = (Fixed, 1, 3),
        ["CLEAN"]       = (Clean, 1, 1),
        ["DOLLAR"]      = (Dollar, 1, 2),
```

- [ ] **Step 4: Add implementations**

```csharp
    // ═══════════════════════════════════════════════════════════════════
    // Phase 4a  –  Logical / Text
    // ═══════════════════════════════════════════════════════════════════

    private static ScalarValue Xor(IReadOnlyList<ScalarValue> args, IEvalContext ctx)
    {
        bool result = false;
        foreach (var a in args)
        {
            if (a is ErrorValue e) return e;
            result ^= ToBool(a);
        }
        return new BoolValue(result);
    }

    private static ScalarValue TrueFunc(IReadOnlyList<ScalarValue> args, IEvalContext ctx) =>
        new BoolValue(true);

    private static ScalarValue FalseFunc(IReadOnlyList<ScalarValue> args, IEvalContext ctx) =>
        new BoolValue(false);

    private static ScalarValue Iseven(IReadOnlyList<ScalarValue> args, IEvalContext ctx)
    {
        if (args[0] is ErrorValue e) return e;
        return new BoolValue((long)Math.Truncate(ToNumber(args[0])) % 2 == 0);
    }

    private static ScalarValue Isodd(IReadOnlyList<ScalarValue> args, IEvalContext ctx)
    {
        if (args[0] is ErrorValue e) return e;
        return new BoolValue((long)Math.Truncate(ToNumber(args[0])) % 2 != 0);
    }

    private static ScalarValue Replace(IReadOnlyList<ScalarValue> args, IEvalContext ctx)
    {
        if (args[0] is ErrorValue e) return e;
        var text    = ToText(args[0]);
        int start   = Math.Max(0, (int)ToNumber(args[1]) - 1); // 1-based → 0-based
        int numChars = Math.Max(0, (int)ToNumber(args[2]));
        var newText = ToText(args[3]);
        start = Math.Min(start, text.Length);
        int end = Math.Min(start + numChars, text.Length);
        return new TextValue(text[..start] + newText + text[end..]);
    }

    private static ScalarValue Concatenate(IReadOnlyList<ScalarValue> args, IEvalContext ctx)
    {
        var sb = new System.Text.StringBuilder();
        foreach (var a in args)
        {
            if (a is ErrorValue e) return e;
            sb.Append(ToText(a));
        }
        return new TextValue(sb.ToString());
    }

    private static ScalarValue TFunc(IReadOnlyList<ScalarValue> args, IEvalContext ctx) =>
        args[0] is TextValue t ? t : new TextValue("");

    private static ScalarValue Fixed(IReadOnlyList<ScalarValue> args, IEvalContext ctx)
    {
        if (args[0] is ErrorValue e) return e;
        double n    = ToNumber(args[0]);
        int dec     = args.Count > 1 && args[1] is not BlankValue ? (int)ToNumber(args[1]) : 2;
        bool noCommas = args.Count > 2 && args[2] is not BlankValue && ToBool(args[2]);
        dec = Math.Max(0, dec);
        string fmt = noCommas ? "F" + dec : "N" + dec;
        return new TextValue(Math.Round(n, dec, MidpointRounding.AwayFromZero)
                                 .ToString(fmt, System.Globalization.CultureInfo.InvariantCulture));
    }

    private static ScalarValue Clean(IReadOnlyList<ScalarValue> args, IEvalContext ctx)
    {
        if (args[0] is ErrorValue e) return e;
        var sb = new System.Text.StringBuilder();
        foreach (char c in ToText(args[0]))
            if (c >= 32) sb.Append(c);
        return new TextValue(sb.ToString());
    }

    private static ScalarValue Dollar(IReadOnlyList<ScalarValue> args, IEvalContext ctx)
    {
        if (args[0] is ErrorValue e) return e;
        double n = ToNumber(args[0]);
        int dec  = args.Count > 1 && args[1] is not BlankValue ? (int)ToNumber(args[1]) : 2;
        dec = Math.Max(0, dec);
        string rounded = Math.Round(n, dec, MidpointRounding.AwayFromZero)
                             .ToString("N" + dec, System.Globalization.CultureInfo.InvariantCulture);
        return new TextValue("$" + rounded);
    }
```

- [ ] **Step 5: Run tests**

```
dotnet test tests/FreeX.Core.Formula.Tests --filter "Xor_|TrueFunc_|FalseFunc_|Iseven_|Isodd_|Replace_|Concatenate_|T_Text|T_Number|Fixed_|Clean_|Dollar_" -v n
```

Expected: all PASS

- [ ] **Step 6: Commit**

```
git add src/FreeX.Core.Formula/BuiltInFunctions.cs tests/FreeX.Core.Formula.Tests/FunctionLibraryTests.cs
git commit -m "feat: add 11 logical/text functions (XOR/TRUE/FALSE/ISEVEN/ISODD/REPLACE/CONCATENATE/T/FIXED/CLEAN/DOLLAR)"
```

---

## Task 6: Reference functions (4 new)

**Functions:** INDIRECT, ADDRESS, LOOKUP, N

LOOKUP → `IsStructuredRangeFunction` (already added in Task 2 Step 4)

- [ ] **Step 1: Write failing tests**

```csharp
// ── Reference ────────────────────────────────────────────────────────────────

[Fact] public void Indirect_A1String_ReturnsValue()
{
    var sheet = MakeSheet((1, 1, new NumberValue(42)));
    _eval.Evaluate("=INDIRECT(\"A1\")", sheet).Should().Be(new NumberValue(42));
}

[Fact] public void Address_AbsoluteRef_ReturnsString() =>
    _eval.Evaluate("=ADDRESS(2,3)", MakeSheet()).Should().Be(new TextValue("$C$2"));

[Fact] public void Address_RelativeRef_ReturnsString() =>
    _eval.Evaluate("=ADDRESS(2,3,4)", MakeSheet()).Should().Be(new TextValue("C2"));

[Fact] public void Lookup_FindsValueInVector()
{
    var sheet = MakeSheet(
        (1,1,new NumberValue(1)),(2,1,new NumberValue(2)),(3,1,new NumberValue(3)),
        (1,2,new TextValue("A")),(2,2,new TextValue("B")),(3,2,new TextValue("C")));
    _eval.Evaluate("=LOOKUP(2,A1:A3,B1:B3)", sheet).Should().Be(new TextValue("B"));
}

[Fact] public void N_Text_ReturnsZero() =>
    _eval.Evaluate("=N(\"hello\")", MakeSheet()).Should().Be(new NumberValue(0));

[Fact] public void N_Number_ReturnsNumber() =>
    _eval.Evaluate("=N(42)", MakeSheet()).Should().Be(new NumberValue(42));

[Fact] public void N_True_ReturnsOne() =>
    _eval.Evaluate("=N(TRUE)", MakeSheet()).Should().Be(new NumberValue(1));
```

- [ ] **Step 2: Run to see failures**

```
dotnet test tests/FreeX.Core.Formula.Tests --filter "Indirect_|Address_|Lookup_Find|N_Text|N_Number|N_True" -v n
```

- [ ] **Step 3: Register reference functions**

```csharp
        // ── Phase 4a: Reference ──────────────────────────────────────────────
        ["INDIRECT"] = (Indirect, 1, 2),
        ["ADDRESS"]  = (Address, 2, 5),
        ["LOOKUP"]   = (Lookup, 2, 3),
        ["N"]        = (NFunc, 1, 1),
```

- [ ] **Step 4: Add implementations**

```csharp
    // ═══════════════════════════════════════════════════════════════════
    // Phase 4a  –  Reference
    // ═══════════════════════════════════════════════════════════════════

    private static ScalarValue Indirect(IReadOnlyList<ScalarValue> args, IEvalContext ctx)
    {
        if (args[0] is ErrorValue e) return e;
        var refText = ToText(args[0]).Trim();
        string? sheetName = null;
        int bangIdx = refText.IndexOf('!');
        if (bangIdx >= 0)
        {
            sheetName = refText[..bangIdx].Trim('\'');
            refText   = refText[(bangIdx + 1)..];
        }
        if (!TryParseA1Ref(refText, out uint row, out uint col))
            return ErrorValue.Ref;
        return sheetName is not null
            ? ctx.GetCellValue(sheetName, row, col)
            : ctx.GetCellValue(row, col);
    }

    private static bool TryParseA1Ref(string cellRef, out uint row, out uint col)
    {
        row = 0; col = 0;
        int i = 0;
        while (i < cellRef.Length && char.IsLetter(cellRef[i])) i++;
        if (i == 0 || i >= cellRef.Length) return false;
        string colStr = cellRef[..i].ToUpperInvariant();
        if (!uint.TryParse(cellRef[i..], out row)) return false;
        col = 0;
        foreach (char c in colStr) col = col * 26 + (uint)(c - 'A' + 1);
        return row > 0 && col > 0;
    }

    private static ScalarValue Address(IReadOnlyList<ScalarValue> args, IEvalContext ctx)
    {
        if (args[0] is ErrorValue e0) return e0;
        int rowNum = (int)ToNumber(args[0]);
        int colNum = (int)ToNumber(args[1]);
        int absNum = args.Count > 2 && args[2] is not BlankValue ? (int)ToNumber(args[2]) : 1;
        string? sheetText = args.Count > 4 && args[4] is not BlankValue ? ToText(args[4]) : null;
        string colLetter = CellAddress.NumberToColumnName((uint)colNum);
        bool colAbs = absNum is 1 or 3;
        bool rowAbs = absNum is 1 or 2;
        string addr = $"{(colAbs ? "$" : "")}{colLetter}{(rowAbs ? "$" : "")}{rowNum}";
        if (!string.IsNullOrEmpty(sheetText))
            addr = $"'{sheetText}'!{addr}";
        return new TextValue(addr);
    }

    // LOOKUP(lookup_value, lookup_vector, [result_vector]) – sorted approximate match
    private static ScalarValue Lookup(IReadOnlyList<ScalarValue> args, IEvalContext ctx)
    {
        if (args[0] is ErrorValue e) return e;
        if (args[1] is not RangeValue lookupVec) return ErrorValue.Value;
        var lookupFlat = lookupVec.Flatten();
        var resultFlat = args.Count > 2 && args[2] is RangeValue rv
            ? rv.Flatten()
            : lookupFlat;
        var lookupVal = args[0];
        int matchIdx = -1;
        for (int i = 0; i < lookupFlat.Count; i++)
            if (CompareScalar(lookupFlat[i], lookupVal) <= 0)
                matchIdx = i;
        if (matchIdx < 0) return ErrorValue.NA;
        return matchIdx < resultFlat.Count ? resultFlat[matchIdx] : ErrorValue.NA;
    }

    private static ScalarValue NFunc(IReadOnlyList<ScalarValue> args, IEvalContext ctx) =>
        args[0] switch
        {
            NumberValue nv   => nv,
            BoolValue bv     => new NumberValue(bv.Value ? 1 : 0),
            ErrorValue ev    => ev,
            _                => new NumberValue(0)
        };
```

Note: `Address` uses `CellAddress.NumberToColumnName` from `FreeX.Core.Model`. The `BuiltInFunctions.cs` file already uses `FreeX.Core.Model` types (they're in the same `using` context since the project references it). Add the using at the top if it is not already present:

```csharp
using FreeX.Core.Model;
```

This is already present (line 1 of the file).

- [ ] **Step 5: Run tests**

```
dotnet test tests/FreeX.Core.Formula.Tests --filter "Indirect_|Address_|Lookup_Find|N_Text|N_Number|N_True" -v n
```

Expected: all PASS

- [ ] **Step 6: Run full test suite**

```
dotnet test tests/FreeX.Core.Formula.Tests -v n
```

All existing tests must still pass.

- [ ] **Step 7: Build check**

```
dotnet build src/FreeX.App.Host --no-incremental -v q
```

Expected: 0 errors, 0 warnings.

- [ ] **Step 8: Commit**

```
git add src/FreeX.Core.Formula/BuiltInFunctions.cs tests/FreeX.Core.Formula.Tests/FunctionLibraryTests.cs
git commit -m "feat: add 4 reference functions (INDIRECT/ADDRESS/LOOKUP/N)"
```

---

## Self-Review

**Spec coverage:**
- ✅ Task 0: XLOOKUP/SUMIFS/COUNTIFS/AVERAGEIFS bug fixed
- ✅ Task 1: 18 math/trig functions
- ✅ Task 2: 10 date/time functions
- ✅ Task 3: 14 statistical implementations
- ✅ Task 4: 8 financial functions
- ✅ Task 5: 11 logical/text functions
- ✅ Task 6: 4 reference functions

**FormulaEvaluator.cs classification summary (final state after all tasks):**

`IsStructuredRangeFunction`:
```
VLOOKUP, HLOOKUP, INDEX, MATCH, SUMIF, COUNTIF, AVERAGEIF, LARGE, SMALL, RANK,
SUMIFS, COUNTIFS, AVERAGEIFS, XLOOKUP,
WORKDAY, NETWORKDAYS,
CORREL, FORECAST, FORECAST.LINEAR,
PERCENTILE, PERCENTILE.INC, PERCENTILE.EXC,
QUARTILE, QUARTILE.INC,
PERCENTRANK, PERCENTRANK.INC,
LOOKUP, IRR
```

`IsAggregateFunction`:
```
SUM, AVERAGE, MIN, MAX, COUNT, COUNTA, AND, OR, CONCAT, STDEV, MEDIAN,
PRODUCT, XOR, VAR, VAR.S, VAR.P, STDEV.P,
GEOMEAN, HARMEAN, AVEDEV, MODE, MODE.SNGL,
CONCATENATE, NPV
```

**Type consistency:** All new methods follow the `(IReadOnlyList<ScalarValue> args, IEvalContext ctx)` signature. `CollectNumbers` helper returns `object` — callers must cast. This is acceptable but keep in mind for maintenance.

**ISODD edge case:** `ISODD(-3)` returns true because `(-3) % 2 = -1 != 0` in C#. Correct.

**LOOKUP assumption:** Assumes lookup_vector is sorted ascending (Excel's documented requirement for approximate match).
