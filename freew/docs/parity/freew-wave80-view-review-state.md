# FreeW Wave 80: View and Review Toggle State

WPF authority: `FreeW.App.Host/MainWindow.cs` passes live predicates for Print Layout, Web Layout, Draft, Navigation Pane, Reveal Formatting, and Reviewing Pane. The WPF ribbon therefore updates each command's checked state after the command changes the shell.

Before this slice, Avalonia registered the same visible commands as `ActionRibbonCommand`, so they executed but exposed no checked state. Avalonia now uses the shared `ToggleActionCommand` path and `RibbonHostCallbacks` carries live predicates backed by `DocumentView.ViewMode` and the actual pane visibility. The canonical and legacy navigation/layout command ids share the same stateful command instance where applicable.

Focused coverage verifies both detached registry callbacks and a production `MainWindow` lifecycle: switching view modes clears the previous check, and opening each pane immediately reports checked state.

Residuals: this note covers toggle state synchronization only. Visual layout differences in the panes and view-mode surfaces remain separate parity work.
