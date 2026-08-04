# FreeX Avalonia Entire Workbook Print Preview: Wave 151

## Closed boundary

Avalonia Print Preview now has a live workbook-level page stream for `Print What: Entire Workbook`.
It follows the WPF `PrintRenderer.RenderWorkbook` contract:

- visible worksheets are traversed in workbook order; hidden and very-hidden sheets contribute no pages;
- each sheet uses its configured print areas, or its used range when no print area is configured;
- `Ignore Print Area` repaginates every sheet against its used range;
- worksheet grid pages are followed by that sheet's `PrintComments=AtEnd` appendix pages;
- empty sheets are safely skipped;
- page navigation crosses sheet boundaries and reports the aggregate preview page count;
- `&P` uses `FirstPageNumber + workbook running offset + sheet-local page index` and `&N` uses the
  aggregate grid-plus-appendix page count, matching WPF's workbook render path;
- settings and nested Page Setup callbacks rebuild the selected workbook/sheet page stream;
- preview export routes Entire Workbook and Selection to the existing portable workbook export planner.

WPF now consumes the same shared `PrintCommentSummaryPlanner.FilterToPrintedCells` policy used by the
Avalonia workbook context. The comment appendix painter is renderer-neutral; Avalonia turns its paint
instructions into controls just as it does for worksheet pages.

## Verification

- `PrintPreviewWorkbookPaginationContextTests`: 4/4 passed.
- `Wave151PrintPreviewWorkbookParityTests`: 2/2 passed; the combined Wave150/Wave151 focused
  Avalonia run passed 6/6.
- Presentation workbook tests plus source guards passed 7/7.
- The adjacent WPF comment subset passed 2/4; two existing renderer-summary assertions remain
  outside this slice and are unaffected by moving the former private filter to shared presentation.
- FreeX Avalonia Release build: 0 warnings, 0 errors.

## Residual boundary

The page stream and pagination semantics are shared with WPF, but Avalonia still paints the page with
Avalonia controls rather than WPF's native `FixedDocument`/`DocumentViewer`; native viewer chrome and
platform text rasterization can therefore differ visually. The comment appendix is functionally and
geometrically represented, but it does not expose WPF's native document selection/printing chrome.
`Entire Workbook` remains a visible-worksheet scope, matching WPF; hidden/very-hidden sheets are not
included.
