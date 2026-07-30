# FreeW Wave72 Table Properties Visual Parity

Date: 2026-07-31
Base: `e433af1aa9` (`origin/main`)
Route: `table-properties`
Authority: paired WPF capture; existing comparison thresholds unchanged

## Selection

The authoritative report at `docs/parity/freew-dialog-harness/freew_dialog_visual_comparison.json`
contains 170 genuine visual mismatches, 13 passes, 4 state-not-applicable rows, 96
Avalonia extensions, and zero semantic-mismatch rows. `table-properties` was selected as the
highest-confidence in-scope coherent family after excluding routes whose implementation lives
in shared code. It has seven paired states, no semantic differences, and one existing visual
pass. The WPF and Avalonia dialogs both expose the same four tabs, default/cancel actions,
focus targets, validation planner, and result application.

## Changes

- `freew/FreeW.App.Avalonia/TableDialogs.cs`
  - Applies the WPF action-row spacing of 14 px to the table-properties buttons.
  - Uses the WPF-neutral default-button border brush for the dialog's normal button state while
    retaining `IsDefault` and `IsCancel` behavior.
  - Adds the WPF checkbox leading inset to the table-properties checkbox controls.
- `freew/tools/FreeW.DialogVisualHarness.Avalonia/AvaloniaDialogRouteFactory.cs`
  - Removes Avalonia-only populated and validation mutations. The common harness population pass
    now supplies the same state to both hosts, as WPF already did.
- `freew/FreeW.App.Avalonia.Tests/WpfAuthoritySurfaceParityTests.cs`
  - Adds focused chrome assertions and a source guard preventing the route adapter from creating
    host-specific field values or validation state.

## Fresh paired evidence

The local capture used the seven `table-properties` states from the canonical inventory, with
fresh WPF authority and Avalonia Skia captures. Temporary evidence was written under
`%TEMP%\\freew-wave72-table-properties-20260731-b`; it was not added to the repository.

| State | Before ratio / mean | After ratio / mean | Classification | Semantic difference |
| --- | ---: | ---: | --- | --- |
| initial | 9.2119% / 6.7175 | 9.1271% / 6.6716 | genuine visual mismatch | none |
| populated | 9.2780% / 6.8179 | 9.1271% / 6.6716 | genuine visual mismatch | none |
| tab-cell | 6.6964% / 4.8618 | 6.6092% / 4.8138 | genuine visual mismatch | none |
| tab-column | 2.7295% / 2.1526 | 2.6515% / 2.1118 | pass | none |
| tab-row | 4.5557% / 3.7787 | 4.4842% / 3.7590 | genuine visual mismatch | none |
| tab-table | 9.2119% / 6.7175 | 9.1271% / 6.6716 | genuine visual mismatch | none |
| validation-error | 10.0577% / 7.5083 | 9.2405% / 6.8136 | genuine visual mismatch | none |

The seven-state average changed from 7.3916% / 5.5078 to 7.1952% / 5.3590. The largest
correction is the validation state: the previous Avalonia adapter displayed an extra validation
message and invalid indent value that the WPF authority did not display. This is now an honest
paired state rather than a platform-specific synthetic state.

## Residuals

Six states remain genuine visual mismatches. The remaining differences are primarily Avalonia
Fluent template behavior and Skia/WPF text rasterization: the default-button template still
surfaces its blue accent outline in the rendered Avalonia frame despite the local neutral brush
property, and compact tab-pane borders, text antialiasing, and control-template pixels differ.
No threshold was weakened and no row was relabeled as a pass. The `tab-column` pass remains a
useful control that the route geometry can match.

## Verification

```text
dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj -c Release --no-restore --filter "FullyQualifiedName~WpfAuthoritySurfaceParityTests|FullyQualifiedName~CommonDialogChromeParityTests|FullyQualifiedName~TablePropertiesDialogTests"
  24 passed, 0 failed

dotnet test freew/FreeW.App.Host.Tests/FreeW.App.Host.Tests.csproj -c Release --filter "FullyQualifiedName~TablePropertiesDialogTests"
  3 passed, 0 failed
```

## Physical Linux result

The existing real-dialog X11 lane was rerun after integration:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools/Run-FreeWTablePropertiesX11Validation.ps1 -Port 6722 -OutputDir artifacts/freew-wave72-table-properties-x11
```

Result: **passed**. The physical probe traversed Table, Row, Column, and Cell, returned to Table,
edited `IndentFromLeftPt` to `12`, invoked the real OK button, and verified the exact applied table
model in `artifacts/freew-wave72-table-properties-x11/`. The harness stopped and removed its
task-owned container.

The fresh seven-state WPF/Avalonia capture was also promoted into the canonical report. It retains
one pass and six genuine visual mismatches with zero semantic differences. Average changed pixels
improved from 7.3916% to 7.1952%, and mean channel delta improved from 5.5078 to 5.3590.
