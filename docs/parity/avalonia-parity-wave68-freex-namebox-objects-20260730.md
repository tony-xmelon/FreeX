# FreeX Wave 68: Name Box Object-Kind Parity

## Scope

This slice closes the bounded Name Box dropdown residual for named drawing objects in FreeX: named shape, picture, text box, and chart. It covers deterministic fixture data, physical selection evidence, fail-closed host validation, and the existing WPF open-dropdown screenshot-tour counterpart.

The aggregate Wave68 report is intentionally unchanged.

## Implementation

- Avalonia's opt-in physical fixture now projects `PhysicalChart`, `PhysicalPicture`, `PhysicalShape`, and `PhysicalTextBox` alongside the existing named range and table.
- Each object probe starts from visible neutral cell `J20`, outside every fixture object, records a baseline event with no selected object, selects the projected dropdown item, and records observable name-box, active-cell, object-kind, and object-id state.
- The Linux probe writes object rows and a strict postcondition artifact. The PowerShell host validator enforces a fixed contract for every expected ID, including exact expected and observed names, kinds, IDs, order, neutral baseline, stage, name-box text, and active-cell evidence. Status and count metadata are not trusted as identity evidence.
- The WPF screenshot tour seeds the same four named object kinds and includes them in the existing `freex_formula_name_box_dropdown_opened` open-dropdown capture context.
- Presentation and Avalonia tests now exercise deterministic ordering and selection of chart, picture, shape, and text-box entries.

## Verification

Focused managed tests completed:

- `NameBoxDropdownPlannerTests`: 3/3 passed.
- `AvaloniaMainWindowNameBoxStage2Tests`: 12/12 passed.
- `MainWindowScreenshotTour_CapturesFormulaBarNameBoxEvidence`: 1/1 passed.
- `LinuxFreeXInteractionValidationToolTests`: 6/6 passed.
- `AvaloniaInteractionCoverageTests`: 8/8 passed.

Static checks completed:

- PowerShell parser check passed for `tools/Run-FreeXLinuxInteractionValidation.ps1`.
- Bash syntax check passed for `tools/LinuxInteractiveDocker/run-freex-input-probes.sh`.
- JSON schema parse check passed.
- `git diff --check` passed; Git only reports the repository's normal LF/CRLF normalization warnings.

## Parent validation

The sequential Linux physical probe passed 6/6 at 1280x820 and 96 DPI:

- Defined name: exact `Region` clipboard readback.
- Structured table: exact `North<TAB>120` clipboard readback.
- Chart, picture, shape, and text box: exact projected name, object kind, object ID,
  selected-object state, Name Box text, and active anchor cell from neutral `J20`.

The run also exposed and closed two harness defects and one product defect:

- Empty JSON fields are now framed with a non-whitespace delimiter instead of
  collapsing during Bash field splitting.
- Neutral evidence is emitted after pointer release, when the Name Box refresh is
  settled.
- Avalonia now keeps the selected drawing object's name in the Name Box after
  `RefreshShell`, matching the WPF route instead of replacing it with the anchor
  cell address.

Strict manifest:
`artifacts/linux-interactive/freex/interaction-validation/20260730T132717Z/interaction-validation.json`.

## Limitations

The WPF tour provides a deterministic same-size open-dropdown baseline through
the existing in-process capture at 1180x768, while the Linux harness emits its
normal X11 captures and exact object evidence. A fully automated WPF/Avalonia
composite image report remains outside this bounded slice.
