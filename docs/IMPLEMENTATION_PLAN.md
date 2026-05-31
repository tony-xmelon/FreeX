# FreeX Implementation Plan — Gap Closure

**Last updated:** 2026-05-31
**Basis:** Gap analysis from FUNCTION_PARITY.md, COMMAND_SURFACE_PARITY.md, SHORTCUT_PARITY_MATRIX.md, FIDELITY_CONTRACT.md, and MENU_TOOLBAR_PARITY.md

> **Historical note (2026-05-19):** This plan is retained as implementation history. Its formula gap phases are complete and some scope decisions here have since changed (for example `CELL`, `INFO`, `LET`, `LAMBDA`, statistical distributions, financial functions, `HYPERLINK`, and engineering base/bit functions are implemented). Use `FUNCTION_PARITY.md`, `NEXT_PHASES_PLAN.md`, and `OUTSTANDING_BUILD.md` for current status.

---

## New Out-of-Scope Decisions

The following previously "Not Implemented" items are now explicitly excluded. Each exclusion is justified.

| Feature | Reason |
|---|---|
| **Multi-window View advanced controls** (Hide/Unhide, Side-by-Side, Sync Scrolling, Reset Window Position) | Requires window visibility state, paired layout, and synchronized viewport routing. New Window and Switch Windows now have a live registry-backed slice; the remaining advanced controls stay out of the ribbon until their subsystems exist. |
| **Thesaurus** | Requires an external dictionary/thesaurus service or bundled corpus. No offline equivalent in .NET base libraries. |
| **Insert > Icons** | Requires Microsoft's proprietary Fluent icon library; not redistributable. |
| **Insert > Screenshot** | OS-level snipping tools (Win+Shift+S) are a better UX; not worth duplicating. |
| **Recommended PivotTables / Recommended Charts** | AI/ML-driven suggestions requiring data-pattern analysis; proprietary Microsoft heuristics. |
| **Insert > Map Chart authoring/rendering** | Geographic chart authoring needs a dedicated map/geospatial model and renderer; XLSX preservation stays documented separately. |
| **Insert > Equation authoring** | Requires a math object model/editor and renderer before it can be exposed as a live command. |
| **Freehand Ink** | Requires an ink capture/conversion subsystem; no disabled ribbon placeholder should be shown without it. |
| **Customize QAT** | Low user value for v1; the fixed QAT (Save/Undo/Redo) covers typical use. |
| **Select Objects (arrow cursor mode)** | Niche; interactive drag-handle object selection is already deferred. |
| **Spell Check full dictionary** | No offline spell-check corpus in scope; the existing known-corrections baseline is sufficient for v1. |
| **Accessibility Checker full expansion** | Current merged-cell + alt-text checks cover the most common issues; full WCAG audit engine is a separate product concern. |

---

## Implementation Phases

Coverage targets after each phase assume all planned items are completed.

---

## Phase A — Quick Formula Wins  
**Effort:** 1 sprint · **Formula coverage after:** ~70% → ~75%

All items here are pure math/lookup — no new evaluator infrastructure needed.

### A1: Missing Text Functions (3)
| Function | Description |
|---|---|
| `UNICHAR(n)` | Returns Unicode character for code point `n` |
| `UNICODE(text)` | Returns Unicode code point of first character |
| `NUMBERVALUE(text, dec_sep, group_sep)` | Locale-aware text-to-number; alias to `VALUE` for simple cases |

