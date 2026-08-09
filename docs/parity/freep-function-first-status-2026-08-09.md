# FreeP Function-First Status: 2026-08-09

This is the current function-first checkpoint for the FreeP parity lane. It is
deliberately separate from pixel-level tuning: a feature is considered useful
when its authored semantics survive import, editing, save/reopen, and the
WPF/Avalonia workflow that consumes them.

## Current baseline

- Main tip at the prior checkpoint: `d2197a476c`.
- Current function-first checkpoint: `b331667406` (`freep: preserve RTF text effects`).
- Current source audit tip: `b331667406`; the checkpoint includes the WPF rich-editor list-marker, inherited list-layout, inherited run-style, unsupported-SmartArt cached-authoring, schema-valid SmartArt picture-cache synchronization, and external RTF underline/text-effect normalization through the shared undoable/clipboard paths.
- Command inventory: `668` command IDs present in both WPF and Avalonia; the
  inventory reports `0` WPF-only, `0` Avalonia-only, and `0` actionable command
  gaps.
- Functional corpus recorded in the baseline evidence: `27/27` decks opened,
  `53/53` slide PNGs emitted, with no failed exports, missing references, or
  unexplained evidence diffs.
- Latest broad package gate reported by the active lane: FreeP Core I/O
  `1494/1494`, with the recent native-field and run-token additions included.
- Recent host/shared gates include WPF/Avalonia animation timing, TTML region
  layout, PAGEREF/TOC/TOF/index/TOA ownership, section parity pages, print page
  ranges, automatic hyphenation, media reflection export, and SmartArt package
  editing. Those slices were accepted only with focused host tests and clean
  consuming Release builds.

## Functionally covered

The current implementation has end-to-end coverage for the main authoring and
playback workflows: shared command routing, animation authoring and timing,
SmartArt outline/text-pane editing, bounded assistant hierarchy operations,
ChartEx title/legend/data/label edits, Zoom frame and return behavior, media
seek/bookmarks/loop/rewind, caption sidecars and TTML/DFXP timing, generated
TOC/TOF/TOA/index fields, PAGEREF logical labels, section parity pages, print
page ranges, table-cell rich editing, native field/revision/ruby/bidi package
retention, and Word-style native media/effect payload preservation.

Recent function-first additions on main include:

- authored WPF/Avalonia animation acceleration and deceleration;
- native per-record merge-field prompting;
- TTML region origin/extent, alignment, writing mode, and sequential timing;
- physical/logical page ownership shared by PAGEREF and generated indexes;
- durable XE marks, subentries, cross-references, formatting switches, ranges,
  alternate identifiers, Mark All, selective Insert/Update Index, and native
  INDEX/TOC/TOA field ownership;
- homogeneous NextPage sections, table-first section starts, EvenPage/OddPage
  physical blanks, and post-composition print ranges;
- automatic hyphenation for body, table, and note stories without mutating
  model/caret text, plus direct-PDF display-layer parity;
- native Office artistic-effect source/preview separation and mixed run tokens
  such as breaks, no-break hyphens, smart tags, move revisions, ruby, and bidi.
- external RTF character highlighting through `\\highlightN`/`\\chcbpatN`,
  including writer round-trip through the existing per-run text-fill model.
- external RTF baseline offsets now round-trip exact `\\upN`/`\\dnN` half-point
  controls instead of collapsing authored values to coarse `\\super`/`\\sub`.
- external RTF double, dashed, thick, and wave underline controls now retain
  the shared `Run.Underline` semantic and normalize back to canonical `\\ul`.
- WPF XamlPackage per-run `Background` fills, including direct and style-resource
  input plus writer package round-trip through the same text-fill model.
- WPF in-canvas rich editing now shows character, auto-number, and image list
  markers through tagged display-only inline visuals; marker text is excluded
  from model runs, clipboard payloads, and logical caret offsets. Paragraphs
  with no local bullet now inherit character/number marker defaults from
  `TextBody.LstStyle`, while explicit `BulletSuppressed` remains authoritative;
  alignment and list indentation inherit through the same style chain, with
  local paragraph values overriding it. Inherited run defaults are applied at
  paragraph scope so WPF shows style font/color defaults without baking them
  into model runs during a no-op edit round-trip.
