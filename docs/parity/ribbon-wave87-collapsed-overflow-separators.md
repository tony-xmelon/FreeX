# Ribbon Wave 87 Collapsed Overflow Separator Parity

## Divergence

WPF collapsed group menus used the shared overflow projection without separators or row breaks, while Avalonia explicitly requested separator controls and inserted native separator rows into the overflow flyout.

## Fix

Avalonia now consumes the shared planner default, matching WPF: collapsed overflow keeps command controls in definition order and omits layout-only `RibbonSeparator` and `RibbonRowBreak` controls.

## Evidence

- `RibbonWpfSplitButtonTests.CollapsedGroup_OmitsSeparatorsAndRowBreaksFromOverflowMenu` passed in the WPF ribbon UI lane.
- `AvaloniaRibbonSplitButtonTests.CollapsedGroup_OmitsSeparatorsAndRowBreaksFromOverflowMenu` passed in the Avalonia ribbon UI lane.

## Residuals

Popup chrome and focus ownership remain native to each toolkit; this slice covers the collapsed command list contract only.
