# FreeX Formula Function Parity

**Last updated:** 2026-06-01
**Total implemented:** 496
**Status:** All in-scope functions implemented

## Status Legend

| Status | Meaning |
|---|---|
| Implemented | Works with Excel-matching semantics; covered by tests |
| Partial | Core behavior works; some edge cases or overloads missing |
| Not Implemented | Not yet implemented; returns #NAME? |
| Excluded from scope | Requires Microsoft services or proprietary runtime |

---

## Coverage Summary

| Category | Implemented | Partial | Not Implemented | Excluded | In-scope Total | **Coverage** |
|---|---:|---:|---:|---:|---:|---:|
| Math / Trig | 78 | 0 | 0 | 0 | 78 | **100%** |
| Statistical | 140 | 0 | 0 | 0 | 140 | **100%** |
| Logical | 11 | 0 | 0 | 0 | 11 | **100%** |
| Lookup / Reference | 39 | 0 | 0 | 0 | 39 | **100%** |
| Text | 51 | 0 | 0 | 0 | 51 | **100%** |
| Date / Time | 25 | 0 | 0 | 0 | 25 | **100%** |
| Financial | 55 | 0 | 0 | 0 | 55 | **100%** |
| Information | 19 | 0 | 0 | 0 | 19 | **100%** |
| Lambda / Advanced | 9 | 0 | 0 | 0 | 9 | **100%** |
| Database | 12 | 0 | 0 | 0 | 12 | **100%** |
| Engineering / Cube / Cloud | 57 | 0 | 0 | 9 | 57 | **100%** |
| **TOTAL** | **496** | **0** | **0** | **9** | **496** | **100%** |

Coverage = (Implemented + Partial) / In-scope Total. Excluded functions are not counted in the in-scope total.

The former [remaining formula parity plan](../archive/superpowers/plans/2026-05-18-remaining-formula-parity.md) is now historical: its in-scope implementation phases are complete. Current formula work is parity proof and hardening rather than broad function addition:

- Excel-authored cached-result fixture workbooks now cover high-risk financial, statistical, date/time, dynamic-array, lookup/reference, engineering, `LET`, and text-join cases; continue adding targeted edge-case workbooks as parity bugs are found.
- Fuzz/property tests cover inverse and round-trip families such as distribution/inverse pairs, price/yield pairs, XIRR/XNPV, and engineering base conversions.
- Evaluator edge-case audits cover Excel coercion, error precedence, blank/empty handling, range flattening vs. structured range arguments including modern `CONCAT` range flattening, array expressions, spills, volatility, and date serial behavior.
- Structured-reference formula tests cover current-row, `#This Row`, multi-column, spaced-column, and case-insensitive header resolution through formula evaluation.

## Parity Test Sweep

The 2026-05-19 function parity sweep added a catalog guard and category-focused Excel parity suites:

| Area | Coverage added |
|---|---|
| Catalog integrity | Verifies every documented in-scope function is registered, every registered function is documented, and excluded functions remain outside the runtime. |
| Math / Trig | Exhaustive direct coverage for all 50 documented functions, including numeric coercion, domain errors, ranges, matrix outputs, random bounds, subtotals, and conditional aggregates. |
| Statistical | Direct coverage for previously unpinned aliases and modern names: DEVSQ, GAMMALN.PRECISE, MODE.SNGL, PERCENTILE.INC, PERCENTRANK.INC, QUARTILE.INC, RANK.AVG, and RANK.EQ. |
| Logical | Direct coverage for all logical functions, including IF short-circuiting and Excel-style error handling for IFERROR, IFNA, AND, and OR. |
| Information | Direct coverage for CELL, ERROR.TYPE, INFO, IS* predicates, N, NA, and TYPE. |
| Database | Direct coverage for DSTDEV, DSTDEVP, DVAR, and DVARP sample/population semantics, OR/AND criteria behavior, nonnumeric value handling, and empty-match errors. |
| Financial odd-coupon | ODDFPRICE, ODDFYIELD, ODDLPRICE, and ODDLYIELD now match Microsoft Excel documented examples and enforce Excel date-order/frequency/domain errors. |

