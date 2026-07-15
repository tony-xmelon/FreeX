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

## Follow-up - Avalonia Non-Editable Run Formatting and Body Cadence

The paged Avalonia layout used a plain-text fallback for non-editable paragraphs. That included paragraphs with footnote or endnote references, so their per-run formatting was silently discarded during measurement and placement. In particular, Word's superscript reference markers were measured at full font size even though the renderer drew them at its 0.583 scale.

`DisplayCells` now preserves each run's formatting, revision, comment, and hyperlink information for non-editable paragraphs. Its layout measurement applies the same superscript/subscript scale as rendering. The new regression test creates a footnote-reference run and asserts that its placed width is 0.583 of its otherwise identical body glyph.

The live Word measurements then identified the remaining pagination drift: an unstyled Calibri 11 body paragraph advanced by about 29.71 DIP in Avalonia versus about 28.57 DIP in Word. Avalonia now applies a 0.94 natural-line-height scale only to unstyled or Normal Calibri 11 paragraphs with no explicit line spacing. Named styles, direct font formatting, and explicit line-height rules retain their existing metrics. A second headless regression test fixes this Word-calibrated body cadence.

The native first-page capture now includes `More filler 1` and `More filler 2` above the bottom-margin note band, matching Word's page-one body flow. Focused verification passed:

```powershell
dotnet build freew\FreeW.App.Avalonia.Tests\FreeW.App.Avalonia.Tests.csproj --configuration Release --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false
dotnet test freew\FreeW.App.Avalonia.Tests\FreeW.App.Avalonia.Tests.csproj --configuration Release --no-build --filter "FullyQualifiedName~DocumentViewHeadlessTests|FullyQualifiedName~DocumentViewNoteRenderTests|FullyQualifiedName~VisualEvidencePageLayoutShotSourceTests" --logger "trx;LogFileName=word-body-cadence-tests.trx"
dotnet build freew\tools\FreeW.PageLayoutShot\FreeW.PageLayoutShot.csproj --configuration Release --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false
```

The live COM comparison is recorded at `freew-fidelity-corpus\runs\avalonia-body-cadence-word-baseline-20260715`. It still intentionally fails the strict `word-png-default` threshold, but has no missing rows and improves every Avalonia note-placement artifact from the preceding published baseline:

| Renderer / page | Previous mean delta | Current mean delta | Previous changed pixels | Current changed pixels |
| --- | ---: | ---: | ---: | ---: |
| Avalonia endnotes p1 | 13.9101 | 9.8187 | 10.918 % | 8.862 % |
| Avalonia endnotes p2 | 9.0747 | 3.9535 | 6.880 % | 4.379 % |
| Avalonia footnotes p1 | 14.5454 | 11.0157 | 11.561 % | 9.864 % |
| Avalonia footnotes p2 | 11.1364 | 7.0421 | 8.662 % | 6.344 % |

The remaining delta is principally glyph raster and final note/body geometry rather than a lost body paragraph or an unformatted reference marker.

## Follow-up - Avalonia Footnote Band Spacing

After the body cadence correction, aligned Word and Avalonia page-one bands showed that body rows were within one DIP, but Avalonia compressed two short footnotes into a 16-DIP step. Word uses a 28-DIP step for this fixture: its separator is at row 895, the first note begins at 907, and the second note begins at 935. Avalonia's old band placed those elements at 915, 924, and 940 respectively.

The native footnote renderer now treats the separator-to-first-note gap, inter-note spacing, and trailing reserve as explicit band geometry. The same geometry is used during the pre-layout reservation pass and final rendering, so pagination cannot reclaim the extra note space. The focused note renderer test now verifies a 27-29 DIP vertical advance between two short footnote markers.

The regenerated native capture lands at separator rows 895-896, first-note rows 907-918, and second-note marker/text rows 935/938-949. It also restores the final Word-visible body row on page 2 (`613-625`) rather than ending one line early.

Focused build and test verification passed with 49 tests. Live Word COM evidence at `freew-fidelity-corpus\runs\avalonia-footnote-spacing-word-baseline-20260715` remains outside the strict `word-png-default` threshold but improves the footnote mean deltas:

| Renderer / page | Previous mean delta | Current mean delta | Previous changed pixels | Current changed pixels |
| --- | ---: | ---: | ---: | ---: |
| Avalonia footnotes p1 | 11.0157 | 10.4802 | 9.864 % | 9.453 % |
| Avalonia footnotes p2 | 7.0421 | 6.9432 | 6.344 % | 6.403 % |

