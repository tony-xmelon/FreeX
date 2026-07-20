# FreeW Design Dialog Parity Evidence

Generated at UTC: 2026-07-20T05:32:54.1493171Z
Source commit: `bc946b2db52672a3410249e55d6773238e2661c7`
Schema: `freew.design-dialog-parity.v1`

Routes: 11 total; 10 complete; 0 remaining in the owned dialog/planner scope; 9 shell gaps recorded.

| Route | Status | WPF authority | Avalonia/shared implementation | Exact shell gap |
|---|---|---|---|---|
| Themes gallery | complete | freew/FreeW.App.Host/Ribbon/ThemeGallery.cs | freew/FreeW.App.Avalonia/Ribbon/FreeWAvaloniaRibbonCommands.cs | Avalonia gallery rendering remains owned by the forbidden ribbon construction surface. |
| Colors and Customize Colors | complete | freew/FreeW.App.Host/CustomizeThemeColorsDialog.cs | freew/FreeW.App.Avalonia/DesignDialogParity.cs | Avalonia freew.customize-colors registration is owned by the forbidden ribbon command registry. |
| Fonts and Customize Fonts | complete | freew/FreeW.App.Host/CustomizeThemeFontsDialog.cs | freew/FreeW.App.Avalonia/DesignDialogParity.cs | Avalonia freew.customize-fonts registration is owned by the forbidden ribbon command registry. |
| Custom Paragraph Spacing | complete | freew/FreeW.App.Host/CustomParagraphSpacingDialog.cs | freew/FreeW.App.Avalonia/DesignDialogParity.cs | Avalonia freew.custom-paragraph-spacing registration is owned by the forbidden ribbon command registry. |
| Effects gallery / selector | complete | freew/FreeW.App.Host/Ribbon/ThemeGallery.cs | freew/FreeW.App.Avalonia/DesignDialogParity.cs | Avalonia gallery opener and command construction remain owned by the forbidden ribbon construction surface. |
| Style Sets gallery | complete | freew/FreeW.App.Host/Ribbon/ThemeGallery.cs | freew/FreeW.App.Avalonia/DesignDialogParity.cs | Avalonia gallery rendering and value-command construction remain owned by the forbidden ribbon construction surface. |
| Reset / Set as Default confirmation | complete | freew/FreeW.App.Host/Ribbon/FreeWRibbonCommands.cs | freew/FreeW.App.Avalonia/DesignDialogParity.cs | WPF authority uses a direct Reset to Default Style Set command; no shell-owned confirmation route exists to wire without changing forbidden registry files. |
| Custom Watermark | complete | freew/FreeW.App.Host/WatermarkOptionsDialog.cs | freew/FreeW.App.Avalonia/DesignDialogs.cs | OpenWatermarkDialog is an optional callback; the forbidden Avalonia shell integration does not supply it. |
| Page Color / More Colors | complete | freew/FreeW.App.Host/Ribbon/FreeWRibbonCommands.cs | freew/FreeW.App.Avalonia/DesignDialogParity.cs | Avalonia page-color palette registration is present, but the More Colors launcher is shell-owned and forbidden to edit here. |
| Page Borders | complete | freew/FreeW.App.Host/BordersAndShadingDialog.cs | freew/FreeW.App.Avalonia/DesignDialogs.cs | OpenPageBordersDialog is an optional callback; the forbidden Avalonia shell integration does not supply it. |
| Combined Borders and Shading | authority-complete | freew/FreeW.App.Host/BordersAndShadingDialog.cs | freew/FreeW.App.Presentation/Dialogs/BordersAndShadingDialogPlanner.cs | Avalonia combined paragraph/shading launcher is outside this branch's allowed ownership boundary. |

## Freshness

Generate-FreeWDesignDialogParityEvidence.ps1 -Check recomputes SHA-256 for every authority, implementation, and focused-test source listed in the JSON. The check is expected to pass at handoff.

| Source | SHA-256 |
|---|---|
| freew/FreeW.App.Avalonia.Tests/DesignDialogParityTests.cs | 27425b625d8efd0e93e76dd516657e4c209ab7a4d57245faa3c5daacef74bb69 |
| freew/FreeW.App.Avalonia.Tests/DesignTabTests.cs | 48074f93f0151ce08d4f08c85375d8dfee652f8ac36f381d9718a19f1271b4ac |
| freew/FreeW.App.Avalonia.Tests/WatermarkDialogTests.cs | 832492d3075f13214c561fd33e998feef2d154197482d3db146124d17bc4e449 |
| freew/FreeW.App.Avalonia/DesignDialogParity.cs | 6ccf2e1a586106039b1084d3f4835cee6b819e117c65ed0d53ed58fc6563099d |
| freew/FreeW.App.Avalonia/DesignDialogs.cs | 4b5d5adabca1ee46bce74792678eebb702e32e9148ab0606cbc441e2cfa26c67 |
| freew/FreeW.App.Avalonia/Ribbon/FreeWAvaloniaRibbonCommands.cs | 54d58be6ab9fb5b403448e09d52e89c8cfb398c090509b60f7f79a0bc0c144d2 |
| freew/FreeW.App.Host.Tests/DesignDialogParitySourceTests.cs | 24031353a41f4dc24469f70bc9f2c654f98de877c062f2ce21e24393b4fedec8 |
| freew/FreeW.App.Host.Tests/DocumentEffectRenderingTests.cs | c2a5787dec308aa987236facc571ccd24f5149d209632e84ca63569e643c2ecf |
| freew/FreeW.App.Host/BordersAndShadingDialog.cs | 521607d92464e2d784a643be5f6cccd5f761be932fca2b7fe5cc892e6665cc9c |
| freew/FreeW.App.Host/CustomizeThemeColorsDialog.cs | bd28675846fb52802d52c181a7240f291e5c0691b447b781214c37162fafc6de |
| freew/FreeW.App.Host/CustomizeThemeFontsDialog.cs | 50ae9bd4205411248e43f40731229017785fe667ad5b071de9d106604c0aeb6c |
| freew/FreeW.App.Host/CustomParagraphSpacingDialog.cs | 20afb847c38092f3fedd03a2a4f7d530d6311b962729790dcd74edc50647297f |
| freew/FreeW.App.Host/Ribbon/FreeWRibbonCommands.cs | bb1c4a6f5719868a587a3f6692720565b854c2a288dadebe4c19d3e37efb6835 |
| freew/FreeW.App.Host/Ribbon/ThemeGallery.cs | c190ac2a56ad4f373319f27b4140e4be309d901032fcc7e6cf5fe026b96815e9 |
| freew/FreeW.App.Host/WatermarkOptionsDialog.cs | 03f4a60b77482836ef7b99933f86ab57c0cbca4b42192358754e14519a509611 |
| freew/FreeW.App.Presentation.Tests/BordersAndShadingDialogPlannerTests.cs | 67b81c58af54ee31e5b34eef1039dfb3c9c153daf6ae8f88f8e0ff2c952536c3 |
| freew/FreeW.App.Presentation.Tests/DesignDialogPlannerTests.cs | 8ff3670cdfa6c5f71cbf10b213df14140b88366d6f5bf37f8521007031bb5425 |
| freew/FreeW.App.Presentation/Dialogs/BordersAndShadingDialogPlanner.cs | 7ce9b8fbda22ac3bee1aaf1cc1ccbc0203af355094ccbfc4e5f7bc1d52792350 |
