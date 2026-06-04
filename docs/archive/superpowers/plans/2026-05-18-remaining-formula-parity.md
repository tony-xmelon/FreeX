# Remaining Formula Parity Plan

> **Historical note (2026-05-19):** The in-scope function implementation phases in this plan are complete. Current formula work has moved to Excel-authored cached-result fixtures, fuzz/property tests, and evaluator edge-case hardening. See `docs/FUNCTION_PARITY.md` and `docs/OUTSTANDING_BUILD.md` for current status.

**Goal:** Move FreeX from broad day-to-day Excel formula coverage to near-complete desktop Excel formula compatibility for in-scope local workbook calculation.

**Historical baseline at plan creation:** 214 documented Excel functions implemented, 95 in-scope functions remaining. The current baseline is 345/345 in-scope functions implemented; excluded live-data/cube/service functions remain outside scope unless a design decision changes that.

## Phase F1: Statistical Distributions

- Implement normal family: `NORM.DIST`, `NORM.INV`, `NORM.S.DIST`, `NORM.S.INV`, `STANDARDIZE`.
- Implement t/F/chi-squared family: `T.DIST`, `T.INV`, `T.TEST`, `F.DIST`, `F.INV`, `F.TEST`, `CHISQ.DIST`, `CHISQ.INV`, `CHISQ.TEST`.
- Implement discrete distributions: `BINOM.DIST`, `BINOM.INV`, `NEGBINOM.DIST`, `POISSON.DIST`, `HYPERGEOM.DIST`.
- Implement continuous/descriptive tail: `BETA.DIST`, `BETA.INV`, `GAMMA.DIST`, `GAMMA.INV`, `LOGNORM.DIST`, `LOGNORM.INV`, `EXPON.DIST`, `WEIBULL.DIST`, `CONFIDENCE.NORM`, `CONFIDENCE.T`, `FREQUENCY`, `SKEW`, `SKEW.P`, `KURT`.

## Phase F2: Financial Bond And Depreciation Math

- Add day-count/coupon schedule helpers shared by settlement functions.
- Implement accrued-interest/settlement: `ACCRINT`, `DISC`, `INTRATE`, `RECEIVED`.
- Implement coupon analytics: `COUPDAYBS`, `COUPDAYS`, `COUPDAYSNC`, `COUPNCD`, `COUPNUM`, `COUPPCD`.
- Implement price/yield/duration: `PRICE`, `PRICEDISC`, `PRICEMAT`, `YIELD`, `YIELDDISC`, `YIELDMAT`, `DURATION`, `MDURATION`.
- Implement depreciation and remaining finance helpers: `DB`, `DDB`, `VDB`, `SYD`, `AMORDEGRC`, `AMORLINC`, `CUMIPMT`, `CUMPRINC`, `IPMT`, `PPMT`, `EFFECT`, `NOMINAL`, `FVSCHEDULE`, `MIRR`, `XIRR`, `XNPV`, `PDURATION`, `RRI`, `TBILLEQ`, `TBILLPRICE`, `TBILLYIELD`, `DOLLARDE`, `DOLLARFR`, odd-period functions.

## Phase F3: Reference Runtime Features

- Implement `FORMULATEXT`, `ISFORMULA`, `ISREF`, `CELL`, and `INFO`.
- Implement `OFFSET` as a volatile range-producing function with dependency invalidation tests.
- Add workbook/sheet context APIs needed for reference-inspection functions without leaking UI concepts into Core.Formula.

## Phase F4: LET, LAMBDA, And Higher-Order Arrays

- Extend the evaluator with lexical name bindings for `LET`.
- Add function-value representation and invocation for `LAMBDA`.
- Implement `MAP`, `REDUCE`, `SCAN`, `BYROW`, `BYCOL`, and `MAKEARRAY`.
- Add spill and recursive evaluation tests.

## Verification Gate

- Add xUnit coverage for every function before implementation.
- Keep `docs/FUNCTION_PARITY.md` aligned after each batch.
- Run `dotnet test tests\FreeX.Core.Formula.Tests\FreeX.Core.Formula.Tests.csproj` and `dotnet build FreeX.slnx` after each phase.
