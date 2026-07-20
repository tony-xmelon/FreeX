# FreeW Shell Platform Parity

Generated from WPF authority, Avalonia adapters, shared contracts, and focused-test source hashes. Run `tools/Generate-FreeWShellPlatformParityEvidence.ps1 -Check` to verify freshness.

- Schema: `freex.freew.shell-platform-parity.v1`
- Authority: FreeW WPF native PrintDialog/XpsDocumentWriter behavior, supplemented by the existing Avalonia shared PDF draw-op contract
- No owned UI files were edited.

## Capability Matrix

| Surface | Status | Implementation | Focused evidence |
|---|---|---|---|
| WPF native printing | implemented | Preserved unchanged; evidence hashes the authoritative source. | Existing WPF host print/paginator tests remain the authority. |
| WPF native XPS | implemented | Preserved unchanged; it writes a real FixedDocumentSequence OPC package on STA. | Existing FreeW.App.Host.Tests.XpsExportTests cover package/page output. |
| Linux/macOS printer discovery | implemented | CupsPrintService with injected IProcessRunner and explicit no-printer/unavailable/failed/cancelled results. | CupsPrintServiceTests parse printers/default and cancellation. |
| Linux/macOS PDF submission | implemented | CupsPrintCommandPlanner plus CupsPrintService; arguments use ProcessStartInfo.ArgumentList, never a shell command string. | CupsPrintServiceTests assert exact lp arguments and no-printer short circuit. |
| Later Avalonia print dialog contract | implemented-contract | Shared PrintSelection, PrintPageRange, PrinterInfo, PrintDialogPlan, and PrintSelectionPlanner. | PrintSelectionPlannerTests cover requested/default printer, no printers, and validation. |
| Cross-platform XPS | truthful-fixed-layout-only | PortableXpsWriter writes a real OPC XPS package for supported vector operations and analyzes unsupported text/image dependencies; FreeWAvaloniaXpsExport never relabels PDF bytes. | PortableXpsWriterTests validate package parts and prove text fails without an embedded font resource. |

## Exact UI Wiring Gaps

| File | Gap for integration pass |
|---|---|
| `freew/FreeW.App.Avalonia/MainWindow.cs` | Current AvaloniaDirectPrintCapability is Deferred and ExportXps is null in the Backstage callback set; integration must inject CupsPrintService and later dialog selection. |
| `freew/FreeW.App.Avalonia/PrintPreviewDialog.cs` | The existing preview button chooses Print versus Create PDF from BackstageDirectPrintCapability; the integration pass must provide a real direct-print callback and cancellation/error messaging. |
| `freew/FreeW.App.Avalonia/Backstage/BackstageView.cs` | The view already accepts DirectPrintCapability and ExportXps callbacks; integration must supply the new adapter contracts without changing this owned shell UI file. |
| `freew/FreeW.App.Presentation/Backstage/BackstagePaneSurfacePlanner.cs` | Export XPS rows appear only when an ExportXps callback is supplied; the integration pass decides whether the truthful Avalonia capability is exposed after a font-resource provider exists. |
| `freew/FreeW.App.Host/MainWindow.cs` | No gap to wire in this slice: WPF PrintDialog and native XPS behavior remain intact and outside the edit boundary. |

## XPS Boundary

The current Avalonia PdfContentDocument/PdfDrawOp model exposes text strings and positioned draw ops, but no embedded XPS font bytes, font URI, glyph indices, subsetting metadata, or equivalent glyph-outline renderer. A normal text document therefore cannot be truthfully emitted as selectable XPS until that exact dependency is supplied.

The shared writer emits a real OPC package with `FixedDocSeq.fdseq`, `FixedDocument.fdoc`, and `.fpage` parts for representable vector content. It does not write PDF bytes with an XPS extension.

## Freshness

The JSON records SHA-256 hashes for every authority, implementation, shared contract, and focused-test input. `-Check` regenerates both artifacts in memory and fails if either committed artifact differs.
