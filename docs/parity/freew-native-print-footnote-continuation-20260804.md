# FreeW native print footnote continuation

## Scope

Print Preview, Print, XPS, and PDF export share `PrintLayout.BuildPaginator`. That path
previously added the complete footnote height to every page's bottom padding. The cached
700-word overflow fixture consequently followed the same pathological global-reserve
model that FidelityRender used before the canonical-flow correction.

The proven WPF reservation logic now lives in one `FootnoteContinuationFlowComposer`.
Both FidelityRender and native `PrintLayout` consume it. The composer returns concrete
paragraph anchors because the print clone intentionally strips private WPF marker tags
during XAML round-tripping; page ownership is measured from those anchors after the
actual print paginator has realized its pages.

`HeaderFooterPaginator` receives the resulting physical-page fragment map and paints
only that page's shared continuation plan into the reserved body band. Ordinary notes,
tables, columns, multi-section documents, and other unsupported complex flows retain
the previous reserve and overlay paths.

## Verification

- Exact cached `f2-footnote-overflow.docx` through native `PrintLayout`: 5 pages, matching
  Word's five-page sequence.
- In-repo synthetic 700-word continuation: 6 bounded pages with fragment overlays on
  all three long-note pages; its deliberately simplified paragraph formatting is taller
  than the exact corpus fixture.
- `HeaderFooterPaginatorTests`: 11/11.
- `VisualEvidenceFidelityRenderSourceTests`: 23/23.
- Host and FidelityRender Release builds: 0 warnings, 0 errors.

The shared extraction leaves the accepted FidelityRender-vs-Word RGBA whole-page scores
unchanged: page 1 `8.6936%`, page 2 `9.8555%`, page 3 `7.0768%`, page 4 `3.0862%`, and
page 5 `0.3045%`.

## Remaining work

Complex multi-section, multi-column, table-contained, and nested-block long-footnote
flows remain deliberately on the legacy fallback. Note font metrics and vertical
registration are separate visual calibration work after physical page ownership.
