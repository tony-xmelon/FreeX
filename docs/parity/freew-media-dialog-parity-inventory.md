# FreeW Media Dialog Parity Inventory

Generated: 2026-08-27T16:52:35.3848192Z

Routes: 14 | Shell-wired: 14 | Shell follow-ups: 0

| Route | WPF authority | Avalonia surface | Status | Follow-up |
|---|---|---|---|---|
| Picture adjust | `ImageAdjustDialog.cs` | `MediaDialogParity.cs` | implemented-and-wired |  |
| Picture border | `ImageBorderDialog.cs` | `PictureFormattingDialogs.cs` | implemented-and-wired |  |
| Picture crop | `ImageCropDialog.cs` | `ImageAndTableConversionDialogs.cs` | implemented-and-wired |  |
| Picture position | `ImagePositionDialog.cs` | `MediaDialogParity.cs` | implemented-and-wired |  |
| Picture size | `ImageSizeDialog.cs` | `PictureFormattingDialogs.cs` | implemented-and-wired |  |
| Image Alt Text | `Ribbon/FreeWRibbonCommands.cs` | `PictureFormattingDialogs.cs` | implemented-and-wired | Keep the existing WPF TextPrompt and Avalonia ImageAltTextDialog launchers under shell ownership. |
| Image/table conversion | `Ribbon/FreeWRibbonCommands.cs` | `ImageAndTableConversionDialogs.cs` | implemented-and-wired | Keep the existing Avalonia conversion launchers under MainWindow ownership. |
| Insert Chart | `InsertChartDialog.cs` | `MediaDialogParity.cs` | implemented-and-wired |  |
| Chart title | `ChartTitleDialog.cs` | `MediaDialogParity.cs` | implemented-and-wired |  |
| Chart axis titles | `ChartAxisTitlesDialog.cs` | `MediaDialogParity.cs` | implemented-and-wired |  |
| Chart size | `ChartSizeDialog.cs` | `MediaDialogParity.cs` | implemented-and-wired |  |
| Insert SmartArt | `InsertSmartArtDialog.cs` | `MediaDialogParity.cs` | implemented-and-wired |  |
| SmartArt edit text | `InsertSmartArtDialog.cs` | `SmartArtEditDialog.cs` | implemented-and-wired |  |
| Icon picker | `IconPickerDialog.cs` | `IconPickerDialog.cs` | implemented-and-wired |  |

Ownership boundary: MainWindow, ribbon, Backstage, page-layout, and shared-shell routes are included in the completed integration.

Run ``powershell -File tools/Generate-FreeWMediaDialogParityEvidence.ps1 -Check`` to verify source fingerprints are fresh.
