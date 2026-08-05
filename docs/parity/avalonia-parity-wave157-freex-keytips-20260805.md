# FreeX Avalonia parity Wave157: Data What-If keytips

Date: 2026-08-05

## Scope

FreeX only. WPF remains authoritative. This wave closes the paired legacy ribbon sequence:

- `Alt+A`, `W`, `G` opens the existing Goal Seek workflow.
- `Alt+A`, `W`, `S` and `Alt+A`, `W`, `D` remain the canonical Scenario Manager and Data Table routes.
- `Escape` closes the live What-If flyout and clears the keytip path.
- An invalid continuation is consumed and clears the keytip path.
- The sequence is excluded while formula editing or the Backstage overlay is active, matching the WPF host boundary.

## Evidence

- WPF paired authority: `MainWindowRibbonKeyTipTests.DataWhatIfKeyTip_OpensAnalysisMenuWithExcelChoices`.
- Avalonia coverage drives `MainWindow_KeyDownAsync`, the rendered `What-If Analysis` flyout, and the real Goal Seek dialog workflow.
- The focused verification command and result are recorded in the Wave157 handoff.

## Residuals

Scenario Manager and Data Table terminal workflows remain covered by their existing command/dialog parity work; this wave does not duplicate those dialog implementations or touch FreeW/FreeP.
