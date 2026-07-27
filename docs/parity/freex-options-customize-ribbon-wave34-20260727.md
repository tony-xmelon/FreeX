# FreeX Options Customize Ribbon Wave34

Date: 2026-07-27
Branch: `codex/freex-customize-ribbon-wave34-20260727`
Surface: `dialog.Options.CustomizeRibbon`
Authority: WPF `OptionsDialog`

## Change

Avalonia now enables the Import/Export button, assigns the stable `RibbonImportExportButton` automation id, and routes activation to the existing localized deferred message resources through `AvaloniaUserMessageDialog.ShowWarningAsync` owned by the Options dialog. The existing category focus/navigation, default OK, cancel, and `ShowDialog` lifecycle remain intact. WPF UI was not changed.

## Runtime Evidence

The fresh matched captures use the same logical client dimensions, 744 x 521 pixels:

- WPF: `artifacts/options-customize-ribbon-wave34-20260727/wpf/dialog.Options.CustomizeRibbon.png`
- Avalonia: `artifacts/options-customize-ribbon-wave34-20260727/avalonia/out/dialog.Options.CustomizeRibbon.png`
- Compare report: `artifacts/options-customize-ribbon-wave34-20260727/compare/parity-report.json`
- Before report: `artifacts/options-customize-ribbon-wave34-20260727/before-compare/parity-report.json`
- Committed canonical pair: `docs/parity/dialog-visual-assets/wpf-capture/dialog.Options.CustomizeRibbon.png` and `docs/parity/dialog-visual-assets/avalonia-capture/dialog.Options.CustomizeRibbon.png`

| Metric | Before canonical pair | Fresh Wave34 pair |
| --- | ---: | ---: |
| Target diff percent | 2.2170% | 1.6662% |
| Logical dimensions | 744 x 521 | 744 x 521 |
| Target present in both | yes | yes |
| Hard comparison regressions | 0 | 0 |

The fresh target reduced the measured difference by 24.84%. The remaining difference is primarily platform text/control rasterization and native chrome treatment; no additional structural change was justified, and this is not a 100% parity claim.

## Behavioral Verification

`OptionsDialogAdvancedParitySourceTests` passed 6/6, including real headless activation by click and Enter, owned modal verification, click/Escape close, and parent Options lifecycle completion. `OptionsDialogSourceTests` passed 46/46 on WPF. The WPF host build passed with 0 warnings and 0 errors.

Capture commands also completed successfully: WPF targeted capture, Avalonia Linux Docker/Xvfb capture, and the parity comparer. The task-owned container was removed after capture; no task-owned process or container remains.
