# Selection Pane Object Rename

## Scope

Close the Selection Pane object-name editing gap by making rename edits model-backed and undoable instead of local
dialog-only text changes.

## Tasks

- [x] Add red command tests for object rename and undo across selection-pane object kinds.
- [x] Add red host tests for modeled names in the planner and rename changes in dialog results.
- [x] Add lightweight `Name` fields to charts, pictures, text boxes, and drawing shapes.
- [x] Add `RenameSelectionPaneObjectCommand` and route dialog rename changes through the command bus.
- [x] Apply rename/visibility/move changes through a single composite command so each dialog acceptance is one undo step.
- [x] Persist modeled object names through Native JSON, copy them when duplicating sheets, and document the architecture
  decision plus XLSX naming limitation.

## Verification Log

- Red: `dotnet test FreeX\tests\FreeX.Core.Model.Tests\FreeX.Core.Model.Tests.csproj --filter "SelectionPane" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal` failed because visual object models had no `Name` property and `RenameSelectionPaneObjectCommand` did not exist.
- Green: `dotnet test FreeX\tests\FreeX.Core.Model.Tests\FreeX.Core.Model.Tests.csproj --filter "SelectionPane" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal` passed 10 tests.
- Green: `dotnet test FreeX\tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --filter "SelectionPane" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal` passed 7 tests.
- Green: `dotnet build FreeX\FreeX.slnx --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 -v minimal` succeeded with 0 warnings and 0 errors.
