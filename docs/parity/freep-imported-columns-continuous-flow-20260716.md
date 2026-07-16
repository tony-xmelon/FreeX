# FreeP imported text-column continuous flow parity

This slice compares the imported `20-columns-gradoutline.pptx` corpus deck against
PowerPoint COM at 1280x720. The deck combines a two-column text box with a
gradient outline shape.

## Change

- Added shared line-level column placement so a plain paragraph can continue
  across a `numCol` boundary instead of moving as an indivisible paragraph.
- Added matching WPF and Avalonia fragment layout for plain, non-autofit,
  single-run column text.
- Preserved the existing paragraph-level path for bullets, effects, tabs, math,
  stored font scaling, and runtime autofit cases.

## COM evidence

| Metric | Before | After |
| --- | ---: | ---: |
| WPF vs PowerPoint | 1.2081% | 1.1606% |
| WPF vs Avalonia | 0.8644% | 0.9375% |
| Avalonia vs PowerPoint | 1.0888% | 0.9432% |

The PowerPoint reference now has the same continuous-flow behavior as FreeP for
the corpus text box, including the final line crossing into column 2. The small
WPF/Avalonia delta increase is the expected renderer-specific text rasterization
difference; both renderers move closer to the PowerPoint reference.

## Verification

- `dotnet test freep/FreeP.App.Presentation.Tests/FreeP.App.Presentation.Tests.csproj --configuration Release --filter "FullyQualifiedName~TextLayoutPlannerTests|FullyQualifiedName~TextColumnsGradOutlineTests"`
  - 49 passed, 0 failed, 0 skipped.
- `dotnet build tools/FreeP.RenderCompare/FreeP.RenderCompare.csproj --configuration Release`
  - 0 warnings, 0 errors.
- Final COM comparison used:
  `dotnet tools/FreeP.RenderCompare/bin/Release/net10.0-windows10.0.19041.0/FreeP.RenderCompare.dll --avalonia-compare tools/FreeP.RenderCompare/corpus/20-columns-gradoutline.pptx ... --width 1280 --height 720`.
