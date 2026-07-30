# WPF Footnote Overflow Current-Main Diagnostic

## Fixture and reference

`C:\Temp\FreeW-FootnoteOverflowProbe-20260730\f2-footnote-overflow.docx`
contains a long first footnote, a later short second footnote, and ordinary body
paragraphs after both references.

On current main, a fresh visible Word COM export completed through
`Render-WordBaseline.ps1` in about twelve seconds. The lifecycle trace records
the isolated Word process becoming ready, opening the document read-only,
exporting its short flat staging PDF, closing the document, and quitting the
owned process. Word produced five 816x1056 PNG pages.

## Current WPF result

`FreeW.FidelityRender` was rebuilt in Release and rendered the same DOCX with
the composite path. Its current global reserve takes the height of the complete
rendered footnote and applies it to every body page. That produced 47 logical
pages; the focused render emitted the first eight, with the first page nearly
empty except for the heading.

The complementary no-global-reserve probe previously produced only two pages,
but painted no usable footnote content. It is therefore not an acceptable
fallback.

| Renderer / policy | Physical pages | Result |
| --- | ---: | --- |
| Word COM | 5 | Reference behavior |
| WPF current global full-note reserve | 47 | Reject: repeated full-note reservation creates blank body pages |
| WPF no global reserve | 2 | Reject: note content is not composed onto the page |

## Decision

Do not tune `bodyFootnoteReserveDip` or cap the global reservation. Either
change hides or misplaces authored content.

The owning correction is a WPF physical-page compositor that uses the shared
continuation fragments, reserves only the fragment that actually shares a
body page, and inserts continuation-only pages while preserving the later
body flow. The existing Avalonia continuation planner is useful input, but its
physical-page model cannot be copied into WPF `FlowDocument` composition
without reflowing the body at each affected page boundary.

## Verification

- `dotnet build freew\tools\FreeW.FidelityRender\FreeW.FidelityRender.csproj --configuration Release`
  completed with 0 warnings and 0 errors.
- Fresh Word COM export: 1/1 document, five PNG pages.
- Fresh WPF composite render: 8/47 pages emitted with the current `maxPages=8`
  diagnostic cap.
