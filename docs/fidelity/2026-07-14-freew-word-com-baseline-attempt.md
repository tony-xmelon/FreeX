# FreeW Word COM Baseline Attempt - 2026-07-14

## Goal

Take over the FreeW visual parity Word-baseline lane on the Windows machine with Microsoft Word installed, generate real Word PNG baselines for the generated FreeW visual evidence corpus, and feed them into the shared `FreeW.VisualEvidenceSummary` comparison contract.

## Run

Worktree: `C:\Users\ali\Documents\GitHub\FreeX\.worktrees\freew-word-com-baseline-20260714`

Run root: `freew-fidelity-corpus\runs\word-com-baseline-20260714` (ignored)

Command attempted:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\Run-FreeWWordBaselineEvidence.ps1 -RunRoot freew-fidelity-corpus\runs\word-com-baseline-20260714
```

The run completed the generated corpus and FreeW renderer evidence before reaching Word export:

| Artifact | Count |
| --- | ---: |
| Generated DOCX fixtures | 29 |
| WPF PNG outputs | 45 |
| Avalonia PNG outputs | 43 |
| Word PDFs | 0 |
| Word baseline PNGs | 0 |

The fallback summary was then written explicitly with a Word-baseline-unavailable reason:

```powershell
dotnet run --project freew\tools\FreeW.VisualEvidenceSummary\FreeW.VisualEvidenceSummary.csproj --configuration Release -- --run-root C:\Users\ali\Documents\GitHub\FreeX\.worktrees\freew-word-com-baseline-20260714\freew-fidelity-corpus\runs\word-com-baseline-20260714 --manifest C:\Users\ali\Documents\GitHub\FreeX\.worktrees\freew-word-com-baseline-20260714\freew-fidelity-corpus\runs\word-com-baseline-20260714\wpf\freew_visual_evidence_manifest.json --manifest C:\Users\ali\Documents\GitHub\FreeX\.worktrees\freew-word-com-baseline-20260714\freew-fidelity-corpus\runs\word-com-baseline-20260714\avalonia\freew_visual_evidence_manifest.json --word-baseline-scope generated-corpus --baseline-tolerance word-png-default --allow-no-word-fallback-evidence --word-baseline-unavailable-reason "Word.Application COM is registered (Microsoft Word 16.0.20131), but Documents.Open/ExportAsFixedFormat hung before emitting a PDF from Codex shell, scheduled /IT task, and powershell -STA one-document probes on 2026-07-14." --output-json C:\Users\ali\Documents\GitHub\FreeX\.worktrees\freew-word-com-baseline-20260714\freew-fidelity-corpus\runs\word-com-baseline-20260714\freew_visual_evidence_summary.json --output-md C:\Users\ali\Documents\GitHub\FreeX\.worktrees\freew-word-com-baseline-20260714\freew-fidelity-corpus\runs\word-com-baseline-20260714\freew_visual_evidence_summary.md
```

Summary result:

| Metric | Value |
| --- | ---: |
| Trust | passed |
| Evidence rows | 88 |
| Baseline comparisons | 88 |
| Real Word compared | 0 |
| Word unavailable | 85 |
| Skipped/unmapped | 3 |

## Word COM Findings

Microsoft Word is installed and COM registration is present:

```json
{"Version":"16.0","Build":"16.0.20131","Name":"Microsoft Word"}
```

However, fixed-format export did not complete in this Codex automation context:

- `tools\Run-FreeWWordBaselineEvidence.ps1` reached `tools\FreeW.RenderCompare\Export-WordPdfs.ps1` and left `word-pdf\_progress.log` at only the `start` line for more than 30 minutes.
- A direct one-fixture probe using `Render-WordBaseline.ps1` hung before producing a PDF or PNG.
- The same one-fixture probe launched as an interactive scheduled task with `/IT` also hung with zero output.
- A `powershell.exe -STA` one-fixture probe also hung with zero output.
- A brand-new one-line Word document created through COM also hung on `ExportAsFixedFormat`, so the blocker is not specific to the generated DOCX fixtures.

Owned `WINWORD.EXE` and PowerShell child processes from these probes were stopped by PID after each timeout. No repository source files were modified by the generated run; bulky outputs remain under ignored `freew-fidelity-corpus\runs\`.

## Resume Notes

## Retry - Word UI Export Path

After Word was opened interactively and confirmed functional, direct COM `ExportAsFixedFormat` still did not visibly drive Word and continued to hang. A visible COM ping did work: Codex could attach to the running `Word.Application`, activate Word, and type into the open scratch document. The working export route was therefore:

1. Open each generated fixture in the running Word instance.
2. Invoke Word's built-in `FileSaveAsPdfOrXps` command.
3. Drive the visible `Publish as PDF or XPS` dialog.
4. Move the generated PDF into `word-pdf`.
5. Rasterize each PDF with `FreeW.PdfRasterize`.

Retry output under `freew-fidelity-corpus\runs\word-com-baseline-20260714`:

| Artifact | Count |
| --- | ---: |
| Generated DOCX fixtures | 29 |
| Word PDFs generated through UI publish | 25 |
| Word baseline PNGs rasterized | 59 |
| Word-open failures | 4 |

The four fixtures Word still rejected, even with `OpenAndRepair`, were:

- `drawing-objects-complex.docx`
- `object-format-position-size-style.docx`
- `wordart-picture-watermark-layout.docx`
- `wordart-watermark-stress.docx`

`chart-smartart-complex.docx` also failed normal Word open, but `OpenAndRepair` produced a repaired document that could be published to PDF through the visible dialog.

The real-Word summary was written to:

- `freew-fidelity-corpus\runs\word-com-baseline-20260714\freew_visual_evidence_summary.real-word.json`
- `freew-fidelity-corpus\runs\word-com-baseline-20260714\freew_visual_evidence_summary.real-word.md`

Summary result:

| Metric | Value |
| --- | ---: |
| Trust | failed |
| Evidence rows | 88 |
| Baseline comparisons | 88 |
| Failed comparisons | 75 |
| Missing baseline rows | 10 |
| Skipped/unmapped rows | 3 |

The failed summary is expected useful evidence, not an export failure: it records actual Word PNG baseline mismatches and the remaining Word-rejected fixture gaps. The current summary authority is `word-baseline-missing`, not `word-baseline-unavailable`.

The next pass should focus on making Word fixed-format export complete on this machine before rerunning the full baseline:

1. Promote or formalize the visible-dialog export workaround if direct `ExportAsFixedFormat` remains unreliable from Codex automation.
2. Fix or regenerate the four Word-rejected fixtures so Microsoft Word can open them, or mark them as non-Word-comparable in the evidence contract.
3. Revisit the `word-png-default` comparison tolerance and page-size normalization: many real Word baselines are 816x1056 while Avalonia evidence is emitted at larger page surfaces such as 960x1200, 960x1400, or 960x1800.
4. Rerun the summary after fixture and normalization work; expect a failing trust result until the renderer deltas are intentionally triaged or fixed.
