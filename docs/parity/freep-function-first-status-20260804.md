# FreeP Function-First Status - 2026-08-05

Evidence anchor: current FreeP function baseline is the checked-out `main` commit.
The shared repository may contain newer FreeW merges; those are not counted as
FreeP feature evidence unless they touch the FreeP implementation or contracts.
Historical continuation entries below retain their original snapshot labels;
the current verified Release baseline includes **3,749/3,749** shared Presentation
tests, plus the focused
host and renderer contracts listed below. These are implementation/contract
counts, not a claim that every PowerPoint-native behavior has been reproduced.

## Current FreeP checkpoint - 2026-08-05

### Current-main refresh: `4152ba61ac`

The current `origin/main` tip is `4152ba61ac` (2026-08-05), not the older
`9c7f9d0983` checkpoint referenced later in this handoff. Since that older
checkpoint, FreeP added native Zoom frame-border soft-edge and reflection
authoring through the existing undo, package, WPF, and Avalonia routes. The
reflection model retains alpha, distance, direction, scale, and optional blur
metadata; both desktop dialogs expose the settings and native `a:reflection`
round-trips without changing unrelated Zoom properties.

Latest slice gates were Presentation planner/compositor **168/168**, WPF host
round-trip/Zoom authoring **46/46**, Avalonia Zoom authoring **4/4**, the full
`FreeP.App.Presentation.Tests` lane **3,770/3,770**, and a clean Release
solution build. The reflection renderer uses the shared mirror/fade ownership
path; directional/blurred raster equivalence remains an explicit visual-depth
boundary rather than an unverified parity claim.

The current function-first baseline therefore remains: **650/650** shared
commands, **0 actionable WPF gaps**, **0 actionable Avalonia gaps**, and **0
known deferred command rows**. The next implementation should be selected from
a reproducible feature-depth trigger, not from another isolated pixel delta.

## 2026-08-06 continuation - ChartEx explicit-empty authoring

Current main is `4d8b151d16`. The preserved native ChartEx writer now treats
cleared title and legend model values as explicit authoring operations: when a
user removes either item, the corresponding preserved `cx:title` or `cx:legend`
node is removed instead of being silently carried into the saved package.
Regression coverage is in `ChartDataCommandTests` (88/88 on the compiling and
no-build passes), with clean WPF and Avalonia Release builds. This is a package
and function correction; it makes no new visual-parity claim.

The audit following this slice found no additional reproducible missing command
route. SmartArt relationship families beyond the bounded imported `relationship1`
cache grammar remain intentionally preserved-cached unless a native cache grammar
is independently proven. ChartEx series layout, data, title, legend, and modeled
decoration paths remain source-scoped; unsupported family-specific payloads stay
verbatim. The remaining backlog is therefore the depth/platform list below, not
another generic command or pixel-only adjustment.

The latest FreeP-specific mainline work closes three bounded, source-backed gaps:

- `250ed89360` preserves authored SmartArt cache text formatting by stable model ID
  during drawing-cache regeneration, while generated geometry and text remain the
  editable authority.
- `5c7f6401b` / `861f75bf5b` add generated Table of Figures/Tables/Equations page
  references using the existing physical-page and logical-label resolver.
- `8e70312538` preserves PresentationML animation acceleration/deceleration through
  model clone, normal and motion-path package round-trip, and shared WPF/Avalonia
  slideshow easing.
- The current presenter-property slice preserves PresentationML `p:showPr/p:penClr` as a theme-aware model value,
  round-trips it through package IO, and seeds the shared WPF/Avalonia presenter session
  defaults without overriding explicit transient tool choices.

The animation and presenter-property slices pass the full Presentation Release lane at **3,749/3,749**;
focused WPF animation-pane coverage was **18/18**, Avalonia animation-pane coverage
was **4/4**, and both consuming desktop Release builds were clean. SmartArt and
generated-index evidence is recorded in their focused contracts and remains separate
from the visual-fidelity corpus.

This checkpoint does not widen the command-surface claim: the generated inventory is
still **650/650**, with **0 actionable WPF gaps**, **0 actionable Avalonia gaps**, and
**0 known deferred command rows**. The next FreeP implementation must come from a
reproducible depth boundary below, rather than another generic command or pixel-only
probe.

## Current position

The generated FreeP command inventory on `main` reports **650/650** command IDs
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
- Native print handoff is implemented at the host boundary: WPF opens the Windows
  `PrintDialog`, applies copies/collation/color options, and submits the shared raster
  paginator; Avalonia uses its platform printer adapters where available and retains an
  explicit preview/PDF fallback. The remaining print risk is OS/printer-driver behavior
  and foreground-dialog evidence, not an absent FreeP print route.
