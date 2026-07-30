# FreeX Wave73 Pivot Value Field Settings

## Scope

The Avalonia Value Field Settings dialog was compared with the WPF route for
Summarize Values By, Show Values As validation, Number Format state, and
apply/cancel behavior.

## Change

The Avalonia Show Values As apply path now resolves validation errors through
the shared validation plan and `UiText`, matching WPF's localized messages for
missing base fields and base items. The dialog still applies changes only on
OK and leaves the pivot unchanged on Cancel.

## Verification

`dotnet test tests\\FreeX.App.Avalonia.Tests\\FreeX.App.Avalonia.Tests.csproj --configuration Release --filter "FullyQualifiedName~PivotValueFieldSettings"`

Result: 17 passed, 0 failed, 0 skipped.

## Residuals

This slice did not run Docker or physical Linux capture. Visual evidence and
physical interaction verification remain Wave73 integration responsibilities.