Verification: `FreeX.Core.Formula.Tests` passes 2,656/2,656 tests. Formula scalar array coercion parity was hardened across six batches (statistical, financial, range-argument, ChiSq, percentrank, higher-order, and rank functions) since the 2026-05-19 sweep, with broader inverse/round-trip tests for distribution and engineering conversion families, direct volatile registry guards, formula serializer/rewriter guards for modern error literals plus omitted dynamic-array arguments, omitted optional lookup-argument parity guards, database blank-criteria-row parity coverage, COUNTIF/SUMIF-style date criteria text parsing, engineering base-conversion optional-argument error precedence, engineering fractional conversion/places/shift truncation, `CONVERT` minute-unit alias parity for both `mn` and `min`, `CONVERT` SI deka-prefix parity for both `da` and `e`, `CONVERT` binary information-prefix parity plus unsupported-unit `#N/A` guards, `TIMEVALUE` fake-1900-leap-day date-time handling, `EDATE`/`EOMONTH` fake-1900-leap-day offset handling, financial basis-domain guards, `UNICODE` scalar text coercion, `UNICHAR`/`UNICODE` supplementary-plane code point guards, `PROPER` non-letter capitalization guards, `LEN`/`LEFT`/`RIGHT`/`FIND`/`SEARCH`/`MID`/`REPLACE` surrogate-pair text positions, `LENB`/`LEFTB`/`RIGHTB`/`FINDB`/`SEARCHB`/`MIDB`/`REPLACEB` DBCS byte-count parity, `LEN`/`LEFT`/`RIGHT` range spilling, empty-search scalar end-boundary guards, wildcard matching over surrogate-pair text elements, date serial bounds, modern lookup-array error precedence guards including exact, wildcard, approximate, and duplicate binary-search `XLOOKUP`/`XMATCH` scans, legacy lookup index-domain errors, `#GETTING_DATA` error literal parsing, dynamic-array cell-level error precedence and empty-array `#CALC!` guards, `FILTER` explicit blank `if_empty` plus blank include-cell handling, finite integer-domain guards for `TAKE`/`DROP` slice counts, `WRAPROWS`/`WRAPCOLS` wrap counts, `SEQUENCE` dimensions plus leading blank-argument defaults, and `CHOOSECOLS`/`CHOOSEROWS` indexes, `EXPAND` spill-size caps, spilled-index-array handling for `CHOOSE` index errors and `CHOOSECOLS`/`CHOOSEROWS`, `TOROW`/`TOCOL` scalar-error ignore handling, volatile `RANDARRAY` bounds including equal min/max rejection, structured-reference current-row and spaced-header coverage, East Asian/Thai text function coverage, `BAHTTEXT` satang half-boundary rounding plus satang-only wording, `TEXTJOIN` delimiter-range cycling, `TEXTSPLIT` explicitly omitted `pad_with` defaulting to `#N/A`, `EXACT`/`CODE`/`CHAR` range spilling, `VALUETOTEXT` single-cell reference scalar formatting, local `ENCODEURL`/secure `FILTERXML` coverage, higher-order `REDUCE`/`SCAN` nested-array rejection, `SORTBY` omitted-order handling, `XLOOKUP` omitted-mode defaults plus horizontal return-array coverage, omitted dynamic-array padding defaults, `ADDRESS` sheet-name escaping, `WEEKDAY` omitted return-type defaults, `LEFT`/`RIGHT` omitted length defaults, `LOG` omitted-base defaults, `FIND`/`SEARCH` omitted start defaults, `SUBSTITUTE` omitted instance defaults, `HYPERLINK` omitted friendly-name defaults, `DOLLAR` negative accounting formatting plus explicit blank-decimal behavior, `UNICHAR` fractional-code truncation, `NUMBERVALUE` explicit blank-separator errors plus ASCII tab/LF/CR stripping without NBSP stripping, `ROUND`/`MROUND` decimal midpoint parity, and cached Excel-result fixtures for lookup/dynamic-array/LET/text cases including cached `#CALC!` formula errors.

