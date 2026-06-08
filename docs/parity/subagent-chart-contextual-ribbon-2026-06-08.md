# Chart Contextual Ribbon Parity - 2026-06-08

## Scope

Ported the chart contextual ribbon behavior from `codex/chart-context-ribbon-parity-20260608` onto the aggregate visual parity branch.

## Findings

- Excel exposes contextual chart tabs only when a normal embedded chart is selected: `Chart Design` and `Format`.
- Pivot charts should not light up the normal chart contextual ribbon.
- FreeX had chart commands on Insert, but no contextual chart tabs or `JC`/`JF` top-level key-tip routing.

## Changes

- Added collapsed-by-default `ChartDesignTab` and `ChartFormatTab` before Table Design in `MainWindow.xaml`.
- Wired chart contextual tab visibility into viewport refresh caching.
- Limited contextual eligibility to visible, non-pivot charts.
- Added localization keys for chart contextual group captions across all `Strings*.resx`.
- Added key-tip, static catalog, top-level routing, adaptive ribbon, and pivot/hidden chart negative coverage.

## Follow-Up

- Screenshot tour/harness integration should add chart-context screenshot seeding so automated ribbon captures include `Chart Design` and `Format`.