- Windows WPF and Windows Avalonia now attempt native in-place OLE hosting for
  unrotated, unflipped slide objects, commit edited bytes back to the model, and
  fall back to external activation when the server declines or fails.
- Windows-native presenter capture now classifies permission denial, privacy
  policy blocking, cancellation, and ordinary device failures into actionable
  status text instead of exposing raw WinRT exception messages. The capture
  engine and package payload contract are unchanged; hardware-observable
  permission prompts still require an integration fixture.
- cache-only SmartArt picture replacement/clearing, plus live and insertion
  payload support for the vertical picture-list layout; Avalonia inline page
  breaks now also paginate through the shared display-layer path.
- imported SmartArt picture-cache replacement/clearing now recognizes the
  schema-valid `dsp:sp` + `a:blipFill` owner emitted by the writer, as well as
  legacy `dsp:pic`-shaped payloads; the corresponding `ShapeFill.Picture`
  fallback owner is refreshed or removed with the native media relationship.
- a newly populated picture node can now attach to an existing cached shape
  owner without rebuilding unsupported SmartArt layout geometry; the owner’s
  authored transform survives while the media relationship and fallback fill
  are added through the same undoable session.
- SmartArt Quick Style and Change Colors now refresh simple cached fallback nodes
  when a parsed data tree is present but its live layout grammar is unsupported;
  native style/color parts and the visible cached owner stay aligned through
  undo/redo as well as direct planner calls.

## Current-source audit: 2026-08-09

The source audit was intentionally function-first. It found no new safe chart
omission: doughnut, radar, bubble, stock, and Surface3D chart dispatches are
present in both WPF and Avalonia. It also confirmed that the earlier OMML
equation-array distribution gap is already represented by the shared model and
layout planner. Those areas remain visual/evidence-depth work, not missing
authoring routes.

The follow-up audit at `927be181cf` likewise found no smaller reproducible
functional omission in the remaining candidates: connection-site resolution,
SmartArt authoring/cache fallback, animation-pane workflow, accessibility/alt
text, external RTF/XamlPackage clipboard paths, and rectangular Windows OLE
hosting already have an implemented route or an explicit host boundary. The
next product slice should therefore be selected from the bounded items below
with a concrete package or host trigger, rather than inferred from a visual
residual.

Rotated or flipped OLE is a genuine architectural boundary rather than a
missing transform property. Native in-place activation creates an HWND child;
the current WPF/Avalonia host engines can size that child but cannot apply the
slide's rotation/flip transform. Both hosts therefore reject that route and
retain external activation as the safe fallback. A visual-only transform shim
would not provide editable in-place OLE semantics and was deliberately not
added.

The remaining rich-editor boundary is similarly explicit: WPF now has
display-only list markers, including inherited list-style defaults, without
contaminating model text or caret offsets, but full list-continuity behavior
after arbitrary edits and IME behavior remain deferred. The marker slice is recorded in
`docs/parity/freep-wpf-rich-editor-list-markers-20260809.md`.

## What remains

These are genuine depth or evidence gaps, not generic missing ribbon commands:

- SmartArt: broader PowerPoint-authored layout/style/color regeneration,
  richer assistant/org-chart semantics, cache authoring for unsupported or
  partially populated media payloads when no authored cached shape owner
  exists, and authoritative PowerPoint visual
  baselines for the many bounded live layout families. The current lane now
  covers the vertical picture-list insertion path and cache-only picture
  replacement/clearing; those are no longer open omissions.
- Charts: exact Surface3D mesh/camera/facet ownership, family-specific radar,
  stock, doughnut, bubble, and ChartEx visual acceptance thresholds, and wider
  real-deck chart coverage. The shared ChartEx data/title/legend/label editing
  path is present; the remaining work is depth and authoritative comparison.
- Animation pane and advanced effects: PowerPoint-authoritative pane UI and
  exact advanced-effect playback comparisons still require a COM-capable
  baseline capture, even though the shared workflow and many playback families
  are covered.
