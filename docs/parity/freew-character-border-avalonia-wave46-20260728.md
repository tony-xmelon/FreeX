# FreeW Character Border Avalonia Parity - Wave 46

## Resolved mismatch

WPF presents Character Border as an explicit twelve-color palette with a `No
Border` action. Avalonia previously applied a fixed black border whenever the
top-level command ran. The Avalonia Font ribbon now exposes the same color
choices and only changes selected runs after an explicit choice.

Every palette entry creates the same 0.5-point single-line `ParagraphBorder`
used by the WPF command. `No Border` clears the existing border through the
shared `DocumentView.SetCharacterBorder` route, retaining undo/redo and DOCX
round-trip behavior.

## Validation

Build:

`dotnet build freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1`

Result: 0 warnings, 0 errors.

Focused tests:

`dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release --no-build --filter "FullyQualifiedName~ParagraphShadingParityTests|FullyQualifiedName~CommandRegistryTests.Character_border_and_shading_commands_apply_model_run_formatting" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1`

Result: 7 passed, 0 failed, 0 skipped.

## Residual

The command mirrors the existing WPF color picker, which itself emits only a
single 0.5-point border style. Richer border line styles remain supported by the
shared model and DOCX package path but are not exposed by either host command.