- Internal caption replacement now preserves an existing WebVTT, SRT, TTML, or DFXP
  package format and relationship identity; WebVTT remains the default for new tracks.
- External caption relationships can now be deleted or replaced through the shared
  authoring pane and undo bus without mutating the linked remote resource. Replace
  converts the selected relationship in place to an embedded caption part, preserving
  its slot and metadata while switching the relationship to package-owned content.
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
2,025/2,025 host tests plus 3,647/3,647 shared Presentation tests on the Release
baseline.

The native ChartEx data path now also resolves the schema's per-series `cx:dataId`
references. Multi-series preserved payloads with one unambiguous category dimension and
one value dimension per referenced series can be edited through the existing chart-data
command, while ambiguous families remain verbatim. The reader reconstructs omitted
`cx:pt` gaps from `ptCount`/`idx`, and the writer changes only the referenced values and
series names, retaining family-specific extensions. This closes the basic multi-series
authoring gap without pretending that series-specific layout, decoration, or connector
semantics are modeled.

The next bounded ChartEx authoring gap is now closed: each native series retains its
`cx:series/@layoutId` through read, clone, and write, and the shared editing session
exposes an undoable per-series layout edit without downgrading the object to classic
chart XML. The follow-up host slice adds a WPF and Avalonia ChartEx Series Layout
dialog and ribbon command. Its choices are allowlisted from layout IDs already present
in the preserved payload, so cancel remains non-mutating and unsupported family IDs
cannot be synthesized from the UI. Unsupported family-specific children remain
preserved rather than being synthesized. Focused chart contracts are **114/114** on
the compiling and no-build passes for the package/edit slice; the new shared planner
contracts are **3/3**, and both desktop projects build with 0 warnings and 0 errors.

The animation continuation now resolves authored `a:schemeClr` and direct RGB colors
through the active presentation theme and slide color map, including the bounded
lumMod/lumOff/tint/shade transforms used by PowerPoint animation effects. The shared
planner owns the color semantics; WPF and Avalonia only consume the resulting playback
colors. Focused coverage is Presentation 127/127, WPF host 2/2, and Avalonia host 4/4.

The current table lane also closes a concrete fixed-width paginated-cell gap. When
the WPF host owns a nested `TableCell`/`BlockUIContainer` inset, serialized positive
left margin is mapped to the measured residual rather than double-counted. The
matched 816x528 sequence improved p1/p2/p3 from **6.9059/9.2442/7.3462%** to
**6.7027/8.8065/7.1575%**, with bounded table ROIs improving on every page and
ordinary positive-spacing/no-spacing controls byte-stable. `DocumentViewRoundTrip`
coverage for the lane is **50/50**.

The chart continuation now exposes native waterfall connector-line visibility through
the existing shared Chart Options workflow. The planner and undoable display command
carry `ChartShape.ShowWaterfallConnectorLines`, and WPF/Avalonia show the checkbox only
for waterfall charts; classic chart behavior and the existing ChartEx payload path are
unchanged. Focused planner and command coverage is included in the current chart lane.

The follow-on chart function slice exposes existing line/stock `dropLines` and
`upDownBars` visibility through the same shared Chart Options workflow. The controls
are gated to line-marker/line/stock families, the atomic command preserves authored
gap and fill styling, and both desktop hosts use the same planner. Package and undo
coverage verifies that toggling visibility does not flatten or rewrite the chart
family payload.

The stacked-chart continuation also exposes authored `serLines` visibility for
stacked column/bar families. Its command changes only the presence token, preserving
the existing line style and chart geometry; planner, package/undo, and both-host dialog
coverage keep the control out of unsupported chart families.

The media continuation now preserves authored playback volume. `MediaInfo` carries a
clamped 0-100 percentage, the reader consumes `p:cMediaNode/@vol`, and the writer emits
the timing node when a non-default volume needs persistence instead of hard-coding
`80000`. WPF and Avalonia initialize their playback sessions from the same value, and
`EditingSession.SetSelectedMediaVolume` commits it through an undoable shared command.
Default 80% media remains package-compatible with the previous writer path.

The WPF and Avalonia media caption panes now expose that same value through a Playback
volume slider and Apply action, so the function is reachable from the desktop UI rather
than only through the shared editing API.

## 2026-08-05 continuation

