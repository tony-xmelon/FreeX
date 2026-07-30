# WPF Footnote Physical-Compositor Probe

## Scope

The controlled `f2-footnote-overflow.docx` fixture has a 700-word first
footnote, a later short second footnote, and ordinary paragraphs after each
reference. Its matching Word COM export has five 816x1056 pages.

This probe replaced the WPF FidelityRender global footnote reserve with a
bounded physical-page compositor for plain, single-section paragraph flows.
It used `DocumentNoteRegionPlanner` fragments, inserted continuation-only
pages, and repaginated contiguous body block ranges against the note fragment
sharing each page.

## Result

The probe was active and materially changed the route:

| Renderer / policy | Physical pages | Result |
| --- | ---: | --- |
| Word COM reference | 5 | Reference sequence |
| Current WPF global full-note reserve | 47 | Reject: repeated reserve creates nearly empty body pages |
| Physical-compositor probe | 4 | Reject: continuation was isolated, but body flow diverged |

After fixing an early fallback that had painted the old body page into the
continuation-only page, the probe correctly rendered the second page as note
content only. The remaining WPF-vs-Word page metrics were still not
acceptable: page 1 `11.8951%`, page 2 `14.2768%`, and page 3 `8.5022%` mean
channel delta.

Tightening the continuation capacity aligned its source token boundary closely
to Word on page 2, but the independently rebuilt WPF body ranges changed
paragraph cadence and still emitted only four pages.

## Decision

No product code was retained. The owning solution must keep one canonical WPF
text flow and provide page-specific body regions or content positions while
the note fragments are inserted into the physical sequence. Cloning model
blocks into independent `FlowDocument` ranges is not a valid reflow strategy:
it loses the continuous paginator's paragraph/line ownership and cannot be
accepted even when the note fragments themselves are correct.

## Verification

`dotnet build freew\tools\FreeW.FidelityRender\FreeW.FidelityRender.csproj --configuration Release --no-restore --disable-build-servers -m:1 -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false`
completed after the probe was reverted, with 0 warnings and 0 errors.
