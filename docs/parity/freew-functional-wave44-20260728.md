# FreeW Functional Wave 44

## Resolved mismatch

The WPF `freew.para-shading` command opens a palette, applies the selected
paragraph fill, and supports `No Color`. The Avalonia command was a fixed
`ToggleParagraphShading()` action, so it silently chose `#FFF2CC` or cleared
the shading instead of exposing the WPF choices.

Avalonia now exposes the WPF-authority swatches and `No Color` through the
Shading dropdown. Each palette command calls the existing undoable
`SetParagraphShading` model route, and the top-level command only opens the
menu.

## Changed files

- `freew/FreeW.Ribbon.Definitions/FreeWAvaloniaRibbonDefinition.cs`
  defines the Shading dropdown and palette command ids.
- `freew/FreeW.App.Avalonia/Ribbon/FreeWAvaloniaRibbonCommands.cs`
  registers the swatches and clear command against the shared document model.
- `freew/FreeW.App.Avalonia.Tests/CommandRegistryTests.cs`
  updates the focused paragraph shading route assertion.
- `freew/FreeW.App.Avalonia.Tests/ParagraphShadingParityTests.cs`
  exercises the Avalonia registry and pins the WPF palette authority.

## Validation

Focused command tests passed with the constrained single-process command:

`dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release --no-restore --filter "FullyQualifiedName~ParagraphShadingParityTests|FullyQualifiedName~CommandRegistryTests.Paragraph_border_and_shading_commands_apply_model_formatting"`

Result: 3 passed, 0 failed, 0 skipped.

## Residuals

This wave covers paragraph shading only. Character shading, character border,
and other command differences were inspected but are outside this focused
production fix. No visual raster comparison or full-suite validation was run.
