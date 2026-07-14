# FreeX XPS/Native Print Readiness - 2026-07-14

## Slice

This slice adds a shared, host-neutral readiness contract for FreeX print/export:

- `PrintExportHostReadinessPlanner` builds one combined plan for scope availability, PDF export-print planning, XPS export-print planning, and native-print routing.
- The planner reuses `WorkbookExportScopePlanner`, `WorkbookExportPrintPlanner`, and `PrintJobPlanner`; host glue should not fork workbook/scope/page/copy/range validation.
- Focused tests model the two current FreeX host profiles:
  - WPF/Windows desktop: PDF and XPS are available on the Windows export surface, and native print routes to a native print dialog.
  - Avalonia portable: PDF is available, XPS is explicitly rejected by the same export-print planner, and native print routes through a platform-printer adapter only when a printer destination exists; otherwise it falls back to producing the shared print-ready PDF.

## Evidence

Focused test coverage:

- `PrintExportHostReadinessPlannerTests.Create_WindowsAndAvaloniaUseSameScopeAndPrintJobPlanningSurface`
- `PrintExportHostReadinessPlannerTests.Create_WindowsSurfacePlansXpsAndAvaloniaSurfaceRejectsXpsHonestly`
- `PrintExportHostReadinessPlannerTests.Create_NativePrintReadinessSeparatesNativeDialogPlatformPrinterAndPdfFallback`

These tests prove the shared service contract, not foreground OS-dialog behavior.

## Remaining Gaps

- This does not add a new Avalonia XPS writer.
- This does not prove Microsoft Excel visual parity, Windows `PrintDialog` foreground behavior, printer driver output, or OS XPS viewer parity.
- WPF and Avalonia host code still own their UI adapters; the new planner is the readiness contract they can consume to avoid platform drift.
