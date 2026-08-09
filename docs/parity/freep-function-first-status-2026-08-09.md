# FreeP Function-First Status: 2026-08-09

This is the current function-first checkpoint for the FreeP parity lane. It is
deliberately separate from pixel-level tuning: a feature is considered useful
when its authored semantics survive import, editing, save/reopen, and the
WPF/Avalonia workflow that consumes them.

## Current baseline

- Main tip at this checkpoint: `592fb274c4`.
- Command inventory: `658` command IDs present in both WPF and Avalonia; the
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

## What remains

These are genuine depth or evidence gaps, not generic missing ribbon commands:

- SmartArt: broader PowerPoint-authored layout/style/color regeneration,
  richer assistant/org-chart semantics, picture/media-backed cache authoring,
  and authoritative PowerPoint visual baselines for the many bounded live
  layout families.
- Charts: exact Surface3D mesh/camera/facet ownership, family-specific radar,
  stock, doughnut, bubble, and ChartEx visual acceptance thresholds, and wider
  real-deck chart coverage. The shared ChartEx data/title/legend/label editing
  path is present; the remaining work is depth and authoritative comparison.
- Animation pane and advanced effects: PowerPoint-authoritative pane UI and
  exact advanced-effect playback comparisons still require a COM-capable
  baseline capture, even though the shared workflow and many playback families
  are covered.
- Presenter recording: live microphone/camera capture, default Windows camera
  encoding that produces local media bytes, permission/error UX, and real
  PowerPoint recording baselines remain unproven. Injected payload and
  unavailable-device contracts are separate and green.
- Media/captions: broader real-deck native media/caption corpus coverage and
  advanced caption styling/accessibility semantics remain open.
- Editing depth: unsupported XamlPackage/RTF controls, richer list/field/RTL/
  IME behavior, and in-place OLE hosting remain bounded or deferred. Portable
  non-Windows OLE also remains an explicit platform gap.
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
