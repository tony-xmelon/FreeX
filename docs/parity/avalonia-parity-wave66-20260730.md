# Avalonia parity Wave 66

Date: 2026-07-30

## Scope

Wave 66 advances one workflow-depth slice in each application:

- FreeX: native XLSX 3-D formula point mode, reference-grip resize, save, package
  inspection, and physical reopen.
- FreeW: paragraph alignment for a selected shape nested inside grouped content,
  including save and reopen.
- FreeP: wrapped visual-line Up/Down and Shift+Up/Shift+Down caret navigation with
  preferred-X retention.

The generated command inventories remained at zero actionable topology gaps, so
this wave deliberately targeted deeper behavior rather than adding command
catalog entries.

## Integrated changes

- `bc4e3263e5` aligns nested grouped-child shape paragraphs through one shared
  planner and command route used by WPF and Avalonia.
- `054a83bc6b` adds the shared preferred-X navigation planner, Avalonia measured
  visual-line routing, and WPF STA parity evidence.
- `9e91426d5d` adds the native XLSX 3-D formula fixture and strict physical
  save/package/reopen validation.

Detailed notes:

- `docs/parity/2026-07-30-freew-wave66-nested-grouped-paragraph-alignment.md`
- `docs/parity/2026-07-30-freep-wave66-vertical-caret.md`
- `docs/parity/freex-wave65-3d-formula-range-grip-20260730.md`

## Focused managed validation

All focused tests were rerun after the three commits were combined:

- FreeW shared alignment planner/command: 5 passed.
- FreeW WPF route and DOCX persistence: 2 passed.
- FreeW Avalonia registry state and execution: 1 passed.
- FreeP shared vertical-navigation planner: 4 passed.
- FreeP Avalonia editor navigation: 5 passed.
- FreeP WPF native STA navigation: 2 passed.
- FreeX Avalonia native XLSX round trip: 1 passed.
- FreeX WPF native XLSX round trip: 1 passed.
- FreeX Linux interaction harness contract coverage: 8 passed.

## Physical Linux validation

Each physical lane was rerun sequentially from the combined integration branch:

- FreeW nested grouped-child alignment: 4/4 passed. The selected child was
  centered, saved to DOCX, reopened, and retained its child path and transforms.
  Manifest:
  `C:\Temp\freex-wave66-freew\freew-wave66-nested-text-alignment-validation.json`.
- FreeP grouped-child caret input route: 5/5 passed. The harness proves focused
  X11 key routing and visible state; managed tests remain the semantic caret
  offset proof because the container has no reliable caret-offset readback.
  Manifest:
  `C:\Temp\freex-wave66-freep\freep\sessions\20260730T091107517Z\freep-rich-text-shortcut-validation\results.json`.
- FreeX native XLSX 3-D formula workflow: 1/1 passed. Point mode read `88`; grip
  resize produced `234`; the exact escaped reverse-span formula and cached result
  survived clean save, ZIP package inspection, and physical reopen. Manifest:
  `artifacts/linux-interactive/freex/interaction-validation/20260730T092101Z/interaction-validation.json`.

## Repository gates

- `tools/Test-RepositoryPreflight.ps1`: passed, including generated parity
  documents, Linux packaging, solution membership, and conflict-marker checks.
- `dotnet build FreeX.slnx --configuration Release -m:1`: passed with 0 warnings
  and 0 errors.
- `dotnet test FreeX.DefaultTests.slnx --configuration Release --no-build -m:1`:
  33,585 passed, 0 failed, and 133 skipped benchmark/stress cases across 19 TRX
  result files.

## Remaining parity work

Wave 66 does not claim complete Avalonia parity. The next inventory should select
new workflow-depth gaps from physical interaction evidence, persistence round
trips, and visual comparison residuals. FreeP preferred-X semantics are fully
covered in managed tests but remain bounded to input-route evidence physically;
FreeW physically exercises Center while Justify remains shared managed coverage.