Post-sweep hardening also pins `ASC`, `DBCS`, and `JIS` to Excel's non-DBCS language behavior: width conversion is only applied for DBCS cultures, while English/non-DBCS settings return the original text unchanged. `CODE` now returns Excel's Windows ANSI replacement code for Unicode characters that cannot be represented in that code page. `REGEXREPLACE` now honors Excel's negative `occurrence` semantics by replacing the matching instance counted from the end, including range-spilled text inputs. `TEXTBEFORE` and `TEXTAFTER` now preserve Excel's empty-text behavior before applying delimiter or instance bounds. `DOLLARDE` and `DOLLARFR` now validate negative fractional denominators before integer truncation so fractional negatives such as `-0.5` return Excel's `#NUM!` rather than falling through to the zero-denominator `#DIV/0!` path. `BASE` now truncates fractional `number`, `radix`, and `min_length` arguments before validating bounds, matching Excel's documented coercion. `DECIMAL` now applies the same truncation to fractional `radix` values before validating the radix domain. Excel-authored formulas persisted with `_xlfn.` and `_xlfn._xlws.` future-function prefixes now tokenize to the canonical built-in function names, so modern formulas such as prefixed `XLOOKUP` and dynamic-array `FILTER` evaluate instead of returning `#NAME?`.

---

## Math / Trig

**Coverage: 78/78 (100%)**

| Function | Status |
|---|---|
| ABS | Implemented |
| ACOS | Implemented |
| ACOSH | Implemented |
| ACOT | Implemented |
| ACOTH | Implemented |
| AGGREGATE | Implemented |
| ASIN | Implemented |
| ASINH | Implemented |
| ATAN | Implemented |
| ATAN2 | Implemented |
| ATANH | Implemented |
| CEILING | Implemented |
| CEILING.MATH | Implemented |
| CEILING.PRECISE | Implemented |
| COMBIN | Implemented |
| COMBINA | Implemented |
| CONVERT | Implemented |
| COS | Implemented |
| COSH | Implemented |
| COT | Implemented |
| COTH | Implemented |
| CSC | Implemented |
| CSCH | Implemented |
| DEGREES | Implemented |
| EVEN | Implemented |
| EXP | Implemented |
| FACT | Implemented |
| FACTDOUBLE | Implemented |
| FLOOR | Implemented |
| FLOOR.MATH | Implemented |
| FLOOR.PRECISE | Implemented |
| GCD | Implemented |
| INT | Implemented |
| ISO.CEILING | Implemented |
| LCM | Implemented |
| LN | Implemented |
| LOG | Implemented |
| LOG10 | Implemented |
| MDETERM | Implemented |
| MINVERSE | Implemented |
| MMULT | Implemented |
| MOD | Implemented |
| MROUND | Implemented |
| MULTINOMIAL | Implemented |
| MUNIT | Implemented |
| ODD | Implemented |
| PERMUT | Implemented |
| PERMUTATIONA | Implemented |
| PI | Implemented |
| POWER | Implemented |
| PRODUCT | Implemented |
| QUOTIENT | Implemented |
| RADIANS | Implemented |
| RAND | Implemented |
| RANDBETWEEN | Implemented |
| ROUND | Implemented |
| ROUNDDOWN | Implemented |
| ROUNDUP | Implemented |
| SEC | Implemented |
| SECH | Implemented |
| SERIESSUM | Implemented |
| SIGN | Implemented |
| SIN | Implemented |
| SINH | Implemented |
| SQRT | Implemented |
| SQRTPI | Implemented |
| SUBTOTAL | Implemented |
| SUM | Implemented |
| SUMIF | Implemented |
| SUMIFS | Implemented |
| SUMPRODUCT | Implemented |
| SUMSQ | Implemented |
| SUMX2MY2 | Implemented |
| SUMX2PY2 | Implemented |
| SUMXMY2 | Implemented |
| TAN | Implemented |
| TANH | Implemented |
| TRUNC | Implemented |

---

## Statistical

**Coverage: 140/140 (100%)**

