# FreeW About Visual Parity Wave 100

Date: 2026-08-01
Authority: FreeW WPF About dialog
Scope: shared About-specific WPF/Avalonia realization and FreeW About guard

## Change

The Avalonia About realization now uses measured WPF-authority corrections while preserving
the existing default/cancel and accessibility contracts:

- compensates the one-device-pixel WPF right-edge layout rounding in the About content root;
- gives the read-only document field the WPF leading inset;
- applies the measured `12.3` DIP text size after shared descendant normalization;
- uses the WPF focused field border (`#569DE5`) and neutral resting default-button border
  (`#ABADB3`), while keeping `IsDefault` and `IsCancel` true;
- restores the focused/normal field border on focus transitions.

WPF source and behavior were not changed.

## Paired Evidence

The pre-change capture was produced before the edits in this checkout at the same `560x600`
logical target. About `initial` and `populated` are identical because this route has no
state-dependent content; both rows were captured independently in the final run.

| Scenario | Before changed | After changed | Before mean | After mean | pHash |
| --- | ---: | ---: | ---: | ---: | ---: |
| `about.initial` | 41,898 / 336,000 (12.4696429%) | 38,489 / 336,000 (11.4550595%) | 16.0905804 | 14.0832411 | 2 -> 2 |
| `about.populated` | 41,898 / 336,000 (12.4696429%) | 38,489 / 336,000 (11.4550595%) | 16.0905804 | 14.0832411 | 2 -> 2 |

Change per paired row: `-3,409` changed pixels, `-1.0145833` percentage points, and
`-2.0073393` mean channel delta. The final rows remain `genuine-visual-mismatch`; this
slice does not claim pixel parity.

Final raw evidence is outside the repository under:

`C:\Users\anton\AppData\Local\Temp\FreeW-Wave100-about-final-compare-both`

## Verification

Build:

```powershell
dotnet build freew/tools/FreeW.DialogVisualHarness.Avalonia/FreeW.DialogVisualHarness.Avalonia.csproj -c Release --no-restore -m:1
```

Result: succeeded, 0 warnings, 0 errors.

Focused tests:

```powershell
dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj -c Release --no-restore --filter FullyQualifiedName~WpfAuthoritySurfaceParityTests --logger "console;verbosity=minimal" -m:1
dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj -c Release --no-build --no-restore --filter FullyQualifiedName~CommonDialogChromeParityTests --logger "console;verbosity=minimal" -m:1
dotnet test tests/FreeX.App.Host.Tests/FreeX.App.Host.Tests.csproj -c Release --filter FullyQualifiedName~AboutDialogTests --logger "console;verbosity=minimal" -m:1
```

Results: FreeW About authority `13/13`, shared chrome `13/13`, and unaffected FreeX WPF About
guard `1/1`.

Capture commands:

```powershell
dotnet run --project freew/tools/FreeW.DialogVisualHarness.Wpf/FreeW.DialogVisualHarness.Wpf.csproj -c Release --no-build -- --inventory docs/parity/freew-dialog-harness/freew_dialog_evidence_inventory.json --scenario wpf.about.initial --output $env:TEMP/FreeW-Wave100-about-final-wpf-initial
dotnet run --project freew/tools/FreeW.DialogVisualHarness.Wpf/FreeW.DialogVisualHarness.Wpf.csproj -c Release --no-build -- --inventory docs/parity/freew-dialog-harness/freew_dialog_evidence_inventory.json --scenario wpf.about.populated --output $env:TEMP/FreeW-Wave100-about-final-wpf-populated
dotnet run --project freew/tools/FreeW.DialogVisualHarness.Avalonia/FreeW.DialogVisualHarness.Avalonia.csproj -c Release --no-build -- --inventory docs/parity/freew-dialog-harness/freew_dialog_evidence_inventory.json --scenario avalonia.about.initial --wpf-authority $env:TEMP/FreeW-Wave100-about-final-wpf-initial/wpf_dialog_capture_manifest.json --output $env:TEMP/FreeW-Wave100-about-final-avalonia-initial
dotnet run --project freew/tools/FreeW.DialogVisualHarness.Avalonia/FreeW.DialogVisualHarness.Avalonia.csproj -c Release --no-build -- --inventory docs/parity/freew-dialog-harness/freew_dialog_evidence_inventory.json --scenario avalonia.about.populated --wpf-authority $env:TEMP/FreeW-Wave100-about-final-wpf-populated/wpf_dialog_capture_manifest.json --output $env:TEMP/FreeW-Wave100-about-final-avalonia-populated
dotnet run --project freew/tools/FreeW.DialogVisualHarness/FreeW.DialogVisualHarness.csproj -c Release --no-build -- compare --inventory docs/parity/freew-dialog-harness/freew_dialog_evidence_inventory.json --wpf $env:TEMP/FreeW-Wave100-about-final-wpf-manifest.json --avalonia $env:TEMP/FreeW-Wave100-about-final-avalonia-manifest.json --output $env:TEMP/FreeW-Wave100-about-final-compare-both
```

Each WPF and Avalonia capture completed `1/1`. The comparator reports exit code `1` when
genuine mismatches remain; its final output contains exactly the two captured About rows and
no invalid About capture.

## Residuals

The remaining delta is genuine: Avalonia/Skia and WPF use different glyph rasterization and
line-box behavior, and Avalonia truthfully identifies its host in the `Built with .NET 10 and
Avalonia.` line while WPF says WPF. The final comparison keeps those differences visible rather
than relabeling them as a pass.
