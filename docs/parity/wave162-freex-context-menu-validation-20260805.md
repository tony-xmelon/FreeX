# Wave162 FreeX Context Menu Validation

Date: 2026-08-05

## Diagnosis

The Wave161 Linux failures were validation harness and fixture defects. Production behavior was correct for both clusters.

`Show Notes` dispatches `ToggleAllNotesVisibility`, which changes note visibility and does not open an owned context dialog. The validation dialog classifier incorrectly treated `ShowNotes` as a dialog route. Command rows therefore waited for a window that production never creates, and the worksheet family and variant aggregates inherited those failures.

The AutoFilter criteria panel correctly leaves its completed criteria text empty until required values are entered. The validation fixture selected an operator without supplying the production Filter Family entry or the required value fields. On the detached Linux Skia fixture, programmatic value input also does not raise `TextChanged`; the probe consequently observed an empty criteria string. The no-value criteria passed while value-bearing criteria failed, matching this fixture problem rather than a production defect.

## Changes

- Removed `ShowNotes` from the owned-dialog classification.
- Made the AutoFilter probe use the production Filter Family entry, the named operator control, and representative values for value, count, and Between criteria. The detached probe applies the same `BuildCompletedCriteriaText` completion rule used by production after seeding the controls.
- Added a regression covering both Show Notes rows and all 32 AutoFilter criteria rows.

## Evidence

- `ProductionDispatch_ExercisesShowNotesAndEveryAutoFilterCriterion`: 1 passed.
- `ContextMenuInteractionValidationTests`: 14 passed, 0 failed, 0 skipped.
- `AutoFilterMenuPlannerTests`: 8 passed, 0 failed, 0 skipped.
- `AvaloniaWorksheetContextMenuBehaviorTests`: 5 passed, 0 failed, 0 skipped.
- Linux Show Notes batch, session `20260805T175926410Z`: 2 command rows passed; 103 bounded-matrix rows skipped.
- Linux AutoFilter diagnostic before the fixture fix, session `20260805T180015085Z`: 24 value-bearing command rows, the family aggregate, and 24 variant aggregates failed; 8 no-value command rows and 8 variant aggregates passed.
- Linux AutoFilter proof after the fixture fix, session `20260805T180917856Z`: 32 command rows, the family aggregate, and 32 variant aggregates passed; overall bounded result was 65 passed, 0 failed, 70 skipped, 135 total.

## Residuals

The full Linux interaction matrix was not rerun. The Linux proof was limited to the affected Show Notes and AutoFilter dispatch ranges. No production behavior change was required; the patch is limited to validation routing and regression coverage.