| Function | Status |
|---|---|
| AVEDEV | Implemented |
| AVERAGE | Implemented |
| AVERAGEA | Implemented |
| AVERAGEIF | Implemented |
| AVERAGEIFS | Implemented |
| BETA.DIST | Implemented |
| BETA.INV | Implemented |
| BETADIST | Implemented |
| BETAINV | Implemented |
| BINOM.DIST | Implemented |
| BINOM.DIST.RANGE | Implemented |
| BINOM.INV | Implemented |
| BINOMDIST | Implemented |
| CHISQ.DIST | Implemented |
| CHISQ.DIST.RT | Implemented |
| CHISQ.INV | Implemented |
| CHISQ.INV.RT | Implemented |
| CHISQ.TEST | Implemented |
| CHIDIST | Implemented |
| CHIINV | Implemented |
| CHITEST | Implemented |
| CONFIDENCE | Implemented |
| CONFIDENCE.NORM | Implemented |
| CONFIDENCE.T | Implemented |
| CORREL | Implemented |
| COVAR | Implemented |
| COVARIANCE.P | Implemented |
| COVARIANCE.S | Implemented |
| COUNT | Implemented |
| COUNTA | Implemented |
| COUNTBLANK | Implemented |
| COUNTIF | Implemented |
| COUNTIFS | Implemented |
| CRITBINOM | Implemented |
| DEVSQ | Implemented |
| EXPON.DIST | Implemented |
| EXPONDIST | Implemented |
| F.DIST | Implemented |
| F.DIST.RT | Implemented |
| F.INV | Implemented |
| F.INV.RT | Implemented |
| F.TEST | Implemented |
| FDIST | Implemented |
| FINV | Implemented |
| FISHER | Implemented |
| FISHERINV | Implemented |
| FORECAST | Implemented |
| FORECAST.LINEAR | Implemented |
| FREQUENCY | Implemented |
| FTEST | Implemented |
| GAUSS | Implemented |
| GAMMA | Implemented |
| GAMMA.DIST | Implemented |
| GAMMA.INV | Implemented |
| GAMMADIST | Implemented |
| GAMMAINV | Implemented |
| GAMMALN | Implemented |
| GAMMALN.PRECISE | Implemented |
| GEOMEAN | Implemented |
| HARMEAN | Implemented |
| HYPGEOMDIST | Implemented |
| HYPGEOM.DIST | Implemented |
| INTERCEPT | Implemented |
| KURT | Implemented |
| LARGE | Implemented |
| LOGINV | Implemented |
| LOGNORM.DIST | Implemented |
| LOGNORM.INV | Implemented |
| LOGNORMDIST | Implemented |
| MAX | Implemented |
| MAXA | Implemented |
| MAXIFS | Implemented |
| MEDIAN | Implemented |
| MIN | Implemented |
| MINA | Implemented |
| MINIFS | Implemented |
| MODE | Implemented |
| MODE.SNGL | Implemented |
| MODE.MULT | Implemented |
| NEGBINOM.DIST | Implemented |
| NEGBINOMDIST | Implemented |
| NORM.DIST | Implemented |
| NORM.INV | Implemented |
| NORM.S.DIST | Implemented |
| NORM.S.INV | Implemented |
| NORMDIST | Implemented |
| NORMINV | Implemented |
| NORMSDIST | Implemented |
| NORMSINV | Implemented |
| PERCENTILE | Implemented |
| PERCENTILE.EXC | Implemented |
| PERCENTILE.INC | Implemented |
| PERCENTOF | Implemented |
| PERCENTRANK | Implemented |
| PERCENTRANK.EXC | Implemented |
| PERCENTRANK.INC | Implemented |
| PEARSON | Implemented |
| PHI | Implemented |
| POISSON | Implemented |
| POISSON.DIST | Implemented |
| PROB | Implemented |
| QUARTILE | Implemented |
| QUARTILE.EXC | Implemented |
| QUARTILE.INC | Implemented |
| RANK | Implemented |
| RANK.AVG | Implemented |
| RANK.EQ | Implemented |
| RSQ | Implemented |
| SKEW | Implemented |
| SKEW.P | Implemented |
| SMALL | Implemented |
| SLOPE | Implemented |
| STANDARDIZE | Implemented |
| STDEV | Implemented |
| STDEV.P | Implemented |
| STDEV.S | Implemented |
| STDEVP | Implemented |
| STDEVA | Implemented |
| STDEVPA | Implemented |
| STEYX | Implemented |
| T.DIST | Implemented |
| T.DIST.2T | Implemented |
| T.DIST.RT | Implemented |
| T.INV | Implemented |
| T.INV.2T | Implemented |
| T.TEST | Implemented |
| TDIST | Implemented |
| TINV | Implemented |
| TRIMMEAN | Implemented |
| TTEST | Implemented |
| VAR | Implemented |
| VAR.P | Implemented |
| VAR.S | Implemented |
| VARP | Implemented |
| VARA | Implemented |
| VARPA | Implemented |
| WEIBULL | Implemented |
| WEIBULL.DIST | Implemented |
| Z.TEST | Implemented |
| ZTEST | Implemented |

