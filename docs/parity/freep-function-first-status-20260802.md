# FreeP Function-First Status - 2026-08-02

## Current position

The current `main` baseline reports **614/614** FreeP command IDs shared by WPF and
Avalonia, with **0 actionable WPF gaps, 0 actionable Avalonia gaps, 0 known deferred
command rows, and 103 workflow-evidence rows**. This is reachability coverage, not a
claim that every PowerPoint feature has identical depth or native behavior.

The latest functional work is concentrated in three areas:

- **Authoring and package compatibility:** SmartArt layouts remain live through insertion,
  Change Layout, editing, cache recovery, and package round-trip for the current catalog;
  table-design flags and grouped-table editing are undoable; chart data and chart option
  dialogs cover indexed series/category edits and the current modeled chart properties.
- **Rich text and embedded content:** external RTF now preserves inline images, embedded OLE,
  nested tables, row heights, tab stops/leaders, and nested-cell text direction through the
  shared WPF/Avalonia visual path. Inline OLE activation updates the live run after the
  external editor closes.
- **Presentation workflows:** animation timing, triggers, playback, presenter timing modes,
  transitions, notes fields, output planning, and Windows video execution have shared
  planner/host routes with focused tests. The slide-layout picker and selection mutation are
  also implemented in both hosts; earlier documentation describing it as a stub is stale.

## Progress by day

### 2026-07-27 to 2026-07-30

The function-first lane moved from command reachability into behavior depth: chart entry
removal and chart option authoring, presenter record/rehearse timing, table-cell and row/column
authoring, SmartArt layout admission/cache recovery/picture placeholders, shape effect authoring,
and broader SmartArt live-layout coverage.

### 2026-07-31

Rich-editor and compatibility depth expanded: nested inline tables and embedded objects became
position-preserving `U+FFFC` runs, inline OLE activation was wired through both hosts, nested RTF
row heights and tab controls were retained, and SmartArt cache connector variants were accepted.

### 2026-08-01

Notes and output behavior gained uncached automatic fields, automatic header/footer date formats,
host-aware Windows video execution, table-design emphasis commands, and additional SmartArt/cache
package compatibility. The command inventory remained synchronized across both hosts.

### 2026-08-02

Nested RTF cell text direction now survives parsing, clipboard serialization, and both host
compositors. The Avalonia nested inline-table editor now consumes the same parsed quarter-turn
cell text directions instead of painting those cells horizontally. The native `trapezoidList`
SmartArt route now emits editable trapezoid nodes with bounded slant geometry instead of falling
through to rounded rectangles. A review of the proposed grouped-table follow-up found that
behavior already exists on current `main`; no duplicate implementation was added.
Native SmartArt quick styles `simple1` through `simple5` now resolve to distinct live profiles
(Simple Fill, White Outline, Subtle, Moderate, and Intense) instead of allowing the generic
`simple` identifier to collapse Moderate and Intense into the Subtle rendering path.

The follow-up capability audit corrected the remaining list against current code: Avalonia already
has Windows native printer submission, MP4 export, persisted narration muxing, and camera
picture-in-picture handoff. Those are no longer classified as wholly deferred. The remaining
printer gap is the PowerPoint-style printer-selection dialog on Avalonia; its Windows adapter
currently submits through the native shell handoff after the shared print plan is built.

The WPF rich-text editor now upgrades an inline OLE placeholder to a native in-place OLE host
when the registered server is available, while retaining the placeholder and external-activation
fallback when it is not. Avalonia continues to use its cross-platform external activation path.

## What remains

- Advanced SmartArt regeneration and style semantics beyond the current live layout catalog.
- Richer chart authoring/layout semantics beyond the modeled chart grid and option planners.
- Cross-host in-place OLE hosting inside text runs: WPF now has the native host path, while
  Avalonia still uses external activation until an equivalent native host is available.
- Broader real-deck media/caption/recording persistence and PowerPoint-authoritative recording
  baselines beyond the current deterministic capture and handoff paths.
- PowerPoint-style printer-selection dialog execution on Avalonia (Windows native queue submission
  is already available), plus broader PowerPoint-authoritative export baselines.
- Physical WPF/Avalonia interaction proof for richer mixed workflows and PowerPoint COM-backed
  validation where exact application behavior or visual parity is being claimed.

The visual-parity lane is intentionally treated as evidence-led and bounded. Existing Word/PowerPoint
comparisons are useful for ranking residuals, but they do not override function-first priorities or
justify broad pixel calibrations without a reproducible user-visible behavior to close.
