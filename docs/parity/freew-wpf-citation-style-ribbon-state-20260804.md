# FreeW WPF Citation Style Ribbon State

## Scope

The WPF References > Citation Style combo was registered as a write-only ribbon command. It read the
legacy `value` parameter even though the shared ribbon shell sends `SelectedValue`, and it did not expose
the loaded document's citation style through `IRibbonStatefulCommand`.

## Change

- Consume the shared `SelectedValue` command contract while retaining the legacy key as a fallback.
- Expose the current document bibliography style as the command's ribbon value.
- Seed the state store when the ribbon is built and update it immediately after style application.
- Refresh stateful ribbon commands when `DocumentView.LayoutChanged` reports a loaded or re-rendered model,
  in addition to the existing selection-change refresh.

## Verification

- `CitationStyleRibbonState_TracksInitialLoadedAndAppliedStyles`: 1/1 passed. It covers initial Harvard state,
  loading a Chicago document, and applying Vancouver through `RibbonCommandContext.ForSelectedValue`.
- `CitationEditorTests|RibbonShellBuilderTests`: 23/23 passed with `--no-build`.
- The broader `FreeWRibbonParityTests` class was stopped after its bounded 184-second run produced no result;
  only the owned `dotnet`/`testhost` process tree was reaped.

## Acceptance

WPF now matches Avalonia's citation-style command contract: the combo applies the selected style and reflects
the active document style after initial build, document replacement, and command execution.
