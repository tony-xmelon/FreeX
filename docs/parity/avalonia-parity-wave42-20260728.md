# Avalonia Parity Wave 42

Date: 2026-07-28

## Closed Production Slice

### FreeX

Chart resize interactions now use one FreeX presentation sizing authority in
both WPF and Avalonia. Avalonia previously let a resize preview and commit
fall to the generic `8x8` minimum, while WPF preserves a usable `24x18`
chart surface. The shared rule now clamps the live Avalonia preview and the
undoable `SetChartBoundsCommand` path, preserving the opposite edge for west
and north handle drags.

## Verification

- Shared sizing/drag planner tests: **56/56 passed**.
- WPF chart resize transform tests: **7/7 passed**.
- Avalonia chart preview/dispatch contract tests: **2/2 passed**.

## Residuals

- Broader real-document compound workflow and paired visual validation remain
  active as described in Wave 41.
