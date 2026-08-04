# Avalonia Parity Wave 136: FreeW Legal Notices

Date: 2026-08-04
Scope: FreeW WPF/Avalonia Legal Notices dialog, all five tabs
Decision: retain a Legal Notices-only read-only document width correction.

## Change

`ApplyAvaloniaReadOnlyDocumentTemplatePadding` keeps its existing default right
margin of `1`, preserving Avalonia About and every other shared consumer. The
Legal Notices dialog explicitly requests `rightMargin: 2` to match the WPF
authority's read-only document width. The existing shared intro compensation,
tab chrome, typography, read-only text behavior, scrolling, copy/select behavior,
focus, automation IDs, and default/cancel Close behavior are unchanged.

## Fresh paired evidence

Fresh WPF authority capture: `artifacts/wave136-freew-legal-baseline/wpf/`
(190/190). Fresh final Avalonia capture:
`artifacts/wave136-freew-legal-margin-only/avalonia/` (288/288).
The five-tab comparison was refreshed in
`docs/parity/freew-dialog-harness/freew_dialog_visual_comparison.{json,md,html}`
using `--refresh-route legal-notices`; the cross-app dashboard was not regenerated.

| Tab | Before ratio / mean | After ratio / mean | Delta ratio / mean |
| --- | ---: | ---: | ---: |
| Project License | 9.1968% / 9.768 | 9.1965% / 9.780 | -0.0003 pp / +0.012 |
| Legal Notices | 18.0078% / 18.730 | 18.0067% / 18.741 | -0.0011 pp / +0.011 |
| Privacy Notice | 16.6820% / 18.674 | 16.6809% / 18.685 | -0.0011 pp / +0.011 |
| Third-Party Notices | 17.8317% / 19.190 | 17.6247% / 19.156 | -0.2070 pp / -0.034 |
| Third-Party License Texts | 18.1930% / 20.033 | 17.9720% / 20.004 | -0.2210 pp / -0.029 |

All rows remain honest `genuine-visual-mismatch` classifications with no
semantic differences. The remaining delta is concentrated in WPF ClearType
versus Avalonia/Skia glyph rasterization, native scrollbar pixels, and the
known one-pixel content registration. No capture validity or behavior gate was
weakened.

## Tests and commands

- `dotnet build freew/tools/FreeW.DialogVisualHarness.Avalonia/FreeW.DialogVisualHarness.Avalonia.csproj --configuration Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1` - passed, 0 warnings/errors.
- `dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --filter "FullyQualifiedName~LegalNoticesDialogVisualParityTests"` - 13/13 passed.
- `dotnet test freew/FreeW.App.Host.Tests/FreeW.App.Host.Tests.csproj --configuration Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --filter "FullyQualifiedName~FreeWHelpInfoTests"` - 9/9 passed.
- WPF harness: 190/190 captured; Avalonia harness: 288/288 captured; final comparison: 478 scenarios, 158 genuine visual mismatches, 25 passes, 105 Avalonia extensions, 7 state-not-applicable.
