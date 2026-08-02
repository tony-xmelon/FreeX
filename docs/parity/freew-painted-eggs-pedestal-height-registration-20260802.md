# FreeW Painted Eggs pedestal height registration (2026-08-02)

## Scope

The imported `eggsBlack` pedestal approximation had a flat bottom at local y=32,
leaving two solid black rows below Word's visible pedestal. The shared planner now
moves only the two bottom vertices to local y=30. The pedestal's upper contour,
outer/inner shell, mottles, cadence, and frame placement remain unchanged.

## Matched reference

- Fixture: `eggs.docx`, SHA-256
  `F04CEBAF5CB08EA63F0C27E408FDF1C51CA99EA06D8E38BB7E62AF97A2F45BEA`
- Fresh Word COM PNG: 816x1056, SHA-256
  `E592B57C4722541EE45028570A0FD88F9E17CD6232AF37D78A852C836308D6CD`
- Before WPF composite PNG: 816x1056, SHA-256
  `8D3CB985BEBD4A364046C687EE1670A551A2FE4466ED765DDB6B83D663F5190E`
- Candidate WPF composite PNG: 816x1056, SHA-256
  `EDAF00BF2562A11DD691020E925DE925AF73C1D51DA7EBEF5A39AAE0F41C843C`

The Word PNG and before-candidate hashes exactly match the preceding accepted shell
apex slice. Word COM exported one document and one page and then quit its owned process.

## Visual result

Mean absolute RGB delta against the unchanged Word PNG:

| Region | Before | After | Change |
| --- | ---: | ---: | ---: |
| Whole page | 4.566710% | 4.262332% | -0.304378 pp |
| Top border | 11.070914% | 10.310482% | -0.760433 pp |
| Bottom border | 9.119173% | 8.418957% | -0.700215 pp |
| Left border | 8.747100% | 8.137952% | -0.609149 pp |
| Right border | 8.495186% | 7.886454% | -0.608732 pp |
| Isolated top egg | 26.017157% | 23.704567% | -2.312590 pp |
| Pedestal ROI | 33.120098% | 23.638480% | -9.481618 pp |
| Interior control | 0.573890% | 0.573890% | 0.000000 pp |

## Verification

- `PageBorderArtVisualPlannerTests`: 19/19
- WPF decorative page-border consumer source contract: 1/1
- Avalonia live/PDF consumer and Painted Eggs PDF raster contracts: 2/2
- Avalonia PDF black-ink interval tightened to 250-260 pixels; actual 255
- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors
- Fresh isolated Word COM export: 1/1 document, 1/1 page

## Process note

Use raw motif rows and a lower-material ROI to identify unsupported source geometry.
When a flat edge is owned by two vertices, move only those vertices and require the
isolated object, every edge, and whole page to improve with interior content unchanged.
