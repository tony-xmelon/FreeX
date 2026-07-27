# FreeP SmartArt Relationship Tail - 2026-07-27

FreeP now exposes two additional PowerPoint Relationship-family SmartArt layouts
through the shared WPF/Avalonia workflow:

- `relationship1` / Basic Relationship: two or three overlapping translucent ellipses.
- `opposingIdeas` / Opposing Ideas: two to four inward-facing arrow nodes arranged
  in opposing left and right columns.

Both layouts are now admitted by the package reader, represented by the shared
live layout engine, available through the authoring planner and insertion factory,
and reachable from both host ribbons. Native layout IDs and node text survive
save/reopen through the existing SmartArt package path; edits remain owned by the
shared undoable editing session.

This is function-first shared-layout coverage. It does not claim exact PowerPoint
polygon sizing, effects, text offsets, or PowerPoint-authoritative raster parity.

## Verification

- FreeP Presentation SmartArt lane: 242 passed.
- FreeP WPF SmartArt/package/ribbon lane: 292 passed.
- FreeP Avalonia headless workflow lane: 219 passed.
- Generated command inventory: both new layout and insertion commands present in
  WPF and Avalonia profiles with zero actionable host gaps.
