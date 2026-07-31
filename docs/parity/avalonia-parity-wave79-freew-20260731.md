# FreeW Avalonia parity wave 79

## Selected functional gap

The View tab `freew.gridlines` and `freew.ruler` commands changed the live
Avalonia editor flags, but their registrations were plain `ActionRibbonCommand`
instances. That meant the actions worked while the ribbon could not show the
current checked state. The WPF authority registers both as stateful toggles:
`freew.ruler` uses `ToggleActionCommand` against the host visibility state, and
`freew.gridlines` uses the same command against `ShowPageGridlines`.

## Fix

Avalonia now registers both commands as `ToggleActionCommand` instances whose
state queries read `DocumentView.ShowGridlines` and `DocumentView.ShowRuler`.
The canonical commands and their existing compatibility aliases share the same
stateful command instance, so the button and alias stay synchronized.

## Verification

Focused Release test command:

`dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release --no-restore --filter FullyQualifiedName~ViewTabDepthTests --logger "console;verbosity=normal"`

Result: **23/23 passed**. The two focused toggle tests now assert the initial
unchecked state, checked state after execution, and cleared state after the
second execution, in addition to the existing editor-flag assertions.

## Scope and residuals

This slice closes checked-state parity for these two View toggles only. It does
not claim that every View command or every ribbon state query is complete. No
Docker, screenshot, or Microsoft Word/COM validation was required for this
model-and-command-state fix; visual styling and any remaining stateful command
differences remain separate work.
