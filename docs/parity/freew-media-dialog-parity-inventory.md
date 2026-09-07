# FreeW Media Dialog Parity Inventory

Generated: 2026-09-07T08:19:28.2368049Z

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

This inventory records hand-authored parity findings for the WPF authority and Avalonia surface files named above. Run ``powershell -File tools/Generate-FreeWMediaDialogParityEvidence.ps1 -Check`` to verify the generator still reproduces those declared findings; it does not detect edits to the contents of those files. When a listed source changes, the routes above must be re-verified by hand and this artifact regenerated.
