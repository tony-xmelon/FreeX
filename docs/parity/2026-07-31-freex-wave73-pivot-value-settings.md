# FreeX Wave73 Pivot Value Field Settings

## Scope

The Avalonia Value Field Settings dialog was compared with the WPF route for
Summarize Values By, Show Values As validation, Number Format state, and
apply/cancel behavior.

## Change

The Avalonia Show Values As apply path now resolves validation errors through
the shared validation plan and `UiText`, matching WPF's localized messages for
missing base fields and base items. The dialog still applies changes only on
OK and leaves the pivot unchanged on Cancel. On validation failure it now
selects the Show Values As tab and restores WPF's invalid-input focus target:
the base-field combo when no base field is selected, otherwise the base-item
textbox with its text selected.

## Verification

`dotnet test tests\\FreeX.App.Avalonia.Tests\\FreeX.App.Avalonia.Tests.csproj --configuration Release --filter "FullyQualifiedName~PivotValueFieldSettings"`

Result: 18 passed, 0 failed, 0 skipped.

## Residuals

This slice did not run Docker or physical Linux capture. Visual evidence and
physical interaction verification remain Wave73 integration responsibilities.
