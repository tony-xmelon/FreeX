# Sheet Tabs And Backstage Parity Slice - 2026-06-07

Scope: sheet-tab context menu and sheet-tab navigation-arrow behavior, integrated into the parent parity branch after reviewing the completed sheet-tabs/backstage worker.

Validated behavior:
- Sheet tab context menu now follows Excel order more closely: Insert, Delete, Rename, Move or Copy, disabled View Code, Protect Sheet, Tab Color, Hide, Unhide, Select All Sheets, and Ungroup Sheets.
- Non-Excel shortcut entries Duplicate, Move Left, and Move Right were removed from the visible sheet-tab context menu. Duplication remains available through Move or Copy with Create a copy.
- Right-clicking either sheet-tab navigation arrow opens the Activate dialog for visible sheets, even when the specific arrow cannot scroll further but the tab strip can scroll.
- Same-workbook Move or Copy, Activate Sheet, and focused sheet-tab keyboard access remain covered by the existing dialog/planner/harness tests in this branch.

Verification:
- `dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --configuration Debug --no-restore --filter "FullyQualifiedName=FreeX.App.Host.Tests.MainWindowSheetTabKeyboardTests.MenuKeyOnFocusedSheetTab_OpensSheetTabContextMenuWithFocusAndAccessKeys" --logger "console;verbosity=minimal" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1` passed: 1/1.
- `dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --configuration Debug --no-restore --filter "FullyQualifiedName=FreeX.App.Host.Tests.LocalizationUsageTests.AppSourceLocalizationKeys_AllExistInNeutralResources|FullyQualifiedName=FreeX.App.Host.Tests.LocalizationUsageTests.AppXamlUserFacingText_UsesLocalizationResources" --logger "console;verbosity=minimal" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1` passed: 2/2.
- `dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --configuration Debug --no-build --filter "FullyQualifiedName~MainWindowSheetTabKeyboardTests|FullyQualifiedName~SheetTabDialogTests|FullyQualifiedName~MoveOrCopySheetPlannerTests" --logger "console;verbosity=minimal"` passed: 19/19.

Remaining gaps:
- Cross-workbook/new-workbook Move or Copy targets remain deferred.
- Live foreground screenshot evidence for pointer-only flows and drag reorder is still needed.
