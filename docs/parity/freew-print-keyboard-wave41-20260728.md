# FreeW Print Keyboard Parity Wave 41

Date: 2026-07-28

## Closed Functional Mismatch

The shared `FreeWKeyboardShortcutCatalog` maps `Ctrl+P` to
`FreeWKeyboardCommand.PrintDocument`. WPF dispatches that command to `Print()`,
which opens the printer selection workflow and submits the page-settings-aware
document paginator. Avalonia incorrectly dispatched the same command to
`OpenPrintPreviewAsync()`, so `Ctrl+P` could never enter the already-backed CUPS
printer-selection and submission path.

Avalonia now dispatches `PrintDocument` to `PrintAsync()`. Print Preview remains
available through its separate View/ribbon command. The existing injected
`IPlatformPrintService` and `CupsPrintDialog` provide the Linux host boundary;
no WPF-specific printing API was copied into the portable layer.

## Evidence

- Shared catalog test: **1 new assertion passed**; the catalog remains the
  authority for `Ctrl+P`.
- WPF authority test: **1/1 passed**; WPF retains the direct `Print()` route.
- Avalonia lifecycle test: **1/1 passed**; synthetic `Ctrl+P` reaches the
  injected printer-selection callback and does not open preview.
- Existing Avalonia print lifecycle, CUPS service, and presentation print
  planner tests remain covered in the focused run.

## Residuals

- Physical CUPS printing remains environment-dependent; the Docker harness has
  no configured printer, so real spooler submission is still validated through
  the injected service rather than hardware.
- WPF and Avalonia print-renderer pixel fidelity remains a separate visual
  evidence task.
