# Linux Dialog Parity Pause Handoff - 2026-06-23

## Current State

- Main is clean and pushed at `1f44fb76c` (`Merge Avalonia legal notices dialog visual alignment`).
- Dialog deduplication audit status: 57/57 parity routes are shared/presentation-backed.
- Visual alignment batches landed so far: 9/57 surfaces.
- Approximate remaining first-pass visual alignment work: 48 dialog surfaces.
- Temporary dialog visual worktrees and branches from this pass were removed after merge.

## Landed Dialog Visual Batches

Earlier batches in this Linux dialog parity push:

- `PrintPreview`
- `SymbolPicker`
- `ShapeGradient`
- `About`
- `Sort`
- `SortOptions`
- `AdvancedFilter`

This pause covered and landed:

- `SelectionPane`
  - Commit: `2e28eb88a` (`Align Avalonia selection pane dialog chrome`)
  - Merge: `1042ff126` (`Merge Avalonia selection pane dialog visual alignment`)
  - Visual metric moved from 6.06% to 3.02%.
  - Main changes tightened Avalonia controls, fonts, list chrome, disabled button sizing, and checkbox/list-row styling.

- `LegalNotices`
  - Commit: `38ebf7034` (`Align Avalonia legal notices dialog`)
  - Merge: `1f44fb76c` (`Merge Avalonia legal notices dialog visual alignment`)
  - Visual metric moved from 5.69% to 4.25%.
  - Replaced the Linux-only concatenated text dump with a Windows-shaped tabbed legal notices dialog.
  - Added missing Avalonia/shared localization keys for the Legal Notices dialog.
  - Updated source-readiness guards to watch the new tabbed Legal Notices implementation markers.

## Validation Evidence

SelectionPane branch before merge:

- `dotnet build src\FreeX.App.Avalonia\FreeX.App.Avalonia.csproj -c Release`
- `dotnet test tests\FreeX.App.Services.Tests\FreeX.App.Services.Tests.csproj -c Release --filter "FullyQualifiedName~AvaloniaShellSourceTests|FullyQualifiedName~SelectionPane"`: 82 passed.
- `dotnet test tests\FreeX.App.Presentation.Tests\FreeX.App.Presentation.Tests.csproj -c Release --filter "FullyQualifiedName~SelectionPane|FullyQualifiedName~DrawingObject"`: 35 passed.
- `powershell -ExecutionPolicy Bypass -File tools\Test-RepositoryPreflight.ps1`
- Focused parity report: `dialog.SelectionPane` at 3.02%, report-only compare passed.

LegalNotices branch before merge:

- `dotnet build src\FreeX.App.Avalonia\FreeX.App.Avalonia.csproj -c Release`
- `dotnet test tests\FreeX.App.Services.Tests\FreeX.App.Services.Tests.csproj -c Release --filter "FullyQualifiedName~AvaloniaShellSourceTests|FullyQualifiedName~LegalNoticeProvider|FullyQualifiedName~Localization"`: 74 passed.
- `powershell -ExecutionPolicy Bypass -File tools\Test-RepositoryPreflight.ps1`
- Focused parity report: `dialog.LegalNotices` at 4.25%, report-only compare passed.

Merged main after both batches:

- `dotnet build src\FreeX.App.Avalonia\FreeX.App.Avalonia.csproj -c Release`
- Relevant focused service/source tests passed.
- `powershell -ExecutionPolicy Bypass -File tools\Test-RepositoryPreflight.ps1`

## Known Capture Notes

- Linux parity capture for the full 77-surface matrix may time out after screenshots are written.
- When that happens, stop only the fresh `ubuntu:24.04` parity container and its focused `dotnet run --project tools\FreeX.ParityCompare ...` parent process.
- Then run:

```powershell
dotnet run --project tools\FreeX.ParityCompare -- --out <artifact-dir> --skip-capture --threshold 5
```

- Do not clean older unrelated `ubuntu:24.04` containers without checking ownership; several were already long-running before this pause.

## Next Suggested Targets

Use the latest broad report as the ranking seed, then subtract the batches already landed above. The next practical targets are:

- `dialog.SelectDataSource` - 5.50%
- `dialog.FormatChartArea` - 5.50%
- `dialog.ConditionalFormatManage` - 5.10%
- `dialog.Sparkline` - 5.03%
- `dialog.GoalSeekStatus` - 5.00%

Suggested next move: start with `SelectDataSource` unless the latest regenerated report changes the order. It is still high on the diff list and likely has shared planning code to reuse.

## Resume Checklist

1. Verify main state:

```powershell
git status --short --branch
git fetch origin main
git rev-list --left-right --count main...origin/main
```

2. Create a dedicated worktree from current `main`, for example:

```powershell
git worktree add .worktrees\dialog-select-data-source-visual-20260623 -b codex/dialog-select-data-source-visual-20260623 main
```

3. Copy Windows references from the latest complete report capture into a focused artifact directory.
4. Inspect Windows and Linux screenshots side by side before editing.
5. Prefer reusing WPF/shared dialog structure when Linux is still using generic Avalonia-only chrome.
6. Capture Linux, run report-only compare, run focused tests plus preflight.
7. Commit, merge to `main`, push, then remove the temporary worktree and branch.
