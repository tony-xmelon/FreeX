# Review region coverage

What the rolling code-review program (rounds 176+) has and has not aimed a dedicated lens at.
This exists because "keep reviewing until the codebase is exhausted" is unfalsifiable without an
accounting of what has actually been looked at. Update it at the end of each round.

A region counts as **covered** only when a lens targeted it *by name* and reported (findings or a
considered empty answer). A region touched incidentally by a cross-cutting lens does not count.

Cross-cutting lenses used so far — meta (audits the previous round's own commit), undo/redo,
concurrency, input edges, localization/culture, state-after-failure, selection/caret, clipboard,
formatting fidelity, test integrity, resource lifetime, IO round-trip, accessibility, robustness
against malformed input, and a rotating numbered sweep class (108-118).

## Covered

| Region | Files | Round | Outcome |
|---|---:|---|---|
| shared/Free.Shared.AppServices | 121 | r181 shared-tier | Recent-list UI-thread block (remedy incomplete, see below) |
| src/FreeX.Core.IO | 396 | r181 xlsx-io | VML shape-id collision with cell comments |
| src/FreeX.Core.Formula + Core.Calc | 154 | r177, r181 | empty both times |
| freew/FreeW.Core.IO | 33 | r181 untrusted-input | two uncatchable StackOverflow crashes |
| freep/* domain (slides/masters/layouts) | ~530 | r181 freep-domain | placeholder Idx never allocated |
| print / export / PDF / XPS | — | r181 print-export | Insert > Shapes never printed (open) |
| on-screen layout + rendering | — | r181 render-layout | chart render cache never invalidates (open) |
| accessibility (both shells, 3 apps) | — | r181 accessibility | content controls not keyboard-focusable |
| FreeW find/replace + editing surface | — | r177-r181 | many; the most-worked area of the program |

## Not yet covered by a dedicated lens

**None.** Round 184 aimed one lens at each remaining production project; every project in the
size ranking has now had a dedicated pass. Two of them -- `src/FreeX.App.Host` (291 files) and
`src/FreeX.App.Services` (197) -- returned no findings, as did `src/FreeX.Core.Formula` on both
of its passes.

That is coverage, not exhaustion: a lens finding nothing means that lens found nothing, and a
different question asked of the same code can still surface a defect. What has changed is that
there is no longer a project nobody has looked at. Further rounds should rotate the QUESTION
(new sweep classes, new concerns) rather than hunt for unvisited files.

Covered in r184: FreeX.App.Host, FreeX.App.Services, FreeX.App.Avalonia, FreeX.App.UI,
FreeW.App.Host + App.Avalonia, FreeP.App.Host + App.Avalonia, Free.Shared.Opc + IO,
Free.Shared.Drawing + Pdf + Theme, FreeP.App.Recording(.Windows), and the three
Ribbon.Definitions projects plus Free.Shared.Ribbon.

## Concern areas

All seven have now been lensed. The last two were the r187 rotation.


- Performance and algorithmic complexity -- LENSED r182 (AutoSum full-column walk).
- Memory retention and leaks -- LENSED r182 (FreeP find-replace subscription) and r184 (camera device).
- Serialization formats beyond the main OOXML ones -- LENSED r182 (SYLK/DIF; both assessed and declined).
- Security boundaries -- LENSED r182 (OLE shell-execute allowlist).
- Cancellation and progress -- LENSED r182 (FreeP Export Video, still open).
- Update/installer and crash-recovery flows -- LENSED r187 (self-update discarded other windows unsaved work; crash-recovery snapshot ordering, still open).
- Cross-app consistency of shared *behaviour* (as opposed to shared code) -- LENSED r187 (drag-and-drop gaps in FreeP and FreeW; save prompts that omit the document name; both still open).

## Round 187: rotating the question, not the file list

r184 gave every production project a lens and two of them came back empty. r187 tested whether
that meant those projects were clean, by asking a DIFFERENT set of questions of the same code --
new sweep classes (115 the fallback that no longer matches its primary, 116 the branch that only
runs when the primary found nothing, 117 the rebuild that flattens what it did not intend to
touch, 118 the test whose fixture is too simple to reach the risk, 119 two writers of one piece
of state, 120 the ordering assumption on something unordered, 121 the message that names the
wrong thing) plus the two previously unlensed concern areas above.

All ten lenses returned findings, including against `src/FreeX.App.Host`, which r184 had reported
empty. That settles the question empirically: one pass per project is coverage, not exhaustion,
and the productive axis from here is the question asked, not the file visited.

Fixed this round: the self-update path restarted the whole process after prompting only the window
the user clicked in, silently destroying unsaved edits in every other open workbook; the same path
ignored a false return from `ApplyAndRestart`, leaving the user on the old version with no message;
and the Goal Seek error box was titled with a competitor's product name.

## Round 188: the same method, applied again

r188 repeated r187's approach with a fresh question set (sweep classes 122-128, plus a
half-applied-operation lens and a second-invocation lens). Six findings survived 2-of-2
verification; four lenses returned empty (122 the guard that validates the wrong instance,
124 the retry that repeats a side effect, 126 the collection mutated under a held index,
127 the confident default for a merely-unknown answer).

The meta lens produced the round's most useful result by auditing r187's own commit: the r187
self-update fix had been written into the WPF shell alone, and the Avalonia twin still had both
halves of the bug. That is worth recording as a finding about the PROGRAM, not just the code --
a fix aimed at one shell is not a fix, and the remedy is to move the decision into the shared
tier rather than to patch the sibling. Both update prompts now come from
`FreeXSynchronousPromptCatalog`, and the FreeP slideshow launch coordinator takes its new
liveness/activation callbacks as REQUIRED constructor arguments for the same reason.

One fix shipped without a failing-first test: `AddPivotTableCommand` now records what it
registered before rendering rather than after, but the render's throw could not be provoked from
a test. The test written for it passed with the fix reverted, so it was deleted rather than
shipped -- a green test that cannot fail is worse than none, and this program has already been
caught once by a vacuous test that counted windows in an assembly that never creates any.

## Round 189: the backlog is not what it said it was

r189 added a lens that re-read every entry in the known-open list against today's code, because
a list of open defects is an accounting claim and this repo has many sessions committing to main.
Of the fifteen entries, four turned out to be wrong or already resolved: two were MIS-STATED
(the sync/async conflict-policy defaults agree; the WPF sibling does not block New Window during
a save either, so there was no divergence to fix), one was ALREADY FIXED upstream
(`ApplyAndRestart` does re-query the feed), and one understated its own bug (the Avalonia language
field was not merely inert -- the dialog promised a restart would apply it).

That is the useful result: "N open findings" was not a measure of remaining defects. It mixed real
work with entries that had rotted. Any future claim about how much is left has to re-verify the
list, not count it.

The meta lens again found more in this program's own last commit than most lenses found in the
product. Two of r188's changes were wrong:

  * the slideshow reuse check compared only liveness, not MODE, so asking for Reading View while a
    fullscreen show was running silently re-focused the fullscreen window -- and my own r188 test
    asserted that behaviour, pinning the defect the fix had introduced; and
  * the two tie-break tests never reached the tie-break. Measured on .NET 10, their chosen pair
    ("co-op"/"coop") compares non-zero under de-DE collation, so the primary comparison settled it.
    They passed for the wrong reason. Replaced with NFC/NFD forms of one word, which do compare
    equal, and with an assertion that both input orders converge -- a property a stable sort does
    not give you for free.

And the fix for backlog item 5 reached FreeX alone on its first attempt, which is the same
one-shell trap r188's meta lens caught. It is now wired through the shared sister-app Avalonia
profile, so FreeW and FreeP get it from the same code path rather than from a remembered edit.

## Round 190: working the backlog down, and the meta lens again

r190 fixed five of the entries the r189 backlog left open (items 5, 6 were r189's; 16, 17, 20 and
the new 22 are this round's) and recorded six more that the new question set surfaced. Two lenses
returned empty (137 the comparison against an already-transformed value, 140 the assumption that a
collection is non-empty).

The meta lens found a defect in r189's own fix for the third round running: the slideshow reuse
branch it had just corrected still returned before applying the timing intent, so Rehearse Timings
and Record Timings on an already-running show refocused the window and started no recording. Both
r188 and r189 touched that method and neither noticed, because every test written for it asserted
about WINDOWS -- how many were created, which was activated -- and none about what was done to the
window that was reused.

The bar-chart axis-title fix is worth recording as a shape, not just a defect. The model's X*/Y*
axis fields denote physical position, and R16/R47/R62/R71 each extended that routing to one more
property: reverse order, then gridlines, then tick styles and line, then crossBetween. The TITLE
was never included. Reader and writer stayed symmetric with each other, so every round-trip test
passed; the renderer, which had always read physically, drew a bar chart's two axis titles on each
other's axes. A convention applied property-by-property leaves exactly this kind of hole, and only
a lens that asks about the ODD ONE OUT rather than about round-tripping will find it.

## Assessed and declined

Findings that survived 2-of-2 verification but that measurement showed did not warrant the change.
Recorded so they are not re-reported every round.

- **SYLK and DIF drop the CR of an embedded CRLF** (r182). Measured by round-tripping a cell whose
  text contains a CR followed by an LF: it comes back with the LF alone, and the neighbouring cell
  is intact. The line break survives, both readers already fold the split record correctly, and only
  the CR is normalised away. FreeX's own model treats CR, LF and CRLF identically
  (`AutoFitSizingService.EnumerateLines` goes through `StringReader.ReadLine`), and Excel uses a bare
  LF for in-cell breaks. This is normalisation to the platform convention, not data loss.

- **AutoSum walks ~1,048,575 cells on a full-column selection** (r182). The walk is real --
  `GridRange.AllCells()` iterates every address and the number probe only exits early when it
  FINDS a number. But the claimed consequence (a synchronous UI-thread freeze) does not occur:
  measured, `TryCreatePlan` on a whole blank column returns in 0 ms, and on a sheet with 5000
  populated cells elsewhere it is still 0 ms. A clamp to the used range was written, could not be
  shown to change anything measurable, and was reverted rather than shipped -- it altered a
  decision path (returning false when a sheet has no used range) for no demonstrable benefit.
  Worth revisiting only if a profile ever shows this path costing real time.

## Known-open findings, with the reason each is still open

1. **Insert > Shapes are never printed, exported or previewed.** `WorksheetPrintDrawingLayerPlan`
   has no `Shapes` field and `sheet.DrawingShapes` is read nowhere in the print pipeline. Needs a
   geometry planner plus changes to the planner, render-model builder, preview builder, WPF renderer
   and PDF/XPS export.
2. **WPF chart render cache never invalidates on appearance edits.** Keyed on the `ChartModel`
   reference plus a data-only fingerprint. `ChartModel` has 328 settable properties, so a
   hand-enumerated appearance fingerprint would rot; it needs a central invalidation seam.
3. **Recent-list probe blocks the UI thread in FreeW/FreeP.** The off-thread cache exists and now
   lives in `Free.Shared.AppServices`, but adopting it requires the four FreeW/FreeP shells to wire
   its `onProbed` refresh, as both FreeX shells already do. Without that it trades a freeze for a
   dead entry that never disappears — two existing tests correctly refuse the half-fix.
4. **Split-pane + column outline misaligns click and render.** `SplitPaneCellLayoutPlanner`
   builds the render geometry with the bare column-header height while `HitTestViewportCell`
   passes the gutter-inclusive height, so with a column outline group AND a horizontal split
   every top-pane row selects one row earlier than the one drawn under the cursor. Needs the two
   paths to agree on one height, which touches render, hit-test and divider geometry together.
5. ~~Avalonia Options UI-language field is inert.~~ **FIXED r189.** The entry was also partly
   wrong: the Avalonia Options dialog shows the restart notice too (Options_AppLanguageRestartNotice),
   so the app was promising a restart would apply a setting nothing read -- worse than merely inert.
   Rather than hide the field, the promise was made true: `AvaloniaAppLocalizationBootstrap` gained
   `ApplyAppLanguage` (only the WPF FrameworkElement.Language metadata step is toolkit-bound; setting
   the UI culture is plain BCL) and FreeX Avalonia App.cs calls it at startup as the WPF host does.
6. ~~PortablePdfWriter never emits /Info.~~ **FIXED r189.** PdfContentDocument already carried
   Properties and both the Skia and WPF writers stamped them; the portable fallback now appends an
   Info object (last, so no existing object number shifts) and references it from the trailer.
   Absent and whitespace-only values are omitted rather than stamped blank.
7. **Slicer state is not synchronised across the six commands that can change it.** Filtering
   through one entry point leaves the others showing stale selection.
8. **Crash-recovery snapshot ordering.** The snapshot can be written before the edit that
   prompted it is committed to the model, so recovery restores one edit short.
9. **Drag-and-drop gaps in FreeP and FreeW** relative to FreeX, which supports the same gestures.
10. **XLTX template save loses VBA.** A macro-enabled template round-tripped through the template
    path drops the project rather than refusing or preserving it.
11. ~~`ExternalFileWriteConflictPolicy` default differs between the sync and non-sync paths.~~
    **MIS-STATED, closed r189.** They agree: `Prepare` evaluates
    `confirmOverwrite?.Invoke(path) == true`, which is false when the handler is null, and
    `PrepareAsync` short-circuits on `confirmOverwriteAsync is null`. Both then return `Declined`.
    The safe default is the one both already have.
12. ~~Avalonia New Window is not blocked during a save, unlike the WPF sibling.~~
    **MIS-STATED, closed r189.** The WPF sibling does not block it either:
    `ApplyLiveWindowCommandState` sets "New Window" to `isEnabled: true` unconditionally and
    `ViewNewWindowBtn_Click` consults neither `_isSavingFile` nor `_isOpeningFile`. There is no
    divergence. Whether New Window SHOULD be blocked mid-save is a separate question neither
    shell has answered, and no harm from it has been demonstrated.
13. **Row-height pixel quantisation drifts** as rows accumulate, so a long sheet's gridlines
    diverge from the heights the model holds.
14. **FreeX save prompts omit the document name**, so with several windows open the user cannot
    tell which document is being asked about. FreeW and FreeP name it.
15. ~~`ApplyAndRestart` does not re-query the update feed.~~ **MIS-STATED, closed r189.**
    `VelopackUpdateOrchestrator.ApplyAndRestart` calls `_manager.CheckForUpdates()` immediately
    before `ApplyUpdatesAndRestart(info.TargetFullRelease, ...)` -- a fresh feed check at apply
    time, not a replay of what `CheckAndDownloadAsync` staged. Both shells route through this one
    implementation via `IUpdateService`.
16. ~~FreeW Drop Cap dialog turns unparseable input into a valid default.~~ **FIXED r190.**
    `BuildResult` became `TryBuildResult`, matching the Columns/Hyphenation/LineNumber siblings in
    the same file; both shells now show the validation message instead of accepting an invented
    value. Non-finite distances (NaN/Infinity, which double.TryParse accepts and Math.Clamp passes
    through) are rejected too. Values the user really typed are still clamped.
17. ~~Bar-chart axis titles are captured by data role while every sibling property routes by
    physical position.~~ **FIXED r190.** Titles now follow the same valueAxisOnX / categoryAxisIsOnY
    routing as the ~15 neighbouring properties, in the reader and mirrored in the writer. The
    renderer already read them physically (left category axis titled from YAxisTitle), so the two
    titles had been drawn on each other.s axes. One R43 writer test pinned the old behaviour and
    was updated: it described the implementation rather than the intent.
18. **FreeP external OLE edit-back is lost if the owning window closes first.**
    `OleActivationService` stores sessions in a static, window-agnostic dictionary and awaits the
    editor's exit with no ownership tie, so the update callback writes into a document that is gone.
19. **FreeW WPF Font dialog never shows mixed formatting as indeterminate.** `FontDialogCommand`
    seeds from `editor.CurrentRunFormatting` (a caret-only snapshot); the Avalonia sibling seeds
    from the selection and does show the indeterminate state.
20. ~~FreeW Ruler never clears its drag state on lost mouse capture.~~ **FIXED r190.** It now
    overrides `OnLostMouseCapture` and abandons the gesture without committing, as
    PaginatedEditorPanel in the same shell already did. Previously an Alt+Tab, a modal dialog, or a
    cancelled pen gesture mid-drag left the ruler dragging the margin on the next mouse move with
    no button held.
21. **Two limit checks compute a bound and do not enforce it**
    (`CustomViewNameDialog`, `CrossPageUndoCoordinator`), found by sweep class 135.
22. **Reusing a live slideshow window dropped the timing intent** -- FIXED r190, found by the meta
    lens auditing r189. Rehearse/Record Timings are ribbon commands with no running-show gate, so
    invoking either while a show was up took the reuse branch and returned before `_setTimingIntent`
    was called: the button refocused the show and started no recording.
23. **FreeP camera capture disposes a live MediaCapture while the timed-out stop is still using it.**
    `CompleteCapture`'s finally disposes unconditionally on TimeoutException, while the orphaned
    `StopRecordAsync` keeps running -- the same hazard the r185 fix deferred disposal for on the
    START path, never applied to the stop path.
24. **FreeW QuickPartLibrary silently discards a corrupt quickparts.json and then overwrites it.**
    `JsonSettingsStore.Load` returns an empty list plus `LastError`; `TryLoad` ignores `LastError`,
    so the gallery comes up empty and the next save writes the empty set over the user's file.
25. **A FreeP Avalonia workarea endpoint command has no reachable handler** (sweep 139).
26. **FreeP Avalonia slide-show media controller diverges from its writer/reader counterpart**
    (sweep 141).
27. **A RecalcEngine cancellation is checked outside the loop that takes the time** (sweep 142).
28. **FreeW Avalonia undo does not restore every field a document-view command changed**
    (undo-fidelity lens).
