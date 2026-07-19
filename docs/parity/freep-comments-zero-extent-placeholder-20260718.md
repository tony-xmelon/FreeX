# FreeP comments deck: explicit zero-extent placeholder

Date: 2026-07-18
Deck: `tools/FreeP.RenderCompare/corpus/21-comments-notes.pptx`
Host: WPF `FreeP.RenderCompare` at 1280x720
PowerPoint reference: fresh COM export in `C:/Users/ali/AppData/Local/Temp/freep-comments-notes-current-20260718`

## Diagnosis

Slide 2 contains a title placeholder named `Title 1` whose `p:spPr/a:xfrm/a:ext` is explicitly
`cx="0" cy="0"`. PowerPoint suppresses that slide shape. FreeP previously treated the zero
extent as absent geometry, inherited the visible title rectangle from the layout, and rendered
`Follow-up comments` above the green comment summary shape.

## Change

- `SlideShape` retains `HasExplicitZeroExtentTransform` when the source contains an explicit
  zero-sized `<a:ext>`.
- The reader sets that bit while retaining the original zero extents.
- WPF skips only slide placeholder shapes carrying that bit; ordinary inherited placeholders and
  layout/master definitions keep their existing behavior.

## Evidence

Fresh WPF candidate render compared with the matching PowerPoint PNG:

| Slide | Previous WPF | Candidate WPF | Result |
| --- | ---: | ---: | --- |
| 1 | 0.0595% | 0.0595% | byte-identical candidate vs previous WPF |
| 2 | 0.4396% | 0.0880% | title removed; comment summary remains |

The candidate slide 2 has no stray title and retains the green rounded rectangle. The focused
package assertion confirms the corpus shape is read with `HasExplicitZeroExtentTransform=true`.

## Verification

- `dotnet test freep/FreeP.App.Presentation.Tests/FreeP.App.Presentation.Tests.csproj --configuration Release --no-build --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --filter "FullyQualifiedName~SlideCompositorTests"`
  - 78/78 passed.
- `dotnet test freep/FreeP.App.Host.Tests/FreeP.App.Host.Tests.csproj --configuration Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false -p:BuildInParallel=false /nr:false -m:1 --filter "FullyQualifiedName~RenderCompareCommentsNotesCorpus_ExplicitZeroTitleTransform"`
  - 1/1 passed.
- `dotnet build tools/FreeP.RenderCompare/FreeP.RenderCompare.csproj --configuration Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false -p:BuildInParallel=false /nr:false -m:1`
  - completed successfully; the shell wrapper timed out while waiting, but the owned build process completed and the focused tests passed against the resulting artifacts.
- `FreeP.RenderCompare --freep-render ...21-comments-notes.pptx ... --width 1280 --height 720`
  - rendered both slides successfully.
- `FreeP.RenderCompare --diff` against the fresh PowerPoint PNGs
  - slide 1: 0.0595%; slide 2: 0.0880%.
