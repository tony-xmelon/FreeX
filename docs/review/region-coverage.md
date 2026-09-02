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

## Round 191: a lens on this program's own tests

The meta lens had found a defect in the previous round's commit three rounds running, and r190
diagnosed the mechanism: the tests around the changed method asserted about how many WINDOWS were
created and which was activated, never about what was DONE to the one that was reused. r191 turned
that into a lens of its own -- "the test that asserts about the wrong subject" -- and asked it of
the whole suite.

It found the strongest defect of the round, and the reason four rounds of tests could not see it.
The slideshow reuse branch discarded the new launch ROUTE: the route reaches a window only through
the plan handed to createWindow, so picking a different custom show while one was already
presenting refocused the running show and left the audience on the old deck. Every reuse test
written in r188, r189 and r190 drove the coordinator with the SAME input twice, and the FakeWindow
fixture had no member recording which route a call carried, so no assertion in any of them could
have failed. The test added this round varies the route between calls and does fail without the fix.

That is worth stating plainly as a method result: asking "does this test constrain what its name
claims" is a different question from "is this code correct", and in a suite this large it finds
things no amount of reading the production code does. The gap was not in the code under test; it
was in what the tests were looking at.

Also fixed: the shared JsonSettingsStore now keeps an unreadable settings file instead of letting
the first save overwrite it (no caller in any of the three apps reads LastError, so this hole
belonged to the store, not to the one consumer that surfaced it); the FreeP camera stop path defers
disposal like the start path already did; six missing FreeP ribbon resource keys; and the stale
drag preview the r190 Ruler override left behind.

One fix was tried and REVERTED. Item 27's recalc cancellation cannot be closed as stated: putting
the token inside RebuildFormulaDependencies leaves a partial dependency graph on cancellation, so a
later incremental recalc would silently miss dependencies. That is a correctness bug worse than the
low-severity responsiveness gap it would have fixed, and the entry now says so.

## Round 192: the test-subject lens across the whole suite -- and what it did NOT find

r191's test-subject lens was the most productive question this program had asked, so r192 pointed it
at all eight test regions instead of one neighbourhood. The result is the first real negative
finding of the program: SIX of the eight lenses returned empty. FreeX's IO, calc, command,
shell, shared-tier and presentation suites each came back with nothing that met the bar -- a
regression that survives the test, named concretely. Only the FreeP suite yielded one.

That is worth recording precisely because it is a null result. The same question that found a real
product defect when aimed at code this program had just churned found almost nothing across suites
it had not. The lens is not universally powerful; it is powerful where tests were written ALONGSIDE
a fix, under time pressure, by someone who already believed they knew what the code did. That is a
statement about how these tests came to exist, not about their subject areas.

The meta lens found a defect in the previous round's commit for the FIFTH consecutive round. The
r191 quarantine rescue keyed "has this file been rescued" on a per-INSTANCE flag, and FreeW builds a
fresh JsonSettingsStore for the Quick Parts gallery on every window: open two windows over a corrupt
file and the second window's save copied the file as it stood by then -- the first window's freshly
written, VALID content -- over the rescued original. The fix's own scenario reappeared through the
two-window path the fix was never checked against. Rescue is now first-writer-wins at the filesystem.

Two of this round's own corrections are worth naming:

  * The strengthened media-pane binding test PASSED the mutation it was written to catch. It looped
    over the enum and asked `buttons.Get(command)` for the button to click -- routing the assertion
    through the very switch under test, so swapping two cases moved expectation and behaviour
    together. That is the "asserts on a value computed with the same helper the production code
    uses" bullet from the lens's own description, written by the person who wrote the bullet. The
    test now uses a fixed button-to-command table and fails on the swap, measured both ways.

  * The Animation Pane fix was half a fix until its test failed. Widening the display to 1ms did not
    stop 1005ms round-tripping to 1004, because the PARSE truncated: `seconds * 1000.0` is inexact
    in binary floating point. The test found that; reasoning about the format alone would not have.

## Round 193: a sixth question set, and the null result did not repeat

r192's test-subject sweep came back six-of-eight empty. r193 rotated to new questions -- aliasing
copies, lazy initialisation, values trusted from the file, user-visible text, bidirectional and
non-Latin text, paired state, plus three concerns (accessibility of what THIS program added, two
writers of one file, and keyboard-shortcut parity between the shells). Nine of ten lenses found
something. So r192's dryness was a property of that question, not a signal about the codebase.

The round's only HIGH is worth naming as a class. FreeW's Drop Cap took its leading letter with
`Text[..1]` -- one UTF-16 char. Applied to a paragraph starting with an emoji that cuts a surrogate
pair in half, and this codebase already knows what a lone surrogate does: the XML sanitizer
chokepoints abort the WHOLE save. So a one-character indexing habit turned a cosmetic feature into
a document that cannot be saved. Splitting by text element fixes it and incidentally does the right
thing for combining marks. The lesson generalises: `[0]` and `[..1]` on user text are worth a sweep
of their own wherever the result is stored rather than only displayed.

Two findings were about this program's own recent work. The FreeP undo save point (R175) worked in
the WPF shell and not the Avalonia one -- and its existing test wired the endpoint BY HAND, "exactly
the way production does", so it asserted the shared mechanism works given correct wiring and could
never notice that one shell supplied none. That is the r191/r192 test-subject shape once more, in a
test written long before this program started. The accessibility lens found that the status control
r190 added to the Avalonia Drop Cap dialog lacks the automation id its siblings carry.

## Round 194: generalising confirmed findings into sweeps -- zero empty lenses

Round 193 confirmed three defects that were each obviously an INSTANCE of something. r194 turned
each into a sweep and asked where its siblings were:

  * `Text[..1]` on user text whose result is stored (the Drop Cap surrogate split);
  * the model field a hand-written copier forgot (chart SeriesNameOverrides);
  * the second allocator for one id space (FreeP shape ids).

Every lens found something. ZERO came back empty -- the first round in this program where that is
true, and a sharp contrast with r192's six-of-eight. The lesson is worth keeping: a bug that was
real once is the best available evidence about where the next one is, and generalising a CONFIRMED
finding is a far better question than inventing a fresh category.

The strongest result came from the first of those. Four sheet-name sanitizers independently wrote
`name[..31]` to enforce Excel's 31-CHARACTER limit -- but the slice counts UTF-16 code units. Open a
.csv whose filename carries an emoji across that boundary, or import a .fxl/.ods/SpreadsheetML file
with such a sheet name, and the name is truncated to a trailing LONE HIGH SURROGATE. Nothing
validates it (`ValidateSheetNameStructure` checks length and the invalid-character set, never
surrogate well-formedness), the workbook opens normally, and then every save to .xlsx throws from
ClosedXML's `Worksheets.Add` before writing a byte -- permanently, because the name never changes in
memory. That is a document the user cannot save, reached by naming a file with an emoji. It is the
same class as the Drop Cap fix one round earlier, and only the generalising sweep found it.

The four call sites now share one `SurrogateSafeTruncation` helper in Free.Shared.IO, beside the XML
sanitizer, so a fifth caller gets it rather than reintroducing the slice.

The pivot field-index fix is worth noting for WHERE it went. The finding pointed at one unchecked
`row[field.SourceFieldIndex]`; there are 31 of them. Guarding each would have been busywork with a
hole in it, so the check went into the reader -- the same chokepoint that already drops the -2
"Values" placeholder for the identical stated reason, so the model simply cannot hold an impossible
index any more.

## Round 195: generalising again -- and the fix that was half a fix

r194's method (turn each confirmed finding into its own sweep) gave the program's first zero-empty
round, so r195 did it again with r194's twelve findings. Zero empty lenses a second time, and
nothing refuted. Two rounds running, generalising a CONFIRMED defect has outperformed every
invented category this program has tried.

The meta lens found the most important thing, for the sixth consecutive round: r194's own
sheet-name fix was HALF a fix. It routed the four initial truncations through the new
SurrogateSafeTruncation helper -- and left the four dedup/uniqueness loops sitting right beside them
re-slicing raw, at a DIFFERENT cut point (31 minus a " (N)" suffix). So the unsaveable-document bug
r194 was written to eliminate stayed reachable, this time without any crafted import file at all:
rename a sheet to a 31-character name whose emoji straddles the suffix cut, press Duplicate Sheet,
and the copy's name carries a lone surrogate that makes every later .xlsx save throw.

That is worth recording as a lesson about fixing a CLASS rather than an instance. Introducing a
shared helper felt like the thorough move, and the commit said so. But a helper only helps the call
sites that call it, and the second cut point was four lines below the first in the same functions.
The generalising sweep found in one round what the "shared helper" framing had made me stop looking
for.

## Round 196: weighting toward closing, and a consent bug

By r195 the backlog had reached 58 recorded items and was growing faster than it was shrinking --
each round's sweeps produced more than that round's fixes closed. Discovering faster than you
resolve is not progress toward exhausting anything, so this round weighted toward closing the
highest-severity open items rather than opening new lenses.

The one fixed here is a consent bug and the most user-important thing this program has found. The
Trust Center's "send opt-in crash reports" checkbox was read exactly ONCE, inside Initialize, which
startup calls once. Unticking it changed nothing until the app was restarted, and the checkbox
carries no restart notice -- so a user who withdrew consent kept sending crash reports for the rest
of the session and had every reason to believe they had stopped. Withdrawal of consent is the one
direction that must never lag, and every other side effect the Options commit handler drives
(gridlines, headings, the QAT, calculation mode) already took effect immediately.

The gate is now live and is checked in two places: the class's own send paths, and Sentry's
BeforeSend hook. The second matters because the SDK captures unhandled exceptions on its own, so
gating only the methods would have left the biggest category of report still flowing after an
opt-out. Turning the option back ON mid-session re-enables reporting only if the SDK was
initialised at startup; it is deliberately not re-initialised here, because getting that wrong
sends data the user did not ask to send.

## Round 197: a saturation test -- measuring whether the questions are exhausted

Nine rounds had asked whether the codebase still holds defects and kept finding that it does. The
question never asked was whether the QUESTIONS were spent. r197 measured it: five lenses re-asked,
over the same ground, the exact questions earlier rounds had already swept the whole repo with and
whose findings were fixed. The brief said plainly that an empty answer was the valuable one and
must not be padded.

RESULT: one of five came back empty. Four found defects their first pass had missed.

  * re-sweep "second allocator for one id space" -- EMPTY. Three confirmed instances across two
    apps, all now fixed, and a fourth full pass found nothing. This question looks spent.
  * re-sweep "text sliced by UTF-16 char and stored" -- found a HIGH, a fourth instance. FreeP
    derives comment initials with part[0] and stores the result; an author name from dc:creator
    beginning outside the BMP yields a lone surrogate that goes straight into the OOXML author
    element, and constructing that XElement throws -- aborting every later .pptx save, permanently.
    Three rounds had already fixed this class in Drop Cap, four sheet-name sanitizers and four
    dedup loops. It still had somewhere to hide.
  * re-sweep "model field the copier forgot" -- found the .fxl conditional-format DTO dropping 7 of
    62 properties.
  * re-sweep "degenerate input still mutates" -- found RemoveDuplicateRows pushing a phantom undo
    entry on an empty range.
  * re-sweep "honoured on screen, ignored on the page" -- found FreeP notes/handout PDF ignoring a
    table cell's vertical anchor.

So the honest state is: ONE question of five is exhausted, and it took four passes to establish
even that. Rounds that find defects are evidence the code is not clean; this round is the first
evidence about the METHOD, and it says the method's individual questions retain yield well past the
point where they feel finished. Anyone claiming exhaustion of this codebase would need this
experiment to come back five-for-five empty, repeatedly.

