# FreeX Wave 187 AutoFilter Numeric Criteria Evidence

Date: 2026-08-23

## Scope

Timeboxed physical Linux/X11 validation of numeric AutoFilter criteria in the
Avalonia shell:

- Number Filters -> Greater Than (`50`), expected visible values `75,100`.
- Number Filters -> Equals (`50`), expected visible value `50`.

Each criterion was intended to prove the rendered menu/dialog route, visible
rows, clean save, exact `customFilter` operator/value in `xl/worksheets/sheet1.xml`,
and the same visible rows after production reopen.

## Result

No product change is claimed. The physical selector was run once after a
minimal diagnostic correction and failed **0/2** before criteria commit:

- Run: production Linux Docker/X11, port `62875`.
- Artifact: `artifacts/linux-interactive/freex/interaction-validation/20260823T050225Z/x11-validation/`.
- Calibration passed at `1280x820`; `A1=(29,236)`, cell pitch `64x20`.
- The fixture rendered `Amount`, `10`, `50`, `75`, and `100` correctly.
- `autofilter-numeric-header-selected.png` and
  `autofilter-numeric-mouse-open.png` show the same selected B1 state with no
  flyout. The production `Alt+Down` fallback also produced no flyout.
- Postcondition: `greater-menu-open=true` was only the selection transition,
  `greater-visible=10,50,75,100`, `greater-save-clean=false`, package empty,
  and Equals never started.

The preceding run at port `62874` showed the same route failure after the
numeric fixture was corrected. The first earlier run was discarded because
the fixture encoded the `Amount` header incorrectly; it is not evidence.

## Verification

- Core.IO focused `R38/R65/R98`: **21 passed, 0 failed**.
- Avalonia source guard for the provisional physical lane: **1 passed, 0 failed**.
- The provisional fixture, selector, source guard, and equality unit-test
  changes were reverted after the failed physical run; no incomplete harness
  or product change remains in this slice.

## Blocker and remaining

The reproducible blocker is the Avalonia physical input route from a valid
non-first AutoFilter header cell to its rendered flyout: the visible glyph
does not open the flyout, and the active-header `Alt+Down` route does not open
it either. Parser, save, package, reopen, equality, and comparison behavior
therefore remain uncredited by physical evidence.

Numeric criteria need a focused product-route fix and a new 2/2 physical run.
Date, color, composite/multi-column, and criteria-clear/reapply workflows also
remain outside this evidence row.
