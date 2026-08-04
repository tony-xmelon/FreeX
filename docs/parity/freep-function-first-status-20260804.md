# FreeP Function-First Status - 2026-08-04

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
- Windows WPF and Windows Avalonia camera readiness now enumerate the same WinRT
  `DeviceInformation` identities consumed by `MediaCapture`; a missing requested
  camera is deferred explicitly instead of silently selecting another device.

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

## What remains

- Advanced SmartArt layout/style/effect semantics outside the bounded live catalog and
  PowerPoint-authoritative authoring baselines.
- Richer chart authoring/layout semantics, including exact Office connector geometry and
  remaining native decoration families.
- Full Zoom authoring depth beyond the current target, preview, cover-image, crop,
  retargeting, target-list, and tile-layout paths.
- Broader real-deck media/caption/recording persistence and PowerPoint recording baselines,
  beyond the now format-preserving internal caption authoring path and the corrected
  Windows camera identity handoff.
- Printer-driver/OS-owned dialog behavior, portable non-Windows OLE, and physical mixed
  workflow validation.
- PowerPoint COM-backed visual validation for claims that need Microsoft-authored output.

These are evidence or platform boundaries unless a reproducible user-visible behavior
demonstrates a narrower function gap. The next session should not spend time on isolated
pixel calibration without such a function-first trigger.
