# FreeP ChartEx Native Title and Legend Ownership

## Scope

Current main `dc1058882f` exposed four native ChartEx edit failures: preserved
`cx:title` and `cx:legend` nodes were removed before the reader could import
their text, position, overlay, and text-style metadata. The writer treated a
null high-level property as an explicit clear even when the native payload had
not been edited.

## Fix

`ChartShape` now carries explicit title/legend edit-request state. Preserved
ChartEx title and legend nodes remain source-authoritative until an authoring
command changes or clears them. The chart title/options commands capture and
restore these markers through undo. Explicit removal tests opt into the same
state, so stale native nodes are still removed when the user actually clears a
component.

## Verification

- Native ChartEx title/legend/series edit tests: **9/9**.
- ChartEx removal and display-options undo tests: **4/4**.
- Avalonia startup dirty-state audit on current main: **1/1**.
- WPF and Avalonia Release consumer builds: required before integration.

This is a functional package/model ownership fix. It makes no visual
calibration claim.
