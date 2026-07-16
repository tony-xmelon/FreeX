# FreeP WordArt capitalization parity - 2026-07-16

## Target

`tools/FreeP.RenderCompare/corpus/13-wordart.pptx`, slide 1, compared with the checked-in PowerPoint export at 1280x720.

## Change

PowerPoint stores the Arch Up WordArt run with `a:rPr cap="all"`. FreeP previously discarded that run property, so both renderers displayed `Arch Up Text` instead of PowerPoint's `ARCH UP TEXT`.

The reader now retains DrawingML capitalization on the run model, the writer round-trips it, the model clone/edit paths preserve it, and the compositor applies the `all` value to the renderer-facing text. The existing shared effects path therefore receives the same uppercase glyph content in WPF and Avalonia.

## Evidence

The candidate renders and heatmaps are retained under:

- `artifacts/freep-wordart-caps-20260716/wpf/`
- `artifacts/freep-wordart-caps-20260716/avalonia/`
- `artifacts/freep-wordart-caps-20260716/wpf-diff.png`
- `artifacts/freep-wordart-caps-20260716/avalonia-diff.png`

| Backend | Previous mean diff | Candidate mean diff |
| --- | ---: | ---: |
| WPF | 2.0524% | 2.0549% |
| Avalonia | 2.4470% | 2.4897% |

The small metric increase is dominated by the remaining WordArt material, gradient, and reflection differences; the visible capitalization behavior now matches PowerPoint. The unchanged `17-bullets-autofit` control remained at WPF `1.0779%` / `3.5904%` and Avalonia `1.1992%` / `3.8667%` for slides 1 / 2.

## Verification

- `dotnet test freep\\FreeP.App.Presentation.Tests\\FreeP.App.Presentation.Tests.csproj --configuration Release --no-restore --filter "FullyQualifiedName~WordArtTests|FullyQualifiedName~TextLayoutPlannerTests" --logger "console;verbosity=minimal" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1` - passed, 63 tests.
- `dotnet build tools\\FreeP.RenderCompare\\FreeP.RenderCompare.csproj --configuration Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1` - passed, 0 warnings, 0 errors.
- WPF and Avalonia renders were generated and diffed against the checked-in PowerPoint reference at 1280x720.
