# FreeW Shell Platform Parity

Generated from WPF authority, Avalonia adapters, shared contracts, and focused-test source hashes. Run `tools/Generate-FreeWShellPlatformParityEvidence.ps1 -Check` to verify freshness.

- Schema: `freex.freew.shell-platform-parity.v1`
- Authority: FreeW WPF native PrintDialog/XpsDocumentWriter behavior, supplemented by the existing Avalonia shared PDF draw-op contract
- Owned shell/UI wiring is complete; only external printer availability and the WPF-only XPS boundary remain platform-dependent.

## Capability Matrix

| Surface | Status | Implementation | Focused evidence |
|---|---|---|---|
| WPF native printing | implemented | Preserved unchanged; evidence hashes the authoritative source. | Existing WPF host print/paginator tests remain the authority. |
| WPF native XPS | implemented | Preserved unchanged; it writes a real FixedDocumentSequence OPC package on STA. | Existing FreeW.App.Host.Tests.XpsExportTests cover package/page output. |
| Linux/macOS printer discovery | implemented | CupsPrintService with injected IProcessRunner and explicit no-printer/unavailable/failed/cancelled results. | CupsPrintServiceTests parse printers/default and cancellation. |
| Linux/macOS PDF submission | implemented | CupsPrintCommandPlanner plus CupsPrintService; arguments use ProcessStartInfo.ArgumentList, never a shell command string. | CupsPrintServiceTests assert exact lp arguments and no-printer short circuit. |
| Avalonia native print lifecycle | implemented | IPlatformPrintService is the non-WPF platform boundary. MainWindow routes supported Backstage print commands through injected discovery/dialog/submission services, cancels in-flight work on close, and restores prior focus. | PrintLifecycleTests cover capability gating, command routing, cancellation, and focus restoration; CupsPrintServiceTests cover CUPS cancellation and injected process behavior. |
| Avalonia XPS export route | not-exposed-platform-limitation | Backstage ExportXps is omitted from Avalonia. The portable writer remains available as shared/internal code and is not presented as an Avalonia platform capability. | BackstageViewTests assert the Avalonia XPS callback is absent; WPF XpsExportTests remain the authority for XPS output. |

## Exact UI Wiring Gaps

| File | Gap for integration pass |
|---|---|
| None | No owned shell/UI wiring gaps remain. |

## XPS Boundary

XPS remains WPF-only at the application surface. Avalonia does not expose an XPS export action because the native XPS stack is Windows/WPF-specific; the portable writer is retained as shared/internal code and is not a claim of Avalonia parity.

The shared writer can emit a real OPC package with `FixedDocSeq.fdseq`, `FixedDocument.fdoc`, and `.fpage` parts for representable vector content, but this does not make XPS an Avalonia application capability. It does not write PDF bytes with an XPS extension.

## Freshness

The JSON records SHA-256 hashes for every authority, implementation, shared contract, and focused-test input. `-Check` regenerates both artifacts in memory and fails if either committed artifact differs.
