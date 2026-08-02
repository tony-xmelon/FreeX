# FreeW Painted Eggs shell apex registration (2026-08-02)

## Scope

The imported `eggsBlack` outer shell used a local apex at y=-2 while the white inner
shell and Word's visible egg begin at y=0. This produced two unsupported black rows
above every egg. The shared planner now moves only that outer-shell apex to y=0.
Mottles, remaining shell vertices, white interior, pedestal, cadence, and placement
are unchanged.

## Matched reference

- Fixture: `eggs.docx`, SHA-256
  `BD278CBA2498FEB7653D45DEF66D60CCCD1541B31AAE5C19B0AB5E03ED3413D8`
- Fresh Word COM PNG: 816x1056, SHA-256
  `E592B57C4722541EE45028570A0FD88F9E17CD6232AF37D78A852C836308D6CD`
- Before WPF composite PNG: 816x1056, SHA-256
  `8E772DFCE325117B4DC310C3D9C09399A072C2116C8550D018D00522A0B6B81F`
- Candidate WPF composite PNG: 816x1056, SHA-256
  `8D3CB985BEBD4A364046C687EE1670A551A2FE4466ED765DDB6B83D663F5190E`

The Word PNG and before-candidate hashes exactly match the preceding accepted mottle
slice. The fresh Word COM run exported one document and one page and quit its owned
Word process cleanly.

## Visual result

Mean absolute RGB delta against the unchanged Word PNG:

| Region | Before | After | Change |
| --- | ---: | ---: | ---: |
| Whole page | 4.622502% | 4.566710% | -0.055792 pp |
| Top border | 11.285824% | 11.070914% | -0.214909 pp |
| Bottom border | 9.368532% | 9.119173% | -0.249359 pp |
| Left border | 8.766084% | 8.747100% | -0.018983 pp |
| Right border | 8.502908% | 8.495186% | -0.007721 pp |
| Isolated top egg | 26.712099% | 26.017157% | -0.694943 pp |
| Interior control | 0.573890% | 0.573890% | 0.000000 pp |

## Verification

- `PageBorderArtVisualPlannerTests`: 19/19
- Avalonia live/PDF consumer and Painted Eggs PDF raster contracts: 2/2
- Avalonia PDF black-ink interval updated to the measured 280-290 pixels; actual 283
- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors
- Fresh isolated Word COM export: 1/1 document, 1/1 page

## Process note

Use raw motif rows to distinguish a source contour error from host antialiasing. When
one serialized approximation vertex solely owns unsupported ink, move only that vertex
and require target motif, all edge ROIs, and whole page to improve with interior content
unchanged.