The page-two changed-pixel ratio increases by 0.059 points despite its lower mean deltas, an expected raster tradeoff from adding the previously missing final body row. Endnote and WPF artifacts are unchanged by this footnote-only correction.

## Follow-up - Equation Physical-Page Evidence

The equation-structure PageLayoutShot was emitted as the entire 960x1200 Avalonia viewport while the real Word baseline was the physical 816x1056 Letter page. That forced the comparator to report a large, non-rendering dimension mismatch. Equation evidence now takes the same shared page-surface crop as the Word-comparable note scenarios.

The focused PageLayoutShot build and 49 source/layout tests pass. The regenerated Avalonia PNG is 816x1056, matching Word, and the cached real-Word comparison under `freew-fidelity-corpus\runs\equation-structure-word-baseline-20260715` reduces the Avalonia mean delta from 15.5202 to 3.0948 and the changed-pixel ratio from 27.970% to 2.881%.

The strict `word-png-default` threshold still fails: the remaining evidence is a real feature difference. Word lays out the fraction, radical, n-ary operator, matrix, equation array, accents, delimiters, and function application as OfficeMath structures, while Avalonia's current page renderer renders the equation content as flattened inline text. That equation rendering capability is the next functional parity slice; the baseline comparison itself is now geometrically valid.

## Follow-up - Avalonia Structured OfficeMath Layout

Avalonia now carries each non-script OfficeMath visual element through pagination as one atomic layout cell. The cell is measured and drawn from the shared `EquationVisualPlanner` element and slot plans, rather than flattening its segments into an ordinary character stream. Fractions stack numerator, rule, and denominator; radicals draw a degree, root sign, and overbar; n-ary forms stack limits; matrices and arrays use rows and columns; and decorators, bars, delimiters, group characters, and function application retain their own visual box.

The native equation evidence now visibly represents the Word structures. Focused verification passed with a zero-warning Avalonia test-project build and 39 equation command/source-guard tests. The cached Word comparison at `freew-fidelity-corpus\runs\equation-structure-native-word-baseline-20260715` remains outside the strict threshold. Its Avalonia mean delta is 3.2094 and changed-pixel ratio is 2.956%, compared with 3.0948 and 2.881% for the prior flattened text. The small metric increase is retained because the old output omitted real equation ink; the next slice is geometry and font calibration against the now-meaningful visual baseline.

## Follow-up - OfficeMath Function Application

The DOCX writer correctly emits an `m:func` with `m:fName` and `m:e`; the synthetic parentheses existed only in FreeW's visual planner. The shared planner now exposes the function name and argument as the two OfficeMath display parts, and Avalonia measures/draws them as one atomic function form with a small inter-part gap. The regenerated native evidence matches Word's `sin x + y + log n` notation rather than `sin(x + y) + log(n)`. Focused verification passed: 39 Avalonia equation command/source-guard tests and 33 shared equation-planner tests.

## Follow-up - Compact N-ary Limits

Avalonia's first structured n-ary layout reserved the full height of upper limit, operator, and lower limit in sequence. Word overlaps the smaller limit glyphs into the operator's vertical extent. The native n-ary measurement now reserves the operator plus compact overlapping limit bands, while the draw path centers the operator between those bands. The rebuilt PageLayoutShot evidence moves the following matrix and remaining equation rows upward toward their Word positions without flattening the limits.

The next calibration separates that visual extent from pagination reservation: Word keeps the limit glyphs visually attached above and below the operator while advancing the paragraph by the compact operator line box. Avalonia now follows that rule, which moves the subsequent matrix, equation array, and decorator rows upward again while preserving the visible limits.

The focused live comparison before this final reservation trim improved Avalonia equation evidence to mean delta 3.1592 and changed pixels 2.923%, from 3.1982 and 2.942% after function application. The trimmed native page places the matrix nearly on Word's row; the next local source of drift is the decorator and group-character line reservation.

## Follow-up - Compact Decorator Lines

Accent, bar, and group-character forms now reserve the base text line only. Their marks and rules are drawn into the same visible overhang area that Word uses, rather than creating a second stacked line. The rebuilt native page closes the remaining accumulated row drift through the accent, delimiter/group-character, and function paragraphs while preserving all of the structural marks.

## Follow-up - Matrix Grid Primitives

Avalonia now uses Word-calibrated matrix column spacing and draws matrix delimiters as brackets spanning the full row grid rather than ordinary one-line text glyphs. The matrix grid in the native page therefore reads as a two-row OfficeMath matrix, with its columns and brackets aligned to the visual structure Word renders.

## Follow-up - Compact Matrix and Array Rows

