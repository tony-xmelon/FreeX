# Ribbon Wave 86 Adaptive Overflow Parity

Wave 86 closes a collapsed-group enablement gap for `RibbonComboBox` projections. WPF treats a combo box that is projected into a collapsed group's overflow menu as a normal commandable menu item: it keeps the item enabled when the registered command is live and routes activation to that command. Avalonia had a renderer-only special case that always created the projection disabled, so the same command became unreachable after adaptive collapse.

Avalonia now consumes the same generic overflow projection as WPF. The combo label, keytip metadata, command id, enabled state, and click route are preserved. Wave 85's menu-only rule remains intact: controls whose primary command is unavailable still retain an enabled overflow/dropdown path when their menu has live entries.

## Runtime evidence

- Avalonia: `CollapsedGroup_ComboBoxProjectionMatchesWpfEnablementAndExecutes` passed 1/1.
- WPF: `CollapsedGroup_ComboBoxProjectionMatchesAvaloniaEnablementAndExecutes` passed 1/1.

The paired tests inspect the collapsed flyout/menu, assert the `Font` projection is enabled, and invoke it through the registered `font` command. The WPF test collapses after the adaptive panel's normal measure pass so the explicit lifecycle transition is not immediately recomputed by layout.

## Residuals

Popup chrome and focus ownership remain native to each toolkit (`ContextMenu` on WPF and `MenuFlyout` on Avalonia). This slice proves the renderer-neutral commandability contract; it does not claim pixel-identical popup visuals or replace native popup focus behavior.