One finding was REFUTED and the refutation is worth keeping: the meta lens reported that r196's
crash-consent fix reached FreeX only, since FreeW and FreeP use a different shared implementation
that still reads consent once at startup. Technically true -- but a verifier established that both
of those apps' Options dialogs DISCLOSE the restart requirement, so the user is not misled, which
is what made the FreeX case severe. Same mechanism, materially different consequence, correctly not
counted.

## Round 198: the second saturation measurement

r197 could not tell whether a question that yielded had yielded its LAST instance, because the
instances it found were still unfixed -- a re-sweep would just re-find them. So r198 first fixed
all four (plus the r197 fix already in the tree), then asked the same five questions again over
the same ground, with the same brief: an empty answer is the valuable one, and padding destroys
the measurement.

RESULT: one of five came back empty. The SAME one.

  * re-sweep "second allocator for one id space" -- EMPTY, a second time. Two consecutive empty
    passes over a question with three confirmed historical instances. This is the strongest
    exhaustion evidence the program has produced for any single question.
  * re-sweep "text sliced by UTF-16 char and stored" -- FIFTH instance. Flash Fill derives name
    abbreviations with `value[0]` in two helpers, and FlashFillCommand writes the prediction into
    `Cell.Value` for every filled row. A name beginning outside the BMP stored a lone high
    surrogate; measured against the repo's own ClosedXML build, that does NOT throw here -- it
    round-trips through the `_xD83D_` escape and comes back as a glyphless box in Excel and FreeX
    alike. Four rounds of fixes in this class, and a fifth hiding place.
  * re-sweep "model field the copier forgot" -- found the .fxl sparkline DTO dropping DateAxisRange,
    the only one of SparklineModel's properties it did not carry, silently reverting a Date Axis
    Type sparkline to even spacing.
  * re-sweep "degenerate input still mutates" -- found TWO more phantom-undo commands: Sort over a
    blank or inverted range, and Bring Forward / Send Backward on an already-frontmost or
    -backmost object. Both clear redo for a command that changed nothing. The Selection Pane one
    had an existing test literally NAMED `...AtTopIsNoOp` that never asserted `IsNoOp`.
  * re-sweep "honoured on screen, ignored on the page" -- found FreeW's Avalonia print preview
    ignoring Show Markup > Balloons. The preview renders a snapshot and reads four Show Markup
    toggles from ReviewDisplayState; Balloons is a fifth that lives on DocumentView instead, so it
    was the one the earlier fix missed -- while Print and Create PDF, which render from the LIVE
    editor, drew the strip. The WPF host already had this right, which is what made the asymmetry
    findable.

Zero of the five reports were refuted, which is itself notable: after a round of re-asking spent
questions, everything reported survived two independent skeptics.

What the two measurements say together: of five questions, one is now empty twice running and four
have yielded on every pass, including the pass taken after their previous instance was fixed. A
question does not run dry because it feels finished, and four passes is not enough to spend one.
Exhaustion of the codebase is not demonstrated and this round moves no closer to demonstrating it;
what it does establish is a defensible claim about ONE question out of five.

## Round 199: zero of five, and a sixth instance in a file just fixed

The r198 pattern repeated with the four questions that had kept yielding, plus one new question
generalised from r198's balloons finding. Every instance the previous round found had been fixed
first, so a re-sweep could only report something new.

RESULT: ZERO of five came back empty. Nothing was refuted.

  * re-sweep "text sliced by UTF-16 char and stored" -- SIXTH instance, and the most instructive
    one in the program. It is in `FlashFillService.cs`, the very file r198 fixed: a second helper,
    `GetEmailNameInitial`, reimplements the extraction that `GetFirstInitial` does safely two calls
    away, so fixing the one left all nine email-address patterns still building an address from one
    UTF-16 code unit. Fixing a helper does not fix its copy.
  * re-sweep "model field the copier forgot" -- `SlideCloner.CloneShape` drops a group's four
    child-coordinate-space fields (a:chOff/a:chExt), so Duplicate Slide and copy/paste of a group
    displace everything inside it. Directed away from the .fxl DTOs, which had had three passes, the
    question found this on the first look at another app.
  * re-sweep "degenerate input still mutates" -- FreeW's
    `ChangeDrawingGroupChildZOrderCommand` never overrode `HasEffect`, unlike its sibling in the
    same file, so Bring Forward on an already-frontmost group child cleared the redo stack.
  * re-sweep "honoured on screen, ignored on the page" -- FreeP's Avalonia slideshow numbered every
    slide "1", because `SlideCanvas` trusts a settable `SlideIndex` that `SlideShowWindow` assigns
    at none of its twenty-odd navigation sites. The editor, the exporter and the WPF twin all get it
    right; the WPF twin cannot go wrong, because it derives the index from the deck instead of
    storing a second copy of it. The fix makes Avalonia do the same.
  * NEW "a group of settings copied all but one, because the missing one lives elsewhere" -- FreeX's
    Show Outline Symbols (Ctrl+8) was the one View-tab display toggle with no per-window override,
    so hiding the outline in one New Window sibling hid it in all of them. Zoom, Freeze, Split,
    Gridlines, Headings, Rulers and Show Formulas each got one across R83/R85/R86/R87/R89; this one
    was passed over every time.

Two results worth separating. The first is about the code: a question can find a further instance
in a file it swept the round before, so "swept" is a claim about a pass, not about a file.

