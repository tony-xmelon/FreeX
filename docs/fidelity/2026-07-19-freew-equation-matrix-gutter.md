# FreeW Equation Matrix Gutter Calibration

## Scope

The WPF OfficeMath matrix renderer used four-DIP horizontal gutters on every
matrix cell. In the Word-authored 2x2 identity matrix this spread the glyph
strip to 44 pixels, compared with Word's 28-pixel strip. The WPF matrix branch
now uses two-DIP gutters; other equation structures and the shared equation
plan are unchanged.

## Matched Word Evidence

The fixture is `equation-structures.docx`, page 1, scored at 816x1056 against
the persistent Word PNG baseline.

| Region | Before | After | Change |
| --- | ---: | ---: | ---: |
| Whole page | 1.0543% | 1.0537% | -0.0006 pp |
| Matrix ROI `(112,255)-(182,293)` | 9.1126% | 8.9045% | -0.2082 pp |
| Matrix row `(112,260)-(182,290)` | 10.8140% | 10.5503% | -0.2637 pp |
| Non-matrix equation control | 6.0805% | 6.0805% | byte-stable |

Candidate-versus-baseline output changed only 341 pixels in
`(133,267)-(166,287)`, the matrix cell strip.

## Verification

- `dotnet build freew/FreeW.App.Host.Tests/FreeW.App.Host.Tests.csproj --configuration Release --no-restore`
  completed with 0 warnings and 0 errors.
- `dotnet build freew/tools/FreeW.FidelityRender/FreeW.FidelityRender.csproj --configuration Release --no-restore`
  completed with 0 warnings and 0 errors.
- `EquationVisualPlannerSourceGuardTests`: 1/1 passed from the Release build.
- The focused STA matrix round-trip test was deferred after the WPF test host
  exceeded its bounded timeout and its exact owned `vstest`/`testhost` children
  were reaped. The source/test assembly builds cleanly; this remains an
  explicit follow-up verification gap.

## Guard

Keep matrix gutters separate from the other OfficeMath structure paths. Future
matrix spacing changes require the same Word target, a matrix ROI gain, a
whole-page non-regression, and byte-stable non-matrix equation controls.
