# Avalonia parity Wave188: FreeX numeric AutoFilter evidence

Date: 2026-08-23
Branch: `codex/parity-wave188-freex-20260823`
Base: `origin/main` at `94241681c6184e23572b5449cbfc312fe4bbe626`

## Diagnosis and accepted changes

The Wave187 blocker had two deterministic harness causes. The Docker entrypoint
reported readiness as soon as any FreeX window existed, while Avalonia was still
opening the requested document asynchronously. The probe then calibrated against
the default workbook instead of the numeric fixture. Separately, the validation
runner did not register the two numeric physical result IDs in both its required
result and artifact schema maps, so a successful physical route could not be
accepted.

Wave188 now waits for the visible window title to contain
`freex-wave188-autofilter-numeric.xlsx` before calibration, records readiness
evidence, creates a minimal OOXML fixture with real numeric B2:B5 values, and
maps both numeric result IDs in the runner schema. The valid run calibrated the
fixture at A1 `(29,236)`, pitch `64x20`, and used the rendered B1 glyph at
`(148,246)`.

With startup, fixture, calibration, and schema valid on Linux/Docker/X11, the
direct B1 click initially failed to open the product menu. This exposed a real
production route issue: the rendered glyph is an inner `Border`, and Linux/X11
pointer delivery did not reach the enclosing `Button.Click` handler. The minimal
accepted product fix retains the button handler for keyboard/accessibility and
also opens the filter flyout from the glyph border's `PointerPressed` event.

## Production evidence

Command:

```powershell
pwsh -NoProfile -ExecutionPolicy Bypass -File tools/Run-FreeXLinuxInteractionValidation.ps1 -Port 62892 -TimeoutMinutes 15 -PhysicalOnly -PhysicalProbeSelector autofilter-numeric-criteria-persistence -SkipImageBuild
```

Result: 2/2 physical probes passed, with no failed probes. Both cases used the
rendered B1 route, a menu/dialog interaction, clean save, XML package inspection,
production reopen, and exact visible-row readback:

| Case | Criteria | Visible rows | XML customFilter | Reopened rows |
| --- | --- | --- | --- | --- |
| Greater Than 50 | `greaterThan:50` | `75,100,` | `ref=A1:B5`, `colId=1`, `operator=greaterThan`, `value=50` | `75,100,` |
| Equals 50 | `equals:50` | `50,` | `ref=A1:B5`, `colId=1`, empty operator, `value=50` | `50,` |

Readiness evidence observed:
`freex-wave188-autofilter-numeric.xlsx - FreeX`.

Report:
`artifacts/linux-interactive/freex/interaction-validation/20260823T065330Z/interaction-validation.json`

HTML report:
`artifacts/linux-interactive/freex/interaction-validation/20260823T065330Z/interaction-validation.html`

Physical artifacts:
`artifacts/linux-interactive/freex/sessions/20260823T065355714Z/x11-validation/`

The physical artifact directory contains readiness text/image, calibration
evidence, before/menu/applied/reopened screenshots for both criteria,
`autofilter-numeric-postcondition.txt`, and `x11-input-results.json`. The
Wave188 container was `freex-linux-interactive-freex-62892` and was stopped by
the runner; no Wave188 container remains running.

## Verification

Focused Core IO R38/R65/R98:

```powershell
dotnet test tests/FreeX.Core.IO.Tests/FreeX.Core.IO.Tests.csproj --configuration Release --no-build --filter "FullyQualifiedName~R38_AutoFilterAdvancedCriteriaPersistenceTests|FullyQualifiedName~R65_AutoFilterPartialUnsupportedAndScopedRankingTests|FullyQualifiedName~R98_AutoFilterUnsupportedColumnHiddenRowsReclassificationTests" --logger "trx;LogFileName=wave188-coreio-filter-final.trx"
```

Result: 20/20 passed. Avalonia/source behavior focus (Wave188, Wave186, R72,
cleanup): 17/17 passed. Presentation AutoFilter planner/workflow focus:
35/35 passed. Release build of the touched production project passed with 0
warnings and 0 errors:

```powershell
dotnet build src/FreeX.App.Avalonia/FreeX.App.Avalonia.csproj --configuration Release --no-restore
```

No full-solution build or default interaction lane was used for Wave188.

## Remaining risk

This evidence covers numeric Greater Than and Equals through the rendered
non-first-column B1 glyph, save/reopen persistence, and exact XML/readback
postconditions. Other AutoFilter operators, mixed-type columns, multi-column
criteria, clear/reapply behavior, and non-X11 platform pointer routing remain
outside this focused Wave188 acceptance lane.
