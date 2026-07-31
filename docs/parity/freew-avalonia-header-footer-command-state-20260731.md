# FreeW Avalonia Header/Footer Command State

The Header & Footer contextual controls now expose the same live model state as the WPF host:

- Different First Page and Different Odd & Even Pages report `IsChecked` from the current page settings.
- Header from Top and Footer from Bottom report their current formatted point values.
- all four commands read `DocumentView.Document` when state is requested, so loading another document
  refreshes the ribbon without rebuilding the command registry.

The existing mutations remain undoable through `ApplyPageSettings`. Distance input now uses the shared
`HeaderFooterDialogPlanner` parser and formatter used by WPF, keeping validation and display text aligned.

Focused `HeaderFooterContextualTabTests` cover imported initial values, command execution and refreshed
state, document replacement, the existing header/footer insertion workflow, and production prompt cancel.
Result: 9 passed, 0 failed.