The Slide Show Settings dialog is now reachable from both desktop ribbons and applies
the shared `UseSlideTimings`, `ShowWithAnimation`, and `LoopUntilStopped` state through
the existing undo bus. The playback setting is now consumed consistently: when
`ShowWithAnimation` is false, shared WPF/Avalonia host planning suppresses ordinary
slide transitions, Back transitions, and authored Zoom transitions as well as object
animation steps. This prevents the setting from disabling only shape animations while
leaving slide-level motion active. Focused host/planner coverage and the full Release
FreeP test lane remain the acceptance gate.

The same panes now expose the existing authored playback start mode (On click or
Automatically) and Loop until stopped flag. One shared undoable mutation updates both
values together, and both desktop hosts consume the persisted state during slide show
playback. This closes the media playback-options authoring gap without adding a host-local
media model.

The Set Up Slide Show workflow now also exposes the already-modeled PowerPoint
`showMediaCtrls` policy. The value is carried by the same shared undoable settings command,
round-trips through the existing PresentationML extension, and is consumed by both WPF and
Avalonia slideshow media controllers. The setting was previously available only through
the model/API, so this closes the last user-facing authoring gap in that bounded playback
policy without changing the media hit-testing or rendering contract.

The Set Up Slide Show mode is now functionally complete for the three PresentationML
show modes: Presented by a speaker, Browsed by an individual, and Browsed at a kiosk.
The selected mode round-trips through `p:present`, `p:browse`, or `p:kiosk`, is undoable
with the other show settings, and is reachable from both desktop dialogs. WPF and
Avalonia consume Browse-by-individual as a normal resizable slideshow window; speaker
and kiosk modes retain the existing borderless presentation window. This is a host
behavior slice, not a visual calibration claim.

The same show-mode state now retains PresentationML's browse scrollbar preference and
kiosk restart interval. `p:browse/@showScrollbar` and `p:kiosk/@restart` survive read,
undo, and write without being synthesized into the wrong show mode. The model names the
restart value as milliseconds, matching the PresentationML contract. Browse mode now
hosts the slide stage in a scroll container using the persisted scrollbar policy, and
kiosk mode restarts through the shared first-slide navigation plan after the persisted
interval in both WPF and Avalonia.

The slideshow package/compositor lane now honors `p:showPr/@showMasterSp`. The model
preserves its default-on/explicit-off state, and shared composition paints authored
non-placeholder master and layout decoration before slide content while leaving
placeholder definitions on their existing inheritance path. This restores a concrete
function gap for master-owned logos and decoration in playback/export without changing
the existing placeholder or background contracts. Focused shared package/compositor
coverage is **3/3**, the full Presentation suite is **3,728/3,728**, the host
round-trip/SmartArt/show-settings lane is **351/351**, and the consuming FreeP Release
build is clean.

The `Show master graphics` option is now reachable from both desktop Set Up Slide Show
dialogs and flows through the shared undo transaction, so the master-decoration policy
is editable as well as package-aware and compositor-consumed. WPF and Avalonia dialog
coverage asserts apply/undo with the option disabled.

The show-settings lane now also preserves `p:showPr/@showNarration` (defaulting to true)
through the model, undo command, and package reader/writer. Both desktop dialogs expose
the Play narration switch, and both slideshow hosts suppress audio playback/click plans
when it is disabled while continuing to present video. This is the bounded FreeP
interpretation of PowerPoint's authored narration policy; it does not claim full
PowerPoint recording-track classification or microphone/voice-over authoring parity.
Focused coverage for the shared settings/media contracts is **7/7**, WPF dialog **2/2**,
and Avalonia dialog **1/1** on a clean Release consumer build.

The Header and Footer workflow now preserves the document-level
`p:showPr/@showSpecialPlsOnTitleSld` policy alongside the existing per-slide visibility
flags. Applying to all slides updates that policy through the undo bus, both desktop
hosts surface the existing title-slide checkbox through the shared planner, and the
reader/writer round-trip the native attribute without inventing it when the policy is
off. This closes the package/function gap for title-slide special placeholders; it is
not a new visual calibration claim.

## What remains

- Advanced SmartArt layout/style/effect semantics outside the bounded live catalog and
  PowerPoint-authoritative authoring baselines.
- Richer chart authoring/layout semantics, including exact Office connector geometry,
  remaining native decoration families, and family-specific ChartEx layout behavior
  beyond selecting IDs already present in a source payload.
- Full Zoom authoring depth beyond the current target, preview, cover-image, crop,
  retargeting, target-list, and tile-layout paths.
