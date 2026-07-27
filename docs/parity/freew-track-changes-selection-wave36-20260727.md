# FreeW Track Changes Selection Parity (Wave 36)

## Scope

This slice closes one local WPF-over-Avalonia behavior gap in the Review ribbon. When Track Changes is enabled while a non-empty body selection is active, the WPF command records that selection as one inserted revision. Avalonia previously only toggled its mode flag.

The shared `TrackChangesTogglePlanner` now owns the WPF/FreeW transition rule. Each host keeps its existing editor mutation path and stamps its normal `FreeW User` author plus a UTC revision date. Enabling with an empty selection and disabling with any selection do not create a revision. The model text remains unchanged. Existing history semantics are explicit: WPF's authority mutation is direct and does not add a new undo entry; Avalonia's existing command-bus mutation remains undoable.

## Evidence

- WPF authority: `FreeW.App.Host.Ribbon.FreeWRibbonCommands.TrackChangesToggleCommand`.
- Avalonia runtime: `FreeW.App.Avalonia.Ribbon.FreeWAvaloniaRibbonCommands.TrackChangesToggleCommand`.
- Shared policy: `FreeW.App.Presentation.Ribbon.TrackChangesTogglePlanner`.
- Tests cover the production command in both hosts, checked state, exact insertion count, author/date, empty-selection and disable transitions, unchanged text, WPF's direct-mutation undo behavior, and Avalonia undo of the inserted revision mark.

This is a bounded functional parity fix. It does not claim parity for behavior outside the modeled FreeW document/revision pipeline.
