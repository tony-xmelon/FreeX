# Avalonia parity Wave 95: threaded comments

Date: 2026-08-01

## Scope

Closed the Wave 94 Avalonia threaded-comment list residual in the FreeX review surface.

## Changes

- Avalonia `Review > Show Comments` now presents a portable two-column list matching the WPF
  `GridView` shape: cell reference and threaded comment text.
- The list uses the localized WPF column headers and list help metadata, with stable automation
  metadata on headers and row cells.
- Threaded rows use the shared comment formatter, so authors, replies, and resolved state remain
  visible consistently with WPF.
- Existing live refresh, address-based selection preservation, single selection, Open/Enter,
  double-click navigation, and separate `Show Notes` toggle-all behavior remain intact.

## Focused verification

- Avalonia threaded-comment runtime tests cover two-column presentation metadata, full thread
  formatting, selection/open state, Enter navigation, live refresh, and Show Comments/Show Notes
  separation.

## Residual

- Avalonia uses a templated `ListBox` row rather than WPF's native `GridView`; native toolkit
  selection and text rasterization can still differ from WPF.
