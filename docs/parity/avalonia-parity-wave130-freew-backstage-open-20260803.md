# Avalonia Parity Wave 130: FreeW Backstage Open

Date: 2026-08-03

## Scope

This slice targets the canonical `backstage-open.open` WPF-authority route.
The shared Open planner, action order, tab labels, and callbacks remain
unchanged. The canonical row already had `semanticDifference: null`; that
contract is preserved.

## Change

The Avalonia Open-pane scroll host now opts into a route-scoped WPF scrollbar
profile. It reserves the same 17-DIP lane one DIP inside the right edge and
styles the instantiated Fluent template parts: `TrackRect` uses the WPF
`#F0F0F0` track, while the vertical template `Thumb` uses `#CDCDCD`. Other
backstage panes retain the shared Avalonia scrollbar theme.

## Fresh paired evidence

Both hosts were captured from current source at 560x600 and 96 logical DPI.
The final Avalonia capture passed the rendered-content gate. Template
inspection confirmed `PART_VerticalScrollBar` at x=528 with width 17, and the
rendered track/thumb pixels matched the WPF authority at representative rows:

| Metric | Fresh pre-edit | Wave 130 final | Change |
| --- | ---: | ---: | ---: |
| Changed-pixel ratio | 15.1131% | 12.8074% | -2.3057 pp |
| Mean absolute channel delta | 11.8908 | 11.2620 | -0.6288 |
| Perceptual hash distance | 6 | 6 | 0 |

The canonical report remains an honest `genuine-visual-mismatch`; the residual
is primarily cross-toolkit text rasterization and control-template rendering.

## Verification

- Release build of `FreeW.DialogVisualHarness.Avalonia`: 0 warnings, 0 errors.
- Focused `FreeW.App.Avalonia.Tests` Backstage suite: 40/40 passed.
- Fresh WPF capture: 1/1 captured and content-gate valid.
- Fresh Avalonia capture: 1/1 captured and content-gate valid.
- Fresh paired comparison: 1/1 captured; `semanticDifference` is null.
- Canonical inventory and visual freshness files refreshed; only the
  `backstage-open.open` comparison row changed.
