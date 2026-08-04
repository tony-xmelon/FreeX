# Avalonia parity Wave 146: FreeW Paragraph Line/Page Breaks

This bounded slice aligns the Avalonia Paragraph dialog's Line and Page Breaks tab with the retained
WPF authority source. The existing baseline row remains `genuine-visual-mismatch` at `0.082480`
changed ratio, `10.036075` mean absolute channel delta, and pHash distance `5`.

## Change

- Matched both WPF section-heading bottom margins at 8 px.
- Matched all six WPF pagination/exception checkbox bottom margins at 6 px.
- Added a focused control-tree assertion for those exact margins.

No comparison threshold, classification, WPF source, or shared Avalonia chrome was changed.

## Evidence

The focused Avalonia capture was valid at
`artifacts/freew-wave146-paragraph-tab-line-and-page-breaks/avalonia`:
`avalonia.paragraph.tab-line-and-page-breaks` captured at 560x600, with both full-frame and target
content gates passing. The attempted fresh WPF capture was blank/unsupported (100% near-black with
no painted bounds), so it was discarded and no new paired metric is claimed; the retained WPF
authority remains the checked-in baseline above.

## Verification

- `dotnet restore freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --disable-parallel`
  passed.
- `dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release --no-restore --filter "FullyQualifiedName~ParagraphDialogVisualParityTests.Line_and_page_breaks_tab_uses_Wpf_section_spacing"`
  passed: 1/1.
- The broader `ParagraphDialogVisualParityTests` class compiled and ran 5 passed / 2 failed; both
  failures are pre-existing unrelated assertions for localized button template content and a stale
  harness source-string expectation.
- The focused Avalonia harness capture command completed 1 captured / 0 unsupported.
