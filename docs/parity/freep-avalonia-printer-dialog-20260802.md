# FreeP Avalonia Windows Printer Dialog

FreeP's Avalonia Windows host now exposes the native Windows printer-selection dialog in the
Print pane. Queue enumeration and PDF submission remain on the existing adapter path; the dialog
only selects a queue and feeds it through the same capability validation used by the existing
printer picker.

The portable/Linux path is unchanged. On Windows, the print host now advertises native dialog
availability and exposes the `FreePWindowsPrinterDialog` automation surface alongside the queue
picker.
