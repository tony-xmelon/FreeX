# Export Explicit Format Extension

## Goal

Prevent explicit PDF/XPS save-dialog choices from writing one file format into a path with the other format's extension.

## Decisions

- Keep extension inference behavior unchanged for direct `PlanExport(path, options)` callers, so existing nonstandard-extension behavior is preserved.
- Treat `PlanExport(path, format, options)` as authoritative because it is fed by the save dialog filter choice.
- Normalize explicit-format paths to `.pdf` or `.xps` even when the user typed the opposite or a nonstandard extension.

## Verification

- Red: `dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "PlanExport_NormalizesMismatchedExtensionForExplicitFormatRequests" -v minimal` failed 4 cases because the explicit-format overload preserved mismatched extensions.
- Green: `dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --no-restore -p:UseSharedCompilation=false -p:NodeReuse=false -m:1 --filter "ExportPlannerTests" -v minimal` passed 62 tests.