The second is about the method. This new question is the second one generalised from a confirmed
finding (after r194's char-slice sweep), and both found real defects immediately. Inventing a
category has never worked as well as promoting one the code has already demonstrated. And the class
it names is invisible to the copier question that ran beside it: listing a source object's members
cannot reveal a member the source object never had.

## Round 200: census instead of sampling

Six rounds asked the char-slice question and six times it found one more instance -- the last of
them in a file the previous round had just fixed, in a sibling helper two calls away. That is not
evidence of an inexhaustible supply of defects. It is evidence that ASKING A QUESTION AGAIN samples
the codebase rather than covering it, and that a sample of one per round says nothing about what
remains.

So r200 stopped asking and started counting. The two questions with the longest yield records were
given to five agents as partitions of an enumeration, each required to run a deliberately over-broad
grep, widen it, classify EVERY site into one of four buckets, and report how many it examined. The
brief said plainly that a census examining forty sites and reporting nothing is a success, and one
that reports a real defect having covered half its partition is a failure.

RESULT: 767 sites enumerated. 13 confirmed defects, 4 refuted.

That is roughly what four rounds of sampling found in total, in one pass. The sampling rounds were
not measuring a codebase that yielded one defect per question; they were measuring their own reach.

  * The cell-text cap had THREE implementations -- typed entry, clipboard paste, delimited import --
    each with its own copy of the constant and the slice, all cutting mid-surrogate. This is the
    r199 lesson at larger scale, on the mainline path where text enters a cell. Now one
    implementation in the shared tier.
  * Text to Columns took the first CODE UNIT of the custom delimiter box. Fixing that alone was
    half a fix, and the behavioural test caught it: the splitter matches the delimiter set one code
    unit at a time, so a two-unit delimiter still split on each half. The matcher now matches at a
    position -- and the first version of that allocated a string per delimiter per character, which
    the file's own allocation-budget test caught at 86MB against a 7MB ceiling. Both were mine, both
    were found by tests rather than by review.
  * Six FreeX commands pushed undo entries -- and so cleared redo -- having changed nothing: Clear
    Outline, Collapse/Expand Group, Clear Data Validation, Remove All Subtotals, Unhide Rows/Columns
    and the Manage Rules dialog committing after the user only looked at it.
  * FreeP had four of five siblings unfixed: FlipShapeCommand got the HasEffect override for a
    protection-locked chart and Move, Resize, Rotate and Delete did not.

The four refutations were as useful as the confirmations. The FreeP PDF-export copy of a truncation
helper is unreachable because PortablePdfWriter throws on non-WinAnsi text before writing, while its
print-renderer twin is a live defect -- the same code, one reachable and one not. FreeW's run-splice
is covered by the XmlTextSanitizer chokepoint an earlier program installed. Both were fixed anyway,
in the twin's case specifically so the pair cannot drift apart again.

What this round establishes about the method: a question's yield per round measures the search, not
the code. Nine rounds of "ask again and see" produced a defensible claim about one question out of
five; one round of enumeration produced auditable counts for two questions and 13 defects the
sampling had walked past. Exhaustion is not demonstrated -- but it is now clear what demonstrating
it would require, and it is not more rounds of asking.

## Round 201: retiring a class instead of finding its next instance

r200 established that asking a question again samples the codebase rather than covering it. The
follow-on question is what to do with a class once you can enumerate it, and the answer is not "find
the last instance" -- for a class that grows with the model, there is no last instance. It is to make
the next one impossible.

The copier question was the right one to try this on, because it is mechanically checkable: for each
DTO, does it carry every member of the model type it serializes? Four rounds had each found one gap
by reading (the chart DTO, the conditional-format DTO, the sparkline DTO), fixed it, and left the
class alive.

So this round wrote the check instead. `R201_NativeDtoCoverageContractTests` reflects over every
`*Dto` the .fxl serializer declares, pairs it with the model type of the same name, and fails when
the model has a public settable member the DTO does not. Escape hatches are explicit `Type.Member`
entries with a stated reason, never name patterns, and a second test fails if an exemption names a
member that no longer exists.

It found seven candidate gaps on its first run, where a hand-written script of mine had found four.
SIX were real; the seventh was mine to get wrong, and is the most useful part of the round:

  * `Sheet.TabThemeColor` -- R123 added it specifically so a theme-linked tab colour is not baked to
    RGB on save. The DTO carried only the resolved `TabColor`, undoing R123 on every round trip.
  * `Sheet.DefaultColumnWidth` / `DefaultRowHeight` -- reset to 8.43 / 20.0 on reopen.
  * `Sheet.CodeName` -- the VBA/OOXML code name, dropped.
  * `Cell.QuotePrefix` -- the leading apostrophe behind "Number Stored as Text".
  * `Cell.LegacyArrayRows` / `LegacyArrayCols` -- a legacy CSE array's declared extent, which decides
    where #N/A padding goes. These had to be assigned AFTER the formula on load, because
    `Cell.FormulaText`'s setter zeroes them on every assignment -- the r169 legacy-array class.

Autosave and crash recovery go through this adapter exclusively, so all six were lost on a recovered
document, not only on an explicit Save As .fxl.

The seventh, `Workbook.NextStructuredTableIdWatermark`, I carried too -- reasoning that reopening
reset the id floor and restored the collision the watermark prevents. The gate refuted it:
`R109_StructuredTableIdWatermarkPersistenceTests` asserts the reloaded watermark is 0 ON PURPOSE,
because R109 folds every slicer's and pivot cache's SourceTableId into NextTableId, and that fold --
not the watermark -- is what blocks reissuing a freed id. The premise of my fix was false and an
existing test held the evidence. Reverted, and recorded as an exemption WITH that reasoning, so the
next person to read the diff finds the argument rather than repeating it.

This is the third time in this program that a "gap" turned out to be a deliberate design with a test
behind it. The rule that keeps proving itself: verify the PREMISE against the sibling path before
calling something a defect -- including, especially, when the finding is your own.

Five others were adjudicated and exempted with reasons: a parse cache, a theme value derived from XML
the DTO does carry, the Circle Invalid Data view overlay, and two per-load identities that nothing
durable stores. Two more were renames rather than gaps (`Cell.FormulaText` is carried as `Formula`,
`ArrayMode` as `FormulaArrayMode`) and are recorded as checked aliases -- the DTO member must exist,
so a rename on either side still fails.

Two things worth keeping about the method.

First, my own diff script found four of the seven. The reflection contract found all seven, because
it works on the real type graph rather than on a regex over source text. When a check can be written
against the artifact instead of its text, it should be.

Second, the contract has a stated limit: it verifies that a DTO HAS a member, not that both
conversion directions are wired. Removing only the write lines leaves it green. That is what the
round-trip tests beside it are for, and the honest description of this round is that one test makes
the class's *omissions* impossible while the other pins its *behaviour*.

### Round 202, second half: the same move on a class that is NOT mechanically decidable

r201 retired the copier class by writing a check that machines can run. The obvious objection is that
the trick only works where a machine can decide the question, and the no-op class is the clearest
counter-example: whether a command can be invoked on a target it would not change depends on what its
callers allow, which is exactly why four rounds each found one more instance.

But the undecidable part is the ANSWER, not the QUESTION. `IPresentationCommand.HasEffect` defaults to
true, so a command that never overrides it has inherited "always changes something" without anyone
checking. That is decidable: did the author declare, or inherit by omission?

So the contract requires a declaration. 132 FreeP commands; 75 already overrode HasEffect. The 57 that
did not were put through a census -- three partitions, every command classified, every claimed no-op
checked by two independent verifiers. 57/57 classified: 25 confirmed no-op-capable, 32 not.

The 25 now have overrides mirroring the guard their own Apply opens with. Sixteen were the same shape
r200 found four instances of: a chart command that returns early when the chart is protection-locked,
while the bus still pushed an undo entry -- and a protection-locked chart still selects and still
accepts the gesture, so it is an ordinary interaction that was clearing the user's redo stack.

The 32 are listed in the contract with the census's reason for each. They divide into commands whose
Apply has no early return at all, commands whose one early return every caller already excludes, and
-- the interesting group -- seventeen where the census claimed a no-op and the verifiers refuted it on
REACHABILITY: chart commands whose dialogs edit an in-memory planner instead, a connector command that
is never bus-executed, table deletes already gated by the caller. Those refutations are recorded as
entries rather than silently dropped, so the claim and its answer stay attached to the code.

What this establishes: a class that cannot be decided by a machine can still be RETIRED by one, if the
check asks whether a decision was made rather than what the decision should be. The cost is honest and
visible -- 32 entries someone had to justify -- and the benefit is that the 133rd command cannot
inherit the default silently.

## Round 203: the same contract in FreeW, and what to do when the debt is too big to pay at once

r202 retired the no-op class for FreeP by requiring every command to declare. FreeW has the same
interface and the same default, so the same contract applies -- except that FreeP had 57 commands
inheriting the default and FreeW has 128. Too many to adjudicate honestly in one round.

The tempting move is a blanket exemption for all 128, which would be a guard that guards nothing. The
honest one is to split the population by what is actually known about each command, and to make the
total a ratchet:

  * **judged, with a reason** -- 4, from this round's census.
  * **known no-op-capable, not yet fixed** -- 32 confirmed defects with the evidence recorded.
  * **not yet adjudicated** -- 89 nobody has looked at.

Three lists rather than one, because conflating "we looked and it is broken" with "nobody looked"
lets the first hide inside the second. A test asserts the two debt lists cannot overlap, cannot
overlap the judged list, and that their TOTAL never exceeds a ceiling each round lowers.

What the contract buys immediately, with 121 entries outstanding: a NEW command cannot join them
silently. Anything not named fails outright. The debt is closed to new entrants before it is paid
down -- verified by adding a throwaway command and watching the contract reject it.

The census covered the 39 Set* commands on floating objects, images, shapes, SmartArt and WordArt --
one coherent family, the equal-value-setter shape. 39/39 classified, 35 confirmed no-op-capable by
two verifiers each. Three are fixed this round; the family they belong to is the one the codebase had
already noticed:

`DocumentObjectEditingCoordinator.SetWrap` carries a comment reading "SetFloatingWrapCommand would
apply as a genuine no-op but still push an inert entry onto the undo stack (it doesn't override
IDocumentCommand.HasEffect)". Someone diagnosed this exact defect, wrote it down next to the code,
and left it. That is the argument for contracts over review notes in one sentence: a note records a
finding, a contract prevents one.

Two of the four ALWAYS-CHANGES verdicts are more interesting than the label suggests.
`SetShapeRotationCommand` and `SetShapeWrappingCommand` are never constructed anywhere -- both are
dead, superseded by the SetFloating* equivalents. They pass the contract only because no gesture can
reach them, so the entries say so explicitly and point at finding 90: the right fix is deletion.

A trap worth recording. `SetFloatingPositionCommand.GetFloatingPlacement` CREATES the placement it
returns (`??=`). A HasEffect that called it would mutate the document while being asked whether it
would -- a worse bug than the one being fixed. The overrides use a separate non-creating peek, and
return true when the placement is absent, because creating one IS a change.

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
23. ~~FreeP camera capture disposes a live MediaCapture while the timed-out stop is still using it.~~
    **FIXED r191.** RunAsync gained a deferred-disposal parameter and CompleteCapture skips its own
    finally on TimeoutException, so the capture is released only once the orphaned StopRecordAsync
    finishes -- the r185 treatment of the start path, now applied to the stop path.
24. ~~FreeW QuickPartLibrary silently discards a corrupt quickparts.json and then overwrites it.~~
    **FIXED r191, in the shared store rather than the one caller.** No caller in any of the three
    apps reads `LastError`, so every consumer of JsonSettingsStore had this hole. The store now
    copies an unreadable file aside once, before the first overwrite, so the data survives.
25. ~~A FreeP Avalonia workarea endpoint command has no reachable handler.~~ **FIXED r193.** The real
    content: the Avalonia endpoint wired neither `MarkSavedAtUndoDepth` nor
    `TryMarkCleanIfAtSavePoint`, and nothing called `NotifySaved`, so undoing back to the saved
    state left the presentation dirty and closing prompted to save an unmodified file. Both are now
    wired and the Avalonia wrapper exposes the pass-throughs it was missing. The existing R175 test
    hand-wired the endpoint "exactly the way production does", so it could never notice a shell that
    supplied no wiring -- a source-contract test now asserts BOTH shells do.
26. **FreeP Avalonia slide-show media controller diverges from its writer/reader counterpart**
    (sweep 141).
27. **A RecalcEngine cancellation is checked outside the loop that takes the time** (sweep 142).
28. **FreeW Avalonia undo does not restore every field a document-view command changed**
    (undo-fidelity lens).
29. ~~FreeP ribbon references six localization keys absent from every resx.~~ **FIXED r191.** The
    Change Zoom Target, Edit Summary Zoom and four SmartArt-layout commands showed raw `[[key]]`
    text on their buttons and keytips; the twelve missing entries were added.
30. ~~Reusing a live slideshow window discarded the new launch ROUTE.~~ **FIXED r191**, found by the
    test-subject lens. The route reaches a window only through the plan given to `createWindow`, so
    picking a different custom show while one was presenting refocused the running show and left the
    audience on the old deck. Reuse now requires the route to match; a different one replaces the
    window, as a mode mismatch already did.
31. ~~The r190 Ruler lost-capture override left the stale drag preview set.~~ **FIXED r191**, found
    by the meta lens. Visual only -- the committed margin never came from that field.
32. ~~RecalcEngine's `#if DEBUG` evaluator-bug safety net never fires in any gate.~~ **FIXED r193.**
    Both catch blocks now consult a runtime seam (`SurfaceUnexpectedEvaluatorExceptions`, default
    false) instead of a compile-time gate, so the strict behaviour is reachable and both branches
    can be asserted. Shipped behaviour is unchanged; no existing test starts failing on a latent
    evaluator bug it was never asked about.
33. ~~FreeP Animation Pane truncates durations to 10ms on focus loss.~~ **FIXED r192.** The display
    went to 3 decimals (1ms, the model resolution), and -- the deeper half, found by the new test --
    the parse now ROUNDS instead of truncating: `seconds * 1000.0` is inexact in binary floating
    point, so "1.005" floored to 1004 even at full precision. An existing test pinned the truncation
    of a sub-millisecond input; its name is about culture acceptance and the rounding policy was
    incidental, so it was updated with the reasoning recorded.
34. ~~FreeP run font size is unbounded before being scaled x100 and cast to int.~~ **FIXED r192.**
    Clamped to ST_TextFontSize"s legal 1..4000pt at the ribbon entry point (where FreeX puts the
    equivalent bound) and again defensively in the writer, so a size reaching the model from a file
    cannot emit a schema-invalid or overflowed `sz`.
35. **Wrap Text auto-fits row heights synchronously across the whole selection**, with no progress
    and no cancel, on the UI thread -- measured to block for a long time at ~200k rows.
36. **The recalc cancellation gap (item 27) is NOT safely fixable as stated.** Threading the token
    into `RebuildFormulaDependencies` was tried and reverted: cancelling mid-rebuild leaves a
    PARTIAL dependency graph, and a later incremental recalc would then silently miss dependencies
    -- a correctness bug worse than the low-severity responsiveness gap. A real fix needs the graph
    to be marked invalid on cancellation so the next recalc rebuilds it.
37. **A media-pane binding test checked 1 of 10 button-to-command mappings** -- FIXED r192. Swapping
    two cases in the switch left the suite green while "Apply Volume" ran Apply Timing on both
    shells.
38. **JsonSettingsStore's rescue flag was per-instance** -- FIXED r192. See the round-192 note: the
    two-window path destroyed the rescued copy the r191 fix exists to keep.
39. ~~FreeW Drop Cap split the leading run by UTF-16 char.~~ **FIXED r193, the round's only HIGH.**
    `Text[..1]` cut a surrogate pair in half, so applying Drop Cap to a paragraph starting with an
    emoji left a lone high surrogate in the cap run and a lone low surrogate in the remainder. In
    this codebase a lone surrogate is XML-illegal and the sanitizer chokepoints abort the WHOLE save,
    so the document became unsaveable -- not merely mis-rendered. Now splits one text element, which
    also keeps combining marks with their base letter.
40. ~~Chart clone drops `SeriesNameOverrides`.~~ **FIXED r194.**
41. ~~FreeP shape-id watermark goes stale after Set Slide Layout.~~ **FIXED r195, together with the
    r194 header-footer HIGH, which was the same defect from a second command.** The watermark is now
    a FLOOR raised from the live document on every allocation rather than a cache seeded once. A
    plain live scan would have been wrong -- AssignShapeIds allocates in a loop for a pasted subtree
    not yet in the presentation, so a scan alone returns the same value each iteration -- and keeping
    the counter also preserves the documented "ids only ever increase" property an undone edit relies
    on.
42. ~~PivotTable Show Details trusts `SourceFieldIndex` from the file.~~ **FIXED r194** at the reader,
    not at the ~31 unchecked `row[field.SourceFieldIndex]` use sites: the reader now drops a field
    index outside the cache range, at the same chokepoint that already drops the -2 Values
    placeholder for the identical reason.
43. **`InsertCopiedCellsPlanner` updates one of two values that must move together** (sweep 154).
44. ~~The r190 Avalonia Drop Cap status control lacks the automation id its siblings carry.~~
    **FIXED r194.** The surface spec never declared a ValidationAutomationId, so there was nothing
    for the dialog to apply. A test now pins the convention across every page-layout dialog that can
    reject input, so the next one added inherits it.
45. **`QuickPartLibrary` is reconstructed per window with no shared state**, so two windows' Quick
    Parts saves overwrite each other independently of the r191/r192 rescue work.
46. **A FreeX keyboard chord diverges between the shells** (`MainWindow.cs:26350`, shortcut-parity).
47. ~~Four sheet-name sanitizers truncate with `name[..31]`, able to leave a lone surrogate that makes
    every later .xlsx save throw.~~ **FIXED r194** via a shared `SurrogateSafeTruncation` helper.
