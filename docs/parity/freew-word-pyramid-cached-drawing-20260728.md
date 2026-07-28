# Word Basic Pyramid Cached Drawing Parity

Fixture: `C:\Temp\native-word-pyramid.docx`  
Input SHA-256: `128ECFD8C4E0362469E7E11D84C5C77AA119EB4A4C8B77C0E4C809ABE06017A0`  
Word reference: direct visible Word COM PDF export, rasterized at 816 x 1056  
Word PNG SHA-256: `2F0382D338565E1C7547D47513863E3DEDC64A9854A2B2AD1CC53D3C6D159DB8`

The imported SmartArt uses the authoritative cached `word/diagrams/drawing1.xml` path:

- `pyramid1` layout, `accent1_2` colors, and `simple1` quick style;
- four contiguous 300 pt by 150 pt trapezoid bands using document Accent 1 (`#156082`);
- white separators and Word-fitted black labels.

FreeW previously resolved this unrecognised native color/style pair to its generic colourful palette. The shared planner now recognises only this imported signature, consumes the document Accent 1 color, and uses the cached drawing's contiguous-band geometry with Word-measured effective label fitting. The older `accent2` / `flat1` pyramid calibration is unchanged.

Matched 816 x 1056 WPF composite comparison:

| Region | Before | After |
| --- | ---: | ---: |
| Whole page | 1.5870% | 0.1923% |
| Pyramid ROI `(140,200)-(590,480)` | 10.8412% | 1.3032% |
| Top band ROI | 15.4446% | 4.2986% |
| Base band ROI | 19.5972% | 1.7264% |

Verification:

- `ChartSmartArtVisualPlannerTests`: 49/49
- WPF `SmartArtRenderingTests`: 17/17
- Avalonia `DocumentViewInlineFO4Tests`: 36/36
- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors
- `FreeW.App.Avalonia` Release build: 0 warnings, 0 errors
