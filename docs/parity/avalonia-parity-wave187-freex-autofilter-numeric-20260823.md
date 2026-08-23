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

No product change is claimed and the prepared direct `Border.PointerPressed`
route was reverted because it was never exercised by a valid B1 X11 run.
The follow-up attempts did not reach the 2/2 acceptance bar:

- Port `62876`: calibration passed, but the selector still used the old
  `A1 + cellWidth - 10` coordinate, which clicks the A/B boundary. The
  resulting `0/2` artifact was
  `artifacts/linux-interactive/freex/sessions/20260823T050301241Z/x11-validation/`.
  Its B1 screenshots show no flyout; the `greater-menu-open=true` value was a
  false positive from the selection screenshot comparison.
- Port `62877`: wrapper exited before X11 with
  `-SkipPublish requires -ResumeReportDirectory with an existing provenance record.`
- Ports `62878` and `62879`: the wrapper stopped its owned container, then
  exited at `Run-FreeXLinuxInteractionValidation.ps1:1662` because the
  physical manifest was invalid. The saved manifests were
  `artifacts/linux-interactive/freex/sessions/20260823T052247132Z/x11-validation/`
  and `artifacts/linux-interactive/freex/sessions/20260823T052413071Z/x11-validation/`;
  both report calibration failure: “The paced Down key did not produce a
  measurable A1-to-A2 selection transition,” with `cellWidth=159` and
  `cellHeight=0`. Their screenshots show the default workbook, not the
  numeric fixture, so they never exercised the B1 route.
- The latest report directories contained only the generated fixture and
  `resume-provenance.json` because the wrapper throws before writing its final
  report when the physical manifest fails schema validation.

## Verification

- Production Avalonia Release build before cleanup: **0 warnings, 0 errors**.
- Core.IO focused `R38/R65/R98`: **20 passed, 0 failed**.
- The direct route and numeric harness changes were reverted after the
  unexercised/invalid runs; this note is the only follow-up change.

## Blocker and remaining

The immediate blocker is deterministic physical startup/evidence readiness:
the wrapper can declare the desktop ready while the default workbook is still
the visible surface, and the calibration lane then fails before the fixture
is usable. The runner also throws on the numeric result IDs at schema
validation, so the report never reaches a final 0/2 row for the later runs.
The product pointer route itself remains uncredited, because no valid B1
glyph click was captured after the corrected coordinate was prepared.

Numeric criteria need a deterministic fixture-open/calibration wait, the
runner artifact-schema mapping fix, and one fresh 2/2 physical run before any
product-route change can be accepted. Date, color, composite/multi-column,
and criteria-clear/reapply workflows also remain outside this evidence row.
