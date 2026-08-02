# FreeW double-strikethrough font-dialog authoring

## Scope

FreeW already preserved and rendered WordprocessingML `w:dstrike`. This slice makes the
same property directly authorable from the Font dialog without coupling it to ordinary
strikethrough.

- The shared `FontDialogPlanner` projects and applies `RunFormatting.DoubleStrikethrough`.
- WPF exposes a dedicated **Double strikethrough** check box and applies the complete
  planner result through the existing selected-run formatting path.
- Avalonia exposes a tri-state **Double strikethrough** check box, preserves mixed
  selections, and applies the change inside the existing Font undo group.
- Single and double strikethrough remain independent model properties. Rendering may
  prefer the double decoration when both are set, matching the existing render contract.

## Verification

- `FontDialogPlannerTests`: 26/26 passed.
- Focused WPF dialog/application tests: 3/3 passed.
- Focused Avalonia dialog/application tests: 14/14 passed.
- Adjacent WPF Home dialog, policy, and double-strikethrough render tests: 22/22 passed.
- Adjacent Avalonia dialog, policy, and PDF-path tests: 101/101 passed.
- `git diff --check`: clean.

All tests used Release artifacts. The wider gates were rerun with `--no-build` after the
focused host builds, ensuring the tested artifacts were the ones consumed by each host.
