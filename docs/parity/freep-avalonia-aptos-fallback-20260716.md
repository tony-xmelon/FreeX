# FreeP Avalonia Aptos fallback parity - 2026-07-16

## Target

Imported PowerPoint decks use the Office theme's `Aptos` minor Latin font for
regular body text. This host does not expose Aptos to Avalonia, and its native
fallback is measurably wider than the PowerPoint baseline. The correction is
limited to Avalonia's `FormattedText` path; WPF keeps its existing fallback and
the imported `Aptos Display` title/bullet font is unchanged.

## Change

`SlideCanvas.ResolvePowerPointFontFamily` maps only `Aptos` to the locally
available `Cambria` family when Avalonia builds a paragraph's formatted text.
The mapping is case-insensitive and is applied to the base typeface and every
run range. Other font names, including `Aptos Display`, pass through unchanged.

The choice is evidence-driven: a 24 px sample line measures approximately
450.04 px through the unresolved host fallback, while PowerPoint COM reported a
326.505 pt paragraph bound (approximately 435.34 px at 96 DPI). Cambria measures
approximately 435.22 px for the same sample in WPF's ideal metrics and reduced
the Avalonia image diff without changing text-box geometry or applying runtime
font shrink.

## Evidence

| Corpus / slide | WPF before | Avalonia before | WPF after | Avalonia after |
| --- | ---: | ---: | ---: | ---: |
| `17-bullets-autofit` / 1 | 1.0779% | 1.1992% | 1.0779% | 1.0202% |
| `17-bullets-autofit` / 2 | 3.5904% | 3.8667% | 3.5904% | 3.7221% |
| `18-chart-types` / 1 | 0.6172% | 0.7094% | 0.6172% | 0.6154% |
| `18-chart-types` / 2 | 1.0170% | 1.0357% | 1.0170% | 1.0058% |
| `18-chart-types` / 3 | 1.2423% | 1.2690% | 1.2423% | 1.2161% |
| `18-chart-types` / 4 | 1.4018% | 1.4291% | 1.4018% | 1.3679% |

The PowerPoint references were exported at 1280x720 by the local COM harness.
Candidate artifacts are retained under:

- `artifacts/freep-bullet-avalonia-cambria-20260716/`
- `artifacts/freep-avalonia-cambria-control-20260716/`

## Verification

- `dotnet test freep\\FreeP.App.Rendering.Avalonia.Tests\\FreeP.App.Rendering.Avalonia.Tests.csproj --configuration Release --no-restore --filter "FullyQualifiedName~SlideCanvasLineSpacingTests"` - expected focused pass.
- `dotnet build tools\\FreeP.RenderCompare\\FreeP.RenderCompare.csproj --configuration Release --no-restore` - expected 0 warnings and 0 errors.
- `17-bullets-autofit.pptx` and `18-chart-types.pptx` were rendered through WPF and Avalonia and compared with PowerPoint COM exports at 1280x720.