The shared matrix row gap is now 0.08em rather than 0.28em. This aligns both matrices and equation arrays to Word's compact row cadence and brings the subsequent accent, delimiter, and function rows into the same vertical neighborhood as their Word baseline counterparts.

## Follow-up - WPF Unboxed OfficeMath Surface

The WPF host previously placed every equation inside a padded pale-blue rounded Border. That decoration is useful for an editor placeholder but is not part of Word's document surface, and it dominated the equation baseline difference. The WPF equation host now remains an unadorned Border solely to retain its Equation model Tag for CommitToModel round-tripping; the shared planned mathematical content sits directly on the page.

The focused WPF equation round-trip suite passes all 32 tests. Against the cached real-Word equation PNG at `freew-fidelity-corpus\\runs\\word-com-baseline-20260714\\word-baseline`, the WPF changed-pixel ratio improves from 4.477% to 2.146%, and mean channel delta improves from 3.4210 to 3.2357. The strict 2.000% changed-pixel tolerance still fails, along with the two 3.000 mean thresholds, so remaining work is WPF structure sizing and vertical cadence rather than editor-chrome removal.

## Follow-up - WPF OfficeMath Cadence Calibration

Word's structured OfficeMath lines use a tighter line box than WPF's default 1.05 multiplier. The WPF structured equation text now uses a 0.85 multiplier, which keeps the fraction, n-ary limits, and matrix grid from accumulating vertical drift across the evidence page. Accents, bars, and group characters receive the small top offsets needed to align their overhanging marks with Word without disturbing the preceding structures.

The 32 focused WPF equation round-trip tests pass. The cached real-Word comparison at `freew-fidelity-corpus\\runs\\equation-structure-wpf-tail-cadence-word-baseline-20260715` now passes the strict `word-png-default` tolerance for WPF: 2.6924 mean channel delta, 2.7012 grayscale delta, and 1.9108% changed pixels. Avalonia's dimensions and mean deltas remain compliant, but its changed-pixel ratio is 2.794%, so it is the sole remaining equation evidence failure.

## Follow-up - Avalonia Word-Comparable Equation Surface

The Avalonia equation PNG originally began at the print-layout editor's chrome border, while Word's PNG begins at the physical white paper surface. The evidence capture now applies the measured two-DIP physical-page origin correction for the equation scenario and removes the editor-only page outline from that capture. This affects only the Word-comparable equation evidence artifact; it does not change the document renderer or the note-placement capture path.

The focused PageLayoutShot/equation source suite passes all 42 tests. The cached real-Word run at `freew-fidelity-corpus\\runs\\equation-structure-avalonia-clean-page-surface-word-baseline-20260715` now passes the strict `word-png-default` tolerance for both renderers:

| Renderer | Mean channel delta | Mean grayscale delta | Changed pixels |
| --- | ---: | ---: | ---: |
| Avalonia | 1.9067 | 1.7655 | 1.9881 % |
| WPF | 2.6924 | 2.7012 | 1.9108 % |

The comparison has exact 816x1056 dimensions against the cached Word page in both cases. This closes the equation-structure visual proof with real Word PNG evidence; fresh live COM exports remain deferred while Word's export call is unresponsive.

## Follow-up - WPF Footnote Printable-Frame Anchor

The current note-placement rebaseline confirmed that WPF's page-one footnote band remained the largest WPF note discrepancy. Its composite renderer anchored the measured note bitmap directly at the bottom margin. The cached Word page instead places the separator at row 895. WPF placed it at row 910 before calibration.

The WPF composite now reserves a measured 15 DIP below its note bitmap. This is intentionally distinct from the Avalonia evidence overlay's 36 DIP reserve because the two renderers produce different measured note-region heights. The WPF separator now lands at row 895, its first note begins at row 908 versus Word row 907, and its second note begins at row 932 versus Word row 935.

The cached comparison at `freew-fidelity-corpus\\runs\\note-placement-wpf-calibrated-reserve-20260715b` improves WPF footnotes page one from 16.8848 to 16.4904 mean channel delta and from 10.180% to 9.988% changed pixels. The scenario remains outside the strict tolerance because WPF body glyph and paragraph cadence differences, as well as the broader Avalonia note-layout gap, are still substantial. The exact band geometry is now correct and protected by the WPF evidence source guard.

## Follow-up - WPF Note Reference Line Box

The reference-line probe showed that WPF's `BaselineAlignment.Superscript` raised the footnote/endnote number correctly, but also expanded that line's box. Word's cached footnote page starts its body text at row 165; the WPF body text started at row 170 and displaced the remainder of the page even though the marker itself began at the right height.

