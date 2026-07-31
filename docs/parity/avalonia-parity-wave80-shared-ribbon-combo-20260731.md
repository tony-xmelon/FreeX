# Avalonia/WPF shared RibbonComboBox parity: Wave 80

## Scope

The shared Avalonia ribbon renderer now matches the WPF editable combo contract:

- combo boxes are editable and commit typed text on Enter;
- selected values still commit through `RibbonCommandContext.ForSelectedValue`;
- initial selection and state synchronization are silent;
- a selection commit followed by the resulting Enter event executes once;
- state refresh reconciles both `SelectedIndex` and `Text`, including custom values not present in the item catalog;
- empty text follows the WPF selected-item/text fallback semantics.

## Evidence

- `tests/Free.Shared.Ribbon.Tests/AvaloniaRibbonComboTests.cs`: 5 focused headless tests passed.
- `tests/FreeX.App.Avalonia.Tests/AvaloniaPageLayoutScaleCommitTests.cs`: 3 production page-layout scale tests passed.

## Residual

The shared renderer behavior is covered headlessly. Cross-platform visual comparison of editable combo chrome remains part of the broader parity visual lane.
