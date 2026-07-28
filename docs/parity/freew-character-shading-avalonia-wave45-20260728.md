# FreeW Character Shading Avalonia Parity - Wave 45

## Resolved mismatch

WPF presents Character Shading as an explicit palette with a `No Color` action.
Avalonia previously applied a fixed light-yellow shading whenever its top-level
command ran. The Avalonia Font ribbon now exposes the same palette choices and
only changes selected runs after an explicit swatch or clear choice.

The palette commands use the existing `DocumentView.SetCharacterShading` route,
so the model, undo/redo behavior, rendering, and DOCX `w:shd` round trip remain
shared with the WPF implementation.

## Validation

Focused Avalonia registry and parity tests passed:

`dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release --no-restore --filter "FullyQualifiedName~ParagraphShadingParityTests|FullyQualifiedName~CommandRegistryTests.Character_border_and_shading_commands_apply_model_run_formatting" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1`

Result: 5 passed, 0 failed, 0 skipped.

## Residual

Character Border remains a separate style-aware command parity task. This change
does not alter its existing fixed default border behavior.
