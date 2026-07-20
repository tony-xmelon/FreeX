# FreeW Shell Platform Parity

Generated from WPF authority, Avalonia adapters, shared contracts, and focused-test source hashes. Run `tools/Generate-FreeWShellPlatformParityEvidence.ps1 -Check` to verify freshness.

- Schema: `freex.freew.shell-platform-parity.v1`
- Authority: FreeW WPF native PrintDialog/XpsDocumentWriter behavior, supplemented by the existing Avalonia shared PDF draw-op contract
- Owned shell/UI wiring is complete; only external printer availability remains host-dependent.

## Capability Matrix

| Surface | Status | Implementation | Focused evidence |
|---|---|---|---|
| WPF native printing | implemented | Preserved unchanged; evidence hashes the authoritative source. | Existing WPF host print/paginator tests remain the authority. |
| WPF native XPS | implemented | Preserved unchanged; it writes a real FixedDocumentSequence OPC package on STA. | Existing FreeW.App.Host.Tests.XpsExportTests cover package/page output. |
| Linux/macOS printer discovery | implemented | CupsPrintService with injected IProcessRunner and explicit no-printer/unavailable/failed/cancelled results. | CupsPrintServiceTests parse printers/default and cancellation. |
| Linux/macOS PDF submission | implemented | CupsPrintCommandPlanner plus CupsPrintService; arguments use ProcessStartInfo.ArgumentList, never a shell command string. | CupsPrintServiceTests assert exact lp arguments and no-printer short circuit. |
| Later Avalonia print dialog contract | implemented | CupsPrintDialog applies PrintSelectionPlanner output and submits the generated PDF through CupsPrintService. | PrintSelectionPlannerTests and CupsPrintServiceTests cover selection, no printers, validation, and submission. |
| Cross-platform XPS | implemented-raster-fallback | PortableXpsWriter writes vector XPS when possible; otherwise Skia renders each laid-out page to PNG and PortableXpsWriter embeds those images in a real OPC XPS package. PDF bytes are never relabeled. | PortableXpsWriterTests validate package parts and unsupported vector text; Avalonia export exercises the raster fallback. |

## Exact UI Wiring Gaps

| File | Gap for integration pass |
|---|---|
| None | No owned shell/UI wiring gaps remain. |

## XPS Boundary

Normal documents use a standards-compliant raster-page fallback when XPS glyph/font resources are unavailable. The fallback is fixed-layout XPS with embedded PNG page images; the vector writer still preserves embedded-font/glyph output when an XpsFontResource is supplied.

The shared writer emits a real OPC package with `FixedDocSeq.fdseq`, `FixedDocument.fdoc`, and `.fpage` parts for representable vector content. It does not write PDF bytes with an XPS extension.

## Freshness

The JSON records SHA-256 hashes for every authority, implementation, shared contract, and focused-test input. `-Check` regenerates both artifacts in memory and fails if either committed artifact differs.
