# FreeP Wave199: Aptos Resource/Raster Diagnostic

Date: 2026-08-29
Status: rejected diagnostic; no production renderer change retained
Base: `4760be18736bf14affc66746b450ad093e54a6bf`

## Scope

This slice converged the unresolved fixed-size Aptos/text-raster hypothesis for deck17 (`17-bullets-autofit.pptx`). The decisive target was slide02, with slide01 used as the control. Each candidate was compared against the authoritative PowerPoint reference and the WPF/Avalonia pair. The production source was restored to the accepted route before this diagnostic was recorded.

## Accepted route and gates

| State | Slide01 Avalonia/Office | Slide01 WPF/Avalonia | Slide02 Avalonia/Office | Slide02 WPF/Avalonia |
| --- | ---: | ---: | ---: | ---: |
| Accepted production | 0.8339% | 0.8439% | 2.4820% | 2.8755% |
| Body-only Liberation Sans | 0.8339% | 0.8439% | 2.5009% | 2.8238% |
| Body + shape-title Liberation Sans | 0.8134% | 0.8590% | 2.4802% | 2.7992% |
| Global Liberation Sans | 0.8171% | 0.8591% | 2.4802% | 2.7992% |

The body-only artifact worsens the decisive Office target. The body-plus-title and global artifacts improve slide02 Office distance, but fail the recomputable slide01 cross-renderer control. Therefore none is safe to retain. These names are historical probe labels: the PNG pixels are tracked and auditable, but no retained patch or generation log independently binds a label to its temporary renderer source.

## Candidate findings

- The historical claim that the host had no native Aptos resource is downgraded to an unverified observation because the host-font inventory was not retained.
- `TextHintingMode.Full` remains independently checkable against the referenced Avalonia API: the enum has no `Full` member.
- Global Calibri and Carlito both regress the decisive target.
- Liberation Sans is the closest retained artifact on slide02, but its slide01 WPF/Avalonia control regresses.
- Raising the scoped fixed-body scale from `0.930` to `0.950` materially worsens slide02.

The former 18-slide before/after averages are removed. The 18 Office references are durable and inventoried in [broader-controls.json](evidence/freep-wave199-deck17-aptos-resource-raster-20260829/broader-controls.json), but zero corresponding candidate control renders were retained, so no broader numerical comparison is independently recomputable.

## Decision

Reject the retained pixel artifacts and preserve the production route: Aptos/Aptos Display resolve to Arial; fixed-size Aptos body scale is `0.930`; rendering uses Antialias, Light hinting, and Unaligned baseline pixel alignment. No `SlideCanvas` production file changed in Wave199.

The retained PNGs and exact measurements are in [metrics.json](evidence/freep-wave199-deck17-aptos-resource-raster-20260829/metrics.json), with image hashes in [images.json](evidence/freep-wave199-deck17-aptos-resource-raster-20260829/images.json). [references.json](evidence/freep-wave199-deck17-aptos-resource-raster-20260829/references.json) binds the tracked corpus, Office references, accepted Avalonia baseline, and WPF baseline. The focused test recomputes every accepted and candidate target metric from those pixels using the `FreeP.RenderCompare/ImageDiff.cs` semantics and evaluates every recorded rejection gate.

## Verification boundary

Pixel values are independently auditable, but candidate identity and generation remain `not-independently-proven`: the temporary source probes were restored before commit and no candidate patch hash or generation log was captured. Evidence was generated with the Avalonia headless renderer on the Windows host and measured against the authoritative WPF/PowerPoint corpus. Docker was available, but no FreeP image or container was present, so this slice does not claim a Linux runtime render. The next investigation must obtain an independently measurable and source-linked Aptos resource or host glyph-raster configuration.

## Verification

Focused test:

```text
dotnet test freep/FreeP.App.Rendering.Avalonia.Tests/FreeP.App.Rendering.Avalonia.Tests.csproj --configuration Release --no-restore --filter "FullyQualifiedName~Wave199Deck17AptosResourceRasterEvidenceTests|FullyQualifiedName~SlideCanvasAptosRasterPolicyTests"
```