- Broader real-deck media/caption/recording persistence and PowerPoint recording baselines,
  beyond the now format-preserving internal caption authoring path, XamlPackage/RTF
  clipboard paths, native Windows capture/export adapters, and the corrected Windows
  camera identity handoff.
- Printer-driver/OS-owned dialog behavior, foreground native-dialog evidence, portable
  non-Windows OLE, and physical mixed workflow validation.
- PowerPoint COM-backed visual validation for claims that need Microsoft-authored output.

These are evidence or platform boundaries unless a reproducible user-visible behavior
demonstrates a narrower function gap. The next session should not spend time on isolated
pixel calibration without such a function-first trigger.

## 2026-08-05 continuation

The function-first lane was rechecked from current `main` (`c7af0b78ef`). The
PowerPoint-authoritative corpus remains complete at **27/27 decks** and **53/53
slide PNGs**; the isolated COM export reports **0 failed exports**, **0 missing
references**, and **0 reference diffs**. This is the current baseline for any
new visual claim, but it does not turn a raster match into a feature claim.

## 2026-08-05 continuation — current-main verification

The function-first baseline was re-run from `origin/main` at `9c7f9d0983`, which
also includes the latest plain-text table projection merge from the concurrent
FreeW lane. The shared FreeP Presentation Release lane passed **3,735/3,735**
tests (0 failed, 0 skipped). The generated command inventory remains **650/650**
shared-profile commands, with **0 actionable WPF gaps**, **0 actionable Avalonia
gaps**, **0 known deferred command rows**, and **110 workflow-evidence rows**.

No new FreeP code slice is justified by this verification: the remaining list is
feature depth or host/evidence boundary work, not an unimplemented command route.
The next implementation should be selected only with a reproducible user-visible
trigger from one of these boundaries: a specific SmartArt family/style/effect,
ChartEx or chart-decoration semantics, Zoom preview/cover/tile behavior, a real
recording/MP4 persistence scenario, or an OS/PowerPoint-authored workflow that can
be exercised on the appropriate host. This keeps the function-first lane from
reopening isolated pixel probes after the visual-fidelity floor has been reached.

The recording boundary was independently checked on the same Windows machine:
`FreeP.App.Recording.Tests` passed **53/53**, and the WPF video export adapter
contract passed **7/7**. This confirms that frame-package construction, MP4 host
handoff, cancellation, and injected narration/camera mux paths are implemented;
the remaining recording work is real-device capture and PowerPoint-authored
recording persistence evidence, not a missing shared command route.

The current FreeP command surface remains **650/650** shared-profile commands,
with **0 actionable WPF gaps**, **0 actionable Avalonia gaps**, **0 known deferred
command rows**, and **110 workflow-evidence rows**. The latest bounded function
slices also include title-slide special-placeholder policy, master-graphics and
show-settings persistence/consumption, native XamlPackage and RTF rich clipboard
projection, and Windows-native recording/capture readiness. Their contracts are
covered by the current Release baseline rather than by a new renderer calibration.

The next implementation slice must therefore be selected from a reproducible
behavioral fixture in one of the explicit boundaries above: a new SmartArt native
grammar, a ChartEx authoring/layout operation, deeper Zoom editing, recording/media
capture behavior, printer/OLE host behavior, or a PowerPoint-authored animation
workflow. Until such a fixture exists, preserved cached drawings, platform-owned
dialogs, and PowerPoint-authoritative pixel baselines remain intentional boundaries.

## 2026-08-05 media continuation

The bounded media playback workflow now preserves PresentationML
`p:cMediaNode/@showWhenStopped` as an explicit `MediaInfo.ShowWhenStopped` policy.
The default remains true and is omitted on write; an authored false value writes as
`showWhenStopped="0"`, survives read/write, participates in the existing undoable
playback-options command, and is exposed in both desktop media panes. WPF and
Avalonia slideshow controllers consume the same policy: video is initially hidden
until play, and is hidden again on pause/end when the policy is false. Audio remains
visually collapsed as before. This is a function/persistence slice, not a visual
calibration claim.

Focused proof: the new package round-trip, command undo/redo, and shared-plan checks
pass with the full Presentation suite at **3730/3730**; affected WPF media tests pass
**73/73**; WPF and Avalonia Release consumers build with **0 warnings/errors**.

## 2026-08-05 media trim continuation