WPF now renders note markers at the existing 0.65 scale with a 5 DIP upward text transform, leaving the marker's baseline alignment unchanged. The transform preserves the superscript appearance while allowing the paragraph to retain its normal line box. The cached run at `freew-fidelity-corpus\\runs\\note-placement-wpf-inline-marker-20260715` brings WPF footnotes page one from 16.4904 to 9.4641 mean channel delta and from 9.988% to 6.954% changed pixels. WPF endnotes page one likewise improves from 16.4279 to 9.4395 mean channel delta and from 9.741% to 6.759% changed pixels. A focused STA test verifies both marker types keep a baseline line box and carry the calibrated transform.

## Follow-up - Avalonia Note Capture Origin

The Avalonia body text on the cached Word note pages began one to two pixels above the corresponding Word surface, while the separately composited note region already had the correct physical-page anchor. The existing equation capture had the same two-DIP page-origin correction, but applying it indiscriminately to every note page regressed endnotes page two.

The capture now applies the two-DIP physical-page correction to both footnote pages and to endnotes page one only. The final cached comparison at `freew-fidelity-corpus\\runs\\note-placement-avalonia-page-origin-final-20260715` improves Avalonia endnotes page one from 9.8187 to 8.8705 mean channel delta and footnotes page one from 10.4802 to 9.5917; footnotes page two improves from 6.9432 to 6.0126, while endnotes page two retains its prior 4.2406 result. The source test protects this page-aware capture rule. Strict tolerance still fails because the residual is renderer text and note rasterization fidelity, not capture geometry.

## Follow-up - Avalonia Grayscale Document Text

The cached Word pages and WPF evidence use grayscale antialiasing for text, whereas the Avalonia document surface was using subpixel LCD rendering. A representative body-text crop contained 1,718 coloured fringe pixels in Avalonia and none in either Word or WPF. That rasterization difference inflated every Word comparison without representing a document-formatting difference.

`DocumentView` now explicitly uses Avalonia's grayscale `Antialias` text rendering mode, which also keeps captured document pages device-independent. The focused headless document-view suite passes all 32 tests.

The cached note comparison at `freew-fidelity-corpus\\runs\\note-placement-avalonia-grayscale-20260715` improves all four Avalonia pages while retaining their established physical-page geometry:

| Page | Previous mean delta | Current mean delta | Previous changed pixels | Current changed pixels |
| --- | ---: | ---: | ---: | ---: |
| Endnotes p1 | 8.8705 | 8.2054 | 8.028 % | 6.467 % |
| Endnotes p2 | 4.2406 | 3.7172 | 4.809 % | 3.780 % |
| Footnotes p1 | 9.5917 | 8.8588 | 8.699 % | 7.016 % |
| Footnotes p2 | 6.0126 | 5.5144 | 5.616 % | 4.455 % |

The strict equation proof remains green against the cached real-Word PNG at `freew-fidelity-corpus\\runs\\equation-structure-avalonia-grayscale-word-baseline-20260715`: Avalonia improves from `1.9067` mean channel delta and `1.9881%` changed pixels to `1.7195` and `1.5733%`; WPF remains at `2.6924` and `1.9108%`. Note placement remains outside strict tolerance because of remaining glyph and line-cadence differences, not coloured subpixel fringes. Fresh Word COM exports remain deferred while the live export call is unresponsive.

## Follow-up - Avalonia Note Content Origin

After removing coloured subpixel fringes, a text-mask comparison showed that Avalonia's note-page body lines were generally one pixel below the cached Word page after the first paragraph. The note overlay is separately anchored, so reducing the body capture offset does not disturb the calibrated separator and note-band placement.

The Word-comparable capture now uses a one-DIP content offset for both footnote pages and endnotes page one. Equation evidence retains its independently calibrated two-DIP offset, and endnotes page two retains zero because the same adjustment regresses that page. The cached comparison at `freew-fidelity-corpus\\runs\\note-placement-avalonia-content-origin-1px-20260715` improves the affected Avalonia rows:

| Page | Previous mean delta | Current mean delta | Previous changed pixels | Current changed pixels |
| --- | ---: | ---: | ---: | ---: |
| Endnotes p1 | 8.2054 | 2.5797 | 6.467 % | 4.009 % |
| Endnotes p2 | 3.7172 | 3.7172 | 3.780 % | 3.780 % |
| Footnotes p1 | 8.8588 | 3.5681 | 7.016 % | 4.652 % |
| Footnotes p2 | 5.5144 | 1.8872 | 4.455 % | 2.819 % |

