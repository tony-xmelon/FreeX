# FreeP PowerPoint COM full-corpus validation

Date: 2026-07-28  
Renderer/tool source: `main` at `6e426d353`
PowerPoint: local `PowerPoint.Application` COM automation  
Capture size: 1280x720

## Result

The checked-in RenderCompare corpus contains 26 decks and 43 slides. Every deck
opened and exported successfully through Microsoft PowerPoint, with no repair
dialog or open failure. Reference matching was completed against all 43 checked-in
PNG references. The long batch completed decks 01-24 before PowerPoint automation
stalled; decks 25 and 26 were then rerun independently and matched successfully.
The stall was therefore a batch automation-lifetime issue, not a deck or package
failure.

- decks: **26/26 passed**
- slides: **43/43 exported and reference-matched**
- export failures: **0**
- repair-dialog or open failures: **0**
- reference diffs: **0**

| Deck | Slides | Result |
| --- | ---: | --- |
| `01-title-slide.pptx` | 1 | PASS |
| `02-autoshapes.pptx` | 1 | PASS |
| `03-mixed-text.pptx` | 1 | PASS |
| `04-picture.pptx` | 1 | PASS |
| `05-table.pptx` | 1 | PASS |
| `06-charts.pptx` | 4 | PASS |
| `07-customgeom.pptx` | 1 | PASS |
| `08-effects.pptx` | 1 | PASS |
| `09-smartart.pptx` | 1 | PASS |
| `10-motionpath.pptx` | 1 | PASS |
| `11-bevel3d.pptx` | 1 | PASS |
| `12-fills.pptx` | 1 | PASS |
| `13-wordart.pptx` | 1 | PASS |
| `14-smartart-live.pptx` | 4 | PASS |
| `15-picture-crop.pptx` | 3 | PASS |
| `16-bg-tabs-vtext.pptx` | 3 | PASS |
| `17-bullets-autofit.pptx` | 2 | PASS |
| `18-chart-types.pptx` | 4 | PASS |
| `19-chart-labels.pptx` | 3 | PASS |
| `20-columns-gradoutline.pptx` | 1 | PASS |
| `21-comments-notes.pptx` | 2 | PASS |
| `22-chart-baseline-depth.pptx` | 1 | PASS |
| `23-run-baseline.pptx` | 1 | PASS |
| `24-run-baseline-wrap.pptx` | 1 | PASS |
| `25-chart-surface3d-view3d.pptx` | 1 | PASS |
| `26-chart-surface3d-default-tall-frame.pptx` | 1 | PASS |

## Reproduction

```powershell
dotnet build tools\FreeP.RenderCompare\FreeP.RenderCompare.csproj --configuration Release
dotnet tools\FreeP.RenderCompare\bin\Release\net10.0-windows10.0.19041.0\FreeP.RenderCompare.dll `
  --powerpoint-corpus-validate tools\FreeP.RenderCompare\corpus `
  <output-directory> `
  --refs tools\FreeP.RenderCompare\corpus\pptx-ref `
  --width 1280 --height 720
```

The batch log and isolated rerun logs are retained in the operator's temporary
output directories. This validates PowerPoint COM open/export behavior and exact
matching against the checked-in PowerPoint reference surfaces; it does not claim
WPF/Avalonia visual parity. That comparison must pair these references with FreeP
renders and record per-deck and per-slide deltas.
