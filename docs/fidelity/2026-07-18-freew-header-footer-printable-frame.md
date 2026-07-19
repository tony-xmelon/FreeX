# Header/footer printable-frame rendering

## Scope

The WPF fidelity composite rendered header and footer slots at the full page
width, then drew the resulting visual only inside the printable frame. That
made a left-aligned image partly survive by coincidence and clipped a
right-aligned header image entirely outside the destination rectangle.

## Change

`FreeW.FidelityRender` now paginates each header/footer wrapper at the same
printable width used by its composite destination:

`page width - left margin - right margin`

This applies to the normal page-box header/footer path and the generated
multi-page-table footer fallback. The compositor still places the result at
the left page margin, so the source and destination coordinate systems agree.

## Cached Word evidence

Source: persistent matching 816x1056 Word COM baseline under
`FreeW-WordBaselineSurfaceRefresh-20260717`. The Word exporter is currently
owned by a separate active wrapper, so this slice did not start another COM
session.

| Fixture | Region | Before | After |
| --- | --- | ---: | ---: |
| `f2-hf-images` page 1 | header band | 0.7824% | 0.2634% |
| `f2-hf-images` page 1 | whole page | 1.1102% | 1.0816% |
| `f2-hf-images` page 2 | header band | 1.9932% | 0.2766% |
| `f2-hf-images` page 2 | whole page | 1.1223% | 1.0280% |

The page-2 orange image mask was absent before the change. Afterwards its
bounds were exactly Word's `613,35-714,66`.

## Verification

- `dotnet build freew/tools/FreeW.FidelityRender/FreeW.FidelityRender.csproj --configuration Release`
  passed with 0 warnings and 0 errors.
- Regenerated `f2-hf-images.docx` and rendered it through the rebuilt Release
  composite path; both pages were emitted at 816x1056.
- `HeaderFooterPagePlannerTests`: 5 passed.
- `PagedEditW18HfPolishTests`: 10 passed.

## Process note

For header/footer images, measure the raw feature bounds before changing
layout. A missing right-aligned image can be a mismatched source/destination
frame rather than a section-slot or image-decoding failure. Gate the repair on
both a right-aligned target page and a left-aligned paired control.
