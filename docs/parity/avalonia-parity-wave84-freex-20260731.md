# FreeX Avalonia parity Wave 84: formula-point directional anchors

Date: 2026-07-31

## Finding

WPF retained the pointer-down anchor and moving cursor for reverse formula-point
range selection, while Avalonia retained those values only in private editor
fields and normalized `WorkbookSession.ActiveCell` to the range's top-left.
Formula text stayed correct, but active-cell consumers diverged for directional
and 3-D range pointing.

## Change and evidence

Avalonia now passes its explicit formula-point anchor into the existing FreeX
session selection path. The default session behavior is unchanged for callers
that do not provide an anchor, and Wave 83 header-drag continuation remains on
its dedicated explicit-anchor helpers.

Focused evidence covers the session contract, Avalonia reverse `Shift+Arrow`
point selection, and the paired WPF reverse range authority path.
