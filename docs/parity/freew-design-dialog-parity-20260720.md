# FreeW Design Dialog Parity Evidence

Generated at UTC: 2026-08-27T16:52:33.3665100Z
Source commit: `4ada132713ec0feeed6d1e1cf73dc3509c381601`
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
| freew/FreeW.App.Avalonia.Tests/PageLayoutDialogParityTests.cs | a6122e47e2f3240a5180b87b03fe433a5ca6117b434d448f25e994ddcda24b05 |
| freew/FreeW.App.Avalonia.Tests/WatermarkDialogTests.cs | f572794914258192a994e4ea35c1d1e3cbcfe43a198ef7d10a4acff6f5ea743b |
| freew/FreeW.App.Avalonia/DesignDialogParity.cs | d533cdab32cdbf879e721254fa24d34d673d1f6d98223a91b551cfe887de085b |
| freew/FreeW.App.Avalonia/DesignDialogs.cs | aab998b94553b026a453fb98b20a7696c9d076f951068f7bff9665706ef603ee |
| freew/FreeW.App.Avalonia/MainWindow.cs | 7835af2e017c02ef0049a5167085521898fa38facb7f952a19c89686da3ad5a5 |
| freew/FreeW.App.Avalonia/PageLayoutDialogs.cs | 1be79922deda672e3b20285933505a5246e771ce43747bb9e1739f58e72e25fd |
| freew/FreeW.App.Avalonia/Ribbon/FreeWAvaloniaRibbonCommands.cs | 0afe87cd1801254e9c08ea7c8c2f6be986a8828d94a25560a18bc2bb1db4538f |
| freew/FreeW.App.Host.Tests/DesignDialogParitySourceTests.cs | b7d44ab89cbb6759c684779b9cece1227edef88e1c7d767760d431c4d6f5b477 |
| freew/FreeW.App.Host.Tests/DocumentEffectRenderingTests.cs | c1f3bab8bc21ebd264b851911c3dcdcf256dc2fdfc735c97ed2ca5a6da9df4b1 |
| freew/FreeW.App.Host/BordersAndShadingDialog.cs | cd6e4794bcaa98dc896eed354313616c4107941eba8e0b323d91a39cb03c57fb |
| freew/FreeW.App.Host/CustomizeThemeColorsDialog.cs | c8a79a343aa69c072c6ce635257344461118d1de0c0d62f330c100ba4163636b |
| freew/FreeW.App.Host/CustomizeThemeFontsDialog.cs | 0d546d0c86b73feadf41d4c960af5709e925f201da988958891c6561c9de4882 |
| freew/FreeW.App.Host/CustomParagraphSpacingDialog.cs | 05c777b3ed1e0e92f549b7e2544c3917f964e2f5a6b16ca253e34a454c5cbd46 |
| freew/FreeW.App.Host/Ribbon/FreeWRibbonCommands.cs | ed4f780d35e3adc82ffe5332925321cf21f9800a3477e99867cb5a05dae08e73 |
| freew/FreeW.App.Host/Ribbon/ThemeGallery.cs | f2c85834ee84333840d120420d17fa59f8af701190019b2be81d2755dbb9eb17 |
| freew/FreeW.App.Host/WatermarkOptionsDialog.cs | c0d8bcb54f46df40cb0ec152319892797313257eaa8d54851cd1e8704cc1a6a1 |
| freew/FreeW.App.Presentation.Tests/BordersAndShadingDialogPlannerTests.cs | e85f8ac331d7bf80f99de76f6935b5b600cf6d85cb27ac4ee4ab397a381e1abf |
| freew/FreeW.App.Presentation.Tests/DesignDialogPlannerTests.cs | fa8a1a51951b85b649e4434d45ff748e8e88d906c760f38478605c30c87997ae |
| freew/FreeW.App.Presentation/Dialogs/BordersAndShadingDialogPlanner.cs | b3bacdce6d02f237d7f15d4622039991df218c18802e1e6cde729b5174f7ec9a |
| freew/FreeW.Ribbon.Definitions/FreeWCanonicalRibbonTabs.Contextual.cs | 17d19593786591f0eb980b2b0991522898cfc8158fb6aa0d88dda293c2c0eeca |
| freew/FreeW.Ribbon.Definitions/FreeWCanonicalRibbonTabs.cs | fba1e7733a5be2e7257a2f408d5a0e77f38e473b5086da92828996b383b3b27d |
| freew/FreeW.Ribbon.Definitions/FreeWCanonicalRibbonTabs.Ordinary.cs | e68b3af17a13208bde91ad1b345689d68797c1d1e6ad28fbc55d2b1dd4e2ca0c |
| freew/FreeW.Ribbon.Definitions/FreeWRibbon.cs | b677dc00c1f57487b84bbfa8f62bb2936c3d880094bb8df15df4adf1559266e9 |
