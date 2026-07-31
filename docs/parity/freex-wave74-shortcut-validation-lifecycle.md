# FreeX Wave 74: Shortcut Validation Lifecycle

## Failure

Avalonia exhaustive shortcut validation replaces the production window's workbook session for each managed interaction. The old path assigned a new `WorkbookSession` directly, leaving the previous session subscribed to workbook events and retaining its recalculation and XLSX source-package resources. On a default test host, the exhaustive catalog could therefore stall or crash after hundreds of interactions, while a fresh isolated host completed.

## Contract

Validation session replacement now goes through `MainWindow.ReplaceSession`. The helper detaches the old workbook event handler, installs the replacement, wires its prompt resolver and event handler, and disposes the previous session synchronously. Ribbon validation uses the same ownership path. The final validation session is disposed by the normal `MainWindow.OnClosed` lifecycle. Shared sibling views remain valid because `WorkbookSession.Dispose` retires shared document state only after the last view closes.

## Regression

`ReplacedValidationSessions_AreDisposedWithoutRetiringSharedSiblingDocuments` repeats a one-step production shortcut validation 256 times and asserts each previous session is disposed immediately, the active session remains usable, and owned windows are empty. It then verifies that closing a root window does not retire a live sibling view, and that the sibling is retired when it closes.

The exhaustive catalog contract remains `ProductionShortcutValidationCore_CompletesEntireCatalog`: 276 shortcut-scenario results, with managed interactions passing and only native, external, or physical-wheel boundaries skipped.

## Parity Impact

This is a lifecycle-only fix. Shortcut routing, interaction semantics, result categories, and production dispatch evidence are unchanged. It makes the Avalonia validation run bounded in retained session resources and keeps the WPF/Avalonia parity harness able to complete the full catalog.

## Verification

- The 256-replacement lifecycle stress regression passed.
- The exact exhaustive catalog test passed three consecutive runs.
- The focused Avalonia shortcut coverage class passed all 14 tests.
- The focused Services sibling-view tests passed both tests.
