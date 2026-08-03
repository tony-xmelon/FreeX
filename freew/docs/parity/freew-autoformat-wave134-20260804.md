# FreeW AutoFormat As You Type Parity - Wave 134

Date: 2026-08-04

## Scope

This slice aligns the Avalonia `options.tab-auto-format-as-you-type` surface with the WPF authority. The shared `OptionsDialogPlanner` state and option behavior remain unchanged.

Avalonia now matches WPF's AutoFormat row contract: the master toggle has no leading spacing and an 8 px trailing gap, the section header uses the shared 4 px toggle spacing, the content origin uses the WPF-aligned inset, and AutoFormat checkbox labels use the WPF-equivalent 7 px glyph gap. The existing 16 px checkbox bounds, enabled-state synchronization, and all persisted toggles are preserved. The shared compact checkbox helper accepts an optional content-spacing value and retains its existing 4 px default for other dialogs.

## Fresh matched capture

Both hosts were captured at 560 x 600 from the focused inventory route, then compared in a disposable temp output. The tracked canonical comparison files were not edited.

| Metric | Before | After |
| --- | ---: | ---: |
| Changed pixels | 25,447 | 22,537 |
| Changed ratio | 7.5735% | 6.7074% |
| Mean channel delta | 8.1581 | 6.6159 |
| P95 channel delta | 62 | 34 |
| Perceptual hash distance | 4 | 2 |
| Classification | genuine-visual-mismatch | genuine-visual-mismatch |

The repository's prior canonical row was 33,868 changed pixels (10.0798%); the fresh matched baseline above was recaptured from the current branch before this patch. The remaining after mismatch is native WPF versus Avalonia control/template and glyph rasterization, plus a small content-height difference. No semantic difference was reported.

## Verification

- `dotnet test freew/FreeW.App.Host.Tests/FreeW.App.Host.Tests.csproj --configuration Release --filter FullyQualifiedName~OptionsDialogParityTests ...`: 5 passed.
- `dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release --filter FullyQualifiedName~OptionsDialogVisualParityTests ...`: 8 passed.
- WPF and Avalonia focused harness builds: succeeded with 0 warnings and 0 errors.
- Focused WPF and Avalonia captures: 1/1 each, content gates passed.
