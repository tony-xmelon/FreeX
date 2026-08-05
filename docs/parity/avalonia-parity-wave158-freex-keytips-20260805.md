# Avalonia Parity Wave 158: FreeX configurable QAT keytips

## Closed gap

The WPF host is authoritative for the Quick Access Toolbar (QAT) access-key contract. Its
`MainWindow.QuickAccessToolbar` implementation assigns keytips by persisted visible command order:
`1` through `9`, then `01`, `02`, and so on. Undo/Redo history-arrow buttons are separate controls and
do not receive command keytips. WPF also keeps the QAT keytip scope out of formula editing and Backstage,
consumes invalid continuations, and lets Alt/F10 restart a paused keytip scope.

### Absence evidence before the change

The WPF authority tests in `MainWindowRibbonKeyTipTests.QuickAccessToolbar.cs` explicitly covered a
custom ten-command QAT and expected keytips `1`, `2`, `3`, `4`, `5`, `6`, `7`, `8`, `9`, `01`.
Before this slice, Avalonia's `MainWindow.LegacyShortcutSequences.cs` only had the static catalog routes
for QAT positions 1-3, and its production `ExecuteQuickAccessKeyTip` enumerated the first three visible
buttons. The Avalonia test helper likewise rejected any QAT digit greater than 3. Thus a configured tenth
command had no production route, no visible badge, and no multi-digit continuation state.

## Implementation

- `MainWindow.CatalogContextMenus.cs` now assigns WPF-compatible visible-index keytips from the persisted
  `QuickAccessToolbarCatalog` order, renders badges on enabled QAT commands, and exposes the current
  keytip mapping only through test seams.
- `MainWindow.LegacyShortcutSequences.cs` adds a dynamic QAT keytip state machine for direct Alt entry
  and visible-keytip continuation, including `0` + digit routes, exact command dispatch through the
  existing QAT click workflow, Escape, invalid-input consumption, and Alt/F10 restart behavior.
- `MainWindow.DesktopChrome.cs` keeps QAT badges synchronized with the existing ribbon keytip visibility
  lifecycle.
- No WPF implementation or FreeW/FreeP code was changed.

## Evidence

WPF authority tests, run from this worktree after restore, passed **5/5**:

- `DirectAltQatKeyTips_InvokeUndoRedoQuickAccessToolbarCommands`
- `DirectAltQatKeyTips_NormalizeAttachedKeyTipMetadata`
- `TitleBarQuickAccessToolbar_PreservesConfiguredOrderKeyTipsAndChromeHitTesting`
- `CustomQuickAccessToolbar_RebuildsBelowRibbonAndRoutesCustomKeyTips`
- `QuickAccessToolbarCatalogKeyTips_AreUniqueAndPrefixSafe`

Avalonia production evidence passed **3/3** in `Wave158AvaloniaQuickAccessKeyTipParityTests`:

- custom ten-command QAT exposes `1`, `2`, and `01`, then invokes the real tenth `Calculate Sheet`
  workflow through `Alt+0, 1`;
- invalid and Escape continuations reset without invoking a command, and Alt restarts the visible scope;
- formula editing and Backstage exclude the QAT route without consuming the input.

The existing related Avalonia lanes also passed **19/19**:

- `AvaloniaLegacyShortcutSequenceTests` — 18/18
- `AvaloniaQuickAccessToolbarFunctionalParityTests` — 1/1

Focused verification command:

```text
dotnet test tests\FreeX.App.Avalonia.Tests\FreeX.App.Avalonia.Tests.csproj --configuration Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --filter "FullyQualifiedName~Wave158AvaloniaQuickAccessKeyTipParityTests|FullyQualifiedName~AvaloniaLegacyShortcutSequenceTests|FullyQualifiedName~AvaloniaQuickAccessToolbarFunctionalParityTests"
```

## Residuals

The QAT badge is rendered inside each Avalonia button rather than through the WPF root-level keytip
overlay, so exact pixel placement still belongs to the broader visual-parity pass. Native Linux/X11
keyboard delivery and Docker/VNC screenshot evidence were not exercised by this headless slice. The full
WPF `MainWindowRibbonKeyTipTests` fixture remains 65/68 in this environment because three unrelated
existing tests fail (Paste Special STA affinity, a Home menu state, and Page Layout margins); the five
QAT authority tests are green independently.
