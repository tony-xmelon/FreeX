# FreeW Visible Word Export Stability - 2026-07-17

## Result

The generated FreeW corpus was regenerated on the Word-capable host and
published through the visible Word `Publish as PDF or XPS` workflow. Microsoft
Word opened and exported all 30 DOCX fixtures successfully, producing
5,818,012 PDF bytes and 63 rasterized Word PNG pages.

This includes the previously rejected drawing, WordArt, object-format,
float-wrap, chart, and SmartArt fixtures. The historical four DOCX-open
failures are therefore resolved.

## Exporter Repair

`Export-WordPdfsVisible.ps1` starts a short-lived PowerShell helper only to
invoke Word's `FileSaveAsPdfOrXps` command. Windows can dispose that helper's
process handle immediately after it exits. The exporter previously queried
`Process.HasExited` after `Wait-Process`; that race marked an already-created
PDF as failed.

Cleanup now targets only the exact helper PID through `Get-Process` when it is
still present. PDF creation remains the successful-export condition.

## Comparison Boundary

The real Word baseline was rasterized successfully. The combined strict
summary still exits nonzero because several `PageLayoutShot` scenarios are
synthetic surfaces with different physical dimensions from their generated
DOCX counterparts. Those rows are valid evidence-runner alignment work, not
Word-open or Word-export failures, and must not be interpreted as package
compatibility regressions.

## Verification

- `powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools/Test-ToolScripts.ps1`
- `powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools/Run-FreeWWordBaselineEvidence.ps1 -RunRoot freew-fidelity-corpus/runs/word-baseline-evidence-20260717 -UseVisibleWordPublish -SkipEvidenceRender -MaxPagesPerDocument 3`

The latter reports 30/30 visible Word PDF exports and 63 Word baseline PNGs;
its final nonzero status records strict renderer deltas rather than an export
failure.
