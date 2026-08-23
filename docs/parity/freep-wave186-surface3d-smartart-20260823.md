# FreeP Wave186 parity evidence

Date: 2026-08-23
Source: `7bc01053a9` (`codex/parity-wave186-freep-20260823`), corpus `1280x720`.

## Selection and experiment

The measured maximum Avalonia/Office residual was `25-chart-surface3d-view3d/slide-01.png`.
Fresh baseline values were WPF/Office `2.7438%`, Avalonia/Office `2.6220%`, and WPF/Avalonia `1.0805%`.
Avalonia was already below WPF, so the shared Surface3D projection was not changed. A bounded Avalonia host experiment removed the `SurfaceFacet` pen; the output remained byte-identical (`6F0C54BF76DB4CE5091E985504C408A30B78F8E4AE1F8D01B1C6BF94496C3483`) with the same three metrics. The experiment was reverted.

The shared planner and both chart execution paths were left unchanged. Their source hashes remain:

| File | Git blob hash |
| --- | --- |
| `freep/FreeP.App.Presentation/ChartRenderPlanner.cs` | `499f957138cb5489f010c99f6ff6cf62e94339fb` |
| `freep/FreeP.App.Presentation/Core/ChartRenderCommandPlanner.cs` | `509d558bda261c0b1b72f85d7a6f84ed58dd5e0e` |
| `freep/FreeP.App.Rendering.Avalonia/SlideCanvas.cs` | `7bf7512ba7419f9ea4b7b5ee3631ef89b7311eb7` |
| `freep/FreeP.App.Rendering.Avalonia/SlideCanvas.ChartExecution.cs` | `1539b63e719b4c449d78b3c834e6208e65333cae` |
| `freep/FreeP.App.Rendering.Wpf/SlideCanvas.ChartExecution.cs` | `4a7ba8be3ed7f167d3aa1dbbf3f67409b588cb4d` |

## Accepted correction

The fallback for the unsupported cached `vList6` SmartArt route now applies the measured Office geometry: right-arrow `adj2=18000` and rounded-rectangle `adj=18000`. The correction is limited to that cache layout, preserving ordinary right arrows and rounded rectangles.

| Metric | Before | After | Delta |
| --- | ---: | ---: | ---: |
| WPF/Office, slide 10 | `2.5120%` | `1.7356%` | `-0.7764 pp` |
| Avalonia/Office, slide 10 | `2.3744%` | `1.5956%` | `-0.7788 pp` |
| WPF/Avalonia, slide 10 | `1.6288%` | `1.6302%` | `+0.0014 pp` |

The unchanged SmartArt slide 01 hashes are WPF `60D8665F5991BB7263798175675EA4894E40666A8DF16F211A6D808B7CB41AE6` and Avalonia `10DDC72669E2BE885C63F7BA2898C1C53C3F280378EE9000A5E7EAAA5156133C` before and after. The full non-Surface chart control corpus was also byte-stable: all four `06-charts` WPF and all four Avalonia slide hashes matched between the detached pre-change render and Wave186.

`06-charts` WPF control hashes by slide: `9C57F2F0A9EF6722913F729A87FE48A51AB98CCDA94F1D14809BFF1A45166C5D`, `F07E600FBB6A14EFD07D079D976E17CB162208BD386D4FE4592471B9CE0E0F92`, `339CE799AE26D71F7E6862A060524A67C22FA75C8D34E21B1C95BBBAD33D7B44`, `45E87AF8D2D96C5A0890A76E202F9863D85C5056496CA7030E0235D7D1B2DF3D`. Avalonia: `2802671F4CB8F4D1F67581AC66D775984DF7CC044C145967EDB0A09366542722`, `8626B6FEFE6DC7F7D9D06BC277CFDE0C208AD5A29A7276F7BD15BD1F6DC15628`, `AC1220031F60CA1604B1025891BD846774E038047725181331F043742B6AFA8D`, `D995EC1DE5495DE43B06485EF8CB6723975FDADC67996EA3CB3CB3F4B1BBAE3D`.

The authoritative recalibration JSON applies only these exact slide-10 deltas. The resulting corpus averages are WPF `1.0447%`, Avalonia `1.0124%`, and renderer pair `0.6248%`; maxima are unchanged.

## Verification and residuals

- `FreeP.RenderCompare` Release build passed with zero warnings and errors.
- Presentation focused tests: 41 passed, including `SmartArtCachedVerticalArrowParityTests`.
- Avalonia focused tests: 14 passed, including existing SmartArt live-renderer and Aptos raster contracts.
- Remaining largest residuals are the shared Surface3D camera/mesh comparison on slide 25 and the cached `IncreasingCircleProcess` SmartArt/text residual on slide 09.
