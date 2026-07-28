# FreeP Avalonia Key-Tip Residual Closure, Wave 49

Date: 2026-07-29

## Scope

This slice closes the four key-tip residuals recorded in the Wave 36 comments
action-strip note and verifies the `freep.font-family` setup path. The production
route now applies the Office rule explicitly: a short exact leaf remains pending
only when a longer matching candidate is a dropdown or split-button scope. This
keeps `Blink=B` from consuming the `Blinds In=BI` prefix while allowing a unique
leaf to execute immediately.

## Evidence

Focused `FreeP.App.Avalonia.Tests` execution of
`KeyboardContextParityTests` passed 17/17 on this Wave 49 source state,
including:

- `AvaloniaAltKeyTipsEnterDropdownMenuAndExecuteNestedMenuCommand`
- `AvaloniaAltKeyTipsDefersExactBlinkUntilLongerBlindsPrefixIsResolved`
- `AvaloniaAltKeyTipsCancelAndRejectUnmatchedDropdownMenuInput`
- `AvaloniaAltKeyTipsDoNotExecuteDisabledNestedMenuCommand`
- `AvaloniaAltKeyTipsOpenComboBoxAndLeaveLeafCommandsUntouched`

The combo-box fixture waits for the rendered `TabItem` template with
`Dispatcher.UIThread.RunJobs()` and locates the actual visual-tree `ComboBox`,
so the test covers the rendered control used by production discovery rather than
an assumed logical-tree shape.

The focused `FreeP.Ribbon.Definitions.Tests` key-tip inventory lane also passed
4/4, covering both WPF and Avalonia profiles and their shared command inventory.

The Docker/X11 family lane passed 23/23 on the integrated Wave 49 source. Its
new physical row inserts and selects a text box, enters `Alt,A,N,B`, verifies
that the longer `BI` sequence remains live, opens the Blinds menu with `I`, and
uses two Escape presses to dismiss the menu and then leave key-tip mode before
the following Backstage checks.

## Residuals

No residual failures remain in this bounded key-tip and font-family slice. The
broader FreeP parity backlog and PowerPoint-authoritative visual validation
remain outside this slice.
