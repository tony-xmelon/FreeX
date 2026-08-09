# FreeP Function-First Status: 2026-08-09

This is the current function-first checkpoint for the FreeP parity lane. It is
deliberately separate from pixel-level tuning: a feature is considered useful
when its authored semantics survive import, editing, save/reopen, and the
WPF/Avalonia workflow that consumes them.

## Current baseline

- Main tip at the prior checkpoint: `d2197a476c`.
- Current function-first checkpoint: `c98f962036` (`freep: refresh unsupported SmartArt cached visuals`).
- Current source audit tip: `c98f962036`; the checkpoint includes the WPF rich-editor list-marker, inherited list-layout, inherited run-style, and unsupported-SmartArt cached-authoring slices.
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
- cache-only SmartArt picture replacement/clearing, plus live and insertion
  payload support for the vertical picture-list layout; Avalonia inline page
  breaks now also paginate through the shared display-layer path.
- SmartArt Quick Style and Change Colors now refresh simple cached fallback nodes
  when a parsed data tree is present but its live layout grammar is unsupported;
  native style/color parts and the visible cached owner stay aligned.

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
  partially populated media payloads, and authoritative PowerPoint visual
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
  capture backend. Live microphone/camera capture, device permission/error UX,
  and real PowerPoint recording baselines remain unproven because they require
  hardware and host-observable capture. Injected payload and unavailable-device
  contracts are separate and green; a deferred result must not be mistaken for
  a missing product route.
- Media/captions: broader real-deck native media/caption corpus coverage and
  advanced caption styling/accessibility semantics remain open.
- Editing depth: unsupported XamlPackage/RTF controls, richer list/field/RTL/
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
