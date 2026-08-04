# FreeW imported Word line-cadence calibration

## Scope

WPF applies a small line-height calibration when imported WordprocessingML relies on Word's application-default run formatting and omits an explicit `w:spacing/@w:line`. The existing `1.01` scale accumulated a 2-3 pixel downward drift over long pages. This slice changes only that route to `1.00975`; explicit line spacing and model-authored documents are unchanged.

## Reference and provenance

- Word 16 COM exported fresh PDFs through `Render-WordBaseline.ps1` using short staging paths under `C:\FWB`.
- Word became ready before each open, exported all three fixtures without a repair prompt, closed each read-only document, and quit its owned process.
- Word and WPF page rasters were both 816x1056.
- The actual consuming `FreeW.FidelityRender` Release artifact was rebuilt before every candidate render.
- Fixtures: `header-footer-basic.docx`, `header-firstpage.docx`, and `header-odd-even.docx`.

## Visual evidence

Mean channel-difference percentages against the matching Word PNG:

| Fixture | Page | Before | After |
| --- | ---: | ---: | ---: |
| header-footer-basic | 1 | 5.3786 | 5.2544 |
| header-footer-basic | 2 | 6.0504 | 5.9368 |
| header-footer-basic | 3 | 4.8328 | 4.7181 |
| header-firstpage | 1 | 3.3408 | 3.2937 |
| header-firstpage | 2 | 6.3136 | 6.2003 |
| header-firstpage | 3 | 5.6840 | 5.5706 |
| header-odd-even | 1 | 5.4831 | 5.3592 |
| header-odd-even | 2 | 6.1444 | 6.0309 |
| header-odd-even | 3 | 6.1634 | 6.0490 |
| header-odd-even | 4 | 1.4465 | 1.4465 |

The ten-page average improved from 5.0838% to 4.9860%. A body-only ROI improved on every affected page; the final short page was stable. Exact header and footer crops were SHA-256 stable on all ten pages, covering first/even/default ownership.

## Probe history

The initially measured `1.005` candidate substantially improved the basic fixture but regressed the first-page fixture's cover page from 3.3408% to 5.3926%. Bounded probes at `1.0075`, `1.009`, and `1.0095` reduced but did not remove that regression. `1.00975` was the first value that improved the cover page and retained gains across the rest of the complete page sequence.

## Verification

- `dotnet test freew\FreeW.App.Host.Tests\FreeW.App.Host.Tests.csproj --configuration Release --filter "FullyQualifiedName~LineHeightMultipleTests"` - 8/8 passed.
- `dotnet build freew\tools\FreeW.FidelityRender\FreeW.FidelityRender.csproj --configuration Release --no-restore` - 0 warnings, 0 errors.
- Fresh Word exports: 3/3 documents; complete WPF gate: 10/10 pages.

## Process rule

Calibrate imported default line cadence with the complete first/even/default page sequence. A strong long-page improvement is insufficient if a different subpixel starting phase regresses a cover page; retain the first scalar that improves every affected page and leaves isolated header/footer layers byte-stable.