The equation structure proof at `freew-fidelity-corpus\\runs\\equation-structure-note-content-origin-word-baseline-20260715` remains strictly trusted for both renderers. Footnotes page two now meets both mean thresholds and misses only the `2.000%` changed-pixel threshold; endnotes page one misses only that changed-pixel threshold. The remaining note differences are now localized to glyph rasterization, body line cadence, and note-region rendering rather than physical-page capture origin.

## Follow-up - Shared Footnote Separator Width

The WPF fidelity renderer obtains its footnote separator from the shared note-region planner. That planner still specified a 60-DIP rule, even though the native Avalonia renderer and the cached Word page use a two-inch, 192-DIP separator. The mismatch was visible directly in the Word baseline: Word's rule spans rows `x=96..287`, while WPF's old rule ended at `x=155`.

The shared planner now specifies the measured 192-DIP Word width, protected by an explicit planner test. The cached comparison at `freew-fidelity-corpus\\runs\\note-placement-wpf-separator-192-word-baseline-20260715` improves WPF footnotes page one from `9.4641` to `9.4250` mean channel delta and from `6.954%` to `6.939%` changed pixels. Other WPF and Avalonia note pages are unchanged; their remaining gap is text layout and glyph rasterization rather than separator geometry.
## Follow-up - Preserve Word PDF Page Geometry

The cached Word baseline renderer forced every exported PDF page to an `816x1056` raster surface. That
silently stretched the authored `612x396` point table fixtures from `816x528` to Letter dimensions,
making their strict Word comparisons report false layout failures. `Render-WordBaseline.ps1` now retains
each PDF page's native 96-DPI dimensions unless a caller explicitly supplies both `-Width` and `-Height`.
`FreeW.PdfRasterize` has the same native-size default, so regenerated Word table baselines will match the
FreeW page surface rather than a resized surrogate.

The cached Word PDF smoke test now emits `816x528` for both repeat-header pages in native mode, while
an explicit `816x1056` request still emits that exact fixed surface. This confirms the compatibility
override and the parity default independently, without issuing a new Word COM export.

## Follow-up - Table Row Height and Word Page-Surface Capture

WPF represented an authored table-row height by appending a separate spacer after the cell's content.
That made every explicit-height row consume content height plus requested height, so the repeat-header
fixture split into four WPF pages while the cached real Word PDF has two. The cell now uses one min-height
content host instead. The focused table proof at
`freew-fidelity-corpus\runs\table-height-content-host-word-baseline-20260715` emits two WPF pages for
the repeat-header fixture and three for the page-composition fixture, matching their Word PDF page counts.

The same capture-contract issue affected three Avalonia object scenarios: they compared the full editor
scene against Word's page surface. They now reuse the existing document-page crop. Cached WordArt evidence
at `freew-fidelity-corpus\runs\wordart-page-surface-word-baseline-20260715` reduces Avalonia changed
pixels from `63.794%` to `23.238%` for picture-watermark layout and from `64.994%` to `15.961%` for the
WordArt watermark. Remaining strict failures are real WordArt/watermark rendering differences, not desk
or canvas geometry.

## Follow-up - Fixed DOCX Table Layout

The native Word baseline exposed a document-format defect in the table fixtures: FreeW wrote the correct
`w:tblGrid` widths but omitted `w:tblLayout`. Word consequently auto-fitted the cells, collapsing the
first two columns and assigning the remaining width to the final column even though the model requested
fixed layout. FreeW now emits `w:tblLayout w:type="fixed"` in schema order for its default fixed mode,
and reads explicit `autofit` back into the model. The generated repeat-header fixture contains the fixed
layout element, and the focused table OOXML lane passes 25 tests. A renewed Word PDF export is still
needed to measure the resulting visual improvement once the live export route is available.

## Follow-up - Avalonia WordArt Fill Semantics

The cached Word WordArt page showed that Avalonia treated the WordArt fill as the text colour and used
large translucent rectangles for glow. Word renders the fill as the object field, uses contrasting text,
and keeps effects close to the text. Avalonia now paints solid, gradient, and pattern fills as the field,
selects text contrast from the field luminance, and does not turn glow into an oversized rectangle.

Cached WordArt evidence at `freew-fidelity-corpus\runs\wordart-clean-chrome-native-baseline-20260715`
improves the Avalonia watermark-stress page from `18.2309` mean channel delta and `15.949%` changed
pixels to `15.9988` and `14.070%`. The remaining visible gap is real WordArt deformation/effect fidelity,
especially `Wave1` and `ArchUp`, rather than field and text-colour semantics.
