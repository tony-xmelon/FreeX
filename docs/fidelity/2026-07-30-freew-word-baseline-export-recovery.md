# Word Baseline Export Recovery

## Problem

After the desktop restart, a controlled one-page Word export could create and close Word but return no artifact while its wrapper reported success. The two scripts did not make that state observable: `Export-WordPdf.ps1` allowed COM failures to be non-terminating, and `Render-WordBaseline.ps1` always returned zero after counting a failed document.

## Fix

- `Export-WordPdf.ps1` now uses terminating PowerShell errors.
- `Render-WordBaseline.ps1` exits nonzero whenever its per-document failure count is nonzero.

The existing exporter already uses a short, flat staging path (`C:\Temp\fw-<pid>-<index>.pdf`), so the recovery deliberately retains that path policy.

## Verification

A visible, isolated Word COM run exported `f2-columns.docx` to a 177,623-byte PDF in about nine seconds. `FreeW.PdfRasterize` produced the 816x1056 PNG with SHA-256 `1C61DDA95AC912B515176EDFF928E26352014143061673980284B166CFF3523B`, byte-identical to the surviving Word baseline. The full `Render-WordBaseline.ps1` wrapper then exported and rasterized the same fixture successfully and closed its owned Word process.

Future runs should poll the expected PDF/PNG and wrapper exit state, not use a fixed sleep. Preserve any pre-existing user-owned Word process; the controlled exporter owns and closes only the instance it creates.