---

## Logical

**Coverage: 11/11 (100%)**

| Function | Status |
|---|---|
| AND | Implemented |
| FALSE | Implemented |
| IF | Implemented |
| IFERROR | Implemented |
| IFNA | Implemented |
| IFS | Implemented |
| NOT | Implemented |
| OR | Implemented |
| SWITCH | Implemented |
| TRUE | Implemented |
| XOR | Implemented |

---

## Lookup / Reference

**Coverage: 39/39 (100%)**

| Function | Status |
|---|---|
| ADDRESS | Implemented |
| AREAS | Implemented |
| CHOOSE | Implemented |
| CHOOSECOLS | Implemented |
| CHOOSEROWS | Implemented |
| COLUMN | Implemented |
| COLUMNS | Implemented |
| DROP | Implemented |
| EXPAND | Implemented |
| FILTER | Implemented |
| FORMULATEXT | Implemented |
| HLOOKUP | Implemented |
| HSTACK | Implemented |
| HYPERLINK | Implemented |
| INDEX | Implemented |
| INDIRECT | Implemented |
| LOOKUP | Implemented |
| MATCH | Implemented |
| OFFSET | Implemented |
| RANDARRAY | Implemented |
| ROW | Implemented |
| ROWS | Implemented |
| SEQUENCE | Implemented |
| SINGLE | Implemented |
| SORT | Implemented |
| SORTBY | Implemented |
| TAKE | Implemented |
| TOCOL | Implemented |
| TOROW | Implemented |
| TRANSPOSE | Implemented |
| TRIMRANGE | Implemented |
| UNIQUE | Implemented |
| VLOOKUP | Implemented |
| VSTACK | Implemented |
| WRAPCOLS | Implemented |
| WRAPROWS | Implemented |
| XLOOKUP | Implemented |
| XMATCH | Implemented |
| GETPIVOTDATA | Implemented for worksheet-range PivotTables; OLAP/Data Model/Power Pivot semantics excluded with those subsystems |

---

## Text

**Coverage: 51/51 (100%)**

| Function | Status |
|---|---|
| ARABIC | Implemented |
| ARRAYTOTEXT | Implemented |
| CHAR | Implemented |
| CLEAN | Implemented |
| CODE | Implemented |
| CONCAT | Implemented |
| CONCATENATE | Implemented |
| DOLLAR | Implemented |
| EXACT | Implemented |
| FIND | Implemented |
| FINDB | Implemented |
| FIXED | Implemented |
| JIS | Implemented |
| LEFT | Implemented |
| LEFTB | Implemented |
| LEN | Implemented |
| LENB | Implemented |
| LOWER | Implemented |
| MID | Implemented |
| MIDB | Implemented |
| N | Implemented |
| NUMBERVALUE | Implemented |
| PROPER | Implemented |
| REGEXEXTRACT | Implemented |
| REGEXREPLACE | Implemented |
| REGEXTEST | Implemented |
| REPLACE | Implemented |
| REPLACEB | Implemented |
| REPT | Implemented |
| ROMAN | Implemented |
| RIGHT | Implemented |
| RIGHTB | Implemented |
| SEARCH | Implemented |
| SEARCHB | Implemented |
| SUBSTITUTE | Implemented |
| T | Implemented |
| TEXT | Implemented |
| TEXTAFTER | Implemented |
| TEXTBEFORE | Implemented |
| TEXTJOIN | Implemented |
| TEXTSPLIT | Implemented |
| TRIM | Implemented |
| UNICHAR | Implemented |
| UNICODE | Implemented |
| UPPER | Implemented |
| VALUE | Implemented |
| VALUETOTEXT | Implemented |
| ASC | Implemented |
| BAHTTEXT | Implemented |
| DBCS | Implemented |
| PHONETIC | Implemented |

