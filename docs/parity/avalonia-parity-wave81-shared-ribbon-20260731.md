# Avalonia/WPF shared Ribbon interaction parity: Wave 81

## Scope

The shared Avalonia editable ribbon combo now limits selection-to-Enter duplicate suppression to the immediate event sequence that can follow an Avalonia selection notification. Escape, arrow navigation, and text input clear that pending marker, so a later Enter is treated as a new explicit commit like the WPF editable combo.

## Evidence

- `tests/Free.Shared.Ribbon.Tests/AvaloniaRibbonComboTests.cs`: focused headless coverage verifies selection plus immediate Enter executes once, while Escape followed by a later Enter is not swallowed.

## Residual

Cross-platform visual comparison of editable combo chrome remains part of the broader parity visual lane.
