# Word Basic Pyramid Anchor Geometry Parity

Controls use the same native `pyramid1` / `accent1_2` / `simple1` cached-drawing route:

| Fixture | Word reference | Input SHA-256 |
| --- | --- | --- |
| Floating 300pt x 150pt | Existing direct Word PDF raster | `128ECFD8C4E0362469E7E11D84C5C77AA119EB4A4C8B77C0E4C809ABE06017A0` |
| Inline 432pt x 252pt | Fresh visible direct Word COM export, PDF SHA `951D4C53FA43E184742FA97659008AE66615BA9887557059996BE39A51B9DCB9` | `D4166829CF893DCEAF616196D6E792217BEA12CBE568FA04E2E0BF1299AE4134` |

The inline Word PNG SHA-256 is `18C863DB7FFD51A8A7D9EACCF1894E948AC22C706B66DF1D462FA3D21E64E37A` at 816 x 1056.

Word's cached `dsp:drawing` uses the SmartArt anchor as its coordinate system. The 432pt x 252pt inline control has contiguous bands `(162,0,108,63)`, `(108,63,216,63)`, `(54,126,324,63)`, and `(0,189,432,63)`. The prior 300pt x 150pt fixed geometry shortened and vertically centered this control.

The shared planner now derives the four contiguous trapezoids from the imported SmartArt anchor width and height. It also passes the document minor font through the exact native pyramid node plan, so the WPF and Avalonia hosts use imported Aptos instead of their platform default.

Matched WPF composite evidence:

| Fixture / Region | Before | After |
| --- | ---: | ---: |
| Floating whole page | 0.1923% | 0.1573% |
| Floating pyramid ROI | 1.3032% | 1.0635% |
| Inline whole page, fixed 300pt x 150pt counterfactual | 3.1499% | 0.8760% |
| Inline pyramid ROI, fixed counterfactual | 9.0128% | 2.5032% |
| Inline base ROI, fixed counterfactual | 25.8323% | 4.7299% |

The final inline FreeW PNG SHA-256 is `DF75F67C79146BAB7D58942C161B14E1150CA371D8B5ABEA4FBB2995D3C2410B`.

Verification:

- `ChartSmartArtVisualPlannerTests`: 50/50
- WPF `SmartArtRenderingTests`: 17/17
- Avalonia `DocumentViewInlineFO4Tests`: 36/36
- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors
- `FreeW.App.Avalonia` Release build: 0 warnings, 0 errors
