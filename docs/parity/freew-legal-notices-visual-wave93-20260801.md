# FreeW Legal Notices Visual Parity Wave 93

Date: 2026-08-01  
Authority: fresh FreeW WPF `SharedLegalNoticesDialog` captures  
Scope: FreeW Avalonia Legal Notices dialog, four long-document tab states at 620x600

## Implementation

The Avalonia Legal Notices adapter now keeps the WPF tab/content join aligned by applying a
local two-pixel header inset and a negative selected-pane top margin with a one-pixel bottom
correction. The close action is explicitly 84 px wide while retaining default and cancel behavior.
Avalonia's Consolas raster metrics use a 12.1 px host compensation with the WPF-authority 16 px
line height so the long notice paragraphs wrap more closely without changing the shared WPF
metrics. Existing visible-scrollbar, read-only, copy, keyboard, and selected-tab behavior remains
intact.

## Fresh Four-State Evidence

The WPF authority and Avalonia final captures were both fresh on this branch. Every state rendered
at 620x600; WPF captured 4/4, Avalonia captured 4/4, and no row was unsupported or content-gate
invalid. The comparator thresholds and classifications were unchanged.

| State | Baseline changed | Final changed | Delta | Baseline mean | Final mean |
| --- | ---: | ---: | ---: | ---: | ---: |
| `tab-legal-notices` | 19.8567% | 19.4121% | -0.4446 pp | 22.452 | 21.369 |
| `tab-privacy-notice` | 17.0145% | 16.6530% | -0.3616 pp | 18.860 | 18.120 |
| `tab-third-party-notices` | 20.0780% | 19.8530% | -0.2250 pp | 23.437 | 22.445 |
| `tab-third-party-license-texts` | 19.0567% | 18.8288% | -0.2280 pp | 21.671 | 20.558 |
| **Average** | **19.0015%** | **18.6867%** | **-0.3148 pp** | **21.605** | **20.623** |

Raw captures and the paired report are under `%TEMP%\\freex-wave93-legal`:

- `final-wpf/wpf_dialog_capture_manifest.json`
- `candidate-avalonia-1210/avalonia_dialog_capture_manifest.json`
- `candidate-compare-1210/freew_dialog_visual_comparison.json`

All four rows remain `genuine-visual-mismatch`: the remaining delta is real cross-framework
glyph rasterization, native scrollbar/template rendering, and focus/chrome pixel variation, not
missing content or a manufactured threshold pass.

## Verification

Focused runtime tests passed 3/3:

```text
dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release --no-restore --filter "FullyQualifiedName~LegalNoticesDialogVisualParityTests"
```

The focused test set covers all packaged tab metadata, text metrics, visible scrolling, read-only
keyboard behavior, default/cancel close metadata, selected-tab lifecycle, and scroll-offset
persistence when switching among the four long-document tabs.
