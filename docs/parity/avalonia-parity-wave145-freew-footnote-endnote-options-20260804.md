# FreeW Avalonia Parity Wave 145: Footnote/Endnote Options Actions

Date: 2026-08-04

## Finding

`FootnoteEndnoteOptionsDialog` already uses the shared Avalonia action-row factory. Its `_OK` and
`_Cancel` content is wrapped in `AccessText`, so the product renders `OK` and `Cancel` without
visible mnemonic underscores and exposes `Alt+O` and `Alt+C`. The stale parity assertion compared
the template wrapper's `ToString()` value instead of its user-facing text.

## Change and evidence

The focused Footnote test now extracts `AccessText.Text` through the shell automation-name contract,
checks the wrapper and raw mnemonic content, and verifies rendered labels, automation names, and
access keys. The two directly related WPF-authority action assertions for Tabs and Page Setup use
the same semantic extraction. No dialog product source changed.

## Verification

- `dotnet restore freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --disable-parallel`: passed.
- `dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release --no-restore --filter "FullyQualifiedName~FootnoteEndnoteOptionsDialogVisualParityTests|FullyQualifiedName~TabsDialogWpfAuthorityParityTests|FullyQualifiedName~WpfAuthoritySurfaceParityTests" -m:1 -p:NodeReuse=false /nr:false --logger "console;verbosity=minimal"`: passed, 19/19.
