# FreeW Design Dialog Parity Evidence

Generated at UTC: 2026-07-20T05:56:35.8817336Z
Source commit: `b3cd5d7c0350551500ffb5433446bc384267af9a`
Schema: `freew.design-dialog-parity.v1`

Routes: 11 total; 10 complete; 0 remaining in the owned dialog/planner scope; 9 shell gaps recorded.

| Route | Status | WPF authority | Avalonia/shared implementation | Exact shell gap |
|---|---|---|---|---|
| Themes gallery | complete | freew/FreeW.App.Host/Ribbon/ThemeGallery.cs | freew/FreeW.App.Avalonia/Ribbon/FreeWAvaloniaRibbonCommands.cs | Avalonia gallery rendering remains owned by the forbidden ribbon construction surface. |
| Colors and Customize Colors | complete | freew/FreeW.App.Host/CustomizeThemeColorsDialog.cs | freew/FreeW.App.Avalonia/DesignDialogParity.cs | Avalonia freew.customize-colors registration is owned by the forbidden ribbon command registry. |
| Fonts and Customize Fonts | complete | freew/FreeW.App.Host/CustomizeThemeFontsDialog.cs | freew/FreeW.App.Avalonia/DesignDialogParity.cs | Avalonia freew.customize-fonts registration is owned by the forbidden ribbon command registry. |
| Custom Paragraph Spacing | complete | freew/FreeW.App.Host/CustomParagraphSpacingDialog.cs | freew/FreeW.App.Avalonia/PageLayoutDialogs.cs | Avalonia freew.custom-paragraph-spacing registration is owned by the shared ribbon command registry. |
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
| freew/FreeW.App.Avalonia.Tests/DesignDialogParityTests.cs | cfcb03426e8bb638acdf096c220b539f6294eb8858e058544ad5532d727165cb |
| freew/FreeW.App.Avalonia.Tests/DesignTabTests.cs | 48074f93f0151ce08d4f08c85375d8dfee652f8ac36f381d9718a19f1271b4ac |
| freew/FreeW.App.Avalonia.Tests/PageLayoutDialogParityTests.cs | ef5c8b9b0675858d0b73284dbab6bc38f6188f176f19df4af4a49022fed38e7e |
| freew/FreeW.App.Avalonia.Tests/WatermarkDialogTests.cs | 832492d3075f13214c561fd33e998feef2d154197482d3db146124d17bc4e449 |
| freew/FreeW.App.Avalonia/DesignDialogParity.cs | 79af610a9fa8f2374d61ee68a8940701ddd7431c9e6940c48b0bcd210bbc9c42 |
| freew/FreeW.App.Avalonia/DesignDialogs.cs | da52f17927afff1138cced9ca93414cca23c5ed29829ddeab47a07e25a570ada |
| freew/FreeW.App.Avalonia/PageLayoutDialogs.cs | 6623169fc083a3bd0565c01876ad40b372a298c51bdc384c44a25debb773f9d8 |
| freew/FreeW.App.Avalonia/Ribbon/FreeWAvaloniaRibbonCommands.cs | 486109cf7e7433c9b95ecf2cd6c3a1c68a592ea4fa2f06c51cfde3070c55177b |
| freew/FreeW.App.Host.Tests/DesignDialogParitySourceTests.cs | d50c86032e0ef717069a9824648440412c5f2dd9a3c1cc5b16854fafa1779029 |
| freew/FreeW.App.Host.Tests/DocumentEffectRenderingTests.cs | c2a5787dec308aa987236facc571ccd24f5149d209632e84ca63569e643c2ecf |
| freew/FreeW.App.Host/BordersAndShadingDialog.cs | 521607d92464e2d784a643be5f6cccd5f761be932fca2b7fe5cc892e6665cc9c |
| freew/FreeW.App.Host/CustomizeThemeColorsDialog.cs | 24f91b2d001f9afd8f154c776ab8ed1f341ef5a91f0e8a274a4d28d2f2de8bcf |
| freew/FreeW.App.Host/CustomizeThemeFontsDialog.cs | d4383b13c069f2b11f8d32a15b65d951b4f0f96e39980ea2df96d6f6c0053964 |
| freew/FreeW.App.Host/CustomParagraphSpacingDialog.cs | 20afb847c38092f3fedd03a2a4f7d530d6311b962729790dcd74edc50647297f |
| freew/FreeW.App.Host/Ribbon/FreeWRibbonCommands.cs | 9f3f5248296a4ad29d2e70cc6e0dc2e278ae792a3a56ee40cc56ac65ed2ee0ab |
| freew/FreeW.App.Host/Ribbon/ThemeGallery.cs | c190ac2a56ad4f373319f27b4140e4be309d901032fcc7e6cf5fe026b96815e9 |
| freew/FreeW.App.Host/WatermarkOptionsDialog.cs | 03f4a60b77482836ef7b99933f86ab57c0cbca4b42192358754e14519a509611 |
| freew/FreeW.App.Presentation.Tests/BordersAndShadingDialogPlannerTests.cs | 67b81c58af54ee31e5b34eef1039dfb3c9c153daf6ae8f88f8e0ff2c952536c3 |
| freew/FreeW.App.Presentation.Tests/DesignDialogPlannerTests.cs | 92f89291c7e28f3199bd0e2763d15fc9efd974c34a5d10ed4f4ede30def4ad46 |
| freew/FreeW.App.Presentation/Dialogs/BordersAndShadingDialogPlanner.cs | 7ce9b8fbda22ac3bee1aaf1cc1ccbc0203af355094ccbfc4e5f7bc1d52792350 |
