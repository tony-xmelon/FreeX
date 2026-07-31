# FreeX Avalonia parity wave 81

## Keyboard print workflow

WPF's canonical `Ctrl+P` and `Ctrl+Shift+F12` workbook routes open the Backstage Print pane first. The Avalonia shared workbook dispatcher previously opened the standalone Print Preview window directly, skipping the pane's Preview and Print actions.

Avalonia now enters its live Backstage Print pane through the same keyboard route. The pane keeps the existing preview and printer/PDF actions intact, while direct native-menu Print Preview remains a direct preview workflow.

Focused regression coverage is in `AvaloniaLegacyShortcutSequenceTests.CtrlP_EntersBackstagePrintPaneBeforeChoosingPreviewOrPrint` and the shared-route source contract in `AvaloniaMainWindowChromeSourceTests`.
