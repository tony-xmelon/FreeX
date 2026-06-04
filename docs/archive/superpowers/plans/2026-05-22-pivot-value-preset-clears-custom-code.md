# Pivot Value Preset Clears Custom Code

## Goal

Prevent stale custom value-field number-format codes from overriding a newly selected built-in preset in the PivotTable Value Field Settings dialog.

## Decisions

- Keep the hidden `NumberFormatCodeBox` as the custom-code handoff from the nested Format Cells dialog.
- Clear that hidden custom code when `NumberFormatPresetBox` selection changes to a built-in preset, so OK resolves the visible preset ID instead of promoting the stale code to custom ID 164.
- Initial dialog load remains safe because existing custom code is assigned after the preset index is initialized.

## Verification

- Red: `dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --no-restore -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "PivotValueFieldSettingsDialog_PresetSelectionClearsStaleCustomFormatCode" -v minimal` failed because the stale custom code remained after selecting Currency.
- Green: `dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --no-restore -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "PivotValueFieldSettingsDialog_PresetSelectionClearsStaleCustomFormatCode" -v minimal` passed 1 test.
