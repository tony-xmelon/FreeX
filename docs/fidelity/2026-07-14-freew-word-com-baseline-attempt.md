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

## Follow-up - DOCX Schema Fix and Full Word UI Export

After the DOCX schema fix branch was rebased onto current `origin/main`, the generated corpus was refreshed under the same ignored run root with:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\Run-FreeWWordBaselineEvidence.ps1 -RunRoot freew-fidelity-corpus\runs\word-com-baseline-20260714 -NoWord
```

That refresh generated 30 DOCX fixtures and 89 baseline comparison rows. The four previously Word-rejected drawing/WordArt/object-format fixtures now pass the Open XML schema guard and opened/published in Microsoft Word. The current `main` corpus also added `f2-01-float-wrap.docx`; Word rejected it until `wp:wrapTight` was fixed to include the required rectangular `wp:wrapPolygon`.

The visible Word UI publish workaround then exported every refreshed fixture:

| Artifact | Count |
| --- | ---: |
| Generated DOCX fixtures | 30 |
| Word PDFs generated through UI publish | 30 |
| Word baseline PNGs rasterized | 64 |
| Word-open failures | 0 |

The refreshed real-Word summary was written to:

- `freew-fidelity-corpus\runs\word-com-baseline-20260714\freew_visual_evidence_summary.real-word.json`
- `freew-fidelity-corpus\runs\word-com-baseline-20260714\freew_visual_evidence_summary.real-word.md`

Summary result:

| Metric | Value |
| --- | ---: |
| Trust | failed |
| Evidence rows | 89 |
| Baseline comparisons | 89 |
| Failed comparisons | 85 |
| Missing baseline rows | 1 |
| Skipped/unmapped rows | 3 |

The remaining missing baseline is `f2-endnotes_p3`: the Avalonia evidence emits a third page, while Microsoft Word produced a two-page PDF for that fixture. The other failures are comparison/tolerance or page-geometry deltas, plus WPF software-renderer trust failures for backstage rows. They are no longer DOCX-open/export blockers.

The visible-dialog exporter is now formalized through `tools\FreeW.RenderCompare\Export-WordPdfsVisible.ps1` and the `tools\Run-FreeWWordBaselineEvidence.ps1 -UseVisibleWordPublish` switch. A wrapper verification with `-SkipEvidenceRender -UseVisibleWordPublish` exported all 30 PDFs and rasterized Word baselines through the supported path, then exited nonzero only when `FreeW.VisualEvidenceSummary` reported the known failing real-Word comparison trust. Direct `ExportAsFixedFormat` still remains useful to fix later, but the Word-capable baseline lane no longer depends on an ignored scratch script.

Next work should focus on triaging renderer/page-size/page-count deltas from the real Word summary.

## Follow-up - Endnote Page-Count Normalization

The first real Word summary left one false missing-baseline blocker: `f2-endnotes_p3`. Microsoft Word and the WPF proof should both expose `f2-endnotes` as two comparable pages, with page 2 carrying final-body-page endnote evidence. The Avalonia PageLayoutShot path and WPF composite renderer now follow that two-page contract instead of appending a Word-incomparable third PNG.

Focused verification:

```powershell
dotnet test freew\FreeW.App.Presentation.Tests\FreeW.App.Presentation.Tests.csproj --configuration Release --filter "FullyQualifiedName~VisualEvidencePlannerTests|FullyQualifiedName~VisualEvidenceRunnerScriptTests|FullyQualifiedName~VisualEvidenceBaselinePolicyTests"
dotnet build freew\tools\FreeW.FidelityRender\FreeW.FidelityRender.csproj --configuration Release
powershell.exe -NoProfile -ExecutionPolicy Bypass -File freew-fidelity-corpus\tools\Run-FreeWVisualEvidence.ps1 -OutDir freew-fidelity-corpus\runs\note-placement-word-baseline-20260715 -ScenarioSet NotePlacementVisualProof -WordBaselineDir freew-fidelity-corpus\runs\word-com-baseline-20260714\word-baseline -BaselineTolerance word-png-default
```

The focused evidence run still exits nonzero because the real Word PNG comparisons fail render tolerances, but the false missing-baseline row is gone:

| Metric | Value |
| --- | ---: |
| Note-placement evidence rows | 8 |
| Baseline comparisons | 8 |
| Failed comparisons | 8 |
| Missing baseline rows | 0 |
| `f2-endnotes` WPF outputs | 2/2 |
| `f2-endnotes` Avalonia outputs | 2/2 |

Remaining `f2-endnotes` work is now real render fidelity: WPF page 2 is close but still above tolerance, while Avalonia still needs page-size/page-surface normalization before it is directly comparable to the 816x1056 Word baseline.

## Follow-up - Final-Page Endnote Flow and Page-Surface Capture

The Word PDFs show that the fixture's endnotes follow the final body content on page 2; they are not a separate blank endnote page. The WPF composite renderer now retains both body pages, appends the endnote rule and rows after the final paginator content when they fit, and records the result as normal final-body-page evidence. The shared evidence contract and the evidence-runner check now reject a synthetic endnote page for this Word-comparable fixture.

The same pass corrected WPF's implicit line-spacing interpretation. When DOCX omits `w:spacing/@w:line`, Word uses its natural single-line layout; FreeW no longer forces the model's convenience `1.15` default into WPF. Explicit line-spacing values and styles continue to use the existing natural-line-height calculation. The final WPF pages now have the same line-band count as the Word pages for `f2-endnotes` (30 on p1, 17 including the endnote rule/rows on p2).

Avalonia PageLayoutShot continues to capture the interactive print-layout surface, but the Word-comparable note-placement artifacts now crop the centered white page from that surface before they are compared. This removes the grey desk/chrome from the document-render metric while retaining the ordinary interactive screenshots for other scenarios.

Focused Word-baseline comparison under `freew-fidelity-corpus\runs\note-placement-word-baseline-20260715d` still fails the strict `word-png-default` tolerance, but reports no missing baselines and no Avalonia dimension mismatch:

| Renderer / page | Previous mean delta | Current mean delta | Previous changed pixels | Current changed pixels |
| --- | ---: | ---: | ---: | ---: |
| Avalonia endnotes p1 | 23.8764 | 16.7526 | 28.995 % | 14.019 % |
| Avalonia endnotes p2 | 22.5636 | 11.4280 | 32.741 % | 8.985 % |
| Avalonia footnotes p1 | 24.4580 | 17.9395 | 29.659 % | 15.089 % |
| Avalonia footnotes p2 | 25.0436 | 13.5370 | 34.780 % | 10.739 % |
| WPF endnotes p2 | 6.2729 | 5.9996 | 3.834 % | 4.181 % |
| WPF footnotes p2 | 12.1204 | 6.6974 | 7.136 % | 4.765 % |

The next targeted fixes are the remaining Avalonia page-body pagination offset and note-placement geometry, followed by WPF p1 text/raster differences. The baseline export and schema lane remain healthy: all 30 corpus documents open and export through Word's visible publish path.

## Follow-up - Footnote Body Reservation

The WPF composite renderer was laying out the full body page and then drawing its footnote region over that body. Word reserves the footnote region while it paginates, so the earlier WPF output retained two extra body paragraphs on `f2-footnotes` page 1 and put its separator too close to the physical page edge.

The renderer now probes the PageBox footnote assignment, measures the largest note block, reserves that height in the body paginator's bottom padding, and places the rendered note block above the page's bottom margin. In the live Word comparison fixture, WPF page 1 now ends with `More filler 1`, the same boundary as Word, and page 2 begins with `More filler 2`.

Focused composite evidence was captured under `freew-fidelity-corpus\runs\footnote-reserve-composite-smoke-20260715` and compared against the existing visible-Word baseline. The strict tolerance remains unmet, but the structural correction improved both WPF mean deltas:

| Renderer / page | Previous mean delta | Current mean delta | Previous changed pixels | Current changed pixels |
| --- | ---: | ---: | ---: | ---: |
| WPF footnotes p1 | 17.1389 | 16.8848 | 10.368 % | 10.180 % |
| WPF footnotes p2 | 6.6974 | 6.4723 | 4.765 % | 4.773 % |

The small p2 changed-pixel increase is retained as an honest metric. The next renderer target was Avalonia's Word-comparable page capture, which is corrected in the follow-up below.

## Follow-up - Avalonia Physical Page-Origin Capture

Avalonia's document surface was already paginated, including its per-page footnote reservation. The remaining capture defect was narrower: the Word-comparable crop always began at viewport Y=0, which included the Print Layout desk padding above page 1 and discarded the last 24 DIP of the white page. Page 2 happened to be correct only because its viewport offset started at that physical page's top.

`FreeW.PageLayoutShot` now passes the requested page number and viewport offset into its crop routine and derives the page top from the shared `DocumentViewLayoutPlanner` surface plan. The Word comparator therefore receives the actual 816x1056 paper rectangle for every captured note-placement page, without duplicating Avalonia's desk and inter-page geometry.

Focused comparison under `freew-fidelity-corpus\runs\avalonia-page-origin-word-baseline-20260715` still fails strict `word-png-default`, but improves both affected Avalonia page-one artifacts while leaving page 2 unchanged:

| Renderer / page | Previous mean delta | Current mean delta | Previous changed pixels | Current changed pixels |
| --- | ---: | ---: | ---: | ---: |
| Avalonia endnotes p1 | 16.7526 | 15.7620 | 14.019 % | 11.875 % |
| Avalonia footnotes p1 | 17.9395 | 16.8364 | 15.089 % | 12.859 % |

The next render-fidelity target is actual Avalonia text and note geometry relative to Word, rather than page chrome or a missing physical page boundary.

## Follow-up - Avalonia Default Run and Natural Line Spacing

Avalonia's paragraph layout applied the document's resolved run formatting only when a paragraph had a named style. Ordinary body paragraphs therefore bypassed the DOCX default run and rendered with Avalonia's platform default font instead of the document's Calibri 11pt. It also treated the model's convenience `1.15` line-spacing default as an explicit Word line rule even when the DOCX omitted `w:spacing/@w:line`; Word uses natural single-line height in that case.

The display cascade now always applies document defaults, styles, then direct run formatting, and the natural-line branch matches the existing WPF interpretation. Successful Avalonia captures also no longer add a second shared-plan note overlay over notes that `DocumentView` already rendered; that overlay remains only for the explicit fallback route.

Focused comparison under `freew-fidelity-corpus\runs\avalonia-default-run-word-baseline-20260715` remains outside strict `word-png-default`, but substantially improves every Avalonia Word comparison:

| Renderer / page | Previous mean delta | Current mean delta | Previous changed pixels | Current changed pixels |
| --- | ---: | ---: | ---: | ---: |
| Avalonia endnotes p1 | 15.7620 | 13.9101 | 11.875 % | 10.918 % |
| Avalonia endnotes p2 | 10.6354 | 9.0747 | 8.434 % | 6.880 % |
| Avalonia footnotes p1 | 16.6897 | 14.6441 | 12.743 % | 11.631 % |
| Avalonia footnotes p2 | 13.2723 | 11.1364 | 10.556 % | 8.662 % |

The native page-one body now reaches the second footnote reference, close to Word's final page-one boundary. Remaining work is note-band positioning and glyph-raster fidelity rather than default-format inheritance or omitted line-spacing semantics.

## Follow-up - Avalonia Footnote Bottom-Margin Anchor

Avalonia previously anchored its native footnote band at the footer distance. For the ordinary 36pt footer distance in this fixture, that placed the band 48 DIP too low, in the lower part of the physical bottom margin. Microsoft Word places the band at the body bottom-margin edge, except when a footer begins higher. The native `DocumentView` now uses the earlier of those two bounds and clips only within that usable note region.

The note-render regression test now asserts that the separator and note text do not extend below the body bottom-margin edge, rather than accepting the old footer-distance strip.

Focused verification:

```powershell
dotnet build freew\tools\FreeW.PageLayoutShot\FreeW.PageLayoutShot.csproj --configuration Release --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false
dotnet test freew\FreeW.App.Avalonia.Tests\FreeW.App.Avalonia.Tests.csproj --configuration Release --filter "FullyQualifiedName~DocumentViewHeadlessTests|FullyQualifiedName~VisualEvidencePageLayoutShotSourceTests|FullyQualifiedName~DocumentViewNoteRenderTests" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false
powershell.exe -NoProfile -ExecutionPolicy Bypass -File freew-fidelity-corpus\tools\Run-FreeWVisualEvidence.ps1 -OutDir freew-fidelity-corpus\runs\avalonia-footnote-margin-word-baseline-20260715 -ScenarioSet NotePlacementVisualProof -WordBaselineDir freew-fidelity-corpus\runs\word-com-baseline-20260714\word-baseline -BaselineTolerance word-png-default
```

The build and 46 focused tests pass. The live-Word evidence run deliberately still returns nonzero at the strict `word-png-default` threshold, but has no missing comparison rows. The new Avalonia p1 footnote band is visually aligned with Word's bottom-margin boundary and improves the measured page-one result slightly:

| Renderer / page | Previous mean delta | Current mean delta | Previous changed pixels | Current changed pixels |
| --- | ---: | ---: | ---: | ---: |
| Avalonia footnotes p1 | 14.6441 | 14.5454 | 11.631 % | 11.561 % |

Word still fits `More filler 1` above the note band on page 1, while Avalonia stops after `Filler paragraph 22`; the remaining body-flow difference is one short paragraph. Endnote and page-two metrics are unchanged by this footnote-only placement correction. The next targeted work is Avalonia text measurement/pagination fidelity, followed by glyph-raster differences.
