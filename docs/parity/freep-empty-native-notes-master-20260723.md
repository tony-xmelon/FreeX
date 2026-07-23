# FreeP empty native notes-master parity

Date: 2026-07-23

The PowerPoint COM fixture `21-comments-notes.pptx` contains a native
`ppt/notesMasters/notesMaster1.xml` part, but its shape tree has no renderable
placeholder shapes. PowerPoint consequently emits a text-only notes surface:
the two note paragraphs on slide 1 occupy separate pages, followed by slide 2
on page 3. FreeP had been synthesizing the normal slide-thumbnail/title frame,
combining slide 1's paragraphs, and emitting only two pages.

The planner now treats this exact source state as an empty native notes master.
It preserves the notes text, emits one paragraph per physical page, suppresses
synthetic thumbnail/frame content, and uses the measured continuation text
registration. Normal generated notes masters and masters with authored
placeholder geometry retain the existing path.

## Fresh COM evidence

PowerPoint COM produced three 540x720-point pages. FreeP now produces the same
three-page sequence. Rasterized at 96 DPI, the per-page mean channel deltas
against PowerPoint are:

| Page | Mean channel delta |
| ---: | ---: |
| 1 | 0.1587% |
| 2 | 0.2218% |
| 3 | 0.1637% |

## Verification

- `dotnet build tools/FreeP.RenderCompare/FreeP.RenderCompare.csproj --configuration Release --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1`: `0` warnings, `0` errors.
- Notes-focused Presentation tests: `22/22` passed.
- The exact corpus contract asserts slide 1 renders `2` pages, slide 2 renders
  `1`, and the complete notes PDF contains `3` pages.
