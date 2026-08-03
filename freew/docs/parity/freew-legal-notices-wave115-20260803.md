# FreeW Legal Notices Visual Parity Wave 115

Date: 2026-08-03
Authority: fresh FreeW WPF `SharedLegalNoticesDialog` captures
Scope: the four long-document Avalonia Legal Notices tabs

## Change

Avalonia now uses a dedicated 15 px line box for overflowing Legal Notices documents,
while retaining the measured 14.6 px short-document line box and existing WPF-authority
padding, scrollbar lane, tab chrome, focus, and button semantics. The correction is
Avalonia-host specific; the shared WPF dialog and its metrics remain unchanged. This
removes the cumulative upward baseline drift visible in long notices without changing
short Project License geometry.

## Fresh Evidence

The WPF and Avalonia harnesses captured all six Legal Notices states. The four requested
long-tab rows below are refreshed in the canonical report:
`docs/parity/freew-dialog-harness/freew_dialog_visual_comparison.{json,md,html}`.
Raw manifests and images are retained under:
`C:\Users\anton\AppData\Local\Temp\freew-wave115-legal-current-eb3d9d70438940468357ab78acc21bbe\`.

| State | Before changed | After changed | Improvement | Before mean | After mean | Mean improvement |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `legal-notices.tab-legal-notices` | 18.2777% | 17.7898% | 0.4879 pp | 19.871 | 18.535 | 1.336 |
| `legal-notices.tab-privacy-notice` | 16.5145% | 16.4640% | 0.0505 pp | 18.583 | 18.479 | 0.104 |
| `legal-notices.tab-third-party-notices` | 17.9952% | 17.6137% | 0.3815 pp | 20.321 | 19.127 | 1.194 |
| `legal-notices.tab-third-party-license-texts` | 18.5226% | 17.9728% | 0.5497 pp | 21.215 | 19.975 | 1.240 |

The initial and Project License states are unchanged by this slice. All four rows remain
honest `genuine-visual-mismatch` classifications: residuals are Avalonia/WPF glyph
rasterization, paragraph wrapping differences, and native tab, border, and scrollbar
template pixels. No comparator threshold or classification was changed.

## Verification

- `dotnet build freew/tools/FreeW.DialogVisualHarness.Wpf/FreeW.DialogVisualHarness.Wpf.csproj --configuration Release ...`: succeeded, 0 warnings, 0 errors.
- `dotnet build freew/tools/FreeW.DialogVisualHarness.Avalonia/FreeW.DialogVisualHarness.Avalonia.csproj --configuration Release ...`: succeeded, 0 warnings, 0 errors.
- WPF harness capture: 190/190 captured; Avalonia harness capture: 288/288 captured.
- `LegalNoticesDialogVisualParityTests`: 12/12 passed.
- Comparison report: 478 scenarios; 155 genuine visual mismatches, 28 passes, 105 Avalonia extensions, and 7 state-not-applicable rows.
