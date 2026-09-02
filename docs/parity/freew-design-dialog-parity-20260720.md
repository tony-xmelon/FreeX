# FreeW Design Dialog Parity Evidence

Generated at UTC: 2026-09-02T08:05:43.0917819Z
Source commit: `8e42552704a36edf56cfe9349be731ea65a69f52`
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

Generate-FreeWDesignDialogParityEvidence.ps1 -Check recomputes SHA-256 for every authority, implementation, and focused-test source listed in the JSON. The check is expected to pass at handoff.

| Source | SHA-256 |
|---|---|
| freew/FreeW.App.Avalonia.Tests/DesignDialogParityTests.cs | 9b11b73d7b4b062f6e5cc016f875430a48f5a424b22e693d284146631d4d0168 |
| freew/FreeW.App.Avalonia.Tests/DesignTabTests.cs | d45afd72671318af4f208046f0399cc8c5dfe12ba1d2c22a3f1839c28c2f9d21 |
| freew/FreeW.App.Avalonia.Tests/PageLayoutDialogParityTests.cs | 70ef82be3e746cca541f56a8cfe6976a02cf45fb88c07f9455d8e7c476c9f7ab |
| freew/FreeW.App.Avalonia.Tests/WatermarkDialogTests.cs | f572794914258192a994e4ea35c1d1e3cbcfe43a198ef7d10a4acff6f5ea743b |
| freew/FreeW.App.Avalonia/DesignDialogParity.cs | 33fe3dd13569372598f2259f2adb56c58c61cd739d8ead7b7ccf9b3106b7d339 |
| freew/FreeW.App.Avalonia/DesignDialogs.cs | aab998b94553b026a453fb98b20a7696c9d076f951068f7bff9665706ef603ee |
| freew/FreeW.App.Avalonia/MainWindow.cs | c3011fb86875cb23db719ad4250c0ee1f77b4d95b0633a4b1fd305fcf094a4c9 |
| freew/FreeW.App.Avalonia/PageLayoutDialogs.cs | 3e55df38e14195fa702b81bcd1b0829ec19d1f37d1d62235b8ead92cfba07ff0 |
| freew/FreeW.App.Avalonia/Ribbon/FreeWAvaloniaRibbonCommands.cs | 8b7348a396c3f999bc46ed016992acdfe7eb58a9bd54d0d46def27a90c10c219 |
| freew/FreeW.App.Host.Tests/DesignDialogParitySourceTests.cs | b7d44ab89cbb6759c684779b9cece1227edef88e1c7d767760d431c4d6f5b477 |
| freew/FreeW.App.Host.Tests/DocumentEffectRenderingTests.cs | c1f3bab8bc21ebd264b851911c3dcdcf256dc2fdfc735c97ed2ca5a6da9df4b1 |
| freew/FreeW.App.Host/BordersAndShadingDialog.cs | cd6e4794bcaa98dc896eed354313616c4107941eba8e0b323d91a39cb03c57fb |
| freew/FreeW.App.Host/CustomizeThemeColorsDialog.cs | c8a79a343aa69c072c6ce635257344461118d1de0c0d62f330c100ba4163636b |
| freew/FreeW.App.Host/CustomizeThemeFontsDialog.cs | 0d546d0c86b73feadf41d4c960af5709e925f201da988958891c6561c9de4882 |
| freew/FreeW.App.Host/CustomParagraphSpacingDialog.cs | 05c777b3ed1e0e92f549b7e2544c3917f964e2f5a6b16ca253e34a454c5cbd46 |
| freew/FreeW.App.Host/Ribbon/FreeWRibbonCommands.cs | 45e103b0e0a46207a17332ecdae691b42e91c5a77f90e9ffd69e0c008ff8f053 |
| freew/FreeW.App.Host/Ribbon/ThemeGallery.cs | 8eaed62cc2cf21a9cff500336a047fbfd600798da7f4f12ef48de18cbae73eb9 |
| freew/FreeW.App.Host/WatermarkOptionsDialog.cs | b99ad62827ea8155fec222ce9122b6e151af4b09ad8cd3bb56294ad3629d0f61 |
| freew/FreeW.App.Presentation.Tests/BordersAndShadingDialogPlannerTests.cs | e85f8ac331d7bf80f99de76f6935b5b600cf6d85cb27ac4ee4ab397a381e1abf |
| freew/FreeW.App.Presentation.Tests/DesignDialogPlannerTests.cs | fa8a1a51951b85b649e4434d45ff748e8e88d906c760f38478605c30c87997ae |
| freew/FreeW.App.Presentation/Dialogs/BordersAndShadingDialogPlanner.cs | b3bacdce6d02f237d7f15d4622039991df218c18802e1e6cde729b5174f7ec9a |
| freew/FreeW.Ribbon.Definitions/FreeWCanonicalRibbonTabs.Contextual.cs | 10e64c94c8fee84909970b8d92667d1f78e32066ce152cc0d014cfdcb9a5d14b |
| freew/FreeW.Ribbon.Definitions/FreeWCanonicalRibbonTabs.cs | 1559fe48da3e2833385382305c1a9c9496793d6d21ac7f876a2dd4657f5bb8c3 |
| freew/FreeW.Ribbon.Definitions/FreeWCanonicalRibbonTabs.Ordinary.cs | dbf23c199faa9985c14b591e2a8f1fb8ff27e936a969976c347923f2c9076042 |
| freew/FreeW.Ribbon.Definitions/FreeWRibbon.cs | b677dc00c1f57487b84bbfa8f62bb2936c3d880094bb8df15df4adf1559266e9 |
