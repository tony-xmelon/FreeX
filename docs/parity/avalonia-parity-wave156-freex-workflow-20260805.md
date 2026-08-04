# Avalonia Parity Wave 156: FreeX legacy Edit keytip workflow

## Closed gap

The WPF host preserves Excel's legacy `Alt+E, S` access-key continuation for Paste Special even
though the current visible ribbon has no Edit tab. The Avalonia host previously handled the
catalog-backed ribbon keytip matrix and the legacy `Alt+D, F, F` AutoFilter route, but had no
equivalent Edit continuation; `Alt+E` fell through and the following `S` was not consumed.

Avalonia now owns the same bounded host-local compatibility state:

- `Alt+E` or visible-keytip `E` enters an awaiting-Paste-Special state.
- `S` invokes the existing Avalonia Paste Special workflow and exits the state.
- `Escape` cancels it, and invalid continuations are consumed and reset like WPF.
- Formula editing, inline editing, Backstage, and other text-entry sources remain outside the
  legacy route and continue to the normal input pipeline.

The existing Avalonia Paste Special dialog and execution methods remain authoritative for the
platform-specific surface. No FreeW or FreeP files were changed, and no catalog command route was
duplicated or changed.

## Evidence

- WPF authority: `MainWindowRibbonKeyTipTests.LegacyAltEditPasteSpecialKeyTip_ES_RoutesToPasteSpecialAndClosesKeyTips` — **1/1 passed**.
- Avalonia paired behavior: `AvaloniaLegacyShortcutSequenceTests` — **16/16 passed**, including
  standalone-Alt and direct-Alt entry forms for `Alt+E, S`, state reset, and invocation of the
  existing Paste Special workflow.

Focused commands used:

```text
dotnet test tests\FreeX.App.Avalonia.Tests\FreeX.App.Avalonia.Tests.csproj --configuration Release --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --filter "FullyQualifiedName~AvaloniaLegacyShortcutSequenceTests"
dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --configuration Release --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --filter "FullyQualifiedName~MainWindowRibbonKeyTipTests.LegacyAltEditPasteSpecialKeyTip_ES_RoutesToPasteSpecialAndClosesKeyTips"
```

## Residuals

This closes the identified `Alt+E, S` route only. Broader physical foreground testing of the
Avalonia Paste Special dialog, native clipboard providers, and other non-catalog Excel legacy
access-key families remains outside this slice.