48. **DropCap enlarges an invisible bidi/joiner mark** when a paragraph starts with LRM/RLM/ZWNJ --
    the cap run holds only the control character and the real first letter stays at body size. Same
    "the leading text element is the visible glyph" assumption as the r193 fix, different edge case.
49. **The .fxl chart serializer drops the secondary axis's own title, scale and format**, so a combo
    chart's secondary axis rescales after a save/reload through the native format.
50. **The .fxl chart serializer carries 4 of ChartModel's 17 Secondary* properties** (r194 HIGH), so
    saving a combo chart to the native format and reopening loses the secondary axis title, its
    explicit min/max, its number format and its scale -- the axis reverts to auto.
51. **The ODS writer drops a feature without contributing to the lossy-format warning** (r194).
52. **A FreeW Avalonia IconPickerDialog fire-and-forget has no error path** (r194, low).
53. **A FreeP WPF setting is captured at construction** and ignored after the user changes it (r194).
54. **A FreeP EditingSession command mutates on degenerate input** rather than declining (r194).
55. **A PageContentRenderModel property is honoured on screen but not in print** (r194).
56. ~~Four sheet-name dedup loops re-slice with the raw cut r194 guarded only at the entry point.~~
    **FIXED r195.** Reachable through the UI by rename-then-duplicate, no import file needed.
57. **Ordinary Ctrl+V drops a cell's phonetic guide (furigana)** that Paste Special > All preserves:
    PasteCommandFactory builds rich-text/hyperlink/hyperlink-metadata dictionaries on both the plain
    and tiled paste paths but never the phonetic-guide one, though the same method's Paste Special
    branch does and the method's own doc comment calls the four a single group.
58. **FreeW index alphabetic headings key off the first Unicode text element, not the first VISIBLE
    one**, so an entry beginning with LRM/RLM/ZWNJ gets its own heading made of an invisible
    character while sorting correctly next to its letter -- the r194 DropCap class, in the index.
59. ~~The crash-report opt-in is resolved once at startup and never re-applied.~~ **FIXED r196.**
60. ~~DuplicateSheetCommand mints structured-table ids from its own scan.~~ **FIXED r197**, by
    delegating to CreateStructuredTableCommand.NextTableId -- the allocator that folds in the
    watermark, the slicers and the pivot caches. A re-sweep of this question then found nothing
    further, the only re-sweep of five to come back empty.
61. **Avalonia print preview and PDF export ignore VerticalAlignment, WrapText and TextRotation**
    (r195 HIGH). Honoured by both on-screen grids; lost on the page. Open because the fix is a real
    feature -- line splitting, a vertical anchor and rotated glyph drawing in two builders -- not a
    threading change.
62. **The lossy-format warning planner does not cover every writer that drops a feature** (r195).
63. **Three FreeP commands mutate on degenerate input** rather than declining (r195, sweep 166).
64. ~~FreeP comment initials derived with `part[0]` and stored.~~ **FIXED r197.** Fourth instance of
    the char-slice class; a lone surrogate reached the OOXML author element and aborted every save.
65. ~~The .fxl conditional-format DTO drops 7 of ConditionalFormat's 62 properties.~~ **FIXED r198**,
    both directions, with a round-trip test per property group.
66. ~~RemoveDuplicateRows pushes a phantom undo entry.~~ **FIXED r198.** Re-asking the question then
    found two more of the same shape -- see 70.
67. ~~FreeP notes-pages and handout PDF/print ignore a table cell's vertical anchor.~~ **FIXED r198.**
68. **FreeX Avalonia background save has no cross-window input gate**, unlike the WPF sibling's R115
    fix, so a New Window sibling can mutate the workbook while the save thread enumerates it.
69. **The FreeW Thesaurus pane applies a synonym to whatever word the caret is on now**, not the
    word its display still shows, because it captures the word once when opened and never re-reads.
70. ~~Sort and Bring Forward / Send Backward push phantom undo entries.~~ **FIXED r198.** Sort over a
    blank or inverted range, and a z-order move that falls off either end, all changed nothing and
    still cleared redo. The sibling `DrawingShapeCommandGuards.TryMoveZOrder` had the identical bug
    and was fixed alongside, though it currently has no production caller.
71. ~~Flash Fill derives name initials with `value[0]` and stores the result.~~ **FIXED r198.** Fifth
    instance of the char-slice class, and the first where the lone surrogate does not throw: measured
    against this repo's ClosedXML, it round-trips as `_xD83D_` and lands in the cell as a glyphless box.
72. ~~The .fxl sparkline DTO drops DateAxisRange.~~ **FIXED r198**, both directions. It was the only
    one of SparklineModel's properties the DTO did not carry.
73. ~~FreeW's Avalonia print preview ignores Show Markup > Balloons.~~ **FIXED r198.** Balloons lives
    on DocumentView rather than in ReviewDisplayState, so the snapshot-based preview had nowhere to
    read it from while Print and Create PDF, rendering from the live editor, drew the strip. The WPF
    host reads `editor.ShowMarkupBalloons` directly and was already correct.
74. ~~Flash Fill's email-address patterns build the local part with `token[0]`.~~ **FIXED r199.**
    Sixth instance of the char-slice class, in the file r198 fixed: `GetEmailNameInitial`
    reimplemented what `GetFirstInitial` does safely two calls away.
75. ~~`SlideCloner.CloneShape` drops a group's child coordinate space.~~ **FIXED r199.** All four
    a:chOff/a:chExt fields, so Duplicate Slide and paste no longer displace a group's contents.
76. ~~FreeW's `ChangeDrawingGroupChildZOrderCommand` pushes an inert undo entry.~~ **FIXED r199**,
    by the `HasEffect` override its sibling in the same file has always had.
77. ~~FreeP's Avalonia slideshow resolves every Slide Number field as "1".~~ **FIXED r199**, by
    deriving the index from the deck as the WPF twin does, rather than trusting a second copy of it
    that the twenty-odd navigation sites never set.
78. ~~FreeX's Show Outline Symbols has no per-window override.~~ **FIXED r199** across the session,
    the viewport request, the WPF window snapshot and both shells' Ctrl+8 handlers. It was the one
    member of the View-tab display group left out of R83/R85/R86/R87/R89.
79. ~~The spreadsheet cell-text cap had three implementations, all cutting mid-surrogate.~~
    **FIXED r200**, collapsed to `SurrogateSafeTruncation.LimitToCellText`. Typed entry, clipboard
    paste and delimited-text import each carried their own copy of the constant and the slice.
80. ~~Text to Columns took the first code unit of the custom delimiter, and the splitter matched
    delimiters per code unit.~~ **FIXED r200**, both halves. The delimiter chain is `string` rather
    than `char` end to end, and the matcher matches at a position without allocating.
81. ~~Duplicate Sheet's PivotTable-name dedup sliced a user-typed name at a raw cut point.~~
    **FIXED r200.** PivotTable names have no length cap and no character-class gate, unlike the
    structured-table sibling whose identical slice is therefore unreachable.
82. ~~Six FreeX commands pushed an undo entry, and so cleared redo, having changed nothing.~~
    **FIXED r200:** Clear Outline, Collapse/Expand Group, Clear Data Validation, Remove All
    Subtotals, Unhide Rows *and* Unhide Columns, and Manage Conditional Formatting Rules.
83. ~~FreeP: Move/Resize/Rotate/Delete on a protection-locked chart, Remove Link on a shape with no
    link, and re-applying the font/size/colour a run already has.~~ **FIXED r200.** The chart cases
    are four of five siblings that were missed when FlipShapeCommand got its `HasEffect`.
84. ~~FreeP's print-markup comment-callout truncation cut mid-surrogate.~~ **FIXED r200**, together
    with its PDF-export twin -- which is NOT reachable (PortablePdfWriter throws on non-WinAnsi text
    first) but was fixed identically so the pair cannot drift.
85. ~~The .fxl serializer dropped six members of its model types.~~ **FIXED r201:**
    `Sheet.TabThemeColor` (undoing R123's whole point), `Sheet.DefaultColumnWidth`/`DefaultRowHeight`,
    `Sheet.CodeName`, `Cell.QuotePrefix`, and `Cell.LegacyArrayRows`/`LegacyArrayCols`. All six were
    also lost on autosave/crash recovery. A seventh candidate, the structured-table id watermark, was
    a FALSE finding of mine -- R109 deliberately does not persist it -- reverted, and the reasoning
    kept as an exemption.
    **The class is now guarded** by `R201_NativeDtoCoverageContractTests`, which fails when any DTO
    omits a model member -- so this is the first review class retired by a check rather than by
    finding its instances. Its stated limit: it proves a member EXISTS on the DTO, not that both
    conversion directions are wired; the round-trip tests beside it cover that.
86. **The r201 contract's stated hole is closed** (r202) by
    `R202_NativeRoundTripPropertyTests`: for every scalar member of Workbook/Sheet/Cell it writes a
    distinctive value, round-trips, and requires it back -- so a member that is declared but written
    from nothing, or read into nothing, fails. Proven complementary: deleting only a save line leaves
    r201's membership contract green and turns this one red.
    Its first run produced ZERO defects and six documented behaviours (three sanitising validators,
    one flag-gated field, one formula-gated field, one password hashed on save), each traced to the
    code that causes it and recorded with that reason rather than excused.
    A first attempt asked instead whether each member NAME appeared on both sides of the adapter. It
    passed the very probe it existed to catch, because a member's own declaration mentions its name.
    It was deleted rather than weakened into something that resembles a guard.
87. ~~25 FreeP commands pushed undo entries, and so cleared redo, having changed nothing.~~
    **FIXED r202**, and **the class is now guarded** by
    `R202_CommandDeclaresHasEffectContractTests`: every `IPresentationCommand` must override
    `HasEffect` or appear in that test's list with a reason. 16 of the 25 were the protection-locked
    chart shape r200 found four instances of. The 32 commands that legitimately inherit the default
    are listed there with the census's reason, including 17 whose claimed no-op two verifiers
    refuted on reachability -- kept as entries so the claim and its answer stay with the code.
88. ~~FreeW commands inherit `HasEffect => true` with nobody deciding.~~ **GUARDED r203** by
    `R203_CommandDeclaresHasEffectContractTests`, the FreeW twin of r202's FreeP contract. 128
    commands inherited the default; 3 are fixed, 4 judged sound, and the remaining 121 are split
    into "known broken" and "unexamined" behind a ratchet that only ever lowers. A new command
    cannot join either list silently.
89. ~~32 FreeW commands are confirmed no-op-capable and not yet fixed.~~ **FIXED r204**, all 32.
    Equal-value setters on floating objects, images, shapes, SmartArt and WordArt: re-confirming the
    value a ribbon control already shows pushed an undo entry and cleared redo. The contract test's
    `KnownNoOpCapableNotYetFixed` list is now EMPTY and the debt ceiling is down from 121 to 89 --
    what remains is all "never examined", with nothing left that is known-broken.
90. **`SetShapeRotationCommand` and `SetShapeWrappingCommand` are dead code** (r203). Neither is
    constructed anywhere; rotation and wrapping both route through the `SetFloating*` equivalents.
    Recorded rather than deleted in the same round that found them, so the deletion is a change
    someone makes deliberately rather than a drive-by.

### Round 204: paying the debt down, and two traps in doing it

r203 left 32 confirmed defects listed as debt. r204 fixed all 32, so the known-broken list is empty
and the FreeW debt is 89 -- entirely "nobody has looked", with nothing outstanding that anyone has
looked at and found broken. The ratchet moved 121 -> 89 in one round.

Two traps worth keeping, both of which would have made the fix worse than the bug:

  * **A HasEffect that mutates.** Three of these commands resolve their target through a helper that
    CREATES what it returns -- `GetFloatingPlacement`'s `??=`, `SetShapePositionCommand`'s
    `shape.Placement ??=`, `SetDrawingGroupChildPositionCommand`'s `EnsureOffsetSlot`. Asking "would
    this change anything?" must not change something. Each override uses a non-creating peek and
    returns TRUE when the thing is absent, because creating it IS the change. A test asserts the
    document is untouched after the question is asked.
  * **A peek that covers fewer cases than the mutator.** My first
    `SetDrawingGroupChildRotationCommand` override switched on four child types where `TryMutate`
    handles six. That does not produce a false no-op report -- it produces a SUPPRESSED REAL EDIT,
    which is strictly worse than the phantom undo entry being fixed. Caught by diffing the peek's
    cases against the mutator's rather than by reading it twice; the same diff was then run against
    the other two multi-type peeks.

The general lesson: an override that mirrors a guard has to mirror ALL of it. A partial mirror fails
in the dangerous direction.

### Round 205: the second FreeW tranche

37 more FreeW commands censused -- the Set*/Replace* family on paragraphs, runs, tables, cells,
charts, notes and comments. 37/37 classified, every claimed no-op checked by two verifiers.

  * 27 CONFIRMED no-op-capable, moved from "unexamined" to "known broken" with their evidence.
  * 7 ALWAYS-CHANGES, judged with a reason and out of the debt entirely.
  * 3 claimed no-ops REFUTED on reachability, also out of the debt with the refutation recorded.

FreeW debt: 89 -> 79, and the composition changed as much as the count -- 52 unexamined, 27 known.

The 7 sound ones are almost all the same argument, and it is worth naming because it is the one
structural defence against this class: **the caller passes a negated value**. ToggleChartLegend
passes `!IsLegendVisible`; TryToggleCommentResolved passes `!comment.Resolved`; every
SetTableFormatting caller flips one boolean of a record it read in the same call. A command whose
only caller computes the opposite of the current state cannot be asked to set what is already there.
Where that pattern is used, the class simply does not arise -- which is a better fix than an override,
and worth preferring in new code.

`SetRunFormattingCommand` is the round's second dead-code find (after r203's two): zero call sites
anywhere including tests. Recorded as finding 92 rather than deleted here.
91. **27 more FreeW commands are confirmed no-op-capable** (r205 census, two verifiers each), now
    listed in the contract test's `KnownNoOpCapableNotYetFixed`. Set*/Replace* on paragraphs, runs,
    tables, cells, charts, notes. The ratchet requires that list to shrink.
