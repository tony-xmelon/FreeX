# FreeP Function-First Status - 2026-08-04

Evidence anchor: current `main` is `42d57f0132`. The latest focused Release
baseline reported for the function-first lane is **2,027/2,027** host tests and
**3,632/3,632** shared Presentation tests. These are implementation/contract
counts, not a claim that every PowerPoint-native behavior has been reproduced.

## Current position

The generated FreeP command inventory on `main` reports **648/648** command IDs
available in both WPF and Avalonia, with **0 actionable WPF gaps**, **0 actionable
Avalonia gaps**, **0 known deferred command rows**, and **110 workflow-evidence rows**.
This is reachability coverage; it does not claim identical PowerPoint-native depth.

The function-first lane is now in a "close proven gaps, preserve honest boundaries"
phase. Recent work added bounded grammar confusion corrections (`could of`, `their are`,
`your welcome`, and related unambiguous phrases) with boundary-aware matching, casing
preservation, and the existing correction/ignore/dictionary workflow. The focused planner
lane is 100/100, WPF adapter coverage is 37/37, Avalonia proofing-pane coverage is 2/2,
and the consuming WPF/Avalonia projects build cleanly.

## Verified host coverage

- Windows WPF and Windows Avalonia both have native in-place OLE hosting with model
  byte save-back. Portable/non-Windows Avalonia remains external activation by platform
  design.
- SmartArt insertion, text-pane edits, layout, Quick Style, Change Colors, picture-node
  edits, undo, native data-part updates, and drawing-cache regeneration are transactional
  in both hosts. Unsupported SmartArt variants remain on their preserved cached-drawing
  path rather than being guessed into a live layout.
- The SmartArt Text Pane is now directly reachable from the shared Insert/SmartArt ribbon
  in both WPF and Avalonia; its outline/node edits continue through the transactional
  data-part and drawing-cache refresh path.
- Chart insertion and current modeled chart option/data workflows are shared. Remaining
  chart work is deeper Office semantics, not a missing command route.
- Reading order, accessibility remediation, proofing, comments, media captions, presenter
  recording, Zoom objects (including undoable Slide/Section retargeting and Summary Zoom
  target-list edits), and export/print handoff all have shared planner/host routes with
  focused evidence; platform-native behavior is kept explicit in the evidence manifests.
- Internal caption replacement now preserves an existing WebVTT, SRT, TTML, or DFXP
  package format and relationship identity; WebVTT remains the default for new tracks.
- TTML/DFXP playback planning now respects inherited `body`/`div` `begin`, `end`, and
  `dur` boundaries as well as frame/tick clocks, so child cues cannot outlive their
  containing timed region.
- WebVTT cue settings `position`, `line`, `size`, and `align` now flow through the
  shared cue descriptor and are honored by both slideshow caption hosts; SRT/TTML
  retain their existing default bottom-strip behavior.
- Windows WPF and Windows Avalonia camera readiness now enumerate the same WinRT
  `DeviceInformation` identities consumed by `MediaCapture`; a missing requested
  camera is deferred explicitly instead of silently selecting another device.
- Windows WPF and Windows Avalonia have native recording capture/export adapters
  when the Windows media capability is available. Generic planner messages that
  describe MP4/camera work as deferred apply to unavailable or injected-host
  capability states; they are not evidence that the desktop routes are absent.

## 2026-08-04 continuation

The SmartArt Text Pane is now a user-reachable command in the shared Insert/SmartArt ribbon
for both desktop hosts. Its existing outline, hierarchy-assistant, and picture-node actions
continue through the transactional model, native data-part, and drawing-cache refresh path;
the host entry point does not create a second SmartArt editing implementation. The generated
inventory and status counts now include the subsequent bounded `process1` and `list1`
SmartArt import-cache admissions: 648/648 shared commands and 110 workflow-evidence rows.

The current function-first audit also rechecked the SmartArt relationship boundary.
`relationship1` is a real, bounded authoring path: the reader admits only its audited
three-node cache grammar, the shared layout engine regenerates the editable nodes, and
unsupported cache/effect variants remain on the preserved native drawing path. The
broader relationship catalog is already exposed as model metadata and insertion choices,
but is not being treated as fully live until each native grammar is independently proven.
The current SmartArt-focused Presentation lane passed **394/394** tests on the same
Release baseline. No new command or renderer calibration is justified by this audit.

The caption-placement continuation is bounded to percentage-based WebVTT settings.
The shared planner owns parsing and placement math, while WPF and Avalonia only apply
the resulting rectangle to their native caption surfaces. Focused coverage is
Presentation 12/12, WPF media-host 32/32, and Avalonia media-host 8/8; both host
projects build with 0 warnings and 0 errors.

The chart continuation closed two concrete native ChartEx editing gaps. Single-series
non-waterfall ChartEx data edits now update the preserved category/value payload while
leaving family-specific XML untouched; an explicit chart-type change now converts the
object to a modeled classic chart and remains undoable. No-edit native ChartEx
round-trips remain on the verbatim preservation path. Focused chart coverage is
2,025/2,025 host tests plus 3,631/3,631 shared Presentation tests on the Release
baseline.

The native ChartEx data path now also resolves the schema's per-series `cx:dataId`
references. Multi-series preserved payloads with one unambiguous category dimension and
one value dimension per referenced series can be edited through the existing chart-data
command, while ambiguous families remain verbatim. The reader reconstructs omitted
`cx:pt` gaps from `ptCount`/`idx`, and the writer changes only the referenced values and
series names, retaining family-specific extensions. This closes the basic multi-series
authoring gap without pretending that series-specific layout, decoration, or connector
semantics are modeled.

The current table lane also closes a concrete fixed-width paginated-cell gap. When
the WPF host owns a nested `TableCell`/`BlockUIContainer` inset, serialized positive
left margin is mapped to the measured residual rather than double-counted. The
matched 816x528 sequence improved p1/p2/p3 from **6.9059/9.2442/7.3462%** to
**6.7027/8.8065/7.1575%**, with bounded table ROIs improving on every page and
ordinary positive-spacing/no-spacing controls byte-stable. `DocumentViewRoundTrip`
coverage for the lane is **50/50**.

## What remains

- Advanced SmartArt layout/style/effect semantics outside the bounded live catalog and
  PowerPoint-authoritative authoring baselines.
- Richer chart authoring/layout semantics, including series-specific native ChartEx
  layout, exact Office connector geometry, and remaining native decoration families.
- Full Zoom authoring depth beyond the current target, preview, cover-image, crop,
  retargeting, target-list, and tile-layout paths.
- Broader real-deck media/caption/recording persistence and PowerPoint recording baselines,
  beyond the now format-preserving internal caption authoring path, XamlPackage/RTF
  clipboard paths, native Windows capture/export adapters, and the corrected Windows
  camera identity handoff.
- Printer-driver/OS-owned dialog behavior, portable non-Windows OLE, and physical mixed
  workflow validation.
- PowerPoint COM-backed visual validation for claims that need Microsoft-authored output.

These are evidence or platform boundaries unless a reproducible user-visible behavior
demonstrates a narrower function gap. The next session should not spend time on isolated
pixel calibration without such a function-first trigger.
