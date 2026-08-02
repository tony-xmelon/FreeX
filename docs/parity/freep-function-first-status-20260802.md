# FreeP Function-First Status - 2026-08-02

## Current position

The current `main` baseline reports **641/641** FreeP command IDs shared by WPF and
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

The generated command inventory was refreshed on 2026-08-02 from both ribbon profiles and
matches this count: WPF and Avalonia have no actionable command gaps. This is reachability
evidence only; the backlog below is intentionally about behavior depth and native workflow
semantics rather than adding duplicate command IDs.

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

Funnel and Waterfall chart creation is now reachable from the actual shared Insert Chart
command catalog and ribbon in both desktop hosts. The existing chart model, package,
editable-data, and renderer paths were already present; this closes the remaining
authoring entry-point gap without changing visual behavior.

Combo chart creation now has a direct Insert Chart command as well. It creates an
undoable column-plus-line chart with the line series on the secondary axis, reusing the
existing combo package and renderer semantics.

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

SmartArt Change Layout now updates the native layout definition's title and category metadata
alongside its unique ID. Saved decks therefore report the selected layout consistently to
PowerPoint and other consumers, including when FreeP had to synthesize a missing layout part;
the raw layout body and unsupported attributes remain preserved.
The native `3d1` through `3d9` SmartArt scene styles now also resolve to distinct bounded live
profiles (Polished, Inset, Cartoon, Powder, Brick Scene, Flat Scene, Metallic Scene, Sunset Scene,
and Bird's Eye Scene) in the shared planner. Their native quickStyle identities and raw parts remain
round-trip authoritative; exact Office bevel, lighting, and effect raster semantics remain visual
depth work.

SmartArt Quick Style authoring now refreshes the shared model's per-label line, fill, effect, and
font reference metadata from the newly selected native `styleLbl` elements. A style change therefore
cannot leave the live editor carrying reference indices from the previous Quick Style; the raw style
part remains authoritative for unsupported fields.

SmartArt Change Colors now targets the native node `styleLbl` fill palettes instead of the first
`fillClrLst` in document order. This preserves background/style-label fills when a valid colors
part places them before `node0`, while keeping the shared WPF/Avalonia authoring and undo routes
unchanged. The package-owner regression is covered by Presentation, WPF, and Avalonia tests;
this is a functional/source-semantics fix with no new raster-fidelity claim.

Regenerated SmartArt picture caches now use schema-valid `dsp:sp` nodes with `a:blipFill`
instead of the invalid `dsp:pic` child under `dsp:spTree`. Image relationships, geometry,
reader reopen, and node picture bytes are preserved; the full Presentation test project is
green at 3418/3418.

Hierarchy SmartArt reordering now keeps the assistant prefix ahead of regular reports. Move Up/Down
still reorders peers within the assistant and report partitions, but rejects a move that would cross
that PowerPoint org-chart boundary, preventing an assistant from becoming an ordinary report or a
report from being promoted ahead of assistants.

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

The shared slideshow route now consumes Zoom `returnToParent`: omitted source attributes use
PowerPoint's default-on behavior, explicit `false` remains opt-out, and WPF/Avalonia both return
to the parent slide after the Zoom target is exhausted. Nested return paths use a stack, while
ordinary direct slide jumps clear stale Zoom context. This closes a functional navigation gap;
the same route now consumes a valid authored `transitionDur` as a Zoom transition duration in
both hosts. Both hosts can now restore a custom Zoom cover to a freshly rendered native target
preview through one undoable command, including an individually selected Summary Zoom tile.
PowerPoint-exact preview position styling remains separate work; crop authoring is now covered.

Zoom `showBg` is now consumed at the slideshow transition boundary in both desktop hosts. The
incoming target surface honors the authored setting (with PowerPoint's omitted-attribute default
of true), while the outgoing slide is captured with its own background before the transition
composes the two surfaces. Instant display and transition completion restore normal background
painting. Focused shared planner coverage passed 206 tests; the WPF host policy source contract
passed 2 tests, the Avalonia host policy contract passed 4 tests, and both consuming Release
host builds completed with zero warnings/errors. This closes a functional transition-state gap;
it is not a claim of PowerPoint-exact Zoom position or transition raster parity.

Summary Zoom tile layout is now authorable from the shared Zoom Format route. Both hosts expose
each tile's offset and scale as percentage pairs; the shared command updates the selected
`summaryZmObj`, preserves the other tiles, and restores the complete tile state through undo/redo
and PPTX save/reopen.

The Zoom Format dialog now exposes preview crop edges in both desktop hosts. Values are stored
in the shared `ZoomObjectProperties` model as PowerPoint's thousandths-of-a-percent units,
patched into native DrawingML `a:srcRect`, and carried through the existing undo/redo and
save/reopen path. Blank crop input preserves the pre-existing uncropped XML shape.

The follow-up capability audit corrected the remaining list against current code: Avalonia already
has Windows native printer submission, MP4 export, persisted narration muxing, and camera
picture-in-picture handoff. Those are no longer classified as wholly deferred. Portable Avalonia
now also opens an in-app PowerPoint-style printer/settings surface backed by the shared
`PrintSelectionPlanner` and `IPlatformPrintService`. It discovers actual CUPS queues and carries
printer, copies, page range, collation, and orientation settings into the foreground submission;
the shared presentation planner remains authoritative for slide range, layout, and handout
slides-per-page. This is an application-owned settings surface, not a claim of OS-owned print
dialog chrome parity.

The Wave 105 Docker/X11 physical lane now proves that portable route through real application
input. It opens File > Print, activates the first print layout, selects a non-default queue,
submits two landscape uncollated copies for pages 2-3 through the private fake CUPS boundary,
captures the generated PDF, and restores owner focus. All nine strict gates pass; no test-only
print callback or fabricated application queue is used.

The chart package reader now also honors authored `c:order` for series groups when reopening a
deck, so a producer's physical XML order cannot silently change plot or legend order. A focused
package regression covers reversed `c:ser` placement with preserved authored order.

Chart axis options now also support PowerPoint's authored `c:customUnit` divisor. The custom
value is editable in both desktop hosts, participates in undo/redo, survives PPTX save/reopen,
and is consumed by the shared axis-label renderer; built-in and unknown display-unit behavior
remains unchanged.

Chart-level `c:roundedCorners` is now consumed by the shared scene plan and rendered as a
bounded rounded chart frame in both WPF and Avalonia; omitted metadata remains rectangular.

Native `c:ofPieChart` families are now retained as an explicit pie-of-pie/bar-of-pie chart
model through clone and PPTX save/reopen, including `ofPieType`, split rule/position, secondary
pie size, gap width, and series-line presence. Both hosts route the imported family through the
existing pie primitives rather than silently changing it to a column chart. The shared scene plan
now splits visible points into primary and secondary plots according to the authored split mode;
both WPF and Avalonia render a secondary pie or bar from those primitives. Authored gap width
now scales the shared plot separation, and the authored series-line flag produces the same
two-segment connector plan in both renderers;
native custom split-point indices now
round-trip, drive both host renderers, and are editable through the shared Pie/Doughnut/OfPie
options workflow in both desktop hosts. That workflow also authors the secondary plot type,
split rule/threshold, secondary plot size, secondary plot gap width, and series-line intent with
undoable command semantics.

Pie and doughnut point explosion is now a complete authoring path: `<c:explosion>` survives
PPTX round-trip, the shared WPF/Avalonia planner moves the selected slice and label, and the
existing Chart Point Options command/dialogs can set the bounded 0-100% value with undo.

The WPF rich-text editor now upgrades an inline OLE placeholder to a native in-place OLE host
when the registered server is available, while retaining the placeholder and external-activation
fallback when it is not. Windows Avalonia now uses the same COM site lifecycle through
`NativeControlHost`, with measured inline-run placement and save-back on host teardown; portable
Avalonia targets retain external activation.

The Avalonia Windows Print pane continues to open the native Windows printer-selection dialog
through `PrintDlgEx`, then routes the selected queue through the existing capability-checked PDF
handoff. Portable/Linux printing now uses the CUPS platform adapter and the new Avalonia-owned
settings surface; it does not fabricate printer availability when CUPS is missing.

The continuation audit on the current main line found no new actionable command-level gap.
SmartArt layout admission/edit/cache regeneration, chart option dialogs and package semantics,
media caption-track parsing/playback, and Zoom target/preview/cover/crop/tile-layout routes are
already connected through shared model and host paths. The latest Zoom crop slice was verified
without reopening a visual-parity campaign. The next function-first work therefore remains
depth work in the backlog below, rather than another renderer-only calibration.

## What remains

- Advanced SmartArt regeneration and style semantics beyond the current live layout catalog.
- Richer chart authoring/layout semantics beyond the modeled chart grid and option planners,
  including exact Office connector-line geometry and the remaining native chart decoration
  families.
- Full Zoom authoring depth beyond the current slide, section, and summary target/preview/cover-image/crop/tile-layout
  paths, including PowerPoint-exact slide/section positioning and transition rendering.
- Portable/non-Windows in-place OLE hosting inside text runs remains external activation; Windows
  WPF and Windows Avalonia now have native in-place host paths with model byte save-back.
- Broader real-deck media/caption/recording persistence and PowerPoint-authoritative recording
  baselines beyond the current deterministic capture and handoff paths.
- Printer-driver-specific settings, OS-owned print-dialog chrome, and hardware-backed printer
  behavior remain platform boundaries beyond the modeled portable settings surface and Windows
  native queue-selection path.
- Physical WPF/Avalonia interaction proof for richer mixed workflows and PowerPoint COM-backed
  validation where exact application behavior or visual parity is being claimed.

The visual-parity lane is intentionally treated as evidence-led and bounded. Existing Word/PowerPoint
comparisons are useful for ranking residuals, but they do not override function-first priorities or
justify broad pixel calibrations without a reproducible user-visible behavior to close.