92. **`SetRunFormattingCommand` is dead code** (r205). Zero call sites anywhere, tests included;
    run formatting goes through `FormatParagraphRunsCommand`. Third dead FreeW command found by
    this census line, after `SetShapeRotationCommand` and `SetShapeWrappingCommand` (finding 90).

### Round 206: paying down r205, and a class the mechanism cannot fix

12 of r205's 27 confirmed defects fixed. FreeW debt 79 -> 67 (15 known-broken, 52 unexamined).

The interesting half is the 15 left, because they are not all the same kind of "not yet".

**Two cannot be fixed by a HasEffect override at all.** `ReplaceParagraphRunsCommand` and
`ReplaceCellParagraphRunsCommand` take an opaque `Action<Paragraph> rebuild`. The only way to learn
whether the delegate changes anything is to run it, and running it mutates the document -- which is
precisely the trap r204 recorded (a HasEffect that mutates is worse than the bug). No override can
be written. The remedy is at the bus: compare the paragraph before and after Apply and drop the
entry when they match, which is a change to DocumentCommandBus, not to the commands. Recorded as
finding 93 rather than papered over with a fake override that always returns true.

That distinction matters for the honesty of the ratchet. A debt list that mixes "nobody has looked",
"we know and haven't got to it", and "the mechanism cannot express this" would let the third hide
inside the second forever. The contract test now says which is which.

The other trap this round: a substitution matched `SetCellBorderPayloadCommand` -- whose no-op claim
r205's verifiers REFUTED -- because it shares a line with `SetCellBordersCommand`, the one actually
being fixed. It failed to compile, which is the cheap way to find that. A pattern that matches on a
line rather than on a class is matching the wrong thing.
93. **Two FreeW commands cannot declare `HasEffect` at all** (r206). `ReplaceParagraphRunsCommand`
    and `ReplaceCellParagraphRunsCommand` take an opaque `Action<Paragraph>` rebuild delegate, so
    the answer is unknowable without running it, and running it mutates. The remedy is a bus-level
    before/after comparison in `DocumentCommandBus.Execute`, not a command-level override. They stay
    in the contract's known-broken list, annotated, so the ratchet still counts them.
    **Assessed r207 and deliberately NOT attempted yet.** The bus hook itself is easy -- ask the
    command after Apply whether anything changed, and skip the push if not. The comparison is not.
    `Run` is a reference type with a large member graph (text, formatting, image, shape, chart,
    control, ruby, revision/comment marks), the rebuild delegate allocates NEW Run objects even when
    the content is identical, and this path carries ordinary formatting edits. A conservative
    reference-equality check would be safe but would never fire, so it buys nothing; a hand-rolled
    content comparison that is wrong in the permissive direction SUPPRESSES A REAL EDIT, which is
    far worse than the phantom undo entry it removes -- the same asymmetry r204 recorded. Doing this
    properly means real structural equality over the Run graph with its own tests, which is a piece
    of work in its own right rather than an appendix to a census round.

### Round 207: the last 52, and FreeW's unexamined list reaches zero

The final tranche of FreeW commands nobody had judged: 52 insert, delete, merge, split, revision,
comment, note, bookmark and catalog commands. 52/52 classified, every claimed no-op checked by two
verifiers.

  * 39 ALWAYS-CHANGES
  * 2 claimed no-ops REFUTED
  * 11 CONFIRMED no-op-capable

**FreeW's "nobody has looked" list is now empty.** All 128 commands have been judged: 47 fixed across
r203/r204/r206, 26 recorded as known-broken with evidence, and the rest judged sound with a stated
reason each. The debt ceiling is 26, down from 128.

The distribution is the finding. The earlier tranches were equal-value setters and ran ~90% defective
(35/39, then 27/37). This tranche of STRUCTURAL commands ran ~21% (11/52). That is not luck: an
insert has no already-there case, a delete is gated on the thing existing, and a merge is gated on
two distinct cells. The defect concentrates almost entirely in commands that assign a value the
target may already hold -- which says where to look first in FreeX and FreeP, and says the census
was worth partitioning by shape rather than alphabetically.

Two verdicts are worth keeping for their reasoning rather than their outcome:

  * `CarryMergedCellContentCommand` genuinely CAN mutate nothing -- merging a filled cell with blank
    ones appends nothing. It is still sound, because all three call sites batch it with a
    `MergeCellsHorizontalCommand` that does mutate, and a batch is pushed as one composite entry. The
    verdict is about the composite, not the command. Recorded that way rather than as a bare "safe".
  * `UngroupFloatingObjectsCommand`'s claimed no-op rested on a group with fewer than two children
    being loadable from .docx. Both verifiers found `DocxReader.ReadDrawingGroup` returns null unless
    `Children.Count >= 2`, so the state the claim needs cannot be read from a file. The premise, not
    the mechanism, was wrong.
94. **11 more FreeW commands are confirmed no-op-capable** (r207 census): ApplyShapeStyle,
    ApplyTableStyle, ArrangeFloatingObjects, DesignCatalog, DistributeTableColumns/Rows,
    FormatParagraphRuns, MoveShapeEditPoint, MutateSmartArtStructure, ResetImageSize, SplitCell.
    Listed in the contract's `KnownNoOpCapableNotYetFixed`.
95. **FreeW's unexamined command list is EMPTY** (r207). All 128 commands judged: 47 fixed, 26
    known-broken with evidence, 55 sound with a stated reason. Ceiling 128 -> 26. The class is no
    longer "partly surveyed" for this app -- what remains is a finite, named list of fixes.

### Round 208: FreeX, the third app -- and a contract that had to be built differently

FreeX has 233 command classes and 16 `IsNoOp` sites. The 61 SETTER-SHAPED ones (Set*, Apply*,
Toggle*) that never report IsNoOp were censused: 61/61 classified, every claimed no-op checked by two
verifiers. 35 confirmed, 7 refuted, 19 sound.

35 of 61 is 57%, between FreeW's ~90% for pure equal-value setters and ~21% for structural commands.
That is the expected place to land: FreeX's partition is name-based, so it swept in structural
commands (SetPageBreaks, SetPrintArea) alongside true setters. The r207 distribution finding predicted
the ordering and it held on a different app.

The contract had to be built differently, and the difference is the point worth recording. FreeP and
FreeW both expose `HasEffect`, which a REFLECTION test can check: does this type declare an override?
FreeX has no such member -- `Apply` returns a `CommandOutcome` and the signal is `IsNoOp: true` in the
return VALUE, which reflection cannot see. So `R208_WorkbookCommandDeclaresNoOpContractTests` reads
the source instead, asking whether each command's own class body ever mentions IsNoOp.

That is weaker than its siblings and the test says so in its own remarks: it distinguishes present
from absent, not correct from wrong. It is still worth having -- it refuses a new undeclared
setter-shaped command, which is verified by adding one and watching it fail -- but the asymmetry is
real and recorded rather than glossed. A stronger FreeX check would need either an analyzer or a
bus-level before/after comparison.

Three of the 19 sound verdicts are the negation-gate pattern r205 named
(`SetRowOutlineGroupCollapsed` passes `!group.IsCollapsed`), and four more are the
planner-diffs-first pattern (`SetIterativeCalculationOptions`, `SetFormulaErrorCheckingRule`). Both
are structural defences that make the class impossible rather than merely absent, and both are worth
preferring over an IsNoOp return in new code.
96. **35 FreeX setter-shaped commands are confirmed no-op-capable** (r208 census, two verifiers
    each), listed in `R208_WorkbookCommandDeclaresNoOpContractTests.KnownNoOpCapableNotYetFixed`
    behind a ratchet. Page setup, print area, drawing/picture/text-box properties, chart layout and
    style, comments, hyperlinks, row height and column width, workbook theme and window arrangement.
97. **The FreeX no-op contract is weaker than its FreeP/FreeW twins, by necessity** (r208). Those
    check for a `HasEffect` override via reflection; FreeX's signal is a return value, invisible to
    reflection, so this one scans source for a mention of `IsNoOp`. It tells present from absent, not
    correct from wrong. Stated in the test itself. A stronger check needs an analyzer or a bus-level
    before/after comparison.

### Round 209: starting to pay down FreeX

Eight of r208's 35 confirmed FreeX defects fixed; the known-broken list is 27 and the ceiling moved
with it. All eight are the equal-value setter shape: the Alt Text pane pre-populates the current
description, Page Setup pre-populates the current orientation, paper size and margins, the theme
gallery highlights the current theme, and Print Area re-selects what is already selected.

