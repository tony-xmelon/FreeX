# FreeW Wave155 Thesaurus Insert and Copy Actions

Date: 2026-08-05  
Scope: FreeW WPF/Avalonia parity

## Gap selected

The parity scope recorded that Avalonia exposed synonym Replace over the shared Thesaurus plan while WPF also exposed Insert and Copy. This slice closes that direct functional gap without introducing a second host-local Thesaurus model.

## Implementation

`ThesaurusPresentationPlanner` now owns the canonical Insert tooltip/action contract, while retaining the old `ReplaceToolTip` alias for existing consumers. Avalonia uses the editor's command-bus-backed `CanReplaceCurrentProofingWord` and `ReplaceCurrentProofingWord` APIs, so Insert respects selection/caret position, protected/editing locks, undo, dirty notifications, and caret collapse. The visible pane refreshes through the existing document/caret refresh subscriptions.

Avalonia now renders separate Insert and Copy controls for every planned synonym. Insert is disabled when the current word cannot be replaced. Copy is disabled when no injected clipboard service or attached platform clipboard exists, and clipboard failures remain non-mutating. WPF now consumes the same shared Insert tooltip field and presents the matching Insert label.

## Verification

- `dotnet build freew\\FreeW.App.Avalonia\\FreeW.App.Avalonia.csproj -c Debug --disable-build-servers -m:1 -p:UseSharedCompilation=false -p:NodeReuse=false`: passed, 0 warnings, 0 errors.
- `dotnet test freew\\FreeW.App.Presentation.Tests\\FreeW.App.Presentation.Tests.csproj -c Debug --disable-build-servers -m:1 -p:UseSharedCompilation=false -p:NodeReuse=false --filter FullyQualifiedName~ThesaurusPresentationPlannerTests`: 2/2 passed.
- `dotnet test freew\\FreeW.App.Avalonia.Tests\\FreeW.App.Avalonia.Tests.csproj -c Debug --disable-build-servers -m:1 -p:UseSharedCompilation=false -p:NodeReuse=false --filter FullyQualifiedName~ThesaurusPaneParityTests`: 3/3 passed.
- `git diff --check`: passed.

## Remaining residuals

The platform clipboard remains dependent on Avalonia's attached `TopLevel.Clipboard`; headless and unattached surfaces honestly keep Copy disabled. Full physical clipboard and Excel/Word pairing evidence remain outside this focused source/test slice.
