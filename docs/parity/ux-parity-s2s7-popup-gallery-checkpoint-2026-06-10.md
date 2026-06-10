# S2/S7 Popup Gallery Checkpoint - 2026-06-10

Scope: foreground-harness checkpoint for S2 popup/dropdown/gallery captures and S7 Excel-paired popup/dialog comparison. This pass did not expand beyond the in-hand Format Cells dialog and Data Validation dropdown attempts. It did not modify product app code.

## Harness Changes

- Added foreground harness scenario names for `excel-format-cells-dialog`, `freex-format-cells-dialog`, and `excel-data-validation-dropdown`.
- Added Excel workbook setup for a simple list-validation dropdown candidate and guarded in-cell dropdown clicking.
- Added a native `Ctrl+1` helper for FreeX Format Cells dialog attempts; Excel Format Cells uses a foreground-guarded `Alt,H,O,E` keytip route after `Ctrl+1` did not open the dialog in this environment.

## Retained Artifacts

| Scenario | Artifact | Outcome |
|---|---|---|
| Excel Format Cells dialog | `tools/foreground-captures/excel-format-cells-dialog/excel-format-cells-dialog_manifest.json` | Blocked: Excel owned foreground, but `Alt,H,O,E` did not produce a detectable `Format Cells` dialog. Earlier `Ctrl+1` attempts also failed before the final retained manifest. |
| FreeX Format Cells dialog | `tools/foreground-captures/freex-format-cells-dialog/freex-format-cells-dialog_manifest.json` | Blocked: FreeX owned foreground, but `Ctrl+1` did not produce a detectable `Format Cells` dialog. The run used the already-built Release host from the synced main worktree because this branch changed only the foreground harness. |
| Excel Data Validation dropdown | `tools/foreground-captures/excel-data-validation-dropdown/excel-data-validation-dropdown_manifest.json` | Blocked: Excel COM returned `0x800AC472` while preparing/opening the validation dropdown scenario; no popup PNG was produced. |

No new complete PNG capture was retained in this checkpoint. Existing closed S2/S7 pairings for AutoFilter, Home Borders, Home Number Format, and worksheet context menu remain as documented in `docs/parity/worker-popup-evidence-pairing-s2s7-2026-06-10.md`.

## Remaining S2/S7 Blockers

- Data Validation dropdown popup still needs a foreground runner that can seed the list-validation workbook and open the in-cell dropdown without Excel COM busy-state failures; a FreeX-side seeded foreground path remains future work.
- Format Cells dialog pairing remains blocked because neither product produced a detectable dialog through the current foreground harness attempts in this desktop state.
- Format Cells/dialog-only context submissions remain open; this checkpoint did not attempt context-menu command submission after the direct dialog paths blocked.
- Additional ribbon gallery/dropdown pairings outside the already closed four-surface set remain open and should be attempted only after the foreground runner can reliably open and detect modal dialogs/popups.
