# FreeW Media Dialog Parity Inventory

Generated: 2026-07-20T05:23:03.0966421Z

Routes: 14 | Shell-wired: 6 | Shell follow-ups: 8

| Route | WPF authority | Avalonia surface | Status | Follow-up |
|---|---|---|---|---|
| Picture adjust | `ImageAdjustDialog.cs` | `MediaDialogParity.cs` | implemented-awaiting-shell-wiring | Wire freew.image-adjust-dialog in the Avalonia command callback; shell-owned. |
| Picture border | `ImageBorderDialog.cs` | `PictureFormattingDialogs.cs` | implemented-and-wired |  |
| Picture crop | `ImageCropDialog.cs` | `ImageAndTableConversionDialogs.cs` | implemented-and-wired |  |
| Picture position | `ImagePositionDialog.cs` | `MediaDialogParity.cs` | implemented-awaiting-shell-wiring | Wire freew.image-position in the Avalonia command callback; shell-owned. |
| Picture size | `ImageSizeDialog.cs` | `PictureFormattingDialogs.cs` | implemented-and-wired |  |
| Image Alt Text | `Ribbon/FreeWRibbonCommands.cs` | `PictureFormattingDialogs.cs` | implemented-and-wired | Keep the existing WPF TextPrompt and Avalonia ImageAltTextDialog launchers under shell ownership. |
| Image/table conversion | `Ribbon/FreeWRibbonCommands.cs` | `ImageAndTableConversionDialogs.cs` | implemented-and-wired | Keep the existing Avalonia conversion launchers under MainWindow ownership. |
| Insert Chart | `InsertChartDialog.cs` | `MediaDialogParity.cs` | implemented-awaiting-shell-wiring | Add the Avalonia Insert Chart callback and result application in shell-owned files. |
| Chart title | `ChartTitleDialog.cs` | `MediaDialogParity.cs` | implemented-awaiting-shell-wiring | Add the Avalonia chart-title callback and result application in shell-owned files. |
| Chart axis titles | `ChartAxisTitlesDialog.cs` | `MediaDialogParity.cs` | implemented-awaiting-shell-wiring | Add the Avalonia axis-title callback and result application in shell-owned files. |
| Chart size | `ChartSizeDialog.cs` | `MediaDialogParity.cs` | implemented-awaiting-shell-wiring | Add the Avalonia chart-size callback and result application in shell-owned files. |
| Insert SmartArt | `InsertSmartArtDialog.cs` | `MediaDialogParity.cs` | implemented-awaiting-shell-wiring | Add the Avalonia Insert SmartArt callback and result application in shell-owned files. |
| SmartArt edit text | `InsertSmartArtDialog.cs` | `SmartArtEditDialog.cs` | implemented-and-wired |  |
| Icon picker | `IconPickerDialog.cs` | `IconPickerDialog.cs` | selection-surface-only | Wire the picker in shell-owned files and provide the platform rasterizer/result application; Avalonia currently returns IconPickerSelection. |

Ownership boundary: this inventory intentionally records shell-owned wiring gaps without changing MainWindow, ribbon, Backstage, page-layout, or shared-shell files.

Run ``powershell -File tools/Generate-FreeWMediaDialogParityEvidence.ps1 -Check`` to verify source fingerprints are fresh.
