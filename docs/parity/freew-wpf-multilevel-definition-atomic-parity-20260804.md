# FreeW WPF multilevel definition parity

## Scope

Avalonia already applied a `Define New Multilevel List` result as one undo group, clamped selected paragraphs to the configured level count, and restored paragraph plus document number-format state together. WPF chained a list toggle, two-level start overrides, and a direct format mutation. That could turn an existing list off, ignored the selected level count, and required multiple undo operations.

The paragraph transform now lives in `MultilevelListDialogPlanner`, while the reversible number-format replacement lives in `FreeW.Core.Model`. Both hosts consume those shared semantics. WPF applies the complete definition in one undo group.

The main Multilevel List command and all three gallery presets now use that same atomic route in both hosts. Reapplying a preset to an existing list no longer toggles it off, and the heading-linked preset includes style assignment in the same undo transaction.

The preset undo contract exposed a WPF retention defect: `ListStartOverride` had no native `FlowDocument` slot and was absent from `ParagraphTag`, so commit discarded authored starts. WPF now tags and restores the override alongside list kind and level.

## Verification

- Shared planner definition transform: 3 level/start cases.
- Shared model number-format command: 1 apply/revert contract.
- WPF selected definition and legacy start paths: 3 focused tests.
- Avalonia existing atomic definition contract: 1 focused test.
- WPF and Avalonia consuming Release builds: 0 warnings, 0 errors.
