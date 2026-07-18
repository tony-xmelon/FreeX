# FreeP Avalonia WordArt metal material sheen

Date: 2026-07-18

## Scope

The shared text-effect planner already emits a `MaterialHighlight` pass for
imported WordArt whose DrawingML 3-D material is `metal`. WPF consumes that
pass; Avalonia previously skipped it, leaving the imported ArchUp face without
PowerPoint's cool upper-face sheen. Avalonia now paints the existing shared
highlight brush after the face fill. No planner, WPF, soft-edge, or non-metal
route changed.

## Matched COM evidence

Fresh 1280x720 PowerPoint export and rebuilt Release render artifacts were
used for both captures:

| Backend / ROI | Before | Candidate |
| --- | ---: | ---: |
| Avalonia whole page | 1.5077% | 1.5019% |
| Avalonia ArchUp `(690,215)-(1130,335)` | 4.1547% | 4.0520% |
| Avalonia ArchUp tight `(718,227)-(1096,315)` | 6.4243% | 6.2614% |
| WPF whole page | 1.3392% | 1.3392% |
| WPF ArchUp | 2.3849% | 2.3849% |

The fresh candidate PowerPoint export was 1/1. The `11-bevel3d` WPF and
Avalonia PNGs were SHA-256 byte-identical to the pre-candidate controls, as
were both `08-effects` control PNGs.

## Verification

- `WordArtTests`: 30/30
- `dotnet build tools/FreeP.RenderCompare/FreeP.RenderCompare.csproj --configuration Release --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1`: 0 warnings, 0 errors
- Fresh `13-wordart`, `11-bevel3d`, and `08-effects` COM comparisons completed.
- Provenance: same-host WPF/Avalonia render and PowerPoint COM export.

Process rule: when a shared effect plan already has an evidence-backed host
implementation, enable the equivalent pass in the other host only after
scoring the target material ROI and requiring non-material controls to remain
byte-stable.
