# FreeW AutoCorrect Tab Parity - Wave133

Date: 2026-08-03

## Follow-up scope

This follow-up repairs the WPF `OptionsDialog` replacement table measurement and retains the Avalonia 1:2 layout. The route is `options.tab-auto-correct`, captured fresh at the same 560 x 600 harness size and state. WPF source declares `Replace` as `1*` and `With` as `2*`; the earlier WPF bitmap did not realize that contract correctly.

## WPF measurement repair

A retained pre-fix WPF runtime probe measured `DataGrid.ActualWidth=478.6667`, `ScrollViewer.ViewportWidth=458.6667`, and `DesiredSize.Width=60`. With horizontal scrolling enabled, both declared star columns realized at `ActualWidth=20`, their `MinWidth`, and clipped every replacement value. This was a WPF measure/scroll-layout artifact, not an authoritative usable layout.

The WPF dialog now hosts the table in a finite-width, single-column grid and disables horizontal scrolling. The columns remain declared as `1*` and `2*` in source. Once WPF has completed a measure pass, a one-shot `LayoutUpdated` handler derives one third and two thirds of the current viewport and realizes those declared weights as pixel widths; it unsubscribes immediately after that successful pass. A `SizeChanged` handler reapplies the same calculation when the dialog's available width changes. This avoids a screenshot-specific constant, preserves resize behavior, and does not leave an endless layout mutation loop. The visual harness retains its normal single post-population `UpdateLayout()` pass; no probe-only instrumentation remains.

## Fresh paired result

| Metric | Previous clipped pair | Current WPF repair + Avalonia 1:2 |
| --- | ---: | ---: |
| Changed ratio | 0.1029 | 0.1049 |
| Mean channel delta | 8.577 | 8.714 |
| P95 channel delta | 69.000 | 70.000 |
| Perceptual hash distance | 8 | 9 |
| Semantic difference | none | none |
| Painted content bounds | WPF 517 x 387; Avalonia 518 x 387 | WPF 517 x 387; Avalonia 518 x 387 |

The previous pair is the retained `before-compare` report for the rejected clipped WPF/Avalonia state. The current target remains classified as `genuine-visual-mismatch`; thresholds and classifications were not changed. Both final bitmaps show readable replacement text, including `(tm)` and the symbol replacement. The remaining pHash distance reflects native WPF versus Avalonia rasterization, chrome, focus treatment, and glyph differences rather than replacement-table clipping or a semantic mismatch.

## Product-owned changes

- Fixed WPF star-column realization without changing the declared 1:2 source contract.
- Removed the rejected 20px columns, filler surface, and width override from Avalonia.
- Retained the established Avalonia tab-pane compensation, checkbox geometry, row cadence, table spacing, and gridline palette.
- Preserved replacement parsing, dynamic add-row behavior, validation, focus/select lifecycle, OK/Cancel semantics, and persisted option result construction.
- Added WPF and Avalonia functional geometry/content assertions.
- Removed the probe-only WPF harness instrumentation; the reusable capture harness remains unchanged.

## Validation and canonical evidence

- WPF focused tests: `dotnet test freew\\FreeW.App.Host.Tests\\FreeW.App.Host.Tests.csproj --configuration Release --filter FullyQualifiedName~OptionsDialogParityTests -m:1 -p:NodeReuse=false /nr:false --logger "trx;LogFileName=wave133-wpf-layout-once.trx"` passed: 4, failed: 0.
- Avalonia focused tests: `dotnet test freew\\FreeW.App.Avalonia.Tests\\FreeW.App.Avalonia.Tests.csproj --configuration Release --filter FullyQualifiedName~OptionsDialogVisualParityTests -m:1 -p:NodeReuse=false /nr:false --logger "trx;LogFileName=wave133-avalonia-geometry-final.trx"` passed: 7, failed: 0.
- Release WPF and Avalonia visual harness builds passed with `-m:1 -p:NodeReuse=false /nr:false`.
- Fresh WPF and Avalonia captures passed content validation; semantic difference was null.
- Final inventory and comparison freshness checks passed. The comparison generation command returned nonzero for the remaining genuine mismatch after writing the valid target row.

The fresh WPF and Avalonia screenshots were visually inspected before integration. Their target row and current-source freshness hashes are route-merged into the tracked `docs/parity/freew-dialog-harness/freew_dialog_visual_comparison.json`, `.md`, `.html`, and `freew_dialog_visual_freshness.json`. Disposable worker capture and probe directories are cleaned with the worker worktree.