The alt-text trio shared one helper, so the check went there rather than into three commands --
`AltTextCommandChange.Changes(current)`, which also normalises, so clearing an already-empty
description (null vs "" vs whitespace) correctly counts as no change. That case has its own test;
it is the kind of thing a per-command copy of the comparison would have got inconsistently right.
98. ~~8 of the 35 FreeX confirmed no-op-capable commands.~~ **FIXED r209:** the three alt-text
    commands (via their shared `AltTextCommandChange`), page orientation, paper size, page margins,
    print area, and workbook theme. Ceiling 35 -> 27.
    **Gate note.** The r209 FreeX gate came back 29/31 with 5 failures -- printed comment-indicator
    colour, printed diagonal-merge extent (FreeX), and two FreeP WPF rendering tests. All five are
    WPF pixel renders returning 0x00. They are NOT from this change: FreeP cannot reference
    FreeX.Core.Commands at all, neither FreeX test mentions any command touched here, and the same
    four FreeX tests fail identically at three unmodified commits INCLUDING `b81d6ca8ac`, whose
    descendant gated 31/31 an hour earlier. That makes them environmental -- the known WPF/capture
    behaviour on this machine -- and the control was run in a throwaway worktree rather than
    inferred. Recorded rather than reported as a green gate.
99. ~~5 more of FreeX's confirmed no-op-capable commands.~~ **FIXED r210:** chart style, chart
    layout, picture aspect-ratio lock, drawing-object rotation, worksheet background. Ceiling
    27 -> 22. Two carry a wrinkle now pinned by tests: rotation compares AFTER normalising (450
    degrees on an object at 90 is no change, which a raw-request comparison would have missed), and
    chart layout compares a fresh `Capture(chart)` against the whole options record, so the check
    cannot drift from the fields `ApplyOptions` actually writes.
    **Gate note, and a durable environmental fact.** The r210 FreeX gate came back 29/31 with 42
    failures, up from 5 on essentially the same code an hour earlier. ALL 42 are WPF pixel-render
    tests (printed cells, borders, comment indicators, FreeP SlideCanvas) and every one reports an
    entirely BLANK bitmap -- `minX = 2147483647` (int.MaxValue, i.e. no ink found) or a sampled
    colour of 0x00. Zero non-render tests failed.
    A set of failures that GROWS between runs on unchanged code is not a code cause. Combined with
    r209's control -- the same tests failing at three unmodified commits, including one whose
    descendant gated 31/31 green an hour before -- this is the WPF rendering surface on this machine
    going blank, not a regression. Interpret any future FreeX/FreeP gate the same way: if the
    failures are all render tests reporting no ink, check the environment before the diff.
100. ~~2 more FreeX no-op-capable commands.~~ **FIXED r211:** split panes and picture crop. Ceiling
     22 -> 20. `SetSplitPanesCommand` is the round's lesson: it looked like a two-field compare, but
     establishing a real split ALSO clears any freeze, so a no-op on matching split positions alone
     would have suppressed that clear -- a suppressed real edit, which r204 recorded as strictly
     worse than the phantom entry being removed. The complete mirror, and a test for exactly that
     case, are both in place. The crop fix compares all four edges because all four are written.
101. ~~1 more FreeX no-op-capable command.~~ **FIXED r212:** workbook window arrangement.
     Ceiling 20 -> 19.
     **The remaining 19 are now ranked by difficulty rather than listed flat**, because after r211
     it is clear that the number of fields `Apply` writes is what decides both how hard the fix is
     and how dangerous a partial one would be:
     * **1-2 fields** (ApplyCustomView, ApplyScenario, SetPrintAreas, SetComment) -- a direct
       compare, the shape r209-r211 fixed a dozen times.
     * **6-8 fields** (the drawing-shape colour/gradient/effect family, ApplyStyle, SetColumnWidth,
       SetRowHeight, SetColumnOutlineGroupCollapsed) -- doable, but every written field must be in
       the compare.
     * **Composites and wide writes** (ApplyStructuredTableStyle, SetSlicerSelection,
       SetTimelineRange delegate to inner commands that do not report IsNoOp themselves, so the
       inner one must be fixed first; SetHeaderFooter writes 16 fields including deep-cloned picture
       collections; SetPageSetup writes 20) -- these need real value equality, not a hand-listed
       field compare that drifts the first time someone adds a field.
     Two of the tier-3 commands were deliberately NOT attempted this round for that reason. The
     ranking is in the contract test itself, so the next person picks them up in cost order instead
     of rediscovering which are cheap.
102. ~~3 of the tier-1 FreeX no-op commands.~~ **FIXED r213:** print areas, cell comment, and
     scenario. Ceiling 19 -> 16. Each carried a wrinkle the tests pin: print areas compares
     SEQUENCE-equal because order is part of the value; a cell comment is only a no-op when the note
     ALREADY exists, since a brand-new one also writes the author; and the scenario check runs as a
     separate probe pass so no cell is written before the answer is known -- writing first and then
     deciding would be the mutating-HasEffect trap from r204 in another form.
     `ApplyCustomViewCommand` was left: it is tier-1 by field count but applies a captured state per
     sheet plus an active-sheet index, so it belongs with the composites.
103. ~~2 tier-2 FreeX no-op commands.~~ **FIXED r214:** drawing-shape effect and gradient. Ceiling
     16 -> 14. Both write more than the property the user picked, and the tier-2 warning was the
     right one: a comparison of the visible property alone would have been wrong in the DANGEROUS
     direction on both.
     * Both clear `IsSourceLoaded` unconditionally, and that flag decides whether a shape's original
       XML is replayed verbatim on save (the r-earlier source-loaded discard class). Calling a
       source-loaded shape "unchanged" would leave the flag set and silently keep the old XML.
     * The gradient additionally forces `HasFill` true and `FillThemeColor` null, so a theme-linked
       fill is a real change even when all three gradient values already match.
     Both cases have tests.
104. ~~2 more tier-2 FreeX no-op commands.~~ **FIXED r215:** drawing-shape colours and text-box
     colours. Ceiling 14 -> 12. These two look like siblings and are NOT quite: both have two
     independently-gated blocks (fill, outline) and both clear `IsSourceLoaded`, but the shape
     clears it only when something is actually being updated while the text box clears it
     UNCONDITIONALLY. Copying one mirror to the other would report a no-op for a source-loaded text
     box with nothing else to change, silently keeping its stale source XML. Both sides of the
     asymmetry have tests.
     Worth generalising: "these two are siblings" is a hypothesis to check against the code, not a
     licence to copy the fix. Three rounds running now, the hazard has been in what a command writes
     BESIDES the property the user chose.
105. ~~1 more FreeX no-op command.~~ **FIXED r216:** page breaks. Ceiling 12 -> 11. Compared against
     the SORTED input because that is what Apply writes, so the same breaks supplied in a different
     order are correctly no change -- comparing against the raw request would have called that a
     real edit.
106. **`SetColumnWidthCommand` and `SetRowHeightCommand` re-ranked from tier 2 to tier 3** (r216),
     and the reason is a correction to r212's own method. Field count put them in tier 2; field
     count was wrong. Their `DrawingAnchorResizeHelper.ResizeFor*Range` calls LOOK like snapshot
     lines -- they are assigned to `_previousShapeWidths` and return the previous sizes -- but they
     also RESIZE every shape, picture and text box anchored in the range. Deciding "no change" means
     predicting that resize, not just comparing widths and hidden state.
     The general point: counting written fields is a proxy for danger, and it fails exactly where a
     mutation hides inside a line that reads as a read. Both commands stay in the debt list with
     this noted, rather than being fixed on the strength of a ranking now known to be wrong for them.

## r217 -- the population, not the sample

107. **The scope filter was doing the hiding.** `R208_WorkbookCommandDeclaresNoOpContractTests`
     scanned `(Set|Apply|Toggle)\w*Command` because r207 measured that shape at ~90% defective
     against ~21% for structural commands. Right place to start; wrong thing to leave in place. It
     meant 67 of FreeX's 233 `IWorkbookCommand`s were accounted for and the other 166 were not
     judged clean -- they were **invisible to the accounting**, which reads identically to clean
     from outside. r217 dropped the filter. The scan now covers all 233 and the remainder sits in a
     new `NeverExaminedForThisClass` list: **152 commands**, capped by `UnexaminedCeiling`, asserting
     nothing about them except that nobody has decided yet.
     The ratchet is the point. Nothing may JOIN that list -- a command written after r217 has no
     claim to never having been looked at, so it fails the contract until someone classifies it --
     and entries leave only by being examined. Three lists now partition the undeclared population
     (judged sound / known broken / never examined) and a fourth test proves no command sits in two
     of them, so "we know it's broken" cannot drift into "nobody looked" or back.

108. **The rename family, four fixed.** First payment against the population r217 exposed. Every
     rename surface edits IN PLACE with the current name pre-filled -- double-click a sheet tab,
     Table Design > Table Name, the PivotTable name box, the Selection pane label -- so pressing
     Enter unchanged is an ordinary gesture. Two of the four cost more than a phantom undo entry:
     - `RenameSheetCommand` is `IWholeWorkbookRecalcCommand` and ran `RewriteAllFormulas` over every
       sheet with a `RenameSheetOp` whose halves were identical: rewrote nothing, recalculated
       everything, cleared redo.
     - `RenameSelectionPaneObjectCommand` cleared `IsSourceLoaded`, which R124 added deliberately so
       the writer regenerates the anchor under the new name. Correct for a real rename; for a name
       that did not change it **discards a loaded object's original anchor XML** and re-synthesises
       it for nothing.
     - `RenameStructuredTableCommand` ran the workbook-wide CF/DV/chart rewrite and `CopyTable`.
     - `RenamePivotTableCommand` is the sharpest: the same-name check was **already there and already
       correct**. Only the signal was missing, so the bus pushed anyway. One argument.
     All four guards are ORDINAL. "Sheet1" -> "sheet1" is a real rename, and a case-insensitive
     guard would have suppressed a real edit -- the dangerous direction, per r211's complete-mirror
     rule. The structured-table guard compares against the TRIMMED name because that is what gets
     written, so "  Sales  " over "Sales" is correctly no change. Both directions are pinned in
     `R217_RenameNoOpTests` (10 tests); reverting the four guards fails 6 of them.

109. **Five classes probed in the layers the accounting had never touched, and all five came back
     clean.** Negative results, recorded because "nobody looked" is the thing being paid down:
     - Culture-sensitive numeric parse across FreeW's Presentation/Host/Avalonia layers: every
       decimal parse already threads an explicit `CultureInfo`. A culture pass has been done here.
     - Discarded `TryParse` failure (the r190 shape, where a bad value silently becomes 0): 11
       statement-form sites repo-wide, all of them the deliberate `default`-on-failure idiom.
     - `Enum.TryParse` accepting undefined numeric strings (`"9999"` parses as `(ShapeKind)9999`,
       reachable from a crafted `docPr/@name` in a .docx): real, but every consumer downstream --
       `ShapeGeometryBuilder`, `DrawingShapeKindSupport`, the anchor-token writers -- has a `_ =>`
       fallback, so it degrades to a rectangle rather than throwing or corrupting output.
     - Static-event leaks: there are no static events in the repo.
     - Sync-over-async (50 blocking waits): the two that looked most dangerous are documented as
       deliberate, and the `TaskCompletionSource` wait in FreeW's mail merge blocks a BACKGROUND
       thread while posting to the UI one -- the correct direction, with a comment saying so.
     Worth stating plainly: probing five classes is not the same as reviewing three layers. It
     narrows what is likely to be there; it does not make those 183k lines examined.

## r218 -- the filter was on the name, the class is about the shape

110. **Nine equal-value setters wearing a structural verb.** `Reposition*`, `Resize*` and `Rotate*`
     (picture, drawing shape, text box) assign a value the target may already hold -- precisely the
     shape r207 measured at ~90% defective -- but none is named `Set*`, so the r208 scope filter
     never saw them. That is the sharper version of r217's finding: the filter matched on the NAME
     while the defect is a property of the SHAPE, so it was never going to find the setters that
     wear another verb. All nine now report IsNoOp, and all nine came off the never-examined list.
     Ceiling 152 -> 143.
     The gestures are ordinary. A drag ending in the cell it began in -- picked up and put back, or
     moved less than one cell -- issues a Reposition to the current anchor. Size and Properties
     pre-fills the current width and height, so tabbing out re-submits them. The rotation box
     pre-fills the current angle.

