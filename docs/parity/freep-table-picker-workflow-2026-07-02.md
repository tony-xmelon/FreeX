# FreeP Table Picker Workflow - 2026-07-02

Scope: bounded FreeP picker/UI workflow depth after the generated cross-app dashboard showed FreeP command parity green and asked for deeper picker, slide-pane, and editing evidence.

Findings:

- The shared Layout command already opens concrete WPF and Avalonia layout picker surfaces on current `main`.
- The Insert > Tables group still exposed fixed-size table commands, with the large Table command behaving as the default 3 x 3 insert path.

Implemented:

- Added `TableInsertionPickerPlanner` in `FreeP.App.Presentation` for a shared 5 x 5 table-size picker plan and bounded apply validation.
- Routed the WPF large Table command through a host callback that opens an in-window picker and applies the selected size through `EditingSession.InsertTable`.
- Routed the Avalonia large Table command to the same shared picker plan, with headless coverage proving the picker opens, renders choices, applies a 5 x 4 choice, and collapses.
- Preserved the existing compact 2 x 2 and 4 x 4 fixed-size shortcuts as direct insert commands.

Verification evidence:

- `dotnet test freep\FreeP.App.Presentation.Tests\FreeP.App.Presentation.Tests.csproj --configuration Release --filter TableInsertionPickerPlannerTests --logger "trx;LogFileName=freep-table-picker-planner.trx" -m:1 /nr:false -p:BuildInParallel=false -p:UseSharedCompilation=false` passed 6/6.
- `dotnet test freep\FreeP.App.Host.Tests\FreeP.App.Host.Tests.csproj --configuration Release --filter "FullyQualifiedName~TablePicker|FullyQualifiedName~InsertTable3x3|FullyQualifiedName~SlideObjectInsertionRoutingSourceTests" --logger "trx;LogFileName=freep-table-picker-host.trx" -m:1 /nr:false -p:BuildInParallel=false -p:UseSharedCompilation=false` passed 4/4.
- `dotnet test freep\FreeP.App.Avalonia.Tests\FreeP.App.Avalonia.Tests.csproj --configuration Release --filter "FullyQualifiedName~Ribbon_insert_table|FullyQualifiedName~SlideObjectInsertionRoutingSourceTests" --logger "trx;LogFileName=freep-table-picker-avalonia.trx" -m:1 /nr:false -p:BuildInParallel=false -p:UseSharedCompilation=false` passed 4/4.
