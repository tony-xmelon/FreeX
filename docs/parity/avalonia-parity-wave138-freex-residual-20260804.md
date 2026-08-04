# Avalonia/WPF Parity Wave 138: FreeX Conditional Format Manager Fixture

Date: 2026-08-04

## Audit finding

The existing canonical pair was semantically mismatched. The committed, nonblank WPF authority is
`dialog.ConditionalFormatManage.png` at 840x630 pixels and approximately 144 DPI, or 560x420 logical
pixels. It shows two rules over `$C$2:$C$6`: `Cell Value >= 1600` followed by `Data Bar`.

The current WPF parity helper had drifted to a three-rule Data Bar / 3-Color Scale / Cell Value >100
fixture, while the Avalonia helper independently applied those same three presets to `D2:D5`. This was
stale fixture evidence, not a product behavior difference. The WPF authority was retained; no blank or
new WPF frame was promoted.

## Change

- Added `ConditionalFormatManageParityFixture` in shared presentation code with the authority's exact
  560x420 size, C2:C6 range, rule order, threshold, formatting, and solid-blue data-bar state.
- Updated both WPF and Avalonia parity capture routes to consume that descriptor and removed the duplicated
  three-rule/D2:D5 setup. Production dialog openers, functionality, keyboard/accessibility wiring, and
  exact size remain unchanged.
- Matched the WPF authority's inline Applies To presentation for the parity capture route by suppressing
  Avalonia's separate editor row only for that capture opener; the normal production route retains the
  existing editor, range picker, automation ids, and behavior.
- Added a focused fixture behavior test.

## Evidence and metrics

The pre-change checked-in pair was not a valid semantic comparison. The source audit found:

| Capture source | Rules | Applies-to | Size |
| --- | ---: | --- | --- |
| WPF authority PNG | 2 | `$C$2:$C$6` | 560x420 logical |
| WPF current helper before Wave 138 | 3 | capture range (`A1:E5`) | 560x420 logical |
| Avalonia current helper before Wave 138 | 3 | `D2:D5` | 560x420 logical |

The fresh Linux Docker Avalonia capture passed `app_exit=0`, `capture_validated=true`, nonblank-content,
and exact 560x420 gates. The focused pair comparison against the retained WPF authority measured:

| Pair | Triage | Sample mean | Luma delta | Non-background delta |
| --- | ---: | ---: | ---: | ---: |
| Existing canonical pair before Wave 138 | 0.073983 | 0.045 | 0.000 | 0.028 |
| Wave 138 fresh Avalonia, shared fixture and chrome correction | **0.065497** | **0.035432** | 0.002 | **0.028488** |

The triage score fell 11.5%. The old score is retained for historical comparison only: its frames were
semantically mismatched, so the content correction is the primary result and the numeric delta is
directional rather than a pure chrome-only measurement. The canonical Avalonia PNG/manifest row were
promoted under `docs/parity/dialog-visual-assets/`. Global dialog summary/dashboard regeneration remains
with integration.

## Verification

- `dotnet test tests/FreeX.App.Presentation.Tests/FreeX.App.Presentation.Tests.csproj --configuration Release --no-restore --filter "FullyQualifiedName~ConditionalFormatManageParityFixtureTests"` - 1 passed.
- `tools/Run-LinuxParityCapture.ps1` - app exit 0, `capture_validated=true`, nonblank, exact 560x420.
- `tools/Generate-DialogVisualEvidenceSummary.ps1` - focused pair: 0 logical-size mismatches, 0 nonblank failures, triage 0.065497.

## Residual limitations

The retained WPF authority predates this source correction but is nonblank and semantically explicit. A
fresh WPF authority recapture was intentionally not attempted in this Linux-focused slice, so the final
metric remains conditional on the retained authority plus the fresh Avalonia frame.