### A2: Missing Information Functions (4)
| Function | Description |
|---|---|
| `ISFORMULA(ref)` | TRUE if the referenced cell contains a formula |
| `ISREF(value)` | TRUE if value is a valid cell reference (use AST node type check) |
| `TYPE(value)` | Returns Excel type code: 1=number, 2=text, 4=bool, 16=error, 64=array |
| `ERROR.TYPE(error)` | Returns integer code for the error type (1=#NULL!, 2=#DIV/0!, etc.) |

### A3: Missing Lookup/Reference Functions (3)
| Function | Description |
|---|---|
| `TRANSPOSE(array)` | Transposes a 2-D array (rows ↔ columns); already exists as a paste command, needs a function form |
| `FORMULATEXT(ref)` | Returns the formula string of the referenced cell as text; returns #N/A if not a formula |
| `OFFSET(ref, rows, cols, [height], [width])` | Returns a range offset from a reference; volatile (depends on current values); requires special volatile-range handling in the dependency graph |

### A4: International Date Functions (2)
| Function | Description |
|---|---|
| `NETWORKDAYS.INTL(start, end, [weekend], [holidays])` | Like `NETWORKDAYS` but accepts a weekend mask (1–17 or "0000011" string) |
| `WORKDAY.INTL(start, days, [weekend], [holidays])` | Like `WORKDAY` but with weekend mask |

### A5: Simple Math Completions (5)
| Function | Description |
|---|---|
| `SQRTPI(n)` | `√(n × π)` |
| `MULTINOMIAL(n1, n2, ...)` | Multinomial coefficient |
| `SERIESSUM(x, n, m, coeffs)` | Power series sum `Σ a_i × x^(n+(i−1)×m)` |
| `MMULT(array1, array2)` | Matrix multiply; returns spill array |
| `MINVERSE(array)` | Matrix inverse; returns spill array |
| `MDETERM(array)` | Matrix determinant; returns scalar |

### A6: AGGREGATE Function (1)
`AGGREGATE(function_num, options, array/ref, [k])` — Like `SUBTOTAL` but with 19 function choices and options to ignore errors, hidden rows, and nested SUBTOTAL/AGGREGATE.

### A7: CONVERT Function (1)
`CONVERT(number, from_unit, to_unit)` — Unit conversion across mass, length, time, temperature, pressure, energy, power, magnetism, area, information, speed. Requires a lookup table of ~150 unit pairs.

### A8: Database Functions (12)
All share the same `(database, field, criteria)` signature and can share one criteria-evaluation helper.

`DSUM` · `DAVERAGE` · `DCOUNT` · `DCOUNTA` · `DGET` · `DMAX` · `DMIN` · `DPRODUCT` · `DSTDEV` · `DSTDEVP` · `DVAR` · `DVARP`

---

## Phase B — Statistical Distributions  
**Effort:** 1–2 sprints · **Formula coverage after:** ~75% → ~85%

All are pure numerical functions. Implement using the standard algorithms (series expansion, regularised incomplete beta/gamma, etc.) or reference a NuGet library such as MathNet.Numerics (MIT licensed).

### B1: Normal Distribution Family (5)
`NORM.DIST` · `NORM.INV` · `NORM.S.DIST` · `NORM.S.INV` · `STANDARDIZE`

### B2: T, F, Chi-Squared Families + Tests (9)
`T.DIST` · `T.INV` · `T.TEST`  
`F.DIST` · `F.INV` · `F.TEST`  
`CHISQ.DIST` · `CHISQ.INV` · `CHISQ.TEST`

### B3: Confidence and Descriptive (8)
`CONFIDENCE.NORM` · `CONFIDENCE.T`  
`DEVSQ` · `SKEW` · `SKEW.P` · `KURT` · `RANK.AVG` · `RANK.EQ` · `FREQUENCY` · `STANDARDIZE`

### B4: Discrete Distributions (5)
`BINOM.DIST` · `BINOM.INV` · `NEGBINOM.DIST` · `POISSON.DIST` · `HYPERGEOM.DIST`

### B5: Continuous Distributions (8)
`EXPON.DIST` · `WEIBULL.DIST` · `GAMMA.DIST` · `GAMMA.INV`  
`BETA.DIST` · `BETA.INV` · `LOGNORM.DIST` · `LOGNORM.INV`

---

## Phase C — Financial Completeness  
**Effort:** 1–2 sprints · **Formula coverage after:** ~85% → ~95%

Split into two tracks by usage frequency.

### C1: High-Usage Financial (11) — implement first
`IPMT(rate, per, nper, pv, [fv], [type])` — Interest payment for a period  
`PPMT(rate, per, nper, pv, [fv], [type])` — Principal payment for a period  
`CUMIPMT(rate, nper, pv, start, end, type)` — Cumulative interest  
`CUMPRINC(rate, nper, pv, start, end, type)` — Cumulative principal  
`EFFECT(nominal_rate, npery)` — Effective annual interest rate  
`NOMINAL(effect_rate, npery)` — Nominal annual interest rate  
`MIRR(values, finance_rate, reinvest_rate)` — Modified IRR  
`XIRR(values, dates, [guess])` — IRR for irregular cash flows  
`XNPV(rate, values, dates)` — NPV for irregular cash flows  
`RRI(nper, pv, fv)` — Equivalent interest rate for investment growth  
`PDURATION(rate, pv, fv)` — Periods to reach a future value  
`FVSCHEDULE(principal, schedule)` — Future value with variable interest rates  

### C2: Depreciation (6)
`DB` · `DDB` · `VDB` · `SYD` · `AMORDEGRC` · `AMORLINC`

### C3: Bond / Settlement Math (17) — implement last
`ACCRINT` · `DISC` · `INTRATE` · `RECEIVED`  
`PRICE` · `PRICEDISC` · `PRICEMAT` · `YIELD` · `YIELDDISC` · `YIELDMAT`  
`DURATION` · `MDURATION`  
`COUPDAYBS` · `COUPDAYS` · `COUPDAYSNC` · `COUPNCD` · `COUPNUM` · `COUPPCD`  
`ODDFPRICE` · `ODDFYIELD` · `ODDLPRICE` · `ODDLYIELD`  
`TBILLEQ` · `TBILLPRICE` · `TBILLYIELD` · `DOLLARDE` · `DOLLARFR`

---

## Phase D — LAMBDA and Higher-Order Functions  
**Effort:** 2 sprints · **Formula coverage after:** ~95% → ~97%

Requires new evaluator concepts: named bindings and first-class function values.

### D1: LET (implement first)
`LET(name1, val1, ..., nameN, valN, calc)` — Binds named sub-expressions inside a formula. No closures needed; evaluate eagerly in order.

### D2: LAMBDA
`LAMBDA([param1, ...], body)` — Returns a function value. Requires:
- A new `LambdaValue : ScalarValue` type
- `FunctionCallNode` to resolve a lambda from a cell reference or named range
- Recursive lambda support (lambda referencing itself by name via `LET`)

### D3: Higher-Order Array Functions (6)
All require LAMBDA to be implemented first.  
`MAP(array, lambda)` · `REDUCE(initial, array, lambda)` · `SCAN(initial, array, lambda)`  
`BYROW(array, lambda)` · `BYCOL(array, lambda)` · `MAKEARRAY(rows, cols, lambda)`

---

## Phase E — UI / Command Gaps  
**Effort:** 2–3 sprints · **Command coverage after:** ~88% → ~95%

### E1: Format Painter
- Copy the style of the selected cell(s) to a target range
- Single-click mode: paint once then exit; double-click mode: stay active
- Requires a transient "paint mode" state in the command bus + cursor change

### E2: Full Conditional Format Rule Manager + Icon Sets
- Complete the Manage Rules dialog: reorder rules, duplicate, edit range
- Add icon-set rule type (3/4/5-icon sets with threshold configuration)
- XLSX round-trip for icon sets already works; this is UI only

### E3: PivotTable Creation and Refresh
- PivotTable creation wizard: data range picker → field list panel with row/column/value/filter zones
- In-memory aggregation engine (SUM/COUNT/AVERAGE/MIN/MAX per field combination)
- Refresh command: re-run aggregation against current source range
- Depends on existing `PivotTableModel` and pivot-cache models already in place

### E4: Slicer and Timeline UI
- Slicer: render slicer as a floating panel; click to filter connected PivotTable
- Timeline: render timeline with date-bucket dragging; filter by year/quarter/month
- Insert Slicer / Insert Timeline commands

### E5: Advanced Chart Families
Priority order:
1. **Radar** — already saves/loads; add WPF renderer using OxyPlot RadarSeries
2. **Stock (OHLC/candlestick)** — already saves/loads; add CandleStickSeries renderer
3. **Surface / 3D variants** — low priority; defer beyond these two

### E6: Object Drag Handles and Crop
- Interactive resize/move handles on selected pictures, shapes, and text boxes
- Crop command for pictures (crop margins stored in model, rendered as clip)
- Gradients and richer effects remain deferred

### E7: Advanced Filter
`Data > Advanced Filter` — filter by a criteria range (multi-column AND/OR criteria), optionally copy results to another location. Implementable using the existing `FilterConditionCommand` infrastructure.

---

## Phase F — Polish and Corpus Expansion  
**Effort:** ongoing · **Formula coverage after:** ~97%+ · **XLSX coverage after:** ~90%+

### F1: Format Cells Dialog — Alignment Tab Completion
- Distributed/Justify alignment (model already supports; UI dialog partial)
- Shrink to Fit flag

### F2: Structured Table Full Semantics
- Table formulas referencing column names (`[@Column]`, `Table[Column]`)
- AutoExpand when data is entered below the table
- Table summary row with function choices
- Currently: table metadata loads/saves but Excel table-formula syntax is not evaluated

### F3: XLSX Corpus Expansion to 100+ Workbooks
- Add public/open-license `.xlsx` samples to `test-corpus/` with `public-pass` status
- Add local-private samples for regression testing
- Target: 30+ supported-pass, 20+ known-gap, 10+ regression

---

## Summary Roadmap

| Phase | Focus | Functions added | Commands added | Est. effort |
|---|---|---:|---:|---|
| A | Quick formula wins | 28 | 0 | 1 sprint |
| B | Statistical distributions | 37 | 0 | 1–2 sprints |
| C | Financial completeness | 45 | 0 | 1–2 sprints |
| D | LAMBDA / LET / higher-order | 8 | 0 | 2 sprints |
| E | UI command gaps | 0 | ~15 | 2–3 sprints |
| F | Polish + corpus | 2 | ~5 | ongoing |

**Formula coverage trajectory:**  
60% → Phase A → ~70% → Phase B → ~82% → Phase C → ~95% → Phase D → ~97%+

**Command coverage trajectory:**  
88% → Phase E → ~95% → Phase F → ~97%+

---

## Updated Exclusion List

In addition to the existing excluded features (cloud, VBA, Power Query, data model, slicers/timelines executing, etc.), the following are now explicitly excluded:

| Feature | Category |
|---|---|
| Multi-window View advanced controls (Hide/Unhide, Side-by-Side, Sync Scrolling, Reset Position) | Complex paired-window/visibility subsystem |
| Thesaurus | External service dependency |
| Insert > Icons | Proprietary Microsoft library |
| Insert > Screenshot | OS-level feature |
| Recommended PivotTables / Recommended Charts | AI/ML heuristics |
| Insert > Map Chart authoring/rendering | Dedicated geospatial chart subsystem |
| Insert > Equation authoring | Math object model/editor not implemented |
| Freehand Ink | Ink capture/conversion subsystem |
| Customize QAT | Low v1 value |
| Select Objects cursor mode | Niche |
| Full spell-check dictionary | Out-of-scope corpus |
| Full accessibility audit engine | Separate product concern |