---

## Date / Time

**Coverage: 25/25 (100%)**

| Function | Status |
|---|---|
| DATE | Implemented |
| DATEDIF | Implemented |
| DATEVALUE | Implemented |
| DAY | Implemented |
| DAYS | Implemented |
| DAYS360 | Implemented |
| EDATE | Implemented |
| EOMONTH | Implemented |
| HOUR | Implemented |
| ISOWEEKNUM | Implemented |
| MINUTE | Implemented |
| MONTH | Implemented |
| NETWORKDAYS | Implemented |
| NETWORKDAYS.INTL | Implemented |
| NOW | Implemented |
| SECOND | Implemented |
| TIME | Implemented |
| TIMEVALUE | Implemented |
| TODAY | Implemented |
| WEEKDAY | Implemented |
| WEEKNUM | Implemented |
| WORKDAY | Implemented |
| WORKDAY.INTL | Implemented |
| YEAR | Implemented |
| YEARFRAC | Implemented |

---

## Financial

**Coverage: 55/55 (100%)**

| Function | Status |
|---|---|
| ACCRINT | Implemented |
| ACCRINTM | Implemented |
| AMORDEGRC | Implemented |
| AMORLINC | Implemented |
| COUPDAYBS | Implemented |
| COUPDAYS | Implemented |
| COUPDAYSNC | Implemented |
| COUPNCD | Implemented |
| COUPNUM | Implemented |
| COUPPCD | Implemented |
| CUMIPMT | Implemented |
| CUMPRINC | Implemented |
| DB | Implemented |
| DDB | Implemented |
| DISC | Implemented |
| DOLLARDE | Implemented |
| DOLLARFR | Implemented |
| DURATION | Implemented |
| EFFECT | Implemented |
| FVSCHEDULE | Implemented |
| FV | Implemented |
| INTRATE | Implemented |
| IPMT | Implemented |
| ISPMT | Implemented |
| IRR | Implemented |
| MDURATION | Implemented |
| MIRR | Implemented |
| NOMINAL | Implemented |
| NPER | Implemented |
| NPV | Implemented |
| ODDFPRICE | Implemented |
| ODDFYIELD | Implemented |
| ODDLPRICE | Implemented |
| ODDLYIELD | Implemented |
| PDURATION | Implemented |
| PMT | Implemented |
| PPMT | Implemented |
| PRICE | Implemented |
| PRICEDISC | Implemented |
| PRICEMAT | Implemented |
| PV | Implemented |
| RATE | Implemented |
| RECEIVED | Implemented |
| RRI | Implemented |
| SLN | Implemented |
| SYD | Implemented |
| TBILLEQ | Implemented |
| TBILLPRICE | Implemented |
| TBILLYIELD | Implemented |
| VDB | Implemented |
| XIRR | Implemented |
| XNPV | Implemented |
| YIELD | Implemented |
| YIELDDISC | Implemented |
| YIELDMAT | Implemented |

---

## Information

**Coverage: 19/19 (100%)**

