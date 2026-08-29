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

The body-only candidate worsens the decisive Office target. The body-plus-title and global candidates improve slide02 Office distance, but fail the slide01 cross-renderer control and/or broader corpus gate. Therefore none is safe to retain.

## Candidate findings

- A native Aptos resource route was unavailable: no Aptos font files were installed on the host and no tracked repository font resource exists.
- `TextHintingMode.Full` is not a supported Avalonia API member, so that probe did not compile and produced no render.
- Global Calibri and Carlito both regress the decisive target.
- Liberation Sans is the closest substitute on slide02, but its 18-slide control corpus mean regresses from `1.454822%` to `1.469489%` (`+0.014667` percentage points), with 15 worsened states and 3 improved states.
- Raising the scoped fixed-body scale from `0.930` to `0.950` materially worsens slide02.

## Decision

Reject all probes and preserve the production route: Aptos/Aptos Display resolve to Arial; fixed-size Aptos body scale is `0.930`; rendering uses Antialias, Light hinting, and Unaligned baseline pixel alignment. No `SlideCanvas` production file changed in Wave199.

The retained PNGs and exact measurements are in [metrics.json](evidence/freep-wave199-deck17-aptos-resource-raster-20260829/metrics.json), with image hashes in [images.json](evidence/freep-wave199-deck17-aptos-resource-raster-20260829/images.json). Hashes prove the current image bytes only. Candidate generation is intentionally marked `not-independently-proven` because the temporary source probes were restored before commit and no candidate patch hash or generation log was captured.

## Verification boundary

Evidence was generated with the Avalonia headless renderer on the Windows host and measured against the authoritative WPF/PowerPoint corpus. Docker was available, but no FreeP image or container was present, so this slice does not claim a Linux runtime render. The next investigation must obtain an independently measurable supported Aptos resource or host glyph-raster configuration; this slice does not start that investigation.

## Verification

Focused test:

```text
dotnet test freep/FreeP.App.Rendering.Avalonia.Tests/FreeP.App.Rendering.Avalonia.Tests.csproj --configuration Release --no-restore --filter "FullyQualifiedName~Wave199Deck17AptosResourceRasterEvidenceTests|FullyQualifiedName~SlideCanvasAptosRasterPolicyTests"
```
