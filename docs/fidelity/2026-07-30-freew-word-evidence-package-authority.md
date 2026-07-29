# Word Evidence Package Authority

## Problem

`Run-FreeWWordBaselineEvidence.ps1` generated the DOCX corpus and correctly
rendered its WPF composite from that corpus. Its Avalonia PageLayoutShot call,
however, used the in-memory visual-evidence factories instead of the generated
DOCX files. A Word baseline therefore represented serialized package semantics
while Avalonia could represent richer, unsaved model metadata.

The difference was material for `wordart-watermark-stress`: the generated
package has a noncanonical VML text-path payload. Word suppresses that payload
on its PDF/live surface and the DOCX reader marks it non-paintable, while the
factory model would still paint a large central `CONFIDENTIAL` watermark.

## Correction

The runner now supplies its generated `$fixtureDir` through
`--fixtures-dir` to `FreeW.PageLayoutShot`. Both renderer artifacts and Word
now consume the same serialized DOCX corpus.

## Evidence

Using the existing validated 816x1056 Word PNG and the generated
`wordart-watermark-stress.docx`:

- factory-backed Avalonia capture painted the non-Word-visible central VML text;
- package-backed Avalonia capture correctly suppressed that text;
- the latter reduced the invalid whole-page comparison from approximately
  `7.49%` to `4.49%` and isolates the remaining WordArt/banner and host glyph
  rasterization residuals.

This is a comparison-authority correction, not a claim that the remaining
`4.49%` visual gap is resolved.

## Verification

- PowerShell parser: 0 errors for `Run-FreeWWordBaselineEvidence.ps1`.
- `VisualEvidenceRunnerScriptTests`: 8 passed, 0 failed.