111. **Compare against what Apply writes, third time this has mattered.** The rotation guards
     compare the current angle against `ObjectRotationNormalizer.NormalizeDegrees(request)`, not
     against the request -- so asking for 370 degrees on an object already at 10 is correctly no
     change. Same lesson as r216's sorted page breaks and r217's trimmed table name, and it is
     starting to look like the general rule for this class rather than three coincidences: the guard
     belongs at the value the mutation actually assigns, not at the argument that arrived.

112. **`RotateTextBoxCommand` is the `RenameSelectionPaneObject` shape again.** It clears
     `IsSourceLoaded` unconditionally (R62, so the writer re-emits the object rather than replaying
     stale source XML). Right for a real rotation; on a re-submitted angle it discarded a loaded
     text box's preserved anchor XML for a rotation that did not move it. Two rounds running, the
     no-op defect in a command that clears that flag has turned out to cost fidelity, not just an
     undo entry -- which suggests `IsSourceLoaded`-clearing commands are worth auditing as their own
     sub-family rather than one at a time.
     Its siblings differ and were checked rather than assumed: `RotatePictureCommand` and
     `RotateDrawingShapeCommand` do not touch the flag at all.

113. Exact double equality in the size guards is deliberate, and it is the safe direction. A value
     that came back through a text box at a different precision compares unequal and takes the
     real-edit path, costing one undo entry; a tolerance would risk swallowing a genuine
     one-hundredth-of-a-point resize. `R218_ObjectTransformNoOpTests` (17 tests) pins both
     directions, including a same-size-but-flipped resize that a width/height-only guard would have
     suppressed. Reverting the nine guards fails 10 of the 17.

## r219 -- options dialogs, and a ratchet with the wrong incentive

114. **The `Configure*` family: options dialogs, the purest form of this class.** A dialog that
     pre-fills the current settings and writes them all back on OK changes nothing whenever a user
     opens it, reads it, and closes with OK instead of Cancel. Nine commands; three fixed, six moved
     to known-broken with the evidence, none left unexamined.
     Fixed: `ConfigureChartHiddenEmptyCells` (two fields, both compared),
     `ConfigureSparkline`, `ConfigureStructuredTableStyleOptions`.

115. **Two of those guards are built the way a wide options dialog's guard should be, and the
     technique is the finding.** Hand-listing fields is a transcription that can silently fall out of
     step with what Apply writes -- and the more fields, the likelier it does. Instead, build the
     target state through the SAME function the mutation uses and compare it against the state it
     came from:
     - `SparklineSettings` is a readonly record struct whose `Capture` and `ApplyTo` are visibly
       inverse over the same eight members, so `Capture(sparkline) == _settings` is a COMPLETE mirror
       by construction. It cannot drift.
     - `ConfigureStructuredTableStyleOptions` had its single `with` expression lifted out of the copy
       helper into its own function, so Apply now uses one description of the change for both the
       decision and the write. Comparing the target against the same `CaptureCopyState()` instance it
       was derived from also keeps untouched members reference-identical, so the record struct's
       equality is exact rather than accidentally always-false.
     This is the answer to the brittle-mirror hazard r211 and r218 kept running into. Where a
     capture/apply pair or a single `with` exists, the guard should be written against it.

116. **The six not fixed, with the reason stated rather than implied.** The pivot `Configure*`
     commands replace collections and then run `RefreshGuarded`; deciding "no change" means also
     proving the re-render is unnecessary, and guessing at that is exactly how a guard ends up
     suppressing a real edit. `ConfigurePivotTableOptionsCommand` is a 25-field assignment block --
     it needs the snapshot-versus-target treatment above, not a transcription.
     Their no-op capability is not inferred, it is read off the callers:
     `PivotApplicationSession.PlanFieldFilters` passes `sorts ?? PivotTable.Sorts.ToList()` and
     `PlanFieldSort` passes the pivot's own `LabelFilters`/`ValueFilters` straight back, so
     re-applying the sort already in effect reaches Apply with every argument equal to current state.

117. **The per-list ratchet had the wrong incentive, so it was replaced.** Examining a never-examined
     command and finding it defective is progress -- unknown becomes known, with evidence -- but
     under two independent ceilings that move was forbidden, because it raised the known-broken
     count. A rule that punishes examination is a bad rule, and I would have hit it this round.
     There is now one `OutstandingCeiling` over known-broken PLUS never-examined, which only ever
     falls: 163 at r217, 154 at r218, **151** now. Both lists still exist and are still kept apart,
     so "we know it is broken" and "nobody looked" stay legible as different states, and a second
     bound holds the never-examined column to a separately falling number (**134**) so the combined
     ceiling cannot be satisfied by fixing easy known entries while nobody looks at the rest.

## r220 -- "remove what is not there"

118. **The `Clear*` family, the structural counterpart to the equal-value setter.** Thirteen commands
     examined (nine Clear, four protection); seven fixed, five judged sound with a reason, one moved
     to known-broken. Outstanding 151 -> **139**, never-examined 134 -> **121**.
     These gestures are as ordinary as the setter ones and the ribbon does nothing to stop them:
     Delete over empty cells, Clear Print Area on a sheet that has none, Clear > Comments over a
     selection carrying none, Clear Rules where no rule reaches.
     `ClearContentsCommand` is the standout -- it ALREADY returned early on a null scope, having
     worked out there was nothing to clear, and simply never said so. Pressing Delete over blank
     cells pushed an undo entry and cleared the pending redo.

119. **The conditional-format guard decides by reference equality, and that is the precise test
     rather than a shortcut.** The rebuild loop adds an untouched rule BY REFERENCE, a shrunk rule as
     a fresh `Clone`, and drops a fully-covered one. So "same count and every element the same
     object" means exactly "the loop changed nothing". The test that matters is the shrink case: a
     rule whose range is merely reduced survives as a different object, and a count-only comparison
     would have called that no change and silently dropped the shrink.

120. **My own guard nearly proved the point about incomplete mirrors -- against me.** For
     `UnprotectSheetCommand` the obvious guard is `!sheet.IsProtected`. That is wrong twice over: an
     unprotected sheet loaded from a file can still carry a preserved `ProtectionMetadata` bag which
     Apply clears (a real change to what gets written back), AND a fresh sheet ships with two default
     `ProtectionPermissions` which Apply also clears. I wrote the four-clause version, and the
     behavioural test then failed on the second point -- my fixture had to empty the permission list
     before the command was genuinely a no-op. The complete mirror was right and my mental model of
     "unprotected" was not; the one-clause version would have suppressed a real edit.

121. **The protection family is gated at the planner, which is the defence r207 preferred.**
     `ProtectionWorkflowSession` branches on the current state -- protected sheets get Unprotect,
     unprotected ones get Protect -- so neither command can be issued against a target already in the
     state it would produce. Judged sound on the gate, not on the command. The `UnprotectSheet` guard
     above stays anyway as belt and braces, and is recorded as such rather than as a fix.

122. `ClearPivotTableViewCommand` joins the r219 `RefreshGuarded` group in known-broken for the same
     stated reason: clearing filters that are already clear replaces empty collections with empty
     ones, but deciding that means also proving the re-render is unnecessary. `ClearSparklineCommand`
     is judged sound -- it returns Success:false when the target is missing and otherwise always
     removes one. `R220_ClearNoOpTests` is 19 tests; reverting the seven guards fails 10 of them.

## r221 -- decide after the loop, on the record of what it did

123. **The `Paste*` family, and the best guard shape found so far.** Thirteen commands examined; ten
     fixed, one judged sound, two moved to known-broken. Outstanding 139 -> **128**, never-examined
     121 -> **108**.
     Eleven of these already accumulate a record of what they wrote -- an `affected` list, an
     `_added` list, a `pastedRules` list -- because they need it for `AffectedCells` or for Revert.
     So the no-op decision can be made AFTER the loop, on that record. There is nothing to keep in
     step with the mutation: an empty record IS the proof that nothing was written, whatever
     combination of empty source, filtered mapping or skipped destination produced it.
     Compare r218's hand-listed field comparisons, which have to be re-checked every time Apply
     changes, and r219's capture/apply pairs, which are complete only because two functions happen to
     be inverse. This is stronger than both: it is not a mirror at all.

124. **`PasteMergedRegionsCommand` is why the decision belongs after the loop and not at the top.**
     Its no-op case is NOT an empty source. The command's own comment records Excel's behaviour --
     "a destination that already overlaps an existing merge is left alone" -- so a paste with real
     merges to copy can still add nothing. A "was the source empty" test up front would have missed
     it; the post-hoc test catches it for free.

125. **The limit is stated rather than implied.** These guards catch "there was nothing to paste",
     NOT "the pasted values equalled what was already there". The second needs a value-by-value
     comparison and is not claimed -- in the source, in the tests, and here. A guard that quietly
     over-promises is worse than one that says what it does not cover.

126. `PasteColumnWidthsCommand` and `PasteDataValidationCommand` went to known-broken rather than
     fixed, and the reason is precisely that they are the two with no such record: they mutate
     through helpers and return a bare `CommandOutcome(true)`. Both are no-op-capable -- pasting
     widths onto columns that already have them, or rules identical to the destination's -- but
     deciding them needs a before/after snapshot comparison, which is a change to how they work
     rather than a guard bolted on. `PasteRangeAsPictureCommand` is judged sound: the picture arrives
     ready-made and Apply's only mutation is to add it.
     `R221_PasteNoOpTests` is 12 tests; reverting the ten guards fails 8 of them.

## r222 -- four branches that looked alike and were not

127. **The Add/Create/Insert family, 22 commands.** Nineteen judged sound, three fixed. Outstanding
     128 -> **106**, never-examined 108 -> **86**. Each of the nineteen was read rather than assumed:
     the mutation that creates the object is unconditional once the guards above it pass, and every
     guard that can fail returns Success:false rather than a quiet success. There is no path that
     reaches the add and skips it. That is a reason, not a shrug at a verb.

128. **The three with a same-value path are the defined-name commands, and they needed four
     different guards for what looks like one situation.** Name Manager's Edit dialog pre-fills the
     current Refers To, comment and hidden flag, so OK-unchanged redefines a name to what it already
     is; Create from Selection is idempotent by nature, so running it twice re-defines every name to
     the range it already has. Reading each branch beat assuming they matched:
     - The workbook-global RANGE branch REMOVES the key before re-adding it, specifically so a
       case-only rename ("revenue" -> "Revenue") takes effect -- `Workbook.DefineNamedRange` says so
       in a comment. So the stored key's casing is part of what the command can change, and its guard
       compares the stored key ORDINALLY. Without that clause the guard would have swallowed a
       rename the user explicitly asked for.
     - The SCOPED range branch assigns through a case-insensitive comparer WITHOUT removing first,
       so it cannot re-case a key even when asked to, and needs no such clause.
     - Defining a range deletes a colliding named formula as a side effect, and defining a formula
       deletes a colliding range. Each guard therefore carries a clause for the other kind: same
       range in, but a definition disappearing is a real change.
     - Null metadata means "write WorkbookScope" for ranges and "leave what is stored untouched" for
       formulas -- the same argument with opposite meanings, documented on the formula overload. The
       two guards cannot share a shape.

129. **A latent asymmetry found on the way, recorded not fixed.** The case-only-rename fix described
     in `Workbook.DefineNamedRange`'s comment was applied to the workbook-global overload only. The
     sheet-scoped overload still assigns through the case-insensitive comparer without removing, so a
     scoped name cannot be re-cased at all. That is a real inconsistency between two overloads of the
     same operation, but changing it is a behaviour change needing its own thought and its own tests,
     not a side effect of a no-op round. Left as a note so the next round has it.

