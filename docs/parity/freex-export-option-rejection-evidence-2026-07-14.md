# FreeX Export Option Rejection Evidence - 2026-07-14

Scope: bounded FreeX print/export parity slice after `PrintExportDrawingEvidencePlanner`. This evidence is host-neutral and avoids FreeW, FreeP, Linux visual capture lanes, native dialog automation, and final renderer changes.

## Evidence Added

- `ExportPublishOptionEvidencePlanner` summarizes the shared export-publish rejection contract reached by both WPF and Avalonia before native PDF/XPS painting.
- Focused tests prove rendered page-range validation rejects empty output, starts after the rendered page count, and ends after the rendered page count.
- Focused tests prove unsupported PDF/A and tagged-PDF publish requests are rejected for PDF instead of silently emitting a normal PDF.
- Focused tests prove XPS export clears PDF-only choices before execution: minimum-size quality, bookmarks, initial view, open mode, bitmap text, PDF language, PDF/A, and tagged-PDF flags do not leak into XPS output.

## Remaining Gaps

- Final PDF/XPS vector graphics remain partial; current proof is option/rejection evidence, not a vector-rendering claim.
- Native foreground file/print/export continuation and focus-return evidence remains open for both hosts.
- Full chart text export breadth remains open beyond the existing printed-page drawing evidence.