- Presenter recording: the Windows WPF and Windows Avalonia default routes now
  select the WinRT camera engine, and Linux Avalonia selects its native
  capture backend. Live microphone/camera capture and real PowerPoint recording
  baselines remain unproven because they require hardware and host-observable
  capture. Native permission/policy/cancellation failures now have explicit
  user-facing status classification; injected payload and unavailable-device
  contracts are separate and green. A deferred result must not be mistaken for
  a missing product route.
- Media/captions: broader real-deck native media/caption corpus coverage and
  advanced caption styling/accessibility semantics remain open.
- Editing depth: provider-specific XamlPackage/RTF controls beyond the shared
  underline semantic, richer list/field/RTL/
  IME behavior, and rotated/flipped OLE transforms remain bounded. Portable
  non-Windows OLE remains an explicit platform gap; Windows in-place hosting is
  now covered for the rectangular unrotated route.
- Native print/driver behavior: foreground dialog behavior and real printer or
  driver-level validation remain outside the deterministic paginator tests.

## Visual position

Visual parity is no longer the primary optimization lane. The last reported
FreeW WPF rerank covered `54` matched pages with mean RGB delta `4.1965%` and
median `3.7018%`; the largest residuals were table composition, multi-column
print/PDF fragmentation, and transformed WordArt/VML text paths. Those numbers
are evidence from the latest matched corpus, not a claim that every current
main artifact has identical pixels. Further raster changes should require a
new source-owned behavior and a complete target/control gate.

## Next useful work

The next implementation pass should pick one deferred functional owner with a
reproducible package or host trigger, prove it through both hosts, and only
then add visual comparison if the behavior changes rendered output. The current
inventory does not justify another global easing, font, margin, or compositor
calibration based on pixel residuals alone.

The current-main review also confirmed that the older Arc Left, Arc Up, and Arc
Down motion-path branch is already represented on main; no duplicate command or
historical inventory merge is needed.

### 2026-08-09 external RTF text effects

External RTF `\\outl` and `\\shad` character controls now map to the shared
run outline and shadow owners. WPF and Avalonia already consume those owners
through their common text visual plan; the RTF writer emits the boolean
controls on round-trip. Provider-specific effect parameters are intentionally
outside this control-only boundary. Focused shared RTF coverage passes 64/64,
WPF rich clipboard coverage 23/23, and Avalonia clipboard coverage 40/40.

### 2026-08-09 external RTF field instructions

Integrated as `0d8f3024f` on the current main tip.

External RTF fields now preserve the complete bounded non-hyperlink instruction
through `FieldRun.Instruction`, the in-canvas clipboard payload, and RTF
serialization. `FieldType` remains the native PPTX token; native `a:fld` output
is unchanged. The focused field round-trip gate covers `PAGE \\* MERGEFORMAT`
and the existing safe hyperlink boundary.

### 2026-08-09 native PowerPoint field metadata

Native DrawingML fields now preserve authored `a:fld/@id` and nullable
`a:fld/@dirty` through the model, PPTX reader/writer, model/edit clones, and
in-canvas clipboard payload. New fields retain generated IDs; omitted `dirty`
remains omitted while explicit `0` and `1` survive. The WPF MediaFields gate is
36/36 and the shared external clipboard gate remains 64/64. This is a package
and update-semantics slice, with no new raster claim.

### 2026-08-09 native text-run metadata

Ordinary DrawingML text runs now preserve authored `a:rPr/@lang` and nullable
`a:rPr/@dirty` through the shared run model, PPTX reader/writer, edit/model
clones, and in-canvas clipboard payload. Omitted tokens remain omitted while
explicit language and dirty values are emitted. The WPF MediaFields gate covers
the added native run round-trip.

### 2026-08-09 native text-run proofing metadata

Ordinary DrawingML text runs now also preserve nullable `a:rPr/@noProof` and
`a:rPr/@err` through PPTX read/write, model/edit clones, and in-canvas
clipboard payloads. Explicit `0` and `1` survive while omitted flags remain
omitted. This preserves authored proofing/error state without claiming a
proofing engine; WPF `MediaFieldsTests` passed 37/37 and the focused clipboard
gate passed 8/8 compiled plus 8/8 no-build.
