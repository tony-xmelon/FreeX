# FreeX Wave 74 Scenario Manager Save/Edit Parity

## Scope

The Avalonia Scenario Manager compact dialog now follows the WPF save/edit contract for the
bounded add, edit, and summary-report paths.

## Evidence

- Changing-cells and result-cells fields remain editable and use the existing Avalonia range-picker
  registration/session infrastructure.
- Shared `ScenarioManagerDialogPlanner.ValidateAcceptRequest` validates the scenario name and both
  reference fields before any workbook command is created; the failing field receives focus and
  remains unchanged on invalid input.
- `WorkbookRangeTextCodec.TryParseMany` preserves multi-area and cross-sheet references. A blank
  changing-cells field retains the WPF fallback to the current selection.
- Add submits without a replacement name. Edit submits the selected scenario name as
  `ReplaceScenarioName`, preserving WPF rename/replace behavior.
- The accepted scenario name is trimmed once before command execution and reused for the status and
  refreshed selection, so validation and persisted naming agree.
- Comment, hidden, and prevent-changes flags are carried into `ScenarioManagerSaveRequest`.
- Summary validates and parses result-cell references before passing the exact distinct addresses to
  `ScenarioManagerPlanner.CreateSummaryReportPlan`.

Focused source and planner tests cover these contracts. Linux/Docker execution is intentionally
outside this bounded slice.
