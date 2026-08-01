# Shared Dialog Visual Parity Wave 90

Date: 2026-08-01
Authority: FreeW WPF
Scope: shared Avalonia compact dialog chrome and FreeW Avalonia dialog tests

## Before State

The authoritative generated FreeW report was unchanged at the start of this slice:

- `170` genuine visual mismatches
- `13` visual passes
- `96` Avalonia extensions
- `4` state-not-applicable rows
- `167` of the genuine mismatches were same-size captures in the Wave 90 triage

The highest-delta same-size cluster was Legal Notices: the long legal-notice tabs measured
`20.0731%` to `21.5048%` changed pixels and `21.734` to `23.450` mean channel delta in the
targeted rerun. About measured `13.2345%` changed pixels and `16.034` mean channel delta.

Paired images showed colored text fringes in Avalonia dialog labels and read-only document fields,
while the WPF authority used the grayscale-compatible dialog rendering path. Source audit also
found that shared Avalonia descendant normalization unconditionally replaced local `TextBlock`
font family, size, and foreground values on window open. WPF implicit styles supply defaults without
overriding local hierarchy, hint, and link typography.

## Correction

`AvaloniaCompactDialogChrome.ApplyWindow` now sets `TextRenderingMode.Antialias` for every shared
compact dialog window. This removes the default subpixel color fringes from the shared dialog
surface and matches the existing FreeW `FontDialog`, `ParagraphDialog`, and document-view policy.

`ApplyDescendantChrome` now applies shared typography and foreground only when the `TextBlock`
property is not explicitly set. This preserves local WPF-authority hierarchy and hint styling while
keeping plain labels on the shared Windows dialog defaults.

## Targeted Paired Evidence

The same temporary 14-route inventory was captured before and after on 2026-08-01. WPF was
captured once and reused as the authority for both comparisons; both hosts rendered `14/14`
scenarios with no unsupported rows. Raw PNGs and manifests were kept outside the repository under
`%TEMP%\freex-wave90-slice`.

Commands:

```powershell
dotnet run --project freew/tools/FreeW.DialogVisualHarness.Wpf/FreeW.DialogVisualHarness.Wpf.csproj -c Release --no-restore -- --inventory %TEMP%/freex-wave90-slice/inventory.json --output %TEMP%/freex-wave90-slice/before-wpf
dotnet run --project freew/tools/FreeW.DialogVisualHarness.Avalonia/FreeW.DialogVisualHarness.Avalonia.csproj -c Release --no-restore -- --inventory %TEMP%/freex-wave90-slice/inventory.json --wpf-authority %TEMP%/freex-wave90-slice/before-wpf/wpf_dialog_capture_manifest.json --output %TEMP%/freex-wave90-slice/before-avalonia
dotnet run --project freew/tools/FreeW.DialogVisualHarness.Avalonia/FreeW.DialogVisualHarness.Avalonia.csproj -c Release --no-restore -- --inventory %TEMP%/freex-wave90-slice/inventory.json --wpf-authority %TEMP%/freex-wave90-slice/before-wpf/wpf_dialog_capture_manifest.json --output %TEMP%/freex-wave90-slice/after-antialias-avalonia
dotnet run --project freew/tools/FreeW.DialogVisualHarness/FreeW.DialogVisualHarness.csproj -c Release --no-restore -- compare --inventory %TEMP%/freex-wave90-slice/inventory.json --wpf %TEMP%/freex-wave90-slice/before-wpf/wpf_dialog_capture_manifest.json --avalonia %TEMP%/freex-wave90-slice/before-avalonia/avalonia_dialog_capture_manifest.json --output %TEMP%/freex-wave90-slice/before-compare
dotnet run --project freew/tools/FreeW.DialogVisualHarness/FreeW.DialogVisualHarness.csproj -c Release --no-restore -- compare --inventory %TEMP%/freex-wave90-slice/inventory.json --wpf %TEMP%/freex-wave90-slice/before-wpf/wpf_dialog_capture_manifest.json --avalonia %TEMP%/freex-wave90-slice/after-antialias-avalonia/avalonia_dialog_capture_manifest.json --output %TEMP%/freex-wave90-slice/after-antialias-compare
```

The comparator returned exit code `1` for both runs because the rows remain genuine mismatches;
no acceptance threshold or classification was changed.

| Measure | Before | After | Delta |
| --- | ---: | ---: | ---: |
| Average changed-pixel ratio, 14 pairs | 13.0114% | 12.5711% | -0.4403 pp (-3.4%) |
| Average mean channel delta, 14 pairs | 12.974 | 13.024 | +0.050 |
| About changed-pixel ratio | 13.2345% | 12.4696% | -0.7649 pp |
| Legal Notices changed-pixel ratio range | 10.1078%-21.5048% | 9.7355%-20.6876% | lower in all 6 states |

Representative per-scenario results:

| Scenario | Before changed | After changed | Before mean | After mean |
| --- | ---: | ---: | ---: | ---: |
| `about.initial` | 13.2345% | 12.4696% | 16.034 | 16.091 |
| `legal-notices.tab-legal-notices` | 20.0731% | 19.3315% | 22.284 | 22.481 |
| `legal-notices.tab-third-party-notices` | 21.5048% | 20.6876% | 23.450 | 23.660 |
| `options.initial` | 8.1182% | 8.0131% | 5.032 | 4.932 |
| `options.tab-auto-format-as-you-type` | 11.2884% | 10.9869% | 11.511 | 11.529 |

## Verification and Residuals

Passed:

- `dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release --no-restore --filter "FullyQualifiedName~CommonDialogChromeParityTests"`
- `13/13` focused shared dialog chrome tests, including explicit local typography preservation and shared antialias mode
- Targeted WPF/Avalonia paired capture: `14/14` on each host

Known test residual:

- The combined `CommonDialogChromeParityTests|DialogChromeDedupSourceGuardTests` invocation was `14 passed, 2 failed`. The two failures are pre-existing source-guard drift in unchanged code: the guard expects the obsolete exact `style.ControlHeight` tab setter and `FontParagraphDialogChrome.ApplyCheckBox` contract. They are not caused by this slice.

The full canonical report remains at `170` genuine mismatches because this slice intentionally ran a
targeted 14-pair comparison. Residual visual differences are still real: Avalonia and WPF use
different glyph metrics, tab/control templates, wrapping widths, scrollbars, focus rendering, and
dialog geometry. The mean channel delta did not improve in aggregate, so this is a changed-pixel
reduction only; the report does not claim full parity.
