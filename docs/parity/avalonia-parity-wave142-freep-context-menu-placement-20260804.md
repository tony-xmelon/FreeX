# Avalonia Parity Wave 142 - FreeP Context Menu Placement

Date: 2026-08-04
Scope: FreeP WPF/Avalonia host parity

## Proved divergence

The WPF FreeP host explicitly places chart and table context menus at the mouse
point (`PlacementMode.MousePoint`) in `freep/FreeP.App.Host/MainWindow.cs`.
The Avalonia host built the same menus without an explicit pointer placement
contract, even though both menus are opened from the slide-canvas right-click
route. That left the Avalonia menu anchor dependent on the framework default
instead of matching the WPF interaction contract.

## Change

- Avalonia chart and table context menus now use `PlacementMode.Pointer`.
- WPF chart and table context menus now declare the existing
  `PlacementMode.MousePoint` contract at construction, so the paired behavior
  is explicit and testable.
- No slide-pane cursor styling or unrelated host behavior was changed.

## Evidence

- `freep/FreeP.App.Avalonia.Tests/KeyboardContextParityTests.cs`: asserts
  Avalonia table menus use `PlacementMode.Pointer` and preserves the existing
  menu order, enabled state, and mutation assertions.
- `freep/FreeP.App.Host.Tests/KeyboardContextParityTests.cs`: asserts WPF table
  menus use `PlacementMode.MousePoint` and preserves the matching mutation
  assertions.
- Avalonia focused test run: 17 passed, 0 failed.
- WPF focused test run: 5 passed, 0 failed.

## Residuals

This closes menu anchoring parity for the chart/table context-menu workflow.
It does not claim full PowerPoint-authoritative visual parity for native menu
shadows, theme rasterization, or COM-only chart behavior. Those remain outside
this host-placement slice.
