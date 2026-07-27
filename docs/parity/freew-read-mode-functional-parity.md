# FreeW Read Mode Functional Parity

## Slice

This slice closes the local WPF-over-Avalonia Read Mode workflow gap. It is functional parity evidence, not a claim of pixel-identical rendering.

## WPF authority

`freew/FreeW.App.Host/MainWindow.cs` toggles a distraction-free presentation surface. Entering Read Mode hides the title bar, ribbon, data-folder status item, view-switch status item, zoom status item, navigation pane, Reveal Formatting pane, and Reviewing pane. It saves and restores the editor margin, maximum width, alignment, width, effect, background, and each hidden surface's prior visibility. The read column is 560, 760, or 1024 pixels for Narrow, Default, or Wide. Page color is None/white, Sepia `#F0E0C0`, or Inverse `#1E1E1E`. The editor view mode itself is unchanged.

## Avalonia implementation

`freew/FreeW.App.Avalonia/MainWindow.cs` now follows the same lifecycle and restores the prior title/ribbon/status/pane visibility and editor max width, margin, alignment, transient background, and workspace background. Avalonia's `DocumentView` uses a transient `ViewBackgroundColorHex` for the Read Mode surface; it does not modify the document's persisted page color or undo state.

`freew/FreeW.App.Presentation/Shell/FreeWReadModePlanner.cs` owns the shared token vocabulary, dimensions, normalization, and color values. Both hosts consume it. Avalonia ribbon registrations and View > Views menu routes are in `freew/FreeW.App.Avalonia/Ribbon/FreeWAvaloniaRibbonCommands.cs` and `freew/FreeW.Ribbon.Definitions/FreeWAvaloniaRibbonDefinition.cs`.

## Proof

- `FreeW.App.Host.Tests.PageViewModesTests.ReadMode_AuthorityTogglesChromeOptionsAndRestoresPresentation` runs the real WPF host on STA, including a mixed pre-hidden pane state.
- `FreeW.App.Avalonia.Tests.ReadModeParityTests.ReadMode_MatchesWpfAuthorityAndDoesNotMutateDocumentState` runs the Avalonia headless host, checks the same mixed pane restoration, unchanged view mode, transient color cleanup, and unchanged document page color.
- `FreeW.App.Avalonia.Tests.ReadModeParityTests.ReadModeRibbonCommands_ExposeSharedOptionsAndStatefulToggle` executes the Avalonia option commands and verifies the checked state.
- `FreeW.App.Presentation.Tests.FreeWReadModePlannerTests` verifies the shared authority values and token normalization.

The gap was reproduced from local source and local runtime tests: WPF had the full chrome/pane lifecycle and seven Read Mode routes, while Avalonia had only a status-bar toggle and a fixed-width implementation. No external baseline, Word COM behavior, hardware, or raster comparison is involved.

## Host-native residual

WPF additionally saves/restores `DocumentView.Width` and `Effect` because its editor applies page sizing and a WPF drop shadow. Avalonia's `DocumentView` has no corresponding Width/Effect presentation state in this lifecycle, so it restores the Avalonia-native max width, margin, alignment, transient view background, and workspace background instead. This is an explicit host-native difference, not a visual identity claim.