Media trim values were already persisted and editable, but slideshow playback did not
consume them. Both desktop hosts now resolve the authored trim-from-start and
trim-from-end values against the active engine duration, seek to the start boundary
before playback, clamp manual seeks to the playback window, and stop or loop at the
trimmed end. Unknown duration preserves the start boundary and defers end enforcement
until the engine reports duration. This is a function/runtime slice, not a visual
calibration claim.

Focused proof: shared trim-window contracts **2/2**, Avalonia media adapter tests
**12/12**, WPF media-controller tests **36/36**; WPF and Avalonia Release test
consumers build with **0 warnings/errors**.

## 2026-08-05 media fade continuation

Media fade-in and fade-out values were already persisted and editable, but neither
slideshow host applied them during playback. The shared media planner now computes
an effective volume envelope from the resolved trim window: fade-in begins at the
trimmed start, fade-out ends at the trimmed end when duration is known, and the
authored volume remains the ceiling. WPF and Avalonia apply the same envelope on
open/start, seek, loop restart, timer enforcement, and live volume changes. Unknown
duration still supports fade-in and defers fade-out until the engine reports an end.
This is a function/runtime slice, not a visual calibration claim.

Focused proof: shared planner contracts **9/9**, Avalonia media adapter tests
**13/13**, WPF media-controller tests **36/36**, and the full Presentation test
project **3733/3733**; affected Release consumers build with **0 warnings/errors**.

## 2026-08-05 media bookmark continuation

Media bookmarks were already read, written, and editable, but slideshow playback did
not consume them. The shared interaction planner now resolves named bookmarks with
trimmed case-insensitive lookup and clamps them to the active trim window. WPF and
Avalonia expose the same `TrySeekToBookmark` playback-control operation and reapply
the authored fade/volume envelope after seeking. This is a functional control slice,
not a visual calibration claim; the evidence is recorded in
`docs/parity/freep-media-bookmark-playback-20260805.md`.

Focused proof: shared media planner contracts **10/10**, Avalonia media adapter tests
**14/14**, WPF media-controller tests **37/37**, and the full Presentation test
project **3735/3735**; affected Release consumers build with **0 warnings/errors**.

## 2026-08-05 current-main correction

The authoritative integration point for this status is now `6b1081ed3e`
(`origin/main`), not the earlier `c7af0b78ef`/`9c7f9d0983` snapshots mentioned
in the historical continuation entries above. Current mainline includes the
media playback slices for show-when-stopped, trim windows, fades, and named
bookmarks, as well as the current plain-text table projection and recording
boundary verification.

Current verification remains:

- shared FreeP Presentation Release lane: **3,735/3,735**;
- generated command inventory: **650/650** shared-profile commands;
- actionable host gaps: **0 WPF**, **0 Avalonia**;
- known deferred command rows: **0**;
- workflow-evidence rows: **110**;
- recording package/runtime contracts: **53/53**;
- WPF video-export adapter contract: **7/7**.

These counts prove current route, package, and host contracts. They do not prove
all PowerPoint-native feature depth or OS-owned behavior. The remaining work is
deliberately bounded to reproducible evidence: deeper SmartArt grammar and
effects, richer ChartEx/decorations, full Zoom effect authoring, real
PowerPoint-authored recording persistence and device capture, printer/foreground
dialog behavior, portable OLE activation, and matched PowerPoint visual exports.
No new renderer-only pixel calibration is justified without a fresh behavioral
fixture that demonstrates one of those boundaries.

## 2026-08-05 latest mainline checkpoint

The functional baseline is now `36b58c9359`, with the plain-text table projection
(`9c7f9d0983`) included on `origin/main`. Plain-text export now emits table rows as
tab-separated records, preserves multi-paragraph cell line breaks using the selected
EOL, and retains empty-cell tab positions. The focused adapter lane is **12/12** and
the adapter/file-dialog controls are **55/55**.

This checkpoint also confirms that the remaining list is not a missing route inventory:
the generated command surface remains **650/650**, with **0 actionable WPF gaps**,
**0 actionable Avalonia gaps**, and **0 known deferred command rows**. The next
functional work must therefore be tied to one of the explicit depth boundaries above
and a reproducible package or host contract. In particular, no additional generic
clipboard, command, or renderer calibration slice is justified without new source
evidence; such changes risk inflating the parity counts without increasing PowerPoint
behavioral equivalence.

## 2026-08-05 latest functional checkpoint

Current mainline is `24f2baca6f`. Two small source-backed gaps were closed after the
previous checkpoint:

