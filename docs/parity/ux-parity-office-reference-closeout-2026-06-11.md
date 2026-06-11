# Office Reference Evidence Closeout - 2026-06-11

Scope: closeout note for the remaining Excel-only foreground blockers after FreeX sheet-tab foreground parity was merged.

## Environment Finding

The local/free Microsoft Excel build used for foreground pairing locks some premium workbook-editing features. In this state, live foreground capture could not open the Excel Format Cells dialog or Data Validation setup/dropdown surfaces, even though Excel retained foreground ownership.

The blocked manifests remain truthful automation evidence:

- `tools/foreground-captures/excel-format-cells-dialog/excel-format-cells-dialog_manifest.json`
- `tools/foreground-captures/excel-format-cells-context-dialog/excel-format-cells-context-dialog_manifest.json`
- `tools/foreground-captures/excel-data-validation-dropdown-prepared/excel-data-validation-dropdown-prepared_manifest.json`

## Reference Baselines

- Format Cells: Microsoft Learn documents the Excel Format Cells dialog and its six tabs: Number, Alignment, Font, Border, Patterns/Fill, and Protection. Reference: `https://learn.microsoft.com/en-us/troubleshoot/microsoft-365-apps/excel/format-cells-settings`.
- Data Validation dropdown: Microsoft Support documents Excel in-cell dropdown lists, including the in-cell dropdown checkbox and the active-cell dropdown behavior. Reference: `https://support.microsoft.com/en-us/office/create-a-drop-down-list-7693307a-59ef-400a-b769-c5402dce407b` and `https://support.microsoft.com/en-us/office/apply-data-validation-to-cells-29fecbcc-d1b9-42c1-9d76-eff3ce5f7249`.

These references replace local Excel screenshot capture for the premium-locked Excel-side baselines only. They do not change the FreeX evidence requirements.

## User-Validated Excel Activate Dialog

The Excel sheet-tab overflow Activate dialog was manually validated by the user on 2026-06-11. The screenshot shows the native Excel `Activate` dialog with:

- A title of `Activate`.
- A list labeled `Activate:`.
- Visible sheet entries `Sheet1` through `Sheet14`.
- The active selection on `Sheet14`.
- `OK` and `Cancel` buttons.

The blocked automation manifest remains as a record that the foreground harness could not detect this dialog in the local automation route:

- `tools/foreground-captures/excel-sheet-tab-overflow-activate-dialog/excel-sheet-tab-overflow-activate-dialog_manifest.json`

## Status

- FreeX sheet-tab foreground blockers are closed by merge `87a76ce56`.
- Excel Format Cells and Data Validation are no longer considered actionable local-capture blockers because the installed Excel SKU gates them.
- Excel Activate is no longer considered behaviorally unknown; it is user-validated and can be used as the visual baseline for FreeX's Activate dialog.

