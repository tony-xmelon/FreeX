# FreeW Design Dialog Parity Evidence

Generated at UTC: 2026-09-07T08:19:27.4563638Z
Source commit: `4f585ab8131dad1938ba8fbe19ddfcc5896a88ed`
Schema: `freew.design-dialog-parity.v1`

Routes: 11 total; 10 complete; 0 remaining in the owned dialog/planner scope; 0 shell gaps recorded.

| Route | Status | WPF authority | Avalonia/shared implementation | Exact shell gap |
|---|---|---|---|---|
| Themes gallery | complete | freew/FreeW.App.Host/Ribbon/ThemeGallery.cs | freew/FreeW.App.Avalonia/Ribbon/FreeWAvaloniaRibbonCommands.cs |  |
| Colors and Customize Colors | complete | freew/FreeW.App.Host/CustomizeThemeColorsDialog.cs | freew/FreeW.App.Avalonia/DesignDialogParity.cs |  |
| Fonts and Customize Fonts | complete | freew/FreeW.App.Host/CustomizeThemeFontsDialog.cs | freew/FreeW.App.Avalonia/DesignDialogParity.cs |  |
| Custom Paragraph Spacing | complete | freew/FreeW.App.Host/CustomParagraphSpacingDialog.cs | freew/FreeW.App.Avalonia/PageLayoutDialogs.cs |  |
| Effects gallery / selector | complete | freew/FreeW.App.Host/Ribbon/ThemeGallery.cs | freew/FreeW.App.Avalonia/DesignDialogParity.cs |  |
| Style Sets gallery | complete | freew/FreeW.App.Host/Ribbon/ThemeGallery.cs | freew/FreeW.App.Avalonia/DesignDialogParity.cs |  |
| Reset / Set as Default confirmation | complete | freew/FreeW.App.Host/Ribbon/FreeWRibbonCommands.cs | freew/FreeW.App.Avalonia/DesignDialogParity.cs |  |
| Custom Watermark | complete | freew/FreeW.App.Host/WatermarkOptionsDialog.cs | freew/FreeW.App.Avalonia/DesignDialogs.cs |  |
| Page Color / More Colors | complete | freew/FreeW.App.Host/Ribbon/FreeWRibbonCommands.cs | freew/FreeW.App.Avalonia/DesignDialogParity.cs |  |
| Page Borders | complete | freew/FreeW.App.Host/BordersAndShadingDialog.cs | freew/FreeW.App.Avalonia/DesignDialogs.cs |  |
| Combined Borders and Shading | authority-complete | freew/FreeW.App.Host/BordersAndShadingDialog.cs | freew/FreeW.App.Presentation/Dialogs/BordersAndShadingDialogPlanner.cs |  |

## Freshness

This artifact records hand-authored parity findings for the authority, implementation, and focused-test inputs listed below. Generate-FreeWDesignDialogParityEvidence.ps1 -Check only verifies that the generator reproduces those declared findings and that this covered-input list still resolves to real files; it does not detect edits to the contents of those files. When any listed source changes, the routes and gaps above must be re-verified by hand and this artifact regenerated.

| Covered input |
|---|
| freew/FreeW.App.Avalonia.Tests/DesignDialogParityTests.cs |
| freew/FreeW.App.Avalonia.Tests/DesignTabTests.cs |
| freew/FreeW.App.Avalonia.Tests/PageLayoutDialogParityTests.cs |
| freew/FreeW.App.Avalonia.Tests/WatermarkDialogTests.cs |
| freew/FreeW.App.Avalonia/DesignDialogParity.cs |
| freew/FreeW.App.Avalonia/DesignDialogs.cs |
| freew/FreeW.App.Avalonia/MainWindow.cs |
| freew/FreeW.App.Avalonia/PageLayoutDialogs.cs |
| freew/FreeW.App.Avalonia/Ribbon/FreeWAvaloniaRibbonCommands.cs |
| freew/FreeW.App.Host.Tests/DesignDialogParitySourceTests.cs |
| freew/FreeW.App.Host.Tests/DocumentEffectRenderingTests.cs |
| freew/FreeW.App.Host/BordersAndShadingDialog.cs |
| freew/FreeW.App.Host/CustomizeThemeColorsDialog.cs |
| freew/FreeW.App.Host/CustomizeThemeFontsDialog.cs |
| freew/FreeW.App.Host/CustomParagraphSpacingDialog.cs |
| freew/FreeW.App.Host/Ribbon/FreeWRibbonCommands.cs |
| freew/FreeW.App.Host/Ribbon/ThemeGallery.cs |
| freew/FreeW.App.Host/WatermarkOptionsDialog.cs |
| freew/FreeW.App.Presentation.Tests/BordersAndShadingDialogPlannerTests.cs |
| freew/FreeW.App.Presentation.Tests/DesignDialogPlannerTests.cs |
| freew/FreeW.App.Presentation/Dialogs/BordersAndShadingDialogPlanner.cs |
| freew/FreeW.Ribbon.Definitions/FreeWCanonicalRibbonTabs.Contextual.cs |
| freew/FreeW.Ribbon.Definitions/FreeWCanonicalRibbonTabs.cs |
| freew/FreeW.Ribbon.Definitions/FreeWCanonicalRibbonTabs.Ordinary.cs |
| freew/FreeW.Ribbon.Definitions/FreeWRibbon.cs |
