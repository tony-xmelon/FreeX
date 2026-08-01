# FreeW Backstage Visual Parity Wave 94

Date: 2026-08-01

## Scope

This slice continues the WPF-authority Backstage visual lane for the five
paired surfaces reviewed in Wave 93:

- `backstage-home.open`
- `backstage-export.open`
- `backstage-open.open`
- `backstage-save-as.open`
- `backstage-print.open`

The implementation change is limited to the Open pane. The WPF builder in
`freew/FreeW.App.Host/Backstage/BackstageView.cs` remains the authority.

## Implementation

- Anchored the Avalonia Open `TabControl` to the left edge. Before this fix,
  the native template centered its 640px control in the 523px constrained
  viewport, producing a realized `Bounds.X` of `-58` and clipping the first
  tab label and recent-file rows.
- Matched the WPF four-pixel input/content inset for the Open search box and
  selected tab body while preserving the existing native selected-content
  host, vertical-only scroll viewer, tab selection refresh, automation IDs,
  callbacks, and keyboard/focus lifecycle.
- Added headless assertions for the left tab origin, selected-body inset,
  search-box margin, tab labels, selected content, and attached-window host
  normalization.

## Fresh Evidence

The focused paired evidence is under:

`C:\Users\anton\AppData\Local\Temp\freex-wave94-freew-backstage`

- WPF authority: `wpf-open-v2/wpf_dialog_capture_manifest.json`
- Avalonia final: `avalonia-open-final/avalonia_dialog_capture_manifest.json`
- Comparison: `compare-open-final/freew_dialog_visual_comparison.json`
- Final pair images are both 560x600 at 96 logical DPI and pass the harness
  content gates.

The task's current pre-edit Open evidence was approximately `20.886%`
changed pixels. The fresh Wave 94 Open pair reports `18.991%` changed pixels,
`16.754` mean absolute channel delta, and pHash distance `9`. The comparison
classifies the row as `genuine-visual-mismatch`; the metric is reported as
evidence, not as a claim of complete native-template parity.

## Residuals

Avalonia and WPF still differ in native control templates and text
rasterization. The fixed 560x600 viewport still clips the far-right portion
of intentionally long recent-file paths, and the Open row remains a genuine
visual mismatch. The other four Backstage surfaces remain at their Wave 93
evidence metrics and were not regenerated in this focused Open slice.

## Verification

- `dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release --no-restore --filter FullyQualifiedName~FreeW.App.Avalonia.Tests.BackstageViewTests --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1` - 35 passed.
- `dotnet build freew/tools/FreeW.DialogVisualHarness.Wpf/FreeW.DialogVisualHarness.Wpf.csproj --configuration Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1` - succeeded, 0 warnings, 0 errors.
- `dotnet build freew/tools/FreeW.DialogVisualHarness.Avalonia/FreeW.DialogVisualHarness.Avalonia.csproj --configuration Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1` - succeeded, 0 warnings, 0 errors.
- Focused WPF authority capture - 1/1 captured.
- Focused Avalonia final capture - 1/1 captured.
- Focused comparison - 1/1 paired row captured and classified `genuine-visual-mismatch`; the comparison tool returned its expected non-zero mismatch status.
