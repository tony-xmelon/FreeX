# FreeP Function-First Status - 2026-08-02

## Current position

The current `main` baseline reports **619/619** FreeP command IDs shared by WPF and
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
The parsed SmartArt quick-style model now also retains each native style label's line, fill,
effect, and font reference indices through cloning, so function-first editing does not discard
the source style matrix references even when the raw quick-style part remains the authority.

Slide Zoom now has a shared authoring workflow in WPF and Avalonia: the Insert ribbon command
offers other slides, writes a native PowerPoint 2016 `pslz:sldZm` frame with the writer's
effective target slide id, and routes insertion through the existing undo/redo command bus.
The authoring path is covered for loaded and unsaved decks, and a package round-trip verifies
that the native target survives save/reopen. Existing slideshow navigation and preserved-object
fallback rendering remain unchanged.

Section Zoom authoring now uses the same workflow for named sections. Both hosts offer populated
sections, create a native PowerPoint 2016 \`sectionZmObj\` payload, and preserve the existing section
membership/undo contracts through save and reopen. Section and slide target navigation therefore
share one functional authoring path; Summary Zoom previews and the shared Zoom Format command now
cover the first presentation-depth layer, while PowerPoint-exact cover styling remains separate work.

Summary Zoom now completes the multi-target side of that workflow. Both hosts expose a multi-select
Insert Summary Zoom command, the shared model retains every section tile and its native layout factors,
the writer emits the PowerPoint 2016 \`summaryZmObj\` collection with a fixed layout, and slideshow
hit-testing resolves the clicked tile to its section's first slide. Package round-trip and undo/redo
are covered. Authored Summary Zooms now also render each target section's first slide through the active
WPF/Avalonia renderer and attach the PNG to the corresponding \`summaryZmObj\` as a relationship-backed
preview. Slide and Section Zoom insertion now uses the same single-target preview path, so all three Zoom
types receive a host preview immediately and preserve it through save/reopen. The writer preserves those
preview parts through save/reopen and retains a legacy
AlternateContent shape fallback for viewers without the native zoom extension. The shared WPF/Avalonia
Zoom Format command now edits `returnToParent`, `imageType`, `transitionDur`, and `showBg` across every
summary tile as one undoable operation while preserving unmodeled XML. Slide and Section Zooms expose an
undoable Set Zoom Cover Image command, and Summary Zoom now lets the user choose an individual tile before
replacing that tile's native `blipFill` relationship. Each tile receives its own relationship-backed media
part; model tests cover independent tile images, undo/redo, and package round-trip. The authored target
semantics are no longer collapsed to a single section.

The follow-up capability audit corrected the remaining list against current code: Avalonia already
has Windows native printer submission, MP4 export, persisted narration muxing, and camera
picture-in-picture handoff. Those are no longer classified as wholly deferred. The remaining
printer gap is the PowerPoint-style printer-selection dialog on Avalonia; its Windows adapter
currently submits through the native shell handoff after the shared print plan is built.

The chart package reader now also honors authored `c:order` for series groups when reopening a
deck, so a producer's physical XML order cannot silently change plot or legend order. A focused
package regression covers reversed `c:ser` placement with preserved authored order.

Pie and doughnut point explosion is now a complete authoring path: `<c:explosion>` survives
PPTX round-trip, the shared WPF/Avalonia planner moves the selected slice and label, and the
existing Chart Point Options command/dialogs can set the bounded 0-100% value with undo.

The WPF rich-text editor now upgrades an inline OLE placeholder to a native in-place OLE host
when the registered server is available, while retaining the placeholder and external-activation
fallback when it is not. Windows Avalonia now uses the same COM site lifecycle through
`NativeControlHost`, with measured inline-run placement and save-back on host teardown; portable
Avalonia targets retain external activation.

The Avalonia Windows Print pane now opens the native Windows printer-selection dialog through
`PrintDlgEx`, then routes the selected queue through the existing capability-checked PDF handoff.
Portable/Linux printing remains on its platform adapter and is not affected.

## What remains

- Advanced SmartArt regeneration and style semantics beyond the current live layout catalog.
- Richer chart authoring/layout semantics beyond the modeled chart grid and option planners.
- Full Zoom authoring depth beyond the current slide, section, and summary target/preview/cover-image paths,
  including PowerPoint-exact preview crop/position styling and transition rendering.
- Portable/non-Windows in-place OLE hosting inside text runs remains external activation; Windows
  WPF and Windows Avalonia now have native in-place host paths with model byte save-back.
- Broader real-deck media/caption/recording persistence and PowerPoint-authoritative recording
  baselines beyond the current deterministic capture and handoff paths.
- Broader PowerPoint-authoritative export baselines and printer-setting handoff beyond queue
  selection.
- Physical WPF/Avalonia interaction proof for richer mixed workflows and PowerPoint COM-backed
  validation where exact application behavior or visual parity is being claimed.

The visual-parity lane is intentionally treated as evidence-led and bounded. Existing Word/PowerPoint
comparisons are useful for ranking residuals, but they do not override function-first priorities or
justify broad pixel calibrations without a reproducible user-visible behavior to close.