- Table cell diagonal borders now have explicit model, undo, PPTX read/write, shared
  draw-op, and WPF/Avalonia rendering ownership for `lnTlToBr` and `lnBlToTr`.
  The focused table command lane passed **109/109**.
- Zoom frame border pattern validation now accepts the valid extreme DrawingML presets
  `pct0` and `pct100`, which the existing render path already handled. The focused
  catalog/planner lane passed **6/6**.

Both desktop consumers built cleanly in Release for these slices. The candidate ChartEx
manual-layout boundary was audited in the same pass: mixed factor/edge coordinates are
already consumed by the shared chart planner and covered by focused render-planner tests,
so no duplicate change was kept.

The function-first baseline remains **650/650** shared-profile commands, with **0
actionable WPF gaps**, **0 actionable Avalonia gaps**, and **0 known deferred command
rows**. Remaining work is still bounded to reproducible depth or host evidence:
deeper SmartArt grammar/effects, richer ChartEx/decorations, full Zoom authoring depth,
PowerPoint-authored recording persistence and real-device capture, printer/foreground
dialog behavior, portable OLE activation, and matched PowerPoint visual exports.

## 2026-08-05 connector routing continuation

Elbow connectors now avoid intervening non-endpoint shapes through a deterministic
orthogonal visibility graph. The existing endpoint-only route remains unchanged when
the path is clear; attached shape movement passes the current slide obstacles into the
shared model router, and undo restores both connector bounds and route. WPF and Avalonia
consume the same `ElbowRoute` waypoints.

Focused connector contracts passed **16/16**, the full Presentation lane passed
**3,745/3,745**, and both desktop Release consumers built with **0 warnings/errors**.
Evidence is recorded in `docs/parity/freep-connector-obstacle-routing-20260805.md`.

## 2026-08-06 preserved SmartArt cache text editing

The SmartArt text pane now commits one uniquely matched text-only edit even when the
imported family is rendered from a native `dsp:drawing` cache outside the live layout
planner. The edit updates `data1.xml` plus the cached shape text while preserving the
authored geometry, effects, rotations, extra roles, and run formatting. Structural
changes and ambiguous/missing cache mappings remain rejected. WPF and Avalonia use the
same fallback after their normal cache-regeneration path.

Focused preserved-cache contracts passed **2/2**, the WPF SmartArt text-pane host
contract passed **1/1**, and both desktop Release consumers built with **0
warnings/errors**. Evidence is recorded in
`docs/parity/freep-smartart-preserved-cache-text-edit-20260806.md`.

The accompanying PowerPoint COM probe showed that native `Opposing Ideas` contains
background/divider/rotated-arrow roles not reproduced by the current generic live
layout planner. That family remains cached for visual safety; this slice does not claim
live SmartArt layout parity.
## 2026-08-06: Zoom Return to Parent transition state

Integrated a bounded slideshow function slice: when a Zoom object has Return to Parent enabled, its authored
transition duration and `showBg` value now travel with the parent return stack. Both Advance and Back preserve
those values, so returning from a Slide, Section, or Summary Zoom uses the same transition contract as entering it.
Ordinary slide navigation and non-returning Zooms remain unchanged. Evidence: `docs/parity/freep-zoom-return-transition-20260806.md`.

## 2026-08-06 Zoom cover-image crop semantics

Newly authored Zoom cover images now fill their frame using the shared centered
aspect-ratio crop planner across WPF and Avalonia. Explicit imported/manual crop
edges remain authoritative, and preview images remain on the existing full-source
path. Single-target and Summary Zoom tile draw operations preserve the native
`imageType="cover"` semantic through canvas transform previews. Focused
presentation tests passed **165/165**; both desktop Release consumers built with
**0 warnings/errors**. Evidence is recorded in
`docs/parity/freep-zoom-cover-image-crop-20260806.md`.

## 2026-08-06 ChartEx native title/legend ownership

Current main `dc1058882f` exposed four native ChartEx edit failures because the
writer removed preserved `cx:title`/`cx:legend` nodes when the high-level model
property was null. The model now records explicit title/legend edit requests;
untouched preserved native nodes survive import and save, while title/options
commands mark deliberate replacement or removal and restore the marker on undo.

Focused native ChartEx edit tests passed **9/9**, and the existing ChartEx
removal/display-options undo tests passed **4/4**. The Avalonia startup dirty
state lead passed **1/1** on current main. This is a functional
source-authority fix with no visual calibration claim. Evidence is recorded in
`docs/parity/freep-chartex-native-title-legend-ownership-20260806.md`.
