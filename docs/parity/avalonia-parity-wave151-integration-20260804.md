# Avalonia Parity Wave 151 Integration

- FreeX: closed the documented Avalonia Entire Workbook Print Preview boundary.
- Shared presentation: added workbook page ordering, running page-number offsets, aggregate totals,
  comments-at-end appendix planning/painting, and shared printed-comment filtering.
- WPF: now consumes the shared printed-comment filtering policy; the former private duplicate was removed.
- Avalonia: Entire Workbook is enabled in the live settings rail, navigates across visible sheets and
  appendix pages, repaginates after settings/Page Setup changes, and routes preview export by scope.
- Verification: workbook presentation tests plus source guards 7/7, Avalonia Wave150/Wave151
  focused tests 6/6, and Avalonia Release build 0 warnings / 0 errors. The adjacent WPF comment
  subset passed 2/4; two existing renderer-summary assertions still fail and are not changed by
  this slice because the shared filter is the former WPF helper moved verbatim.

Detailed behavior and residual visual boundary:
`freex-avalonia-entire-workbook-print-preview-wave151-20260804.md`.