| Function | Status |
|---|---|
| CELL | Implemented |
| ERROR.TYPE | Implemented |
| INFO | Implemented |
| ISBLANK | Implemented |
| ISERR | Implemented |
| ISERROR | Implemented |
| ISEVEN | Implemented |
| ISFORMULA | Implemented |
| ISLOGICAL | Implemented |
| ISNA | Implemented |
| ISNONTEXT | Implemented |
| ISNUMBER | Implemented |
| ISODD | Implemented |
| ISREF | Implemented |
| ISTEXT | Implemented |
| NA | Implemented |
| SHEET | Implemented |
| SHEETS | Implemented |
| TYPE | Implemented |

---

## Lambda / Advanced Calculation

**Coverage: 9/9 (100%)**

| Function | Status |
|---|---|
| ISOMITTED | Implemented |
| LAMBDA | Implemented |
| LET | Implemented |
| BYROW | Implemented |
| BYCOL | Implemented |
| MAKEARRAY | Implemented |
| MAP | Implemented |
| REDUCE | Implemented |
| SCAN | Implemented |

---

## Database

**Coverage: 12/12 (100%)**

| Function | Status |
|---|---|
| DAVERAGE | Implemented |
| DCOUNT | Implemented |
| DCOUNTA | Implemented |
| DGET | Implemented |
| DMAX | Implemented |
| DMIN | Implemented |
| DPRODUCT | Implemented |
| DSTDEV | Implemented |
| DSTDEVP | Implemented |
| DSUM | Implemented |
| DVAR | Implemented |
| DVARP | Implemented |

---

## Engineering / Cube / Cloud

**Coverage: 57/57 in-scope functions (100%); cloud/cube/live-data functions excluded**

| Function | Status |
|---|---|
| BASE | Implemented |
| BESSELI | Implemented |
| BESSELJ | Implemented |
| BESSELK | Implemented |
| BESSELY | Implemented |
| BIN2DEC | Implemented |
| BIN2HEX | Implemented |
| BIN2OCT | Implemented |
| BITAND | Implemented |
| BITLSHIFT | Implemented |
| BITOR | Implemented |
| BITRSHIFT | Implemented |
| BITXOR | Implemented |
| COMPLEX | Implemented |
| CUBEKPIMEMBER | Excluded from scope |
| CUBEMEMBER | Excluded from scope |
| CUBESET | Excluded from scope |
| CUBESETCOUNT | Excluded from scope |
| CUBEVALUE | Excluded from scope |
| DECIMAL | Implemented |
| DEC2BIN | Implemented |
| DEC2HEX | Implemented |
| DEC2OCT | Implemented |
| DELTA | Implemented |
| ENCODEURL | Implemented |
| ERF | Implemented |
| ERF.PRECISE | Implemented |
| ERFC | Implemented |
| ERFC.PRECISE | Implemented |
| FILTERXML | Implemented |
| GESTEP | Implemented |
| HEX2BIN | Implemented |
| HEX2DEC | Implemented |
| HEX2OCT | Implemented |
| IMABS | Implemented |
| IMAGE | Excluded from scope |
| IMARGUMENT | Implemented |
| IMAGINARY | Implemented |
| IMCONJUGATE | Implemented |
| IMCOS | Implemented |
| IMCOSH | Implemented |
| IMCOT | Implemented |
| IMCSC | Implemented |
| IMCSCH | Implemented |
| IMDIV | Implemented |
| IMEXP | Implemented |
| IMLN | Implemented |
| IMLOG10 | Implemented |
| IMLOG2 | Implemented |
| IMPOWER | Implemented |
| IMPRODUCT | Implemented |
| IMREAL | Implemented |
| IMSEC | Implemented |
| IMSECH | Implemented |
| IMSIN | Implemented |
| IMSINH | Implemented |
| IMSQRT | Implemented |
| IMSUB | Implemented |
| IMSUM | Implemented |
| IMTAN | Implemented |
| OCT2BIN | Implemented |
| OCT2DEC | Implemented |
| OCT2HEX | Implemented |
| RTD | Excluded from scope |
| STOCKHISTORY | Excluded from scope |
| WEBSERVICE | Excluded from scope |

> Note: `CONVERT` handles unit conversion. The discrete base-conversion and bit-manipulation engineering functions are implemented separately.
