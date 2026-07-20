# FidelityRender Drawing Group Anchor Registration

## Scope

`drawing-objects-complex.docx` contains a paragraph-anchored `DrawingGroup` with five child visuals.
The WPF fidelity compositor detached the body `FlowDocument` before creating its floating canvas, so
the group used estimated paragraph geometry rather than the arranged anchor.

## Change

The compositor now captures an arranged floating canvas before detaching the body flow, then copies
only `DrawingGroup` roots onto the normal detached-model canvas. Images, shapes, charts, SmartArt,
and WordArt continue using the existing detached-model path.

## Matched Word Evidence

Cached Microsoft Word baseline and fresh Release WPF renders at 816x1056:

| Region | Before | After |
| --- | ---: | ---: |
| Group ROI `(450,520)-(750,735)` | 10.2105% | 4.1438% |
| Ellipse ROI `(465,570)-(585,650)` | 10.3631% | 4.9904% |
| Whole page | 7.5984% | 7.1443% |

The exact `#CFE2F3` ellipse mask moved from WPF `y=595..657` to `y=581..643`, toward Word
`y=580..644`.

## Controls

`object-format-position-size-style.docx` and `wordart-watermark-stress.docx` contain no drawing
groups. Their fresh WPF PNGs were byte-identical to their accepted current-main controls.

## Verification

- `dotnet build freew/tools/FreeW.FidelityRender/FreeW.FidelityRender.csproj --configuration Release --no-restore --disable-build-servers -m:1 -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false`
- Focused `VisualEvidenceFidelityRenderSourceTests`
- Fresh `--configuration Release --no-build --no-restore --composite` renders for target and controls.