130. `R222_DefinedNameNoOpTests` is 9 tests, including the case-only rename and the
     colliding-formula-deletion cases that a naive guard would have got wrong. Reverting the three
     guards fails 4 of them.

## r223 -- a false unknown, and one family that disagreed with itself

131. **The contract had been reporting a false unknown, and the fix is a fourth list.**
     `BringDrawingShapeForwardCommand` and `SendDrawingShapeBackwardCommand` DO report IsNoOp -- both
     return the outcome of `DrawingShapeCommandGuards.TryMoveZOrder`, which has reported
     `IsNoOp: true` for "already at the front/back" all along. The source scan reads each class body
     in isolation, so it could not see it, and the two sat in never-examined looking like unknowns.
     They are not defects and they are not exemptions, so filing them under "judged sound" would
     have been wrong in a way that matters: those entries say a command CANNOT no-op, and these
     correctly report that it did. New list, `DeclaresIsNoOpThroughAHelper`, whose value names the
     delegate -- and a new test parses that helper's body and fails if it stops reporting IsNoOp, so
     the claim is machine-checked rather than a comment that used to be true.

132. **The outline family disagreed with itself, and three quarters of it was wrong.**
     `CollapseColGroupCommand` reported IsNoOp on its unresolvable-scope path.
     `CollapseRowGroupCommand`, `ExpandRowGroupCommand` and `ExpandColGroupCommand` have the same
     path and returned a plain success -- and none of the four reported the more common case of
     expanding a group that is already expanded, or collapsing one already collapsed. Clicking the
     outline gutter or the 1/2/3 level buttons does that constantly.
     All four now decide through one `OutcomeFor(sheet)` helper per command, using the technique from
     r221: the two snapshots each command already captures for Revert are taken before anything is
     touched, so comparing the live sets against them at every exit says exactly whether the outline
     moved. Three mutation paths, one decision, nothing to keep in step.

133. Outstanding 106 -> **101**, never-examined 86 -> **81**. `R223_OutlineGroupNoOpTests` is 6
     tests; reverting the guards fails 5 of them. The one that still passes is the
     collapse-then-collapse-again case's first half, which is a real edit either way -- worth noting
     because a test that passes in both directions is documenting, not gating, and it should be
     obvious which is which.

## r224 -- the Delete/Remove family, and a test that refused to certify what it could not read

134. **Fourteen Delete/Remove commands examined; one fixed, twelve judged sound, one reclassified as
     a second delegation case.** Outstanding 101 -> **87**, never-examined 81 -> **67**.
     The pattern that makes twelve of them sound is uniform and was checked in each rather than
     assumed from the verb: the target is looked up first, a miss returns Success:false, and the
     removal below that check is unconditional. A command that cannot find what it was asked to
     delete reports an error rather than a quiet success, which keeps it off the undo stack just as
     effectively as IsNoOp would.

135. `RemoveHyperlinksCommand` is the fix, and it is the twin of r220's `ClearHyperlinksCommand`
     guard sitting in the same file. Both are reachable from the same menu over a selection carrying
     no link. Worth noting that the two were found in different rounds by different routes -- the
     first by sweeping Clear*, the second by sweeping Remove* -- which is an argument for sweeping by
     SHAPE rather than by verb, exactly as r218 concluded.

136. **`RemoveSheetsCommand` is a second delegation false unknown**, and of a different shape from
     r223's: its entire Apply is `_composite.Apply(ctx)`, and `CompositeWorkbookCommand` deliberately
     bubbles IsNoOp up -- it starts `allNoOp` true so a composite wrapping zero children, or one
     whose children were all no-ops, reports IsNoOp itself. So the command already reports correctly
     and the per-class scan cannot see through the delegation.

137. **The delegation test failed on that entry, and it was right to.** r223's version only knew how
     to find a helper METHOD's body, so given a CLASS name it matched
     `CompositeWorkbookCommand`'s constructor -- a body with no IsNoOp in it -- and rejected a claim
     that happens to be true. That is the correct failure to have: the test refuses to certify what
     it cannot read, rather than passing on a loose match. It now handles both extents, method and
     class, and the fix is in the test rather than in the claim.

## r225 -- saturating moves, and refusing a partial fix

138. **Twenty-six commands examined; two fixed, fourteen judged sound, ten moved to known-broken.**
     Outstanding 87 -> **85**, never-examined 67 -> **51**. Note the shape of that: the outstanding
     total barely moved while sixteen commands left the unexamined column. That is the honest
     arithmetic of a round that mostly converted unknowns into knowns, and it is what the combined
     ceiling introduced in r219 exists to allow.

139. **`NudgeChartCommand` clamps where its three siblings do not, and that is the whole defect.**
     Picture, Shape and TextBox add the arrow-key delta to an unclamped anchor offset, so they always
     move. The chart applies `Math.Max(0, ...)`, so one already at the left edge absorbs every
     further press -- and holding the key against the edge pushed one undo entry per repeat, each
     clearing the pending redo. Decided AFTER the write by comparing against the values captured for
     Revert, because predicting a `Math.Max` up front would mean duplicating it. The test that keeps
     it honest is the mixed one: a nudge that saturates horizontally but moves vertically is a real
     edit and must stay on the stack.

140. **`MoveChartCommand` is the RenamePivotTable shape for the fourth time.** `if (_sourceSheetId ==
     _targetSheetId) return new CommandOutcome(true, ...)` -- the check was already there and already
     right, and only the signal was missing. Move Chart's dialog pre-selects the sheet the chart is
     already on, so OK-without-changing-the-dropdown lands there. Four rounds have now found a
     command that had correctly detected its own no-op and said nothing; that is a recognisable
     sub-shape worth grepping for directly rather than waiting to meet it.

141. **The AutoFilter family went to known-broken rather than half-fixed, on purpose.** All eight are
     no-op-capable -- clicking the same colour swatch, re-confirming the same Top 10, recomputes the
     same hidden-row set and writes back the same column model. `TopBottomFilterCommand` even has a
     quiet-success path (count 0, no owned rows) that would have been trivial to mark. Marking it
     alone is exactly the partial fix r221 warned about: it would take the command off the debt list
     and let it declare IsNoOp while still being wrong on every other path. These need a
     snapshot-versus-target comparison across BOTH the hidden-row set and the autofilter model, so
     they stay recorded as broken until someone can do that properly.
     `MovePivotTableCommand` and `MoveRangeCommand` join them: dropping something where it started is
     an ordinary gesture, and both need a real before/after comparison rather than a guard on the
     arguments.

## r226 -- grepping the shape instead of sweeping the family, and correcting two of my own verdicts

142. **r225 named a recurring sub-shape; this round went and looked for it directly.** The shape: an
     early return, before any mutation, whose condition is an equality or emptiness test and whose
     outcome is a plain success. A one-pass source sweep over all 233 commands found eleven
     candidates. Three were real and are fixed, two were already fixed in earlier rounds (the sweep
     re-finding them is a sanity check on the method), two were already on the known-broken list, one
     was a false positive, and one turned out to be dead code.
     The method matters because it does not care which family a command belongs to. Sweeping by
     family had already visited every one of these files.

143. **Two commands I had recorded as JUDGED SOUND were not, and the sweep caught my own reasoning.**
     - `ApplyStructuredTableFiltersCommand` was on the sound list as "refuted: the caller only issues
       a changed filter set" -- two independent verifiers in r208 said so. But the command contains a
       method literally called `FilterHiddenRowsAlreadyMatch`, and when it fires it returned a plain
       success. A command carrying its own already-matches check is telling you the caller gate is
       not relied on, and that check fires whether or not the gate holds.
     - `SetStructuredTableTotalsRowCommand` was sound as "the planner adds it only when the value
       differs, and both shells pass the negation". It also checks `table.TotalsRowShown ==
       _showTotalsRow` itself and returned a plain success.
     The general lesson is about what a caller-gate justification can and cannot cover. A gate makes
     a command's no-op path unreachable TODAY, from TODAY's callers; it says nothing about the
     command's own defences, and where the command has one, recording the gate as the reason leaves
     that defence silently useless. Both are now fixed and off the sound list.

144. **One false positive, recorded as such.** `EditCellsCommand`'s `extraAffectedCells.Count == 0`
     matched the pattern but is not a no-op -- the edits themselves have already been applied above,
     and the branch only means there were no ADDITIONAL affected cells from table/data-table effects.
     The sweep is a lead generator, not a verdict, and this is what it looks like when the difference
     matters.

145. **One dead-code finding, spawned rather than fixed here.** `MoveSelectionPaneObjectCommand`'s
     generic `Move<T>` helper has had no callers since R62-meta-1 rerouted every kind through the
     z-order path; `FindObjectIndex` is called only from it, and the `_fromIndex`/`_toIndex` Revert
     branch with its four `Swap` calls is unreachable in consequence. Its plain-success return is
     what the sweep matched. Removing it is a cleanup outside this class and with its own risk, so it
     is filed as a separate task rather than folded in here.

146. Outstanding 85 -> **84**, never-examined 51 -> **50**. `R226_DetectedButUnsignalledNoOpTests` is
     6 tests; reverting the three guards fails 4 of them.

## r227 -- carrying the method to FreeW, and a bool that is not the bool it looks like

147. **r226's method transfers across apps; the reasoning behind it does not.** The same shape sweep
     -- an Apply early-return before any mutation -- run over FreeW's 67 `IDocumentCommand`s found 29
     with no `HasEffect` override. But the FreeX conclusion does NOT carry over: in FreeX a
     "target not found" guard is judged SOUND because Apply returns `Success:false`, which the bus
     excludes from the stack. FreeW's `Apply` returns void, so the identical shape there is a silent
     no-op with an undo entry pushed anyway. Same code shape, opposite verdict, because the two apps
     signal differently. Worth stating explicitly since the r208/r203 contracts sit side by side and
     invite exactly that transfer.

148. **`DistributeTableColumnsCommand` and `DistributeTableRowsCommand` fixed; FreeW debt 26 -> 24.**
     Clicking Distribute Columns twice is an ordinary gesture and the second click changes nothing.
     Both had the early return and no override.

149. **The trap in those two is a bool that looks like the answer and is not.** Each Apply ends with
     `_applied = TableLayoutOperations.DistributeColumns(table)`, and that return reads exactly like
     a did-it-change flag. It is not: it reports whether the operation was APPLICABLE, and is true
     for any table with columns -- including one already evenly distributed. Deriving `HasEffect`
     from it would have produced a guard that never fires and looks correct.
     The fix adds `WouldDistributeRows`/`WouldDistributeColumns`, which answer the question the bool
     does not, and -- following r219 -- share the target-size calculation with the mutation through a
     private `ResolveDistributed*` helper, so the predicate and the write cannot drift. One test pins
     the trap itself, so nobody re-derives the guard from that return value later.

150. **The fail-before probe was wrong twice before it was right, and both failures are worth
     recording.** Reverting the fix first broke the BUILD, because the tests called `HasEffect` on
     the concrete type -- and a compile error is a weaker proof than a red test: it shows only that
     the tests reference new code. Routing the calls through `IDocumentCommand` fixes that, since the
     interface default (true) takes over when the override is gone.
     The second attempt then reported green off STALE binaries: reverting the whole patch also
     removed the `WouldDistribute*` predicates the tests call, so the build failed and `--no-build`
     happily ran the previous assembly. Reverting only the overrides, and leaving the predicates in
     place, gives the honest result: 3 of 6 fail.
