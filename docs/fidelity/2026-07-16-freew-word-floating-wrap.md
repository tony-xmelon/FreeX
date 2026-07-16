# FreeW / Word floating-wrap parity

Date: 2026-07-16

## Scope

This pass compares the `f2-01-float-wrap` fixture through the live Word COM export and
FreeW's composite `FidelityRender` path. The fixture contains a square-wrapped image at
the left page margin, a tight-wrapped image farther right, and text anchored in a later
paragraph so the earlier body paragraph must carry the visual wrap geometry.

Word evidence:

- Input: `freew-fidelity-corpus/runs/word-orgchart-render-next-20260716-orgchart/fresh-fixtures-point-order/f2-01-float-wrap.docx`
- PDF: `freew-fidelity-corpus/runs/word-orgchart-render-next-20260716-orgchart/word-float-wrap-current/f2-01-float-wrap.pdf`
- PNG: `freew-fidelity-corpus/runs/word-orgchart-render-next-20260716-orgchart/word-float-wrap-current-png/f2-01-float-wrap_p1.png`

## Result

FreeW now emits a page-anchored WPF `Figure` for the visual-only copy of each leading
floating image. The Figure uses the shared planner's page-space rectangle, `PageLeft` /
`PageTop` anchoring, and `WrapDirection.Both`; the original model run remains suppressed
only during visual construction and is preserved in its original paragraph on commit.

The fresh FreeW output places both images at the Word positions and produces the same
left, middle, and right text bands around the top objects. In a sampled RGB comparison
of the content region, mean absolute channel difference fell from `97.89` with the old
wide visual-only Floater to `76.08` with the Figure path. Pixels above the comparison
threshold fell from `19.80%` to `16.49%`.

FreeW evidence:

- PNG: `freew-fidelity-corpus/runs/word-orgchart-render-next-20260716-orgchart/freew-figure-wrap-next/f2-01-float-wrap_p1.png`
- Render command: `dotnet run --project freew/tools/FreeW.FidelityRender/FreeW.FidelityRender.csproj --configuration Release --no-restore -- <input.docx> <outputDir> 3 --composite`

## Verification

- `FloatingImageRenderTests`: 14/14 passed, including Figure geometry, wrap mode, and model-order preservation.
- Floating-object and composite host slice: 35/35 passed.
