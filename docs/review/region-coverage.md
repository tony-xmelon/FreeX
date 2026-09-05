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

## r228 -- when "nothing changed" has to argue with a timestamp

151. **Eight commands examined: four fixed, two judged sound, two already covered.** Outstanding 84
     -> **78**, never-examined 50 -> **44**. The four fixes are the comment-state family
     (`UpdateThreadedCommentText`, `UpdateThreadedCommentReply`, `ResolveThreadedComment`) and the
     Selection pane's `SetSelectionPaneObjectVisibility`.

152. **This is the first round where "nothing changed" was not obviously true, and the argument
     matters more than the fix.** Opening a comment and pressing Save without typing leaves every
     user-visible field identical but writes a fresh timestamp -- so is it a no-op? Two things
     settle it, neither of them a preference:
     - The helper is named `TouchRootTextEdit`, and the model field it writes is documented as "the
       UTC time the ROOT comment's own text was last GENUINELY edited". Stamping it when no text was
       edited contradicts the field's own stated meaning. The command was not recording a change; it
       was recording a wrong thing.
     - Both Update commands were ALREADY computing the text equality, one line further down, to
       decide whether the preserved @mention offsets were still valid. Each knew whether the text had
       changed and wrote the new timestamp regardless.
     Where a judgement like this cannot be settled from the code, the honest move is the debt list,
     not a guess. Here it could be.

153. **Two toggles judged sound, and the distinction is the point.** `ShowHideCommentCommand` and
     `ShowAllNotesCommand` read the CURRENT state and flip it, so no argument can ask them to do what
     is already done -- the self-guaranteeing shape r207 preferred. Their neighbours in the same
     files take the target state as an argument and can be handed the one already in place. Same
     files, same feature area, opposite verdicts, and the difference is toggle versus setter rather
     than anything about comments. `R228_CommentStateNoOpTests` includes the toggle as a contrast
     rather than a fix, so the distinction is pinned and not just asserted here.

154. `SetSelectionPaneObjectVisibilityCommand` is an ordinary equal-value setter with an eye icon on
     top: the pane shows current visibility, and the shells also drive a Show All / Hide All sweep
     that sets every object to the same value, so everything already in that state arrives unchanged.
     8 tests; reverting the four guards fails 4 of them.

## r229 -- the same trap, in a second file

155. **Five fill/analysis commands examined: two fixed, one judged sound, two moved to
     known-broken.** Outstanding 78 -> **75**, never-examined 44 -> **39**.

156. **`SetCalculatedColumnFormula` returns a bool that reports whether the COLUMN WAS FOUND, not
     whether anything changed** -- it returns true for a re-set of the identical formula. That is
     exactly the trap r227 found in `TableLayoutOperations.DistributeColumns`, in a different file
     and a different feature area. Twice in three rounds is enough to make it a habit rather than a
     coincidence: when a mutating helper hands back a bool, read what it means before letting a
     no-op guard depend on it. `PropagateCalculatedColumnCommand`'s guard therefore compares the
     stored formula itself, and a test pins the bool's real meaning so nobody derives a guard from
     it later.
     That command needed two clauses because it makes two writes -- the cell fills recorded in
     `_snapshot` AND the column's stored formula -- and either alone would have been a partial
     mirror.

157. `FlashFillCommand` takes the r221 post-hoc guard: `DetectFill` can succeed and still leave no
     rows to write, when every candidate already holds the value the pattern would produce, and
     nothing above the loop mutates. Same stated limit as the Paste guards -- it catches "there was
     nothing to fill", not "the filled values equalled what was there".

158. **`AutofillCommand` and `FillCellsCommand` went to known-broken precisely because the post-hoc
     test would not work on them.** Both validate a NON-EMPTY target set and then write to all of
     it, so "did we write anything" is always yes and a guard built on it would never fire while
     looking correct. Fill Down over cells that already hold the value being filled changes nothing,
     but deciding that needs a comparison per cell -- the same boundary r221 drew and declined to
     cross by guessing. Recording them as broken is the honest alternative to a guard that cannot
     fire.

## r230 -- a third verb hiding the same shape

159. **The `Change*` family: three commands, all fixed.** Outstanding 75 -> **72**, never-examined
     39 -> **36**. This is the third verb to hide the equal-value setter shape, after r218's
     Reposition/Resize/Rotate and r225's Move -- and all three were missed by the original scope
     filter for the same reason, which is that it matched on the name.
     The gestures are ordinary and pre-selected by the UI: the Change Chart Type gallery highlights
     the chart's current type, and Select Data pre-fills the current range with its header and
     category checkboxes.

160. **Each guard has exactly as many clauses as Apply has writes, and the extra clauses earn their
     place.** `ChangeChartTypeCommand` writes Type AND FirstColIsCategories, the latter DERIVED from
     the requested type -- so a chart whose flag was set by hand can disagree with what its type
     implies, and correcting that is a real edit even though the type already matches. A guard on the
     type alone would have suppressed it. There is a test for exactly that case, because it is the
     one a plausible-looking one-clause guard gets wrong.
     `ChangeChartSourceCommand` writes four fields, and the long per-series clear block below them is
     already gated on the range or orientation having changed -- so when all four match, every
     remaining line is a self-assignment and the guard is exact rather than approximate.

161. 6 tests; reverting the three guards fails 2 of them. The four that still pass are the real-edit
     directions, which is the expected shape: they exist to stop the guards over-reporting, and a
     missing guard cannot make them fail.

## r231 -- a round with no fixes, and why that is the result rather than a failure

162. **Eight commands examined: two judged sound, six moved to known-broken, none fixed.**
     Outstanding 72 -> **70**, never-examined 36 -> **29**. The outstanding total barely moved while
     seven commands left the unexamined column, which is what a classification round looks like. It
     is worth saying plainly rather than dressing up: this round converted unknowns into knowns and
     fixed nothing, and that is a real result because "nobody looked" and "we looked and it is
     broken, here is why it is hard" are different states.

163. **Two commands I expected to fix turned out to be sound, and reading them said so.**
     `ConvertNotesToCommentsCommand` looked like a certain defect -- run Convert twice and the second
     run converts nothing -- but it already returns Success:false with "All notes already have
     threaded comments". `DrillDownPivotTableCommand` errors for a disabled drill, a missing table
     and an empty detail set, and always adds a sheet past those. Expecting a fix is not evidence of
     one.

164. **`SaveScenarioCommand` and `SaveCustomViewCommand` are the round's most useful entry, because
     the obvious guard is a trap.** Both replace an existing entry with a freshly captured one, so
     saving twice with nothing changed in between writes an equal value. Both targets ARE records,
     so `newValue == previous` looks exactly like r219's technique -- but both records carry LIST
     members, and record equality compares those by reference, so against a freshly built instance
     the comparison is always false. The guard would never fire while looking indistinguishable from
     the ones that work. That is the same objection r229 raised against a post-hoc test on Autofill,
     arrived at from the opposite direction, and the rule it yields is: a guard that cannot fire is
     worse than an honest debt entry, because it takes the command off the list without fixing it.

165. **`ReapplyStructuredTableStyleCommand` is a delegation case of a kind r223 and r224 did not
     have.** Those two delegated to something that reports IsNoOp correctly, so the command was fine
     and only the scan could not see it. This one returns `ApplyStructuredTableStyleCommand`'s
     outcome, and that command is itself on the known-broken list -- so it inherits the DEFECT.
     Delegation propagates both, and fixing the inner command will fix this one for free. Listed
     separately anyway, so the count stays honest.

## r232 -- the never-examined column reaches zero

166. **Twenty-nine commands examined: four fixed, eleven judged sound, fourteen moved to
     known-broken. `NeverExaminedForThisClass` is now EMPTY.** Every one of FreeX's 233
     `IWorkbookCommand`s has been looked at for this class. Outstanding 70 -> **50**, which is now
     entirely known-broken-with-evidence and nothing unknown.
     That is the milestone r217 set up when it replaced a scope filter with an honest accounting, and
     it is worth being precise about what it does and does not mean. It means nobody can point at a
     FreeX command and ask whether anyone checked. It does not mean the class is fixed: 50 commands
     are recorded as defective, each with a reason and most with the specific obstacle named.

167. **`AllowEditRangeCommand` is the fifth instance of r226's shape** -- `if
     (!sheet.AllowEditRanges.Contains(_range))` -- the command already knew it had nothing to add and
     returned a plain success anyway. Five rounds have now found this; the sweep that found it is
     cheap and should simply be re-run whenever new commands land.

168. **The two Group commands take r223's technique, in the same files it was invented for.** Every
     mutation is captured for Revert before anything is touched, so comparing the live outline state
     against those snapshots says exactly whether the group moved. Pressing Ungroup on a selection
     that carries no outline level writes nothing.

169. **`GoalSeekCommand` needed a clause that stops it over-reporting.** It compares the cell's
     current NUMBER against the value the solve arrived at -- but a cell holding the TEXT "42" is not
     a cell holding the number 42, and writing the number over it is a real edit. There is a test for
     exactly that, because a guard written as "does the cell look like this value" would get it
     wrong.

170. **What the 50 remaining look like, since the shape of the debt is now the whole story.** Fourteen
     joined this round and thirteen of those are cell-writing commands held by one boundary: each
     writes values into a target set its guards have already established is non-empty, so the
     post-hoc "did we write anything" test is always yes, and deciding whether the written values
     DIFFER needs a comparison per cell. That is one obstacle, not thirteen, and clearing it would
     clear most of the list at once. The rest are the RefreshGuarded pivot group (r219), the
     AutoFilter group (r225), the record-with-list-members group (r231), and two delegation cases
     that inherit their inner command's defect.

## r233 -- naming the obstacle precisely, and a sixth clean probe

171. **r232 said the remaining FreeX debt shares one obstacle. This round established what that
     obstacle actually IS, which turns out to be a design question rather than a missing utility.**
     Thirteen of the fifty known-broken commands need "did the written values DIFFER", not the
     post-hoc "did we write anything" that fixed their neighbours. The blocker is that
     `FreeX.Core.Model.Cell` is a plain sealed class with reference equality only -- and it carries
     `CachedAst`, derived state that must NOT participate in such a comparison. So the fix is not a
     guard; it is defining what "the same cell" means for this purpose.
     `CellEditCompanionSnapshot` is the right home for it -- it already captures the cell plus its
     rich-text runs, hyperlink, metadata and phonetic guide, already has a `Restore` inverse, and the
     thirteen commands already build a list of these for undo. But this is a partial-mirror hazard
     across thirteen commands at once, so it needs the r201 treatment: a reflection contract asserting
     every settable member of `Cell` is either compared or exempted with a reason. Filed as its own
     task rather than started at the end of a round, because a half-built version of this is worse
     than none -- it would take thirteen commands off the debt list without fixing them, which is
     precisely what r229 and r231 refused to do one command at a time.

172. **A sixth defect class probed in FreeW's app layers, and it came back clean too.** Event-handler
     leaks: subscriptions from a short-lived subscriber to a long-lived publisher. FreeW has exactly
     seven event publishers outside its controls (`DocumentCommandBus.Changed`,
     `DocumentEditingSession.Changed`, `OutlineViewController.RowsChanged`, and four read-aloud
     ones), ten subscriptions to them, and five matching unsubscriptions. Every one of the five
     un-paired subscriptions turned out to be same-lifetime and therefore not a leak:
     `OutlineView` constructs the controller it subscribes to, and `DocumentView` constructs its own
     `DocumentEditingSession` in its own constructor -- so even the scratch/print DocumentViews own
     their publisher rather than attaching to a shared one.
     Six classes probed in those layers now (culture-sensitive parse, discarded TryParse, undefined
     Enum.TryParse, static-event leaks, sync-over-async, and now instance-event leaks), six clean.
     Still worth repeating what r217 said: probing six classes is not reviewing 183k lines. But six
     for six is starting to be evidence about where defects in this codebase concentrate, and it is
     not there.

## r234 -- building the thing r233 named

173. **The shared obstacle is now built, with the guard that makes it safe to share.**
     `CellEditCompanionSnapshot.MatchesCurrent(sheet)` answers "did the written values DIFFER" for
     any command that already captures that snapshot for undo -- which is all thirteen of the
     commands r233 identified. Outstanding 50 -> **49**, with `EditCellsCommand` the first through.
     It is deliberately NOT an equality override on `Cell`. Cell is a mutable class used as an
     identity throughout the model, and giving it value semantics would change meaning far beyond
     this question; it also carries `CachedAst`, a derived parse cache that must not participate,
     since two cells with the same formula are the same cell whether or not either has been parsed.

174. **`R234_CellChangeComparisonCoverageContractTests` is the part that matters more than the
     helper.** Thirteen commands are meant to depend on one comparison, so a field added to `Cell`
     and forgotten in it would be a partial mirror THIRTEEN times over -- each one reporting
     "nothing changed" for an edit that did. The contract reflects over every settable member of
     `Cell` and requires each to be compared or exempted with a reason. Proved by deletion: removing
     the `QuotePrefix` clause makes it fail and name the member.
     A side benefit worth recording, given r227's stale-binary trap: because this contract reads the
     SOURCE rather than the assembly, it failed correctly even when the probe build was broken. A
     source-reading contract cannot be fooled by `--no-build` running yesterday's binaries.

175. **One test in this round asserted the wrong thing and the guard was right.** I expected writing
     a blank into a cell that does not exist to be a no-op -- blank over nothing looks like nothing.
     The guard says it is an edit, and it is: the sheet had no `Cell` object at that address and now
     has one, which moves the used range and changes what gets written to the file. The displayed
     value is the same; the model is not. The test now pins that boundary with the reasoning, rather
     than being deleted. (The real gesture, pressing Delete over empty cells, goes through
     `ClearContentsCommand` and was guarded in r220.)

176. The batch case has its own test for a reason: a batch is a no-op only when EVERY cell in it is
     unchanged (`TrueForAll`, not `Any`). Getting that backwards would suppress a multi-cell edit
     because one of its cells happened to match -- a suppression bug hiding inside a no-op fix.

## r235 -- closing a limit that was written down, and a count that under-reports the work

177. **r221's Paste guards said in the source what they could not do; r235 made that sentence
     false.** They caught "there was nothing to paste" and explicitly did not catch "the pasted
     values equalled what was already there". With r234's comparison built, both `PasteCellsCommand`
     and `PasteSpecialCellsCommand` now use it, and pasting a block back over itself -- which people
     do constantly by pasting twice -- is reported for what it is.
     Worth noting the mechanism: those two were ALREADY off the debt list, because r221's partial
     guard was enough to make them declare. So this improvement moves no counter at all. A round's
     number is not the same as a round's work, and the direction of that error matters: a count that
     under-reports is safe, a count that over-reports is the thing r229 and r231 refused to create.

178. **Two commands came off the debt for free, by delegation.** `ExternalTextPasteValuesCommand` and
     `FormControlInteractionCommand` both hand their whole edit to `EditCellsCommand`, which r234
     fixed -- so they now report correctly and only the per-class source scan cannot see it. They
     move to `DeclaresIsNoOpThroughAHelper`, whose machine-checked delegate claim (r223) covers them.
     `FormControlInteractionCommand` needed one extra step of argument, recorded with the entry: it
     DOES write control state of its own, but only inside `if (_applied)`, which is the redo path --
     and redo only runs for an entry that was pushed, which a no-op never is. So on first Apply it is
     pure delegation. r231 observed that delegation propagates a defect; this is the same mechanism
     running the other way, and it is why fixing `EditCellsCommand` was worth doing first.

179. **My arithmetic was wrong before the test corrected it.** I set the ceiling to 45 expecting four
     removals and the contract found 47 -- because two of the four were already off the list. The
     ratchet caught my own bad count, which is the second time this session a mechanical check has
     corrected a number I asserted (see r232). Outstanding 49 -> **47**.

## r236 -- the diagnosis was one level too shallow

180. **r233 said thirteen commands were blocked on "Cell has no value comparison". r234 built that
     comparison, and r236 found it is not sufficient for three of them.** `FillCellsCommand`,
     `AutofillCommand` and `GroupedApplyStyleCommand` write COMPANION state as well as cells --
     hyperlinks, hyperlink metadata, rich-text runs -- and keep it in SEPARATE parallel snapshot
     lists alongside their cell snapshot. So no single snapshot answers "did anything change", and a
     comparison built on the cell list alone would report unchanged for a fill that altered only a
     hyperlink: a partial mirror, in the dangerous direction, in three commands at once.
     The remedy is now specific: capture `CellEditCompanionSnapshot`, which already covers all four
     kinds, instead of three parallel tuples. That is a change to how these commands hold their undo
     state, not a guard added to them -- which is why it is recorded rather than attempted at the end
     of a round, on the same reasoning r233 used.

181. **This is the third time this session that checking a "surely it's fine" assumption changed the
     answer, and the fourth time overall the pattern has paid.** r227: `DistributeColumns` returns
     "was applicable", not "did change". r229: `SetCalculatedColumnFormula` returns "was the column
     found". r236: these commands' cell snapshot is not the whole of what they write. In each case
     the plausible move was to trust the obvious reading, and in each case it would have produced a
     guard that looks right and never fires -- or worse, fires wrongly.

182. **The same look cut the other way too, which is worth recording because it is the answer nobody
     writes down.** Finding that these commands write hyperlinks raised a sharper worry than the
     no-op question: if their undo snapshot were really cell-only, then undoing a fill would not
     restore a hyperlink it removed -- a data-loss bug in a different class entirely. It is not so.
     `FillCellsCommand.Revert` restores from `_hyperlinkSnapshot`, and `GroupedApplyStyleCommand`
     restores rich-text runs from its own. The parallel snapshots exist precisely so undo is
     complete. The structure that makes the no-op question hard is the structure that makes undo
     correct.

## r237 -- undo-completeness and no-op-completeness are the same list

183. **The invariant this whole sub-thread was circling, stated plainly at last.** A command's UNDO
     snapshots are, by construction, the complete record of everything it writes -- that is what
     makes undo correct. So its no-op decision is complete exactly when it consults every one of
     them, and incomplete the moment it skips one. The two properties are the same list.
     That turns "be careful" into a mechanical check.
     `R237_NoOpDecisionUsesEverySnapshotContractTests` scans a command's `_*Snapshot` fields and
     requires the method that makes its no-op decision to reference each one. Adding a sixth snapshot
     without extending the comparison compiles cleanly and silently narrows the guard; this fails
     instead. Proved by deletion: dropping the `_phoneticGuideSnapshot` clause makes it fail and name
     the field.
     The list is opt-in, which keeps it a ratchet on commands that have adopted a decision method
     rather than a claim about the ones that have not.

184. **`FillCellsCommand` is the first through, and it needed all FIVE of its snapshots** -- cells
     and style, hyperlinks and metadata, rich-text runs, phonetic guides, and comments. Outstanding
     47 -> **46**. Two of the four tests are companion cases a cell-only comparison would have got
     wrong: a fill where only a hyperlink differs, and one where only a note differs.

185. **r236's own proposed remedy was ALSO incomplete, and this round caught it.** r236 said the fix
     for these commands was to capture `CellEditCompanionSnapshot` instead of parallel tuples. That
     composite covers cells, rich text, hyperlinks, metadata and phonetic guides -- but NOT comments,
     which `FillCellsCommand` writes and snapshots separately. Following r236's remedy literally
     would have produced a guard that misses a fill carrying a note. Three rounds in a row have now
     found the previous round's confident statement to be one level too shallow (r234 fixed r233's
     obstacle, r236 corrected r234's sufficiency, r237 corrected r236's remedy), which is worth
     recording as a property of this kind of work rather than as three separate mistakes: each layer
     looks complete until you try to build on it.

## r238 -- the second command through, and one registration I nearly got away with

186. **`AutofillCommand` joins `FillCellsCommand`, and the comparison is now shared rather than
     duplicated.** Outstanding 46 -> **45**. Both keep the same five undo snapshots, so rather than
     copy fifty lines the decision moved into `CellWriteSnapshots.NothingChanged`, which takes the
     snapshot lists as arguments. Taking the lists rather than reading the command is the point: they
     are the complete record of what gets written, so passing all of them is what makes the answer
     complete -- and the r237 contract still verifies it, because a call that passes every field
     mentions every field.

187. **The registration nearly slipped through, and the honest version of this round includes that.**
     I added `AutofillCommand.cs` to the r237 contract's list with a `perl` substitution that did not
     match, ran the contract, saw it pass, and moved on. It passed because the list still contained
     only `FillCellsCommand` -- so Autofill's completeness was not being checked at all while I was
     removing it from the debt list on the strength of that check. Caught by grepping for the entry
     rather than trusting the green result.
     The general shape is worth naming: an opt-in contract reports success for anything not opted in,
     so "the contract passed" says nothing about a command until you have confirmed the command is IN
     it. That is the same failure mode as r232's ceiling arithmetic and r227's stale binaries -- a
     green result answering a question I had not actually asked.

188. The companion tests carry across: an autofill where the numbers already match but a target
     carries a note is a real edit, and the shared comparison catches it because the comment snapshot
     is one of the five.

## r239 -- the trio is closed

189. **`GroupedApplyStyleCommand` completes the three commands r236 identified.** Outstanding 45 ->
     **44**. It has two undo snapshots rather than five -- cells with their style-only entry AND its
     provenance tag, and the rich-text runs it rewrites when the style diff touches run fonts -- and
     both are consulted, which is what the r237 contract now enforces for it.
     The provenance tag is the clause worth pointing at: `StyleOnlySource` records whether a
     style-only entry came from a row or a column default, and `Revert` restores it precisely because
     losing it leaves a stale tag behind. So it is part of what the command writes, and therefore
     part of what "unchanged" has to mean. A comparison of the style id alone would have called a
     provenance change nothing.

190. **The grouped case gets its own test for the same reason r234's batch case did.** Sheet A
     already carries the style and sheet B does not: the batch is a real edit even though half of it
     changes nothing. That is the TrueForAll-not-Any argument again, this time across sheets rather
     than across cells -- and it is the direction where getting it wrong suppresses a genuine edit
     rather than merely wasting an entry.

191. **Where the remaining 44 stand.** The thirteen-command cluster r233 named is down to ten, and
     what is left of it splits cleanly: the ones that write cells through their own bespoke snapshot
     shapes (each needs its own decision method, as these three did), and the pivot/filter groups
     whose obstacle is a re-render rather than a comparison. The shared machinery -- `SameCell`, its
     coverage contract, `CellWriteSnapshots.NothingChanged`, and the snapshot-participation contract
     -- is now built and proven on three commands, so the remaining applications are work rather than
     design.

## r240 -- the contract was checking the wrong text and reporting success

192. **`RefreshStructuredTableTotalsCommand` fixed; outstanding 44 -> 43.** A refresh re-derives
     every totals cell, so refreshing a table nothing has moved under writes back what is there, and
     Refresh is a button that can be pressed twice. One undo snapshot, so per the r237 invariant
     consulting it is the whole question.

193. **The r237 contract had a hole, and finding it took three attempts because two of my own edits
     silently did not apply.** Three separate faults, all worth recording because each produced a
     GREEN result for a question I had not asked:
     - The contract keyed on FILE, not class. Several commands share a file, so it would have
       demanded one command's decision mention another's fields. Now class-scoped.
     - Its field pattern matched `_*Snapshot` only. `RefreshStructuredTableTotalsCommand` calls its
       snapshot `_previousCells`, so the contract found no fields to check and would have passed a
       decision that consulted nothing. Now matches `_previous*` too.
     - Worst: it located the decision method's text by searching forward for the next `private`
       member. When the decision is the LAST private member of its class -- which it was here -- that
       search finds nothing, the slice runs to the end of the class, and it sweeps in `Revert`.
       Revert touches every snapshot by definition, so the contract passed for a decision that
       consulted none of them. Now brace-matched.
     Each was found by deleting the clause and watching the test stay green. A contract that cannot
     fail is worth less than no contract, because it is believed.

194. **Two `perl -0777` substitutions in this round did not match and printed nothing, and I nearly
     built on both.** That is now the fourth and fifth instance this session (r232's arithmetic,
     r238's registration, and these). The habit that catches it is cheap and I should have adopted it
     earlier: after an edit, grep for the text you expected to write, before running anything that
     depends on it. Verify the edit, not just the outcome.

195. **`DataTableBodyRefreshCommand`'s guard was written and then REMOVED again, deliberately.** It
     had no behavioural test behind it, and the stale-entry contract correctly refused the state I
     tried to leave it in -- a command that reports IsNoOp cannot also sit on the list of commands
     that do not. Rather than weaken either list I reverted the guard, so the command stays honestly
     on the debt with its remedy known. Removing work to keep the ledger true is the right trade.

196. My own test premise was wrong once more, and the guard was right: I expected refreshing after a
     DATA change to be a real edit. It is not -- `ResolveTotalsCell` writes a SUBTOTAL formula
     derived from column metadata and the table range, not a computed value, so data moving beneath
     it changes nothing this command writes. The evaluator recalculates the formula; the refresh does
     not rewrite it. The test now changes the totals FUNCTION, which does change what gets written.

## r241 -- auditing my own contracts, because one of them was hollow

197. **r240 found a contract that could not fail. This round asked the same question of every other
     contract this program has built, by the only method that answers it: break the thing each one
     guards and confirm the test goes red.** Nine assertions probed, nine failed correctly.
     - `EveryWorkbookCommandDeclaresWhetherItCanNoOp` -- removed a judged-sound entry so a live
       command became undeclared. Red.
     - `EveryEntryStillNamesALiveCommandThatStillLacksAnIsNoOp` -- listed a command that already
       reports IsNoOp. Red.
     - `NoCommandIsInMoreThanOneList` -- put one command in two lists. Red.
     - `EveryDelegatedEntryNamesAHelperThatReportsNoOp` -- pointed a delegation entry at a helper
       that does not report IsNoOp. Red.
     - `TheOutstandingDebtOnlyEverShrinks` -- added three entries above the ceiling. Red.
     - `TheNeverExaminedListStillOnlyShrinks` -- put a command back into the drained column. Red.
     - `EveryExemptionStillNamesALiveCellMember` (r234) -- exempted a member of `Cell` that does not
       exist. Red.
     - `EverySettableCellMemberIsComparedOrExempted` (r234) -- proved in r234 by deleting the
       `QuotePrefix` clause. Red.
     - FreeW's `R203` declaration contract -- removed a judged-sound entry. Red.
     Nine for nine is the answer I wanted and not the one I assumed: r240's hole existed in the ONE
     contract I had probed least carefully, and the probe I had run for it happened to land on a
     command where the flawed extraction worked.

198. **The probe method has its own failure mode, met twice in this round.** Removing a single line
     from a two-line dictionary entry leaves a dangling string literal, so the build fails and
     `dotnet test` prints no result at all -- which reads as "no failure" if you are grepping for the
     word `Failed`. An inconclusive probe is not a passing probe. Both times the fix was to delete
     the whole entry and re-run.

199. A stale comment corrected while in there: `TheNeverExaminedListStillOnlyShrinks` still described
     its bound as "the r218 count", from before r232 drained that column to zero. The assertion has
     since changed meaning -- from "this number keeps falling" to "nothing may ever go back in here
     unexamined" -- and the text now says so. A ratchet whose comment describes a different era is
     the kind of thing that gets loosened by someone who believes the comment.

## r242 -- the pair the original census split

200. **`SetColumnOutlineGroupCollapsedCommand` fixed; `MergeScenarioCommand` judged sound.**
     Outstanding 43 -> **41**.
     The column-outline command is one half of a pair r208 deliberately separated: its ROW twin is
     sound because the caller passes `!group.IsCollapsed`, a negation gate, while the column one has
     no such caller guarantee. Two commands with the same body and opposite verdicts, and the
     difference is entirely in who calls them -- which is what makes a caller-gate justification
     worth recording per command rather than per family. It takes the r223 decision, making it the
     third command in that file to use it.

201. **Two candidates examined and rejected as fixes, both for reasons already on the record.**
     `MergeScenarioCommand` errors when there are no source scenarios and otherwise adds every one,
     renaming on collision rather than skipping -- so the merge always grows the list. Sound.
     `FormatPainterDataValidationCommand` looked tractable -- a single `_previous` snapshot of the
     target sheet's rules -- until the snapshot turned out to be built with `CloneValidation`, and
     `DataValidation` is a plain class with reference equality. Comparing a fresh clone list against
     the live one is always unequal, so the guard would never fire: the r231 trap exactly, now met
     for the third time. It stays on the debt.

202. **Two of my own edits broke the build in this round and one ran tests against stale binaries
     before I noticed.** An `awk` insertion ended a dictionary entry with `;` instead of `,`, which
     compiles as a statement terminator inside an initializer and fails; `--no-build` then ran the
     previous assembly and reported a failure from the OLD ceiling. The green/red I was reading had
     nothing to do with the change I had just made. Same family as r227 and r240: the check ran, but
     not against the code I thought.

## r243 -- twenty fields, and the contract that made writing them by hand safe

203. **`SetPageSetupCommand` fixed; outstanding 41 -> 40.** Twenty fields written, twenty snapshots
     kept, and every pair now compared. Page Setup pre-fills every one of its controls from the
     sheet, so pressing OK without editing rewrites all twenty with what they already hold.

204. **This is the command the r237 contract was worth building for.** Twenty clauses is well past
     the point where hand-transcription is trustworthy -- and the failure mode is silent: nineteen of
     twenty compared looks exactly like twenty, and the missing one reports "nothing changed" for a
     real edit forever. Earlier rounds handled that by keeping guards small enough to eyeball, which
     is why this command sat on the debt list from r208 to r243. The contract removes the constraint:
     it fails if a `_previous*` field this class declares is not mentioned in the decision, so the
     twenty clauses are machine-checked rather than trusted. Proved by deleting the
     `_previousPrintComments` clause and watching the contract name it.
     Worth stating the general form, because it changes what is worth attempting: a guard whose
     completeness is enforced can be as wide as the command needs. Without that, guard width is
     capped by what a person can re-read reliably, and commands wider than that stay broken.

205. The clauses were generated from the command's own `_previousX = sheet.Y;` snapshot lines rather
     than typed, so the pairing comes from the code that already exists rather than from me reading
     twenty names twice. The test that pins it picks a field deliberately far from the first, because
     a comparison that stopped early would still pass a test that only checked orientation.

## r244 -- a record that looks like a value and is not, for the fourth time

206. **`SetHeaderFooterCommand` fixed; outstanding 40 -> 39.** Sixteen fields, and r243's argument is
     what made attempting it reasonable: the r237 contract enforces that all sixteen participate, so
     width stopped being the obstacle. r242 had explicitly skipped this command as "heavy"; the
     contract is what changed.

207. **Six of the sixteen are picture sets, and they are why this one still needed care.**
     `WorksheetHeaderFooterPicture` is a record, so `==` compares its fields -- but `ImageBytes` is a
     `byte[]`, which records compare BY REFERENCE. The snapshot is taken with `DeepClone`, which
     copies the array. So a comparison written with `Equals` would have compiled, read correctly to
     any reviewer, and never once reported a no-op.
     That is the FOURTH instance of this trap in the program (r231's scenario/custom-view records,
     r242's `DataValidation` clones, r236's parallel snapshots, now this) and the sharpest, because
     here the thing that breaks the comparison is the same `DeepClone` that makes UNDO correct. The
     defensive copy and the equality check pull in opposite directions.
     `SameHeaderFooterPictures` compares content, including `ImageBytes.AsSpan().SequenceEqual`, and
     the test that pins it hands the command a separate object holding identical bytes -- which is
     precisely what the dialog does after a round trip through the model.

208. The last test in the file targets `alignWithMargins` deliberately: it is the SIXTEENTH field,
     and a comparison that transcribed fifteen would pass every other test in the file. When a guard
     is wide, the test that matters is the one aimed at its far end.

## r245 -- the obstacle turned out to be the record

209. **`SetColumnWidthCommand` and `SetRowHeightCommand` fixed; outstanding 39 -> 37.** These are the
     two commands r216 re-ranked from tier 2 to tier 3, and the note it left was that
     `DrawingAnchorResizeHelper.ResizeFor*Range` RESIZES every anchored shape, picture and text box
     while reading like a snapshot line -- so deciding "no change" meant predicting that resize, and
     the field-count ranking that had put them in tier 2 was wrong about them.

210. **It is not a prediction any more, and the reason is worth naming: the thing that made them hard
     is the thing that makes them decidable.** The resize helper hands back each object WITH its old
     size, because Revert needs that. So the obstacle r216 identified -- a hidden mutation -- is
     itself the complete record of what was mutated. Comparing what the helper returned against what
     the objects now hold is exact where predicting the resize would have been guesswork.
     That is the r237 invariant arriving from the other direction. r237 said the undo snapshots ARE
     the record of what a command writes; here the mutation and the snapshot are the same call.

211. **The tests that matter are the drawing ones.** A guard comparing only column widths would pass
     "set the same width twice" and "change the width", and still be wrong about a sheet with a shape
     anchored in the range. Two of the six target exactly that, and reverting the guards fails three
     of the six.

212. r216 wrote that these two stayed on the debt "rather than being fixed on the strength of a
     ranking now known to be wrong for them". Twenty-nine rounds later that judgement reads well: the
     right move was to wait until the decision could be made from a record rather than from a
     prediction, and the machinery that allowed it did not exist yet.

## r246 -- probably the most frequent no-op in the product

213. **`ApplyStyleCommand` fixed; outstanding 37 -> 36.** The single-sheet twin of the command r239
     did, and the same two-snapshot decision: cells with their style-only entry and its provenance
     tag, plus the rich-text runs the command rewrites when the diff touches run fonts.
     Worth saying what this one is, because the count does not convey it: pressing Bold on
     already-bold text is very likely the single most frequent no-op gesture in a spreadsheet editor.
     Every one of those was pushing an undo entry and clearing the user's redo.

214. Probed by removing the rich-text clause from the decision: the r237 contract fails and names
     `_richTextSnapshot`. That probe is worth repeating per command rather than trusting the pattern
     -- r240 showed the contract can be structurally unable to see a particular command even while
     passing for others.

215. The third test is the batch case once more, now for a range rather than a sheet group: the first
     cell already carries the style and the second does not, so the application is a real edit even
     though half of it changes nothing. That case has appeared in r234 (cells), r239 (sheets) and now
     r246 (ranges), and it is the same mistake each time -- `Any` where `TrueForAll` belongs -- which
     is why each of the three has its own test rather than an assumption that the earlier one covers
     it.

## r247 -- the delegation that carried a defect now carries the fix

216. **`ApplyStructuredTableStyleCommand` fixed, and `ReapplyStructuredTableStyleCommand` cleared
     with it. Outstanding 36 -> 34 -- two entries, one change.**
     The first is a composite in all but name: one `ConfigureStructuredTableStyleOptionsCommand`
     (fixed in r219) plus a set of `ApplyStyleCommand`s (fixed in r246). Once every child could say
     whether it changed anything, the parent needed only to bubble that up -- the mechanism
     `CompositeWorkbookCommand` has had all along and which r224 leaned on to clear
     `RemoveSheetsCommand`. The `allNoOp` flag starts from the option change so a run with no style
     commands at all still answers correctly.

217. **r231 recorded `Reapply` as inheriting this command's DEFECT through delegation. It now
     inherits the fix through the same delegation.** That is the observation running forward, and it
     is the argument for fixing leaves before composites: the six rounds spent on
     Configure/ApplyStyle/cell-comparison were what made this round a two-line change.
     It moves to `DeclaresIsNoOpThroughAHelper` rather than off the books entirely, because its own
     class body still never mentions IsNoOp and the source scan cannot see through the call. The
     contract's machine-checked delegate claim (r223) covers it.

218. The contract caught the classification, not me: I removed both from the debt list, and
     `EveryWorkbookCommandDeclaresWhetherItCanNoOp` failed naming `Reapply` -- correctly, because
     "fixed" and "declares" are different properties and only the second is what that list tracks.
     Third time this session a mechanical check has corrected my bookkeeping rather than my code.

## r248 -- the fifth instance earns a guard rail instead of another hand-written comparison

219. **`ApplyCustomViewCommand` fixed; outstanding 34 -> 33.** Applying the custom view the workbook
     is already showing writes every sheet's view state back over itself.

220. **This is the FIFTH time this program has met one trap, and that is why it got different
     treatment.** A record whose `==` looks like value equality but carries collection members, which
     records compare by REFERENCE: r231 (scenario and custom-view records), r236 (parallel
     snapshots), r242 (`DataValidation` clones), r244 (header/footer picture bytes), and now
     `WorksheetCustomViewState`'s four list members. Every capture builds fresh lists, so a guard
     written with `==` compiles, reads correctly, and never fires.
     The first four got hand-written content comparisons. The fifth got
     `WorksheetCustomViewStateComparer` PLUS `R248_ViewStateComparisonCoverageContractTests`, on
     r234's pattern: every member of the record must be compared or exempted with a reason. Thirty
     members is past the point where re-reading is a check.

221. **The coverage contract caught two members on its very first run, before any command depended on
     it.** I had enumerated the record's members with a `sed` range that truncated before the end of
     the declaration, so `FitToPage` and `ScaleToFit` were missing from the comparison. A guard
     shipped without that contract would have reported "no change" for a custom view that switched
     fit-to-page -- silently, forever.
     That is the strongest argument yet for writing the contract BEFORE the comparison it guards
     rather than after: it cost one round to build and paid for itself within it.

## r249 -- let the type's own Clone be the field list

222. **`ApplyConditionalFormatCommand` fixed; outstanding 33 -> 32.** The Conditional Formatting
     rules dialog pre-fills the rule being edited, so pressing OK unchanged replaces a rule with an
     equal one. `ConditionalFormat` is a class with reference equality and SIXTY settable members, so
     this needed a content comparison.

223. **The coverage contract for it is a better shape than r234's and r248's, and worth reusing.**
     Those reflect over the type and maintain an exemption list. This one compares `SameAs` against
     `Clone`: every member `Clone` assigns must appear in the comparison.
     `Clone` is the type's own maintained enumeration of what it consists of -- it has to be complete
     or cloning loses data -- so the field list comes from code that is already required to be right
     for an unrelated reason, and there is no exemption list to keep honest. For a sixty-member type
     that is both cheaper to write and harder to fool.

224. **Two coverage contracts in two rounds, two real omissions caught on first run.** r248's caught
     `FitToPage` and `ScaleToFit`; r249's caught `Value1` and `Value2` -- both times in a comparison I
     had GENERATED from the source rather than typed, which is exactly the case where one feels
     safest. A generated comparison is only as complete as the extraction that generated it, and my
     extraction was wrong twice out of two. That is the argument for the contract stated as a
     measurement rather than a principle.
     `Value2` matters concretely: without it, changing the upper bound of a between-rule would have
     been reported as no change. There is a test for it.

## r250 -- the pattern reaches the command r242 had to give up on

225. **`SetDataValidationCommand` fixed; outstanding 32 -> 31.** The Data Validation dialog pre-fills
     the rule being edited, so OK-unchanged replaces a rule with an equal one.
     r242 examined this family and put it back on the debt, because `DataValidation` is a plain class
     with reference equality and the snapshots are built with a clone -- so any comparison written
     with `Equals` would never fire. That verdict was right at the time. The r249 shape is what makes
     it wrong now: a content comparison whose coverage contract derives its field list from the
     type's own `CloneForRanges`.

226. **The four `Native*` collections are the subtlety worth recording.** `CloneForRanges` assigns
     them BY REFERENCE, so a clone genuinely compares equal to its source on those members -- which
     makes reference comparison look adequate if you test with a clone. But the case a no-op decision
     actually faces is two INDEPENDENTLY BUILT rules with identical content, and those share no
     references. Testing with a clone would have hidden the need for content comparison entirely; the
     comparison covers them by content for that reason.

227. **A method note, since it cost time three rounds running.** My shell edits keep silently not
     applying -- a `perl -0777` substitution that does not match, an `awk` line that mangles regex
     escapes. Twice more this round. The reliable form for writing a line containing regex escapes is
     to put the line in a file and have `awk` read it, rather than embedding it in the program text.
     Every one of these was caught by re-reading the file afterwards rather than by the test, which
     is the same lesson as r238 and r240: verify the edit, not just the outcome.

## r251 -- a fix built, measured, and thrown away

228. **I wrote guards for `FormatPainterDataValidationCommand` and `PasteDataValidationCommand`,
     measured them, and reverted both. Outstanding stays 31.** They were the obvious next users of
     r250's `DataValidation.SameAs`: one snapshot each, the target sheet's whole rule list, compared
     element-wise. The tests said the second application was still a real edit, so I probed what
     actually differed between two identical paints. Only the rule's **Id**:
     `...|A5:A6|10` on both sides, different Guids.

229. **Both commands mint a fresh rule identity on every copy** -- `CloneValidation` goes through
     `CloneWithNewIdentity`, which assigns `Guid.NewGuid()`. So by the model's own definition the
     second paint DOES change the document, and a guard comparing content-including-Id can never
     fire for the case it exists to catch. That is the "guard that cannot fire" this program has now
     refused five times (r229 Autofill, r231 SaveScenario, r242 FormatPainter's first look, r248's
     near miss, and this) -- and the only reason I did not ship it is that the behavioural test
     failed. Had I written only the "different rule is a real edit" direction, it would have passed
     and the guard would have looked correct forever.
     That is the argument for always writing the no-op direction as a test, not just the real-edit
     direction: the real-edit direction passes with no guard at all.

230. **The identity churn is a separate question, and possibly a real defect.** Re-painting the same
     validation onto the same target produces a document that differs only by a regenerated Guid --
     which marks the workbook dirty and changes the saved bytes with nothing user-visible behind it.
     Whether copy should preserve or mint identity is a design question about the model rather than
     about no-ops, so it is filed rather than answered here.
     Both commands stay on the debt with this as their reason, which is sharper than r242's "the
     comparison would never fire": now we know exactly which member makes it so, and why.

## r252 -- half the machinery for the largest remaining block

231. **Built `FilterUndoSnapshot.Matches` and its coverage contract. No command came off the list;
     outstanding stays 31.** The AutoFilter group is the largest single block left -- eight commands
     -- and r225 put them all on the debt because each touches BOTH the hidden-row state and the
     autofilter column model, so a guard covering one half would be a partial mirror.
     `Matches` covers the first half completely: field for field with `Capture`, over the five sheet
     members filter state consists of (hidden rows, filter-hidden rows, value-filter-hidden rows,
     the active value-filter columns, and the per-column owned-row map).
     `R252_FilterSnapshotComparisonCoverageContractTests` derives the field list from `Capture` --
     the r249 trick, since Capture has to be complete or undo loses filter state -- and fails if
     Capture reads a sheet member Matches does not. Proved by deleting the `ValueFilterHiddenRows`
     clause.

232. **The second half needs another content comparison, and I stopped rather than guess at it.**
     `_previousAutoFilterColumns` is a SHALLOW copy of `autoFilter.FilterColumns`, so its elements are
     the same instances -- which makes a reference comparison look adequate. But the case that
     matters is re-applying a filter, where `newColumn` is a freshly built model with identical
     content and no shared reference. `WorksheetAutoFilterColumnModel` is a record carrying five
     collection members, so this is the same trap for the SIXTH time, and it needs its own `SameAs`
     with its own coverage contract before any of the eight can be decided.
     Landing the proven half as infrastructure and naming what the other half needs is the honest
     stopping point. The alternative -- shipping a guard over the hidden-row half only -- is exactly
     the partial mirror r225 declined to build, and it would have taken eight commands off the debt
     list without fixing any of them.

## r253 -- the second half, and the first of the eight comes off

233. **`WorksheetAutoFilterColumnComparison.SameAs` -- content comparison for the column model and
     the six nested filter models it carries.** Eleven of the column model's fifteen members are
     reference types, so record equality compares them by reference and reports "changed" for two
     filters built the same way. The comparison is structured to keep using record equality for what
     it is good at: every reference-compared member is stripped to a SHARED instance (`Strip`), the
     stripped pair is compared with `==`, and each stripped member is then compared by content. A
     scalar member added later is covered with no edit here. The six nested models each carry
     scalars plus one `NativeAttributes` dictionary, so they use the same shape --
     `with { NativeAttributes = null }` plus a map comparison.

234. **`R253_AutoFilterColumnComparisonCoverageContractTests` derives its field list from the types,
     not from a hand-written list.** A member is reference-compared exactly when its type is a
     reference type other than `string`, so the contract computes that set by reflection and checks
     three things: every such member of the column model is stripped; every stripped member is then
     compared in `SameAs`; and no nested model has a reference-typed member other than
     `NativeAttributes`. The third is the one that matters most -- an unstripped collection makes
     `SameAs` answer "changed" too often, which loses nothing, but an unhandled member inside a
     nested model makes it answer "unchanged" for two DIFFERENT filters, which drops a real edit.

235. **`AverageFilterCommand` fixed; outstanding 31 -> 30, and r225's eight-command block is now
     seven.** Its two snapshot fields are exactly the two halves and nothing else -- `_undoSnapshot`
     and `_previousAutoFilterColumns` -- which Revert confirms by restoring precisely those two. So
     a decision over both is complete rather than partial, and r225's objection to the group does
     not apply to this member of it.

236. **The decision is post-hoc, so it mirrors nothing.** `WorksheetAutoFilterColumnSync.Unchanged`
     compares the stored filterColumn list against the snapshot Apply already captured, and
     `FilterUndoSnapshot.Matches` does the same for the hidden-row half. Both read the record of
     what the edit did rather than predicting it, which is why an earlier draft of this round --
     a `WouldChange` that re-ran Apply's projection on a copy -- was thrown away: it was a second
     copy of the edit that could drift, and the post-hoc form needs no such copy. It also satisfies
     r237's participation contract honestly, since both fields appear in the decision.

237. **The other seven each carry a THIRD snapshot, and stay on the debt.** Five carry a
     `StructuredTableFilterColumnSnapshot`; `FilterCommand` additionally carries a table-reband cell
     snapshot and a slicer-sync snapshot; `AdvancedFilterCommand` carries a copy-to cell snapshot.
     Each of those halves needs its own content comparison before those commands can be decided,
     and naming which half is missing per command is more useful than the group-level "both models"
     note r225 left.

238. **The fail-before probe came back GREEN, and the round's premise was wrong for this command.**
     Swapping `SameAs` for `!=` in `Unchanged` left every AverageFilterCommand test passing.
     `AverageFilterCommand` builds its column model entirely from EMPTY collection expressions, and
     an empty `[]` targeting an interface lowers to the cached `Array.Empty<T>()` singleton, so its
     two applications are reference-equal member for member; its one nested model carries a null
     attribute dictionary. For this command record equality would have sufficed. The claim in r252
     that "record equality reports changed every time" is true of the seven commands that build
     NON-empty value lists and custom-filter criteria -- not of this one.
     A probe that stays green is evidence about the test, not just the code: the command-level tests
     could not distinguish the two comparisons, so `R253_AutoFilterColumnComparisonTests` now pins
     the distinction on the models directly, asserting that `left == right` is FALSE and
     `left.SameAs(right)` TRUE for two identically-built value filters. That test fails without the
     comparison by construction, which the command-level ones did not.
     Keeping `SameAs` here anyway is deliberate: the singleton-empty-array coincidence is not a
     property AverageFilterCommand states or a test protects, and a later edit giving it a real
     value list would silently turn record equality wrong.

## r254 -- the third half, and five more off the block

239. **`SameAs` for `StructuredTableFilterColumnModel`, and `StructuredTableFilterColumnSync.Unchanged`.**
     A table carries its own `<autoFilter>` inside the table part, so the same criterion has a
     second model of the same shape with the same reference-equality problem. It is compared the same
     way -- strip the seven reference-compared members to shared instances, let record equality cover
     the scalars, compare the stripped members by content -- and `Unchanged` asks post-hoc whether
     the table's filter-column list still holds what the snapshot captured.

240. **Five commands fixed; outstanding 30 -> 25, and r225's block is down to two.**
     CellFillColorFilter, CellFontColorFilter, CellNoFillColorFilter, FilterCondition and
     TopBottomFilter each have exactly three snapshot fields, and each `Revert` restores exactly
     those three, so a post-hoc decision over all three is complete rather than partial. That is the
     whole of what r225 said was missing for them: "a snapshot-versus-target comparison over both
     models" -- there were three models, not two, and the third now has one.

241. **The two that remain are not blocked on another filter model.** `FilterCommand` also repaints
     a banded table's data body and rewrites slicer selections; `AdvancedFilterCommand` writes a
     copy-to block of cells. Both need a cell-level comparison, which is a different piece of
     machinery from the three built in r252-r254, so naming that is more useful than leaving them
     under the group-level note.

242. **The probe failed correctly this time, and the r253 coincidence recurred on a third model.**
     Swapping `SameAs` for `!=` on the table half failed 2 of the 3 no-op tests -- TopBottomFilter
     (whose criterion is a `NativeFilterXmls` entry) and FilterCondition (a `CustomFilters` entry).
     The colour filter still passed, because `ColorFilter` is a nested record whose members are all
     value types with a null attribute dictionary, so record equality happens to be right for it
     too. Three models in, the pattern is clear: reference equality is wrong exactly when the
     criterion lands in a COLLECTION member, and right when it lands in scalars or a nested record
     of scalars. That is a property of where a given filter kind stores itself, not of the command,
     which is why the comparison is written for the type rather than per command.

243. **The sibling tests could not have caught this, and that is why the table-range ones exist.**
     `SortFilterTests`' cases run on a plain worksheet range, where the table half sees a null
     snapshot and returns true without comparing anything -- exactly the r253 situation, where a test
     at the call site cannot distinguish a working comparison from a missing one.
     `R254_TableFilterReapplyNoOpTests` puts the criterion on a structured table so the comparison is
     actually reached.

## r255 -- the AutoFilter block is closed

244. **`AdvancedFilterCommand` and `FilterCommand` fixed; outstanding 25 -> 23, and r225's
     eight-command block is EMPTY.** Neither needed a fourth filter model: both write cell content,
     and the cell comparison they needed already existed --
     `CellEditCompanionSnapshot.SameCellOrAbsent`, built in r234 for the cell-editing commands.
     AdvancedFilter compares its copy-to block cell by cell against `_copySnapshot`; FilterCommand
     does the same for the table-reband block, plus the two filter-column models, the hidden-row
     snapshot, and the slicer selections item by item -- five snapshots, which is exactly what its
     Revert restores.

245. **The probe was the strongest of the three rounds.** Removing the cell comparison from
     AdvancedFilter failed BOTH copy-to tests, including the changed direction: with the copy block
     unexamined the decision reports "nothing changed" for a run that wrote a whole block of data,
     which is the failure mode that actually loses work rather than merely annoying the user.
     r253's probe stayed green and r254's failed half its cases; this one failed everything it
     should, because the machinery it removes is the only thing that can see the change.

246. **A latent hazard noted rather than changed: `FilterCommand.Revert` early-returns on
     `!_undoSnapshot.HasSnapshot` BEFORE restoring the table filter columns, the slicer selections
     and the reband block.** It restores `_previousAutoFilterColumns` first, so those four are
     ordered around a guard that is about a fifth. Today that early return is unreachable after a
     successful Apply, because Apply calls `CaptureIfNeeded` unconditionally -- so this is not a live
     bug and is not "fixed" here. It is recorded because the r237 invariant cuts both ways: the
     undo record is the complete list of what a command writes only while Revert actually restores
     all of it, and making that capture conditional (as five sibling commands already do) would
     silently turn this into an undo that leaves four of five snapshots unapplied.

247. **The r237 contract caught a real hole in my own guard, and the fix was not to loosen it.**
     FilterCommand's first draft consulted `_previousTableFilterColumns` inside a helper, so the
     decision method's body never named it and the contract failed. A contract that followed one
     level of delegation would have passed the draft -- and would also pass a decision that
     delegates to a helper which ignores the field. Passing the snapshot to the helper as an
     argument keeps the field visible in the decision, which is what the contract is actually for.

## r256 -- the pivot Configure family, and r219's obstacle dissolved

248. **Five pivot commands fixed; outstanding 23 -> 18.** ConfigurePivotTableView,
     ConfigurePivotTableFieldFilters, ConfigurePivotTableLayout,
     ConfigurePivotTableCalculatedItems and ClearPivotTableView. r219's evidence was in the callers:
     the dialogs hand back the pivot's own current state as their default, so re-confirming one
     reaches Apply with every argument equal to current state.

249. **r219's obstacle was a consequence of predicting rather than observing.** It declined to fix
     the family because "deciding no change means also proving the re-render is unnecessary, and
     guessing at that is how a guard ends up suppressing a real edit". That is true of a PREDICTIVE
     guard and false of a post-hoc one: `_targetSnapshot` IS the block the re-render overwrote, so
     comparing it against the sheet afterwards observes what the re-render produced. The obstacle
     was never about pivots; it was about guard shape, and r255's cell comparison is the same tool.

250. **`PivotSnapshotComparison` plus `Matches` on the six snapshot records.** Every pivot snapshot
     is a record of lists captured with `ToList()` -- the reference-equality trap for the fifth and
     sixth model family. Only `PivotFieldModel` carries a collection of its own (`SelectedItems`), so
     it gets the strip-and-compare treatment and the rest are compared with
     `EqualityComparer<T>.Default`. `R256_PivotSnapshotComparisonCoverageContractTests` derives each
     record's field list from its own `Capture` (the r249 pattern) and separately pins the assumption
     the scalar path rests on: that those element records carry no collection member. Proved by
     deleting a clause -- the contract named the missing member.

251. **The probe came back green, and the fix was a missing TEST, not a missing guard.** Removing
     the rendered-cell comparison left all ten behavioural tests passing, because in every one of
     them the model changed whenever the render did -- so the model half alone decided every case.
     The case that separates them is a SOURCE-DATA edit: the configuration is identical, the model
     comparison says "unchanged", but the re-render writes a different total. With that test added
     the same probe fails, and the cell half is load-bearing on exactly the case r219 said could not
     be decided. Three rounds running, a green probe has meant the tests could not see the machinery
     rather than that the machinery was unnecessary.

252. **ChangePivotTableSource, RefreshPivotTable, ConfigurePivotTableOptions and
     ConfigurePivotChartOptions stay on the debt, with sharper reasons than the family note.**
     ChangePivotTableSource's `PivotSourceSnapshot` holds the cache OBJECT, and when Apply mutates
     the cache in place that field IS the live object -- so a comparison against it is the
     cannot-fire guard r231 refused, and it needs a captured copy of the cache's fields instead.
     RefreshPivotTable and the two Options commands carry snapshot fields no pivot-state record
     covers (a refresh field snapshot, an autofit column-width map, ten separate chart-property
     fields), each needing its own comparison.

## r257 -- applying the comparison rather than building one

253. **Three more fixed; outstanding 16 -> 13.** MovePivotTable (r225),
     DataTableBodyRefresh (r232) and ExternalTextPasteSpecial (r232). All three were held by the
     same recorded reason -- each "needs a real before/after comparison, not a guard on the
     arguments" -- and r255's `SameCellOrAbsent` is that comparison, so this round applied existing
     machinery rather than building any. Each has a snapshot set small enough to cover completely,
     and each Revert restores exactly that set.

254. **r240's reverted guard is back, with the tests it lacked.** DataTableBodyRefresh had a guard
     written and then deliberately reverted in r240, because there was no behavioural test and the
     stale-entry contract correctly refused an entry that declared IsNoOp while still listed as
     broken. Keeping the debt entry honest that round is what made this round's fix cheap: the
     obstacle was recorded precisely enough to act on.

255. **ExternalTextPasteSpecial's style-only slot needed its own clause.** Revert has two cases --
     restore the cell, or (where no cell existed) restore the style-only entry -- so a comparison on
     cells alone would call a paste that changed only the style-only slot a no-op. The decision
     mirrors Revert's two cases rather than just its obvious one.

256. **Two test premises were wrong, and the code was right both times.**
     Pasting the TEXT "one" through ExternalTextPasteSpecial writes nothing at all:
     `PasteArithmetic.ApplyOperation` returns null for a non-numeric operand, which is Excel's
     documented behaviour, so the loop skips every cell. My test read that correct no-op as a broken
     guard. The tests now paste numeric text, and the comment records why -- otherwise the next
     reader repeats the same misreading.
     The Data Table body writes FORMULA cells, not evaluated values, and the test workbook never
     recalculates, so asserting on `GetValue` found blanks and looked like a table that never built.
     The assertion moved to `FormulaText`, and a build-succeeded assertion was added first, because a
     table that silently failed to build would leave an EMPTY snapshot and make the no-op test pass
     vacuously.

257. **The probe failed on all three, four tests, one per command in the changed direction.**
     Neutralising each decision made a real move, a real paste and a real refresh all report "nothing
     changed" -- the direction that loses work.

258. **MoveRangeCommand stays, and its reason is now countable rather than qualitative: THIRTY
     snapshot fields.** Cells, formulas, comments, threaded comments, hyperlinks and their metadata,
     rich-text runs, phonetic guides, data validations, conditional formats and three formula maps
     for them, chart verbatim XML, merged regions at both ends, structured tables at both ends,
     chart data ranges, named ranges scoped and unscoped, sparklines and their data ranges, and spill
     relocations. A decision over all thirty is a round of its own, and a decision over fewer is the
     partial mirror this program keeps declining.

## r258 -- the guard r231 said could not fire

259. **SaveScenario and SaveCustomView fixed; outstanding 13 -> 11.** r231 named these two exactly
     and refused to guard them: "both targets ARE records, and the obvious guard is
     `newValue == previous` -- but both records carry LIST members, which record equality compares by
     reference, so against a freshly built instance it is always false. That guard would never fire
     while looking exactly like the ones that do work." `SaveTargetComparison` is the comparison that
     does fire; each record has exactly one collection member, so the strip-and-compare shape applies
     directly, and the custom view's elements reuse r248's thirty-member comparer.

260. **The probe confirmed r231's prediction empirically rather than by argument.** Replacing both
     comparisons with `==` fails BOTH no-op tests while all four changed-direction tests keep
     passing -- which is precisely what makes that guard dangerous: it looks like it works. r231
     called this from reading; the probe measured it.

261. **The coverage contract found a reference comparison no reading would have surfaced.**
     `ScenarioCellValue` is a `CellAddress` and a `ScalarValue`, and both are records with value
     equality, so `!=` looked obviously correct. `ScalarValue` is ABSTRACT, and one of its subtypes,
     `RangeValue`, carries a `ScalarValue[,]` -- an array, compared by reference. The member's
     declared type never mentions it. The contract walks the reachable graph including subtypes, so
     it failed; the comparison now compares range contents element by element, recursively, and a
     second test pins the exemption to the existence of that code so it cannot outlive it.

262. **The classifier used since r253 is conservative, not exact, and this round is where the
     difference showed.** "Reference type means compared by reference" is right for collections and
     WRONG for records, which are reference types with value equality. The earlier contracts are
     unaffected -- being conservative there only meant stripping and comparing members that record
     equality would have handled -- but a contract on a record-typed member needs the recursive form:
     value equality recurses into the member, and stops being content equality at the first
     collection it reaches.

263. **A blanket `sed` for the return statement hit two sibling commands in the same file.**
     `CustomViewCommands.cs` holds three commands, two of which had their own bare
     `return new CommandOutcome(true);`, and one already had an unrelated `NothingChanged(ICommandContext)`
     -- so the edit COMPILED and silently changed two commands I had not examined. Caught by grepping
     for the applied pattern and finding three hits where one was intended. This is the fifth time in
     this program that verifying the edit rather than the outcome has caught something.

## r259 -- the two Options dialogs, and a guard with nothing hand-listed

264. **ConfigurePivotChartOptions and ConfigurePivotTableOptions fixed; outstanding 11 -> 9.**
     Both dialogs pre-fill every control from current state, so OK-without-changing-anything is the
     ordinary case, and both wrote every setting back unconditionally.

265. **r219's objection to the PivotTable one is answered by not doing what it warned against.**
     It declined that command because "its Apply is a 25-field assignment block, and hand-listing
     that many fields in a guard is precisely the brittle mirror r218 avoided". Nothing is hand-listed
     in the fix: the decision RE-RUNS `PivotOptionsSnapshot.Capture` and compares the result with the
     snapshot Apply already took. It is complete by construction because it is the same capture the
     undo record uses, and a setting added to the snapshot is carried into the decision with no edit
     at all. This is the cheapest correct shape found in the whole program -- available whenever the
     undo snapshot is a scalar-only record.

266. **What that shape rests on is now a contract, because its failure is silent.** Record equality
     is content equality for the snapshot only while every member is a scalar; a collection member
     added there would be compared by REFERENCE against a fresh capture, so the guard would answer
     "changed" forever and quietly stop firing, with nothing about the code looking wrong.
     `R259_..ContractTests` fails if a reference-typed member appears, and separately pins that the
     snapshot still covers 30+ settings, so a snapshot that shrank would not silently narrow the
     guard.

267. **`ChartDataTableModel` is a CLASS, which is the reference-equality trap one level worse.**
     A record at least compares its scalars; a class compares nothing but identity, and this one is
     captured with `Clone`. It gained a `SameAs` over all twelve members with a contract deriving the
     field list from `Clone`, proved by deleting the `BorderThickness` clause -- the contract named it.

268. **A test premise was wrong again, and finding out why produced a better test.**
     "Re-applying the current options is a no-op" failed. Rather than adjust the assertion, I asked
     which half disagreed: the second identical apply WAS a no-op, so the first was changing
     something real. It was `AutofitColumnsOnUpdate`, on by default, resizing the pivot's rendered
     columns -- caught by the third comparison. So the fixture turns autofit off with a comment, and
     a new test asserts the autofit apply is NOT a no-op while the one after it is. That test is what
     makes the column-width comparison load-bearing: the probe that removes it fails exactly there.

269. **The r237 contract caught the same hole as r255, in the same shape.** The autofit half was
     consulted inside a helper, so the decision body never named the field. Fixed the same way --
     pass the snapshot as an argument -- rather than teaching the contract to follow delegation,
     which would also pass a helper that ignored it. Two rounds apart, the same mistake and the same
     resolution; the contract is earning its keep on my own code rather than on hypothetical future
     edits.

## r260 -- and the contract that had been half-blind

270. **PasteColumnWidths and SetHyperlink fixed; outstanding 9 -> 7.** r221 grouped
     PasteColumnWidths with PasteDataValidation as needing "a before/after snapshot comparison, which
     is a change to how they work rather than a guard bolted on". Half true: that is right about the
     did-we-write-anything test, but this command already HOLDS the before half --
     `_previousWidths` is exactly what Revert restores -- so comparing it against the same range
     afterwards is the whole decision. The capture loop and the comparison now share one
     `CaptureDestinationWidths`, so they cannot describe different ranges.

271. **SetHyperlink's decision covers all five things Revert restores, and the two "had" flags carry
     as much weight as the values.** Apply REMOVES any rich-text runs and phonetic guide on the cell,
     so re-linking a cell that carries them is a real change even when target, display text and
     metadata all match. The probe that drops the runs clause fails exactly that test.

272. **The r237 contract has been HALF-BLIND since r237, and registering SetHyperlink exposed it.**
     Its field pattern matched `_*snapshot` and `_previous*` only. SetHyperlink names its undo state
     `_oldCell`, `_oldTarget`, `_hadOldMetadata` and so on -- nine fields of exactly the state the
     contract exists to police, none of them matched. The failure was loud in this case (the contract
     asserts the field list is non-empty, so it refused a command it could not see), but that
     assertion is the only thing that made it loud: a command with ONE matching field and five
     `_old*` ones would have passed while five sixths of its undo record went unchecked.
     The pattern now covers `old\w*` and `hadOld\w*`, and every previously registered command still
     passes. Proved by dropping a clause: the contract named `_hadOldMetadata`.

273. **The r237 contract reads the decision BODY, so passing a snapshot as an argument only satisfies
     it when the field name appears in that body.** r255 and r259 passed fields into helpers FROM the
     decision, which works. Here I first passed `_previousWidths` in at the CALL SITE, which does not
     -- the body sees only the parameter name. Reading the field directly is both simpler and what
     the contract is actually asking for.

274. **`awk` ate the regex escapes again while editing the pattern**, turning `\s` into `s` and
     `\w` into `w`, which compiled and made the contract match nothing -- reported as "FillCellsCommand
     must declare snapshot fields". Same failure recorded earlier in this program with the same cause.
     Written through a file instead. A contract edited by a tool that silently mangles its regex is
     worth no more than no contract.

## r261 -- MergeCells fixed; RefreshPivotTable attempted and reverted

275. **MergeCells fixed; outstanding 7 -> 6.** r232 recorded it as "net effect nil, but establishing
     that means reasoning through five loops rather than adding a guard". The post-hoc form reasons
     through none of them: Revert restores six things -- the merged region and the absorbed ones, the
     covered cells, and the four per-address comment collections -- and the decision compares all six
     against the sheet.

276. **The comment half is load-bearing on its own.** Apply MIGRATES a covered cell's note onto the
     anchor, so a re-merge that moves a note changed something even though every covered cell was
     already blank and the region already existed. The probe that drops the comment clause fails
     exactly that test and nothing else.

277. **RefreshPivotTable was written, could not be demonstrated, and was REVERTED.** The guard covered
     all four snapshots and looked right. With no `PivotCacheModel` in the fixture its tests passed --
     but that fixture proved nothing, because `cache` was null on both sides and the cache clause
     compared nothing at all. Adding a real cache made the no-op test fail: with a populated cache,
     a second refresh over untouched data still reports a change, and I did not identify which clause
     never settles. A test-only probe established that the cache's own shared items ARE stable across
     the second and third refresh, so the cache comparison is not the culprit -- which narrows it to
     the rendered cells, the last-rendered range, or the merged regions, and leaves the question open.
     Shipping a guard whose no-op direction cannot be demonstrated is exactly what this program has
     declined eight times for other people's code, so it is declined here for mine. r240 set the
     precedent: a guard written and reverted, with the obstacle recorded precisely enough to act on
     next time.

278. **The near-miss worth recording is the fixture, not the guard.** A pivot fixture with no cache
     makes every cache-related clause vacuous while all the tests pass. The first version of these
     tests would have taken RefreshPivotTable off the debt list on the strength of a comparison that
     never executed -- the same failure as r253's and r256's green probes, but reaching a wrong
     conclusion rather than merely an unproven one.

279. **A diagnostic probe belongs in test code, not in the command.** My first attempt at finding the
     unsettled clause added a static diagnosis field to `RefreshPivotTableCommand` itself. Instrumenting
     production code to answer a test question leaves exactly the kind of residue this program is
     supposed to be removing; the same question was answered by comparing cache contents from a test.

## r262 -- the missing contract, and what it cost

280. **RefreshPivotTable fixed; outstanding 6 -> 5. The command was never the problem.** r261 reverted
     its guard because a settled refresh still reported a change. Four test-only diagnoses, one per
     candidate, established that a settled refresh leaves the rendered cells, the last-rendered
     range, the merged regions and the pivot's own field lists all untouched. Nothing churned. The
     false "changed" came from the comparison itself.

281. **`PivotCacheFieldModel` carries THREE collection members and r261's comparison stripped ONE.**
     `SharedItems` was stripped; `SharedItemKinds` and `GroupItems` were not, so both were compared by
     REFERENCE inside the stripped record equality and differed after every refresh that rebuilt the
     cache field list. That is the exact defect this program has been fixing in other people's code
     for ten rounds, committed by me, in the one comparison I shipped WITHOUT a coverage contract.

282. **The symptom of a broken comparison is indistinguishable from the symptom of a churning
     command.** Both look like "the guard never reports a no-op". r261 read it as the command's fault
     and reverted -- the safe call on the evidence then available, and still the right call, but the
     diagnosis was wrong. What separates the two is asking the model directly whether the state
     changed, which is four small tests and does not touch production code.

283. **The contract found the third member on its first run.** Writing the contract r261 skipped
     immediately failed with "one extraneous item: GroupItems" -- a member my hand-written fix had
     ALSO missed. Two misses of the same kind in two rounds, one caught by a machine on first
     execution. Every other comparison in this program had a contract and none of them has had this
     failure. That is the argument for the contracts, demonstrated on my own code rather than
     hypothetically.

284. **The probe reproduces the whole story.** Restoring r261's one-member strip fails
     `ASettledRefreshReportsANoOp` -- r261's symptom exactly -- AND the coverage contract, in the same
     run. The difference between the two rounds is not the code; it is that the second one has a test
     that names the cause.

## r263 -- the slicer/timeline pair, contract first

285. **SetSlicerSelection and SetTimelineRange fixed; outstanding 5 -> 3.** Both re-render every bound
     pivot from a snapshot per target, and both are reached twice by the most ordinary gesture there
     is: clicking a slicer tile back to the selection already in effect, or dragging a timeline handle
     back where it was.

286. **The coverage contract was written BEFORE the comparisons this time**, which is the order r262
     established at the cost of a round. It earned that immediately, twice over: its own
     "a short member list means the parse broke" assertion caught a bug in my parser -- the substring
     excluded the record's closing paren, so the LAST positional member never matched and two of the
     three snapshots silently checked only two members each.

287. **The r237 contract found a structural mistake, not a missing clause.** SetSlicerSelection has
     TWO mutually exclusive paths with disjoint undo records -- a slicer bound to pivots re-renders
     them; one bound to a structured table writes a value filter on a table column -- and I wrote a
     decision per path. That hid half the snapshot fields from the contract, which correctly reported
     `_tableSnapshot` unconsulted. Merging them into one decision that branches on which path ran is
     both what the contract asks and the more honest shape: the command has one no-op question, not
     two.

288. **The slicer's own selection clause is NOT independently demonstrable, and that is recorded
     rather than glossed.** The probe that removes it leaves every test passing, including one built
     specifically to isolate it -- selecting an item absent from the source data, which changes the
     stored selection while every rendered cell stays identical. It passes anyway because the slicer
     sync writes that selection into the pivot's own field model, where
     `PivotFieldLayoutStateSnapshot.Matches` catches it. The clause stays: it is part of what Revert
     restores, r237 requires it, and a slicer whose pivots cannot be resolved would depend on it. But
     it is redundant in every reachable case found, and claiming otherwise would be the kind of
     unearned confidence the probes exist to prevent.

289. **The timeline's clause IS load-bearing** -- the same probe fails
     `SetTimelineRange_ChangingTheRangeIsNotANoOp`, because a timeline stores its dates on itself and
     nowhere else.

## r264 -- the cannot-fire objection, narrowed rather than repeated

290. **ChangePivotTableSource fixed; outstanding 3 -> 2.** r231 held this command back for thirty
     rounds on a real observation: the snapshot's `OriginalCache` is the LIVE cache object whenever
     Apply mutates in place, so comparing its content against itself is always true -- the guard that
     "would never fire while looking exactly like the ones that do work".

291. **The objection was right about that member and wrong about the snapshot.** Every mutable field
     of the cache is captured BESIDE the object -- source type, sheet name, reference, table name,
     table id, and the field list -- and those carry the content half. The object itself is compared
     by IDENTITY, which is not vacuous: a source change that crosses the table/range boundary swaps in
     a replacement cache, and `ReferenceEquals` sees exactly that. A cannot-fire objection is about a
     particular comparison, not about the command, and the way past it is to find what else was
     captured rather than to accept it a second time.

292. **The identity exception is pinned by its own test**, because it is the kind that rots quietly:
     "improving" it to a content comparison would make the clause vacuous again and the guard would
     start reporting no-ops for real source changes. The contract asserts the `ReferenceEquals` is
     there, rather than trusting a comment to keep someone from removing it.

293. **The load-bearing test is a source change that renders identically.** Widening the range to
     include an empty column moves no pivot cell, so the cell comparison sees nothing -- but the
     pivot's SourceRange and the cache's SourceReference both changed, and both round-trip into the
     saved file. The probe that removes the snapshot half fails exactly that test and nothing else,
     which is the distinction r231 could not make from reading.

294. **Two commands remain: MoveRange (thirty snapshot fields) and ResizeStructuredTable.** Neither is
     blocked on a missing technique now -- both are blocked on size, which is a different and more
     honest kind of debt than the one this program started with.

## r265 -- ResizeStructuredTable; one command left

295. **ResizeStructuredTable fixed; outstanding 2 -> 1.** r232 grouped it with the cell-writing
     commands as needing "a comparison per cell". It needed that and six more: Revert restores the
     delegated totals refresh, the captured cells, four filter-state collections, and the table model
     itself.

296. **The table half needed a 27-member content comparison, which is why it waited.** Every
     structural edit goes through `CopyTable`, which builds a NEW instance, so reference equality
     there can never report unchanged -- the r231 cannot-fire shape again, in the largest model yet.
     `StructuredTableComparison` compares all twenty-seven members, with the column list stripped and
     compared per element and the filter columns going through r254's comparison.
     `R265_..CoverageContractTests` derives the field list from `CaptureCopyState`, whose own doc
     comment says it "captures every table field" -- the r249 pattern on the best possible source.

297. **Delegation is now safe to consult, and it was not before.** The command runs
     `RefreshStructuredTableTotalsCommand` and r231 warned that "delegation propagates both" a right
     and a wrong signal. That command has reported IsNoOp correctly since r245, so this decision
     carries its verdict rather than re-deriving it -- one question asked once. The debt entries paid
     off twice here: r231's warning said what to check, and r245's fix is what made the check pass.

298. **The count assertion caught a third parse bug in three rounds.** This one was CRLF: `Multiline`'s
     `$` matches before the `\n` and leaves the carriage return unmatched, so the field list came back
     EMPTY and the contract would have guarded nothing while passing. Every one of these contracts now
     carries a lower-bound assertion on its own field list, and that assertion has now failed more
     often than the contracts themselves.

299. **The blanket-sed mistake recurred, exactly as in r258.** One
     `return new CommandOutcome(true, AffectedCells: affectedCells);` pattern matched THREE commands in
     the same file, and this time it did not compile, which is luckier than r258 where it did. The
     habit that catches it either way is counting matches before applying, not reading the diff after.

## r266 -- the last command's missing machinery; outstanding stays 1

300. **Built the two comparisons MoveRange's decision needs and that nothing else had; no command
     came off the list.** MoveRange is the last entry on the no-op debt and it is there for size:
     twenty-four snapshot fields, which Revert restores through as many helpers. Most are maps of
     key-to-prior-value and compare directly. Two do not -- sparklines and a chart's verbatim formula
     snapshot -- and each is large enough to need its own coverage contract.

301. **Both hand-written comparisons were incomplete, and both were caught by the contracts.** The
     sparkline comparison as first drafted covered EIGHT of the model's twenty-nine members; the chart
     verbatim one covered THREE of six, missing all three error-bar fields. Neither would have failed
     a build or a test; both would have answered "unchanged" for a sparkline whose colours moved or a
     chart whose error-bar range was rewritten. This is the r262 failure twice more in one round, and
     the only reason it cost minutes instead of a round is that the contracts were written first.

302. **`SparklineModel` is a class a move mutates IN PLACE on the captured instance**, which is the
     worst case for reference comparison: the captured object and the current object are the SAME
     object, so identity reports "unchanged" for a sparkline that moved. Twenty-nine members, all
     scalars -- and a contract that fails if a collection member is ever added, because that would
     silently need stripping.

303. **Landing the proven half and naming what remains is the honest stopping point**, the same call
     r252 made for the AutoFilter block. The decision itself is twenty-four clauses over these two new
     comparisons plus the ones r234, r249, r250, r254 and r265 already built; assembling it in the
     same round that discovered two incomplete comparisons would be exactly the rush that produced
     r261's un-demonstrable guard.

## r267 -- MoveRange, and the debt list reaches ZERO

304. **MoveRange fixed; outstanding 1 -> 0. The known-broken list is empty.** Every one of the 233
     FreeX workbook commands now either declares whether it can no-op or is on the judged-sound list
     with a reason. The ceiling that started at 163 in r217 is at 0.

305. **The one reachable no-op was already handled by an early return that simply did not say so.**
     r225's own example -- "dragging something and dropping it where it started" -- hits an explicit
     `targetRange == _sourceRange` branch that captures empty snapshots and returns without writing
     anything. Marking it `IsNoOp: true` is a ONE-LINE fix, true by construction rather than by
     comparison, and I found it only after building a twenty-six-clause decision. Reading the
     command's control flow would have found it first. The lesson is not that the wide decision was
     wasted -- see below -- but that "what does this command do when nothing changes" is a question
     about control flow before it is a question about comparison.

306. **The wide decision is not redundant, and there is a test that proves it.** Moving an EMPTY
     range onto blank cells takes the FULL apply path -- snapshots, formula rewrites, the lot -- and
     still writes nothing observable. The early return never sees that case; only the comparison over
     all twenty-six snapshots reports it. The two probes fail on DISJOINT tests: unmarking the early
     return fails the three same-destination tests, blinding the wide decision fails the two
     real-move tests. Neither half can stand in for the other.

307. **The r237 contract made the same structural point for the fourth time.** Twenty-six snapshots
     split across four helpers meant the decision body named none of them, so the contract reported
     all twenty-six unconsulted. Passing every field from the decision keeps them visible; the
     parameter lists are long, and that is the price of the decision reading as a list of everything
     the command can write.

308. **What the whole program came to.** Fifty-one rounds, 163 commands off the debt, and the shape
     that did most of the work was not a technique but an order: capture what you write, decide
     afterwards by comparing that record against the model, and let a contract derived from the
     capture keep the comparison honest. The recurring failure was never a hard command -- it was a
     comparison that looked complete and was not, which is why every comparison in this program ends
     up with a contract that fails when a member is added.

## r268 -- first lens outside the command layer

309. **The no-op program is CONVERGED, so this round opens a new one.** With the known-broken list at
     zero, the useful question stopped being "which command is next" and became "which class, in which
     layer". The four FreeX app layers are 209k lines that the no-op program never touched.

310. **Chose the class by measuring, not by guessing.** Eight candidate classes counted across the app
     layers: culture-sensitive `Parse` and `DateTime.Parse` are at ZERO (an earlier sweep did that
     work), empty `catch {}` at one, `async void` at twelve, `.Wait()`/`GetAwaiter().GetResult()` at
     ten, and a `.Result` count of 159 that is mostly property accesses rather than task blocking.
     `async void` was picked because twelve is exhaustively reviewable and the class is the most
     punishing available: an exception in an `async void` continuation has no caller, Avalonia has no
     dispatcher-level boundary, and the process dies with the user's workbook in it.

311. **All twenty-three sites across the three apps are guarded. No bug found, and that is the
     finding.** Twelve in FreeX, three in FreeW, eight in FreeP; every one either wraps its awaits in
     a try or delegates to a method that does. The crash-hunt program did this work across twelve
     waves. What it did not do is leave anything behind to keep it done.

312. **The detector reported one false positive, and tracing the callee killed it.**
     `FreeW.PrintPreviewDialog.OnPrimaryActionClick` is an expression-bodied `await
     ExecutePrimaryActionAsync()` with no try of its own -- and the callee catches everything. Same
     lesson as r246 and r262: trace the delegate before calling it a finding. The contract encodes the
     delegation shape rather than flagging it, so the next reader does not repeat the check.

313. **The contract is a ratchet for a class that was fixed twelve times and never fenced.** It scans
     eleven UI layers across three apps, requires every `await` to sit inside a `try` (or the body to
     be a single delegation), and asserts a floor on the number of sites examined -- the same
     lower-bound guard that caught three parse bugs in r263-r266. Proved by both failure modes:
     removing a real guard reports "awaits with no try at all", and hoisting one await above the try
     reports "an await on body line 6 precedes the try on line 7", each naming the exact site.

314. **What carries over from the command work.** Not a comparison technique -- a habit: a class is
     not done when its instances are fixed, it is done when something fails if a new instance appears.
     Fifty-one rounds of no-op work produced exactly one durable artifact per defect, and it was
     always the contract, never the fix.

## r269 -- sync-over-async: an inventory, not a ban

315. **Nine blocking calls in the FreeX app layers; all nine safe, for THREE different reasons.**
     That is why this round produced an inventory rather than a rule. A blanket "never block on a
     task" contract would be a false one -- two of the nine are correct precisely because they block.

316. **The 159 `.Result` hits were noise and the survey said so before any of them was read.**
     Filtering for task-shaped receivers left ZERO: they are property accesses named Result. Counting
     first, reading second, kept a whole afternoon of false leads out of the round.

317. **Six of the nine are one deleted line away from hanging the application.**
     `MainWindow.ClipboardCommands.cs` blocks the WPF UI thread on `IPlatformClipboard` calls with
     `GetAwaiter().GetResult()`. `WpfPlatformClipboard`'s methods `await _dispatcher.InvokeAsync(...)`,
     which on the UI thread would post a continuation to the thread already blocked -- a hang with no
     exception, no log line, no crash dump. What saves them is one branch:
     `if (_dispatcher.CheckAccess()) return action();`. Nothing referenced that coupling from either
     end; now a test does, and it fails if the fast path moves after an await as well as if it is
     deleted.

318. **The PDF exporter's blocking call is unreachable, and finding that out was the point.**
     `PortablePdfDocumentExporter`'s path-taking overload blocks on `AtomicExportExecutor`, which
     awaits WITHOUT `ConfigureAwait(false)` in three places and has two bare `await using` disposals --
     so a UI-thread caller WOULD deadlock. It has no production caller: the Avalonia PDF router passes
     a Stream and binds to the other overload. Recorded as reachable-if-called rather than fixed,
     because fixing the executor's awaits without a caller to protect is a change no test would
     justify -- and the inventory entry says which change to make first if a caller appears.

319. **Sentry's two are correct because the process is dying.** Flushing crash telemetry at shutdown
     has no continuation to starve. Worth stating explicitly: it is the entry that stops someone
     "fixing" all nine to look consistent.

320. **Three failure modes, three probes.** A new blocking call in an unlisted file names the file; a
     changed count in a listed file reports "expected 2, found 1"; deleting the clipboard fast path
     fails with the sentence explaining what hangs. An inventory that cannot fail is a comment.

## r270 -- the third escape route; the async-supervision set is closed

321. **Fire-and-forget fenced; the set r268 opened is complete.** There are exactly three ways an
     async operation escapes supervision in a UI layer, and they fail differently enough that one
     rule could never have covered them: an unguarded `async void` KILLS the process (r268), a bad
     block HANGS it (r269), and an unobserved discarded task does neither -- it swallows the
     exception and the feature silently does not happen. Silent is not the mildest of the three from
     the user's side: a hang at least tells them something is wrong, where a dropped autosave does not.

322. **Twenty-one discard sites, all observed, by FOUR different mechanisms.** The callee guards its
     own body (FreeX's ad-hoc style); the discard routes through a guard helper whose whole job is
     observing (FreeW's `AvaloniaUiTaskGuard`, which every FreeW `RunUiTask` funnels into); a
     `Task.Run` lambda carries its own try; or a `ContinueWith` inspects `IsFaulted`. A contract
     recognising fewer than four would have reported working code as broken.

323. **The contract found three sites my own survey grep had missed -- and all three were its own
     false positives.** `_ = await X()` discards a VALUE from an AWAITED call: the exception
     propagates to the enclosing method, which is entirely safe. My first draft matched `await`
     deliberately and reported three working clipboard call sites as bugs. The lesson is the one this
     program keeps paying for in a new costume: when the detector and the code disagree, the detector
     is the better bet. r268 hit it as delegation, r262 as a missing member, this round as a matched
     keyword that should have been excluded.

324. **FreeW has a guard helper and FreeX does not.** Every FreeW discard routes through
     `AvaloniaUiTaskGuard`; every FreeX discard relies on its own callee happening to be guarded.
     Both are correct today. Recorded rather than "fixed", because adopting FreeW's helper across
     FreeX is a refactor with no defect behind it, and the contract makes the ad-hoc style safe
     either way.

325. **The guard-helper probe passed first, and that was the probe being wrong.** Removing one of the
     helper's two catches left the other, so the test correctly still passed. Removing both fails it.
     A probe that does not reproduce the failure it was written for proves nothing about the test --
     the same trap as r241's inconclusive build and r259's green probe.

## r271 -- throw-on-missing lookups, and where the data has no test

326. **Two classes examined; the interesting result came from crossing them.** Empty `catch {}` (11
     sites) turned out to be one generated file plus five identical WPF paginator pairs -- narrow,
     typed catches around `GetPageNumber` on a not-yet-paginated FlowDocument, each with a working
     fallback. Correct, undocumented, and not defects. `.First()`/`.Single()`/`.Last()` with no
     predicate (14 sites) are all safe: most are `group.First()` inside a `GroupBy`, and the rest have
     explicit emptiness guards -- `backups.Count == 0` returns, `stops.Length == 0` returns,
     `selectableSheetIds.Count > 0` gates.

327. **The 34 predicate forms share ONE shape: a lookup into a curated static plan by enum.** They
     throw when the plan loses an entry, so each is safe exactly as far as that plan is tested. That
     reframed the round: the question was never "is this call site defensive" but "does the DATA it
     assumes have a test".

328. **Cross-referencing found two plans with ZERO test references, both looked up with `.Single()`
     from live UI paths.** `FreeXBackstageHomePanePlan` -- the Avalonia backstage selects a row
     descriptor and a pin command per recent file, so a missing row throws while rendering the File
     menu's recent list. `DialogRangePickerRegistrations` -- resolved by target id, so a typo'd or
     removed id throws while BUILDING a dialog, with a stack trace pointing at LINQ rather than at
     the id. Neither is broken today; neither had anything keeping it that way.

329. **Two fences of deliberately different strength, and the difference is stated rather than
     blurred.** The backstage plan is public, so its test CALLS the planner and asserts each enum
     value resolves to exactly one entry -- behavioural, and true regardless of how the plan is
     written. The registrations are a private static of the Avalonia MainWindow with string literals
     at the call sites, so that one reads source. Weaker, and the strongest available.

330. **The lower-bound assertion caught a fourth parse bug.** The registrations use target-typed
     `new("range.x", ...)`; my regex expected `new DialogRangePickerRegistration(...)` and matched
     nothing, which would have made the contract pass while checking zero ids. Four rounds, four
     catches: r263 (missing closing paren), r265 (CRLF), r266 (twice, on member lists), r271 (target-typed
     new). Every contract in this program now carries one, and it has never once been wasted.

331. **The first backstage probe broke the build, which makes it inconclusive rather than passing.**
     Deleting the Pinned row left invalid syntax, so the test run used stale binaries -- r241's lesson.
     The compiling probe flips the row's Kind instead, and it fails THREE tests at once: Pinned
     resolves to zero and Recent to two, which is exactly the pair of conditions `.Single()` throws on.

## r272 -- auditing my own fences, and what the hole was hiding

332. **The event-leak class is clean, and that made auditing the better use of the round.** FreeX's
     app layers declare EIGHT public events, three on long-lived objects. Both that matter --
     `WorkbookSession.WorkbookChanged` and `WorkbookDocumentContext.CommandStackChanged` -- have
     balanced pairs, and both detach in `OnClosed`/`MainWindow_Closed` with a comment saying why the
     retention would otherwise persist. Fifth class in a row found already correct, which is the
     signal to stop asking the same question.

333. **My own contracts had a coverage hole, and it was the worst-placed one available.**
     r268/r270 scanned eleven UI-bearing projects; the repository has eighteen. The seven omitted
     include BOTH shared shells -- `Free.Shared.Shell.Avalonia` and `.Wpf` -- which all three apps run
     on, so a gap there was a gap in every app simultaneously. Also missed: `src/FreeX.App.UI` and
     four FreeP projects. A fence is only as good as its perimeter, and I never checked mine against
     the repository.

334. **Widening it found a loaded gun with the safety on, in the save-changes prompt.**
     `SisterAvaloniaFileCommandWorkflow.PromptSaveChangesSync` blocks on an Avalonia MODAL dialog's
     `ShowAsync` with `GetAwaiter().GetResult()`. A modal dialog needs the UI thread to pump before it
     can be answered, so calling this on that thread deadlocks with CERTAINTY -- not by luck of
     scheduling, the way the r269 clipboard case would have. It is reachable only through the public
     sync `ConfirmCloseAllowed` overload, and no app calls it: every Avalonia caller uses
     `ConfirmCloseAllowedAsync`.

335. **The codebase already knew, and fenced the wrong half.** Two sibling tests assert the MainWindow
     files never name `PromptSaveChangesSync`, and FreeP's asserts the file-lifecycle chain contains
     no `GetAwaiter().GetResult()` "because these types are driven from the UI". So the hazard was
     understood and the windows were fenced -- while the shared shell that still offers the method
     was not. Recorded rather than deleted: removing a public member of shared code that three apps
     link is not a change to make from inside a review of a different defect class.

336. **Third false positive from my own detector, third time the code was right.** The shared
     window-close coordinator opens with `await Task.Yield()` -- deliberately, to leave the
     synchronous Closing callback before doing anything -- and my "every await inside a try" rule
     flagged it. `Task.Yield()`'s awaiter cannot fault, so the rule was over-strict and now says so
     explicitly. r268 was delegation, r270 was `_ = await`, r272 is this. Every one would have been a
     false bug report if the contract had been written and trusted rather than written and run.

## r273 -- a different region, and the same kind of hole

337. **Changed region rather than class, because six classes into the UI layers five had come back
     clean.** Localization key integrity spans all three apps, is mechanically checkable, and fails in
     the one place a user is guaranteed to look: `LocalizedTextCatalog.Get` returns
     `CreateMissingText(key)` for an unknown key, so a typo renders `[[Some_Key]]` where a label
     belongs. No exception, no log, nothing red.

338. **Cross-referenced 3,037 distinct referenced keys against 7,006 defined ones. Zero missing in
     FreeX; two apparent misses in each sibling, both false.** `Shared_Catalog_Missing_Key` is
     deliberately absent -- it exists to assert the `[[key]]` sentinel -- and `FormatCells_InvalidColor`
     appears only inside doc comments describing the historical bug that prompted these tests. Reading
     the two before reporting them is the difference between a finding and a false alarm, for the
     fourth round running.

339. **The class is already fenced -- and finding that out is what exposed the gap.** FreeW and FreeP
     each fence BOTH shells; FreeX fences its Avalonia shell in `LocalizationKeyIntegrityTests` and its
     WPF host in `LocalizationUsageTests`, whose line 84 does exactly this cross-reference. So the
     question stopped being "is this class clean" and became "what do those tests actually walk".

340. **`src/FreeX.App.UI` has twenty localization keys and neither test scanned it.** The Host test
     walks `FreeX.App.Host`, the Avalonia test walks `FreeX.App.Avalonia`, and a third UI project fell
     between them. All twenty resolve today; nothing checked that they still would. Closed with a
     test built on the same shared support helper, so it behaves identically to its five siblings, and
     proved by renaming one key -- it names both the key and the file.

341. **Second perimeter gap in two rounds, found the same way both times.** r272's was two shared
     shells missing from my own contracts; this one is a UI project missing from tests written long
     before. Neither was found by reading code. Both came from asking what a check covers and
     comparing that against the repository -- which is now the first question this program asks about
     any fence, its own included.

## r274 -- the last question the perimeter method had left to ask

342. **Two rounds of perimeter gaps found by asking what a check walks, so this round asked the
     question at repository scale.** Audited all 114 source-scanning tests for the paths they
     enumerate and compared that set against the 60 production projects. Ten projects were never
     named by any scan; excluding non-production directories left five shared ones.

343. **`Free.Shared.TextSearch` was the only production project in the repository with no test
     referencing it at all** -- not merely unscanned, but unreferenced by any test project, which is
     a stronger and more checkable condition than "under-covered". It is 62 lines and not incidental:
     `FreeW.App.Presentation`'s Find/Replace dialog planner and its navigation pane both search
     through it.

344. **Read it in full before writing anything, and it is correct for its documented policy.** The
     finding is the absence of tests, not a defect -- worth saying plainly rather than manufacturing
     a bug to justify the round. Non-overlapping advance, empty-needle guard, whole-word skip
     advancing by ONE rather than by the needle length, and the `ArgumentOutOfRangeException` span
     guard are all right.

345. **Eleven tests pin every behaviour a caller already depends on, and two document policy at the
     edges rather than endorsing it.** Word characters are decided per `char`, so a surrogate half
     and a combining mark both read as non-word -- a match beside an astral letter or an accent
     counts as whole-word. That may or may not be what a user wants; what matters is that it is now
     written down and cannot change silently.

346. **Proved by two real regressions, each caught by exactly the test written for it.** Advancing by
     one instead of the needle length failed the overlap test; dropping `_` from the word-character
     policy failed that theory row. A test that cannot fail documents nothing, which is the same
     standard the eighteen preceding rounds were held to.

347. **The perimeter method is now exhausted at this level.** r272 found gaps in my own contracts,
     r273 in tests written long before, r274 in the project list itself. Each asked the same question
     one level further out; there is no further out left -- the next unscanned thing would have to be
     a project that does not exist yet, which is what the lower-bound and coverage contracts across
     this program exist to catch.

## r275 -- a new class, and a demonstrated flaw in how this program measures

348. **The hook was right that exhausting a method is not exhausting the issues, so this round changed
     class rather than perimeter.** Culture-sensitive number handling in the file-format layers had
     never been surveyed by this program, and it fails in the one way a green suite here cannot see:
     every test in the repository runs under en-US.

349. **The class has been fixed seven times and fenced zero times.** r98, r108, r110, r111, r145,
     r151 and r152 each found one culture bug and closed it. No contract and no analyzer followed --
     CA1305 is not enabled anywhere in the build -- so nothing stood between the writers and the
     eighth occurrence except that nobody had yet written the wrong line.

350. **Measured before asserting: the layers are clean.** A multi-line-aware scan of every
     floating-point parse across the five format layers found zero provider-less calls. Integer
     parses were excluded deliberately rather than counted as passes: `NumberStyles.Integer` forbids
     group separators, so a digit string parses identically everywhere, and including them would have
     buried the signal.

351. **The round-trip probe is blind to the failure that matters, and this round proved it rather
     than asserting it.** Injecting a symmetric regression -- writer and reader both switched to the
     current culture -- failed the payload assertion for THREE formats and the round-trip assertion
     for ONE. CSV and delimited round-tripped their comma decimals perfectly while handing Excel a
     file it reads as a different number. A save/load test cannot see a wire-format bug, because both
     halves are wrong in the same direction.

352. **That is the same blind spot the format-fidelity harness was already known to have, now
     demonstrated with a number instead of argued.** The remedy is to assert on the saved payload,
     which is what the nine `SavedPayloadUsesTheInvariantDecimalPoint` cases do.

353. **One real inconsistency, correctly NOT reported as a bug.** `DocxWriter.cs:5018` passes
     `cg.Width` to `XAttribute`, which formats via `XmlConvert` and is invariant; line 5061 called
     `.ToString()` on the same value, which is not. The type is `long` and the values are geometry
     extents that are never negative, so no culture in .NET formats them differently -- it is a
     latent wart, not a defect, and saying so plainly beats dressing it up. Made explicitly invariant
     in the file's own fully-qualified idiom.

354. **A stale-binary near-miss, caught by checking the build.** Four failures appeared after a
     compile error left `--no-build` running the probe's own assembly. The r241 trap, and the reason
     a failed build must never be chained into a test run.

## r276 -- untrusted-input hardening, and a class fixed once before

355. **Changed class again, to the one surface this program had never treated as a security
     boundary.** All three apps open zip-container documents from wherever the user got them, so
     archive and XML handling is attacker-controlled input by definition.

356. **Zip-slip has no surface here, and that is a real result rather than a null one.** There is no
     `ExtractToDirectory`, no `ExtractToFile`, and no `Path.Combine` over an archive entry name
     anywhere in the three apps -- the OPC readers work entirely in memory, so a malicious entry path
     has nothing to escape into.

357. **XXE is handled deliberately, not accidentally.** `Free.Shared.Opc.SecureXmlReaderSettings`
     sets `DtdProcessing.Prohibit`, `XmlResolver = null` and a 64 MB character cap together, and most
     of `FreeX.Core.IO` already routes through it. No site anywhere sets `DtdProcessing.Parse`.

358. **The gap was the third protection, not the first two.** Thirteen readers hand-rolled their own
     `XmlReaderSettings` with `DtdProcessing.Prohibit` and no character cap. Twelve open a
     `ZipArchiveEntry` straight from the workbook being opened.

359. **The premise was verified before the fix, because streaming looks like a defence and is not.**
     Eleven of the twelve are pull-readers rather than DOM loads, which bounds accumulation but not a
     single colossal text node or attribute -- a pull-reader still materialises one of those as one
     string. `XlsxPivotCacheReader` already documents why the size cannot be bounded upstream:
     `WorkbookOpenSizeGuard` validates only the zip central directory's DECLARED lengths, which an
     attacker controls outright, and never checks what the DeflateStream actually yields.

360. **So this class was already found, fixed once, and never fenced -- r275's shape exactly.** The
     pivot-cache path was hardened against precisely this zip bomb in an earlier round while thirteen
     siblings kept the unbounded form. Two consecutive rounds have now found the same failure mode:
     the bug gets fixed, the class does not get closed.

361. **Two sites deliberately left alone, and said so rather than swept in.** `FILTERXML`
     (`BuiltInFunctions.TextAdvanced.cs`) parses in-memory cell text in a different layer, and
     `XlsxWorkbookThemeWriter` loads an already-materialised string -- neither carries decompression
     amplification. The theme writer was still capped for uniformity with the layer's policy; the
     formula one was not, and the contract scopes to the package layer to match.

362. **The behavioural test proves the mechanism, the contract proves the coverage, and the doc
     comment says which is which.** A 64 MB production cap cannot be exercised against a real reader
     without a 64 MB fixture, so claiming the behavioural test covers all thirteen call sites would
     have been false. Proved by removing one cap: the contract names the file, the line, and which
     protection is missing.

## r277 -- attacking the meta-pattern instead of guessing another class

363. **Two consecutive rounds found a class fixed once and never fenced, so this round went after
     that pattern rather than picking another region at random.** The pattern is enumerable: the
     repository records every past fix. 1,878 round-numbered test files exist against 27 contract
     tests, so the overwhelming majority of past fixes pinned one bug without closing its class.

364. **r169's fence guards the callers, not the hazard -- and that is a distinct failure mode from
     "no fence at all".** `DataFolderLabelParityTests` asserts four hardcoded shell files call
     `ResolveDataFolderLabel(_optionsStore.StorePath)` and never the parameterless overload. It is a
     real contract and it works, for exactly those four paths. A fifth caller anywhere else -- FreeX,
     another dialog, a new shell -- still got the wrong folder, and no test in the repository could
     see it.

365. **The hazard was still live, on a public method of a shared type used by all three apps.**
     `ApplicationFrameDescriptor.ResolveDataFolderLabel()` defaulted to
     `PlatformApplicationDataPathProvider.LocalInstance` and returned `%LOCALAPPDATA%\{Product}`,
     while every app stores its options under `%APPDATA%`. The store-path overload carried the same
     wrong default on its fallback branch.

366. **r169 had already written down the correct policy and applied it one branch too narrowly.**
     `AppStoragePathPlanner`'s own follow-up comment says every sister app resolves through
     `Instance` and the honest placeholder is `%APPDATA%`. That reasoning corrected the exception
     branch and left the convenience defaults pointing at the local root, so the success branch --
     the one that actually returns a directory -- kept reporting the wrong one.

367. **Memory of this item was partly wrong, and checking beat trusting it.** The note recorded "two
     now-dead overloads awaiting removal". Only the parameterless one is dead; the string overload is
     live and called by all six production sites. Deleting both, as the note implied, would have
     broken every shell.

368. **Fixed at the hazard rather than the call list, and proved by reverting.** Both defaults now
     name `Instance`. All three new tests fail on the old code and pass on the new, so this is a
     behaviour change and not a documentation exercise. One of them guards itself: if the two roots
     ever coincide on the host, it says so instead of passing vacuously.

## r278 -- following r277's new failure mode to its source

369. **r277 surfaced a distinct failure mode -- a fence that guards the callers instead of the
     hazard -- so this round enumerated that shape rather than picking a new region.** Source
     contracts that ban a string in a fixed file list are mostly legitimate (dedup and ownership
     rules are meant to be file-scoped). The dangerous subset is narrow: a ban on OUR OWN API,
     written because that API is wrong.

370. **Two candidates from that subset were checked and cleared, which is what kept the third
     credible.** The `AllCells()` ban in `WorkbookSelectionStatsCalculatorTests` pins the
     implementation strategy of one hot path and is properly file-scoped. `DataValidationPresetPlanner`
     walks a selected range but caps it first with `CellCount > maxCellsToScan` -- the dense-scan
     audit did its job, and re-walking its 86 call sites would have repeated a finished round.

371. **The third was r277's own twin, and it was worse than r277.**
     `AppStoragePathPlanner.GetOptionsFilePathLabelOrFallback` names `OptionsFileName`, the constant
     `"options.json"` -- FreeX's file. FreeW stores `settings.json`, so the method reported a path
     that has never existed on any FreeW install.

372. **Three separate contracts in three apps banned it, and it had zero production callers.** FreeW
     had `DiagnosticsOptionsPathParityTests`, FreeP had its ownership tests, FreeX never called it.
     Three fences maintained around a method nobody used, none of which could stop a fourth app from
     picking it up. Deleted -- the compiler now enforces what three tests were asserting, and all
     three solutions build unchanged.

373. **Deleting it did not close the class, and stopping there would have missed the point.**
     `GetOptionsFilePath` is still public, still FreeX-shaped, and had no fence at all -- the same
     hazard one level down, which is exactly how r277's overload survived r169. Replaced the three
     per-app bans with one rule at the boundary: no FreeW or FreeP source may reach for this
     planner's options-FILE APIs. Its directory APIs are deliberately excluded, since
     `ProductDirectoryName` is ambient per app and banning those would forbid correct code.

374. **The contract carries its own premise as a test.** If `OptionsFileName` ever becomes ambient
     per app, the ban is forbidding correct code -- so a second test asserts the constant is still
     fixed and says to delete the contract rather than work around it, instead of letting a rule
     outlive its reason the way r169's did.

## r279 -- the same leak as r278, one layer up, and visible to users

375. **r278 found a shared API carrying FreeX-specific semantics, so this round asked how many others
     the shared tier has.** Most hits are legitimate per-app catalogs -- `BrandThemes` and
     `ProductThemeResourceProfiles` define all three apps by design. The leak is the opposite shape:
     a shared component that hardcodes ONE app's identity and is used by all three.

376. **The shared WPF ribbon renderer resolves its themed brushes under FreeX's key prefix.** Themed
     brushes are generated per app by `WpfThemeApplier.BuildResources(theme, keyPrefix)`, so FreeX's
     surface is `FreeXRibbonSurfaceBrush` and FreeP's is `FreePRibbonSurfaceBrush` -- a prefix FreeP's
     own startup test pins. All three WPF hosts render through this renderer; it asked for the FreeX
     key by name.

377. **Traced end to end before calling it a bug, because the alternative was a plausible-looking
     false positive.** FreeW's ribbon dictionary declares no brushes at all and FreeP passes no
     dictionary, so in both sister hosts every lookup missed and painted the hardcoded fallback --
     `Brushes.White`, `Brushes.Gray`, `#DADCE0` -- regardless of the active theme. Both apps ship a
     Midnight theme, where that is a white ribbon body under dark chrome.

378. **Nothing caught it because the fallbacks are exactly right for one app.** FreeX defines these
     keys as `#FFFFFF` and `#DADCE0` -- the same values as the hardcoded fallbacks -- so under the
     default light theme the sister apps render identically whether the lookup resolves or not. The
     defect only appears in a non-FreeX app under a non-default theme, which is the intersection no
     existing test covers.

379. **The renderer already had the right abstraction available and bypassed it.**
     `ProductThemeResourceProfile` carries a per-app `KeyPrefix`, and `RibbonWpfPopupAdapter` was
     already reaching for a theme-neutral key first -- but its fallback was still the FreeX one, and
     the neutral key is defined by no app, so it fell through too.

380. **Fixed additively so the app the keys were named for cannot regress.** `RibbonThemeBrushes`
     resolves the running app's prefix first, then the FreeX key, then the hardcoded brush; a test
     pins that second step so the previous behaviour stays reachable. Five call sites across three
     files now route through it.

381. **Three host-lane failures were proved pre-existing rather than assumed so.** The lane has known
     drift, but that is not evidence. Neutralising this round's change to its exact previous
     behaviour and re-running left all three failing identically -- two QAT options-dialog broadcast
     tests and a MainWindow source-hygiene contract, none of which touch ribbon brushes.

382. **A stale-binary reading nearly went the other way, for the second time in three rounds.** The
     first run of the ribbon lane showed three failures because its last build had been the revert
     probe, and the FreeW/FreeP solution builds do not include that test project. Rebuilding gave
     55/55. `--no-build` reports whatever was compiled last, not what is on disk.

## r280 -- finishing the class r279 opened

383. **r279 fixed one instance of "a shared component names one app"; this round finished the class
     rather than moving on.** Two candidates remained from the same survey.

384. **The Avalonia ribbon renderer is clean, and that is a result worth recording.** It carries no
     FreeX-keyed resource lookups at all, so the WPF leak had no twin there -- a negative that was
     checked rather than assumed from the WPF finding.

385. **The shared PDF writer's default header comment read "FreeX portable PDF".** FreeX and FreeW
     each pass their own name on their direct export paths, which is exactly why nobody noticed:
     both apps looked correct.

386. **FreeP took the FreeX name on every vector export, and FreeW took it whenever Skia was
     unavailable.** `SkiaPdfWriter.WriteToBytesWithPortableFallback` called the portable writer with
     no header, so it silently DROPPED the caller's choice and fell back to the shared default --
     including on the one path where FreeW had bothered to pass "FreeW portable PDF".

387. **Fixed at both levels, because fixing either alone leaves the bug.** The shared default is now
     product-neutral, so the shared tier no longer guesses on any app's behalf; and the fallback
     threads the caller's header through instead of discarding it. FreeP now names itself through one
     constant used by both its shells.

388. **A third stale-binary reading, and the pattern is now clear enough to state.** The shared lane
     reported one failure because its last build was the revert probe; rebuilding gave 435/435. Every
     instance this session has the same cause: a probe build, then a verification run whose solution
     does not contain that test project. `--no-build` after a probe needs an explicit rebuild of the
     project under test, not of a solution that merely looks related.

## r281 -- finishing the survey, then a class that came back clean

389. **Completed the shared-tier assumption survey r279 opened instead of declaring it done after the
     name check.** Two more dimensions, both clean: the only app-specific file extensions in shared
     code are doc-comment examples and `AutosaveSnapshotStore`'s `.fxl`, which its own comment
     already calls "shared cosmetic, not a format promise"; and the one spreadsheet limit
     (`SurrogateSafeTruncation.SpreadsheetCellTextLimit`) is honestly named and consumed only by
     FreeX. So the survey ends three-for-three checked, with two leaks found and fixed.

390. **New class: resource lifetime -- and the dangerous subset does not exist here.** Every
     unscoped disposable in the format layers is a `MemoryStream`, which holds no OS handle. There is
     no undisposed `FileStream` or file-backed archive anywhere in production code, so the
     locked-file failure this class usually produces has no source.

391. **The real risk in the class is not a leak at all, and it is handled.** A `ZipArchive` opened
     for `Create` or `Update` writes its central directory on DISPOSE: skip it and the output is not
     a leaked handle, it is an invalid package. 74 such archives exist across the three apps; 70 use
     the `using` form and the other four were each read in full and are deliberate -- they need the
     archive disposed EARLY, before its backing stream is read back, so `using` cannot scope them,
     and each pairs that with a `finally` or an `IDisposable` owner.

392. **Fenced anyway, because the four hand-written pairings are exactly what a later edit breaks
     silently.** The output still looks like a package; the failure surfaces as a corrupt file at the
     user rather than an exception in the suite. Proved by deleting both disposals from the stripper:
     the contract names the file, the line, and the variable.

393. **A fourth detector false positive, and the code was right again.** The first draft reported
     the sanitizer, whose archive is disposed by `using (archive)` on a later line -- a form the
     detector did not know. Same shape as r268's delegation, r270's `_ = await` and r272's
     `Task.Yield`: when a scan indicts long-standing code, the scan is the likelier suspect.

## r282 -- a fence of mine that tested the shape and not the substance

394. **New class: exceptions swallowed silently.** 207 catch blocks across the three apps have no
     executable body; 169 carry a comment explaining why, which makes them deliberate. The 38 bare
     ones were the candidates, and most are legitimate best-effort teardown.

395. **Four of them were UI task funnels, and r270's contract could not see them.**
     `TheGuardHelpersStillCatch` asserted that a guard has a `catch`. Three copies in
     `ReferencesDialogs` and a fourth in `StyleDialog` had one -- binding `ex` into an EMPTY body. So
     a failing OK button, or Add/Edit/Copy source, did nothing at all: no message, no log, no crash.
     `MainWindow`'s equivalent funnel reports to the status bar, which is what the others should have
     been doing.

396. **This is r277's failure mode found in my own fence, one round after naming it.** A contract
     that checks a catch EXISTS tests the shape; what matters is whether anything is done with what
     it caught. Strengthened to require the bound exception be used, and that immediately found the
     fourth funnel, in `StyleDialog`, which the hand survey had missed.

397. **A fifth detector false positive, code right again.** The strengthened check first indicted
     `AvaloniaUiTaskGuard` itself: a lookahead meant to skip the `when (ex is not ...)` filter also
     excluded `onFailure?.Invoke(ex)`. The filter sits on the catch line, which the scan already
     starts after, so the lookahead was never needed. Same lesson as r268, r270, r272 and r281.

398. **The lower-bound assertion earned its keep in the same round it was written for.**
     Consolidating four funnels removed four discards, the population fell 16 to 12, and the floor
     tripped instead of letting the scan quietly shrink. Lowered to 8, keeping the previous headroom,
     with the reason recorded rather than the number silently adjusted.

399. **Stated plainly rather than overclaimed: this is not yet a user-visible fix.** The four dialogs
     now route through the shared `AvaloniaUiTaskGuard`, so there is ONE place to attach reporting
     instead of four -- but FreeW's Avalonia dialogs have no error surface and no logging sink, so
     with no `onFailure` supplied the failure is still silent. Building that surface is a real change
     to a UI layer this environment cannot exercise, so it is left open and named here rather than
     invented and shipped unverified. Five direct `AvaloniaUiTaskGuard` call sites pass no reporter
     for the same reason.

## r283 -- closing the residual r282 left open

400. **r282 named an unfixed gap rather than papering over it, so this round closed it instead of
     opening a new class.** The four consolidated dialog funnels reported nowhere: with no
     `onFailure` the shared guard caught the exception and dropped it, so a failing OK button still
     did nothing visible. Naming it was right; leaving it there would not have been.

401. **The error surface did not need inventing -- the shell already had one.** `MainWindow` reports
     its own guarded failures to the status line. `AvaloniaUiTaskGuard` now falls back to an app-wide
     reporter when a caller supplies none, and the window installs its existing status-line writer
     into it, so a failure raised in a dialog is worded exactly like one raised in the shell.

402. **Five tests pin the behaviour AND its boundaries, because a reporter that fires too often is
     its own defect.** An explicit reporter still wins and the fallback does not also fire (no double
     message); cancellation never reaches it (dismissing a picker is not an error); a throwing
     reporter does not escape the dispatcher boundary; and no reporter installed stays harmless, which
     is what keeps headless construction and the test lane working.

403. **Proved by reverting the one-line fallback: exactly one test failed, and it was the right
     one.** The other four passed on the reverted build, which is the check that they are pinning the
     boundaries rather than quietly depending on the fix.

404. **Installed where the status control is constructed, not at startup.** The reporter needs the
     built control; setting it earlier would have captured a null and traded a silent failure for a
     NullReferenceException inside the failure path -- the worst possible place for one.

## r284 -- finishing r282's triage, and correcting r282's numbers

405. **CORRECTION to finding 394: the counts it reports are wrong.** r282 said "207 catch blocks
     ... 169 carry a comment ... 38 bare". The script behind those figures used a conditional `my`
     in Perl, which retains its previous value across iterations, so the classification leaked
     between sites. Recounted with a method that cannot drift -- walk from the opening brace to the
     first line that is neither blank nor comment -- the real figures are **196 empty-bodied
     catches: 167 commented, 29 bare**.

406. **The r282 fixes stand, because they were read by hand rather than trusted from the count.**
     The four dialog funnels were each opened and confirmed empty before being changed, and the
     strengthened r270 contract found the fourth independently of the scan. A wrong census did not
     produce a wrong fix -- but it did produce a wrong log entry, which is what this corrects.

407. **All 29 remaining bare catches triaged, and none is a defect.** The clusters are FreeP media
     and recording teardown (process, device and session shutdown), culture probing, and dialog
     chrome. Every one is a narrow exception type with an obvious fallback.

408. **The five in FreeX's computation layers were read line by line, because there a swallow
     changes a number.** Three `OverflowException` catches in rounding fall through from a decimal
     precision correction to the double path; a calendar that will not accept Gregorian keeps its
     own; an unavailable region contributes no currency label. All correct, and now all commented,
     which moves them from "silent" to "explained".

409. **Fenced where a swallow costs a result, not everywhere.** The contract requires a comment on
     empty catches in the formula, IO, model, command and app-service layers only. The UI layers are
     full of legitimate best-effort teardown where demanding a comment on each would be noise, and
     r270/r282/r283 already fence the part of the UI that matters. Proved by deleting one comment:
     it names the file and line.

## r285 -- a class that promises something the signature cannot keep

410. **New class: a cancellation token accepted and then ignored.** It is worse than never offering
     one. The signature promises the work can be cancelled, a caller wires Cancel to it, and the
     button does nothing -- which the user experiences as a hang, not as a failure.

411. **All 65 token-taking methods observe their token; the class is clean.** The three the scan
     first flagged have no body to observe it with -- a positional record property and two interface
     declarations -- so they were never candidates.

412. **The sharper variant came back clean too, and it took reading the code to know that.**
     Exactly one method passes `CancellationToken.None` while holding a real token:
     `WorkbookProgressStageRunner` uses it on the continuation that observes an ABANDONED task's
     fault. That continuation must run precisely because cancellation already fired -- passing the
     cancelled token would suppress it and reintroduce the unobserved exception it exists to
     prevent. Sixth detector false positive of the program, and the code was right every time.

413. **Fenced rather than fixed, which is the honest description of this round.** The contract
     requires that a method accepting a token references it, with two exclusions that are real
     rather than convenient: a bodiless declaration has nothing to observe the token WITH, and a
     positional record parameter is a property. Including either would report well-formed code,
     which is exactly how the five earlier detectors went wrong.

414. **Proved against a realistic regression, not a token deletion.** Dropping the token from
     `Task.Run`, the `CanBeCanceled` guard, the registration and the throw -- the shape a refactor
     produces when it "simplifies" a cancellation path -- makes the contract name the file, line and
     parameter.

## r286 -- a real defect, found by a theory that first looked wrong

415. **New class: `StartsWith(string)` without a `StringComparison` compares with the CURRENT
     CULTURE.** In a parser that is unsound, because the slicing that follows a match is ordinal.
     ICU skips ignorable characters -- zero-width joiner, ZWNJ, soft hyphen -- and ordinal indexing
     does not, so the operator is read from one interpretation of the string and its operand from
     another.

416. **The codebase had already fixed this class everywhere else and left seven behind.** Zero
     culture-sensitive `IndexOf`, zero `EndsWith` -- and six `StartsWith` calls splitting
     SUMIF/COUNTIF criteria operators plus one in FreeW's wildcard search. The same file's line 150
     already used `StringComparison.OrdinalIgnoreCase`, so the convention was known and the operator
     splitter simply missed it.

417. **The first behavioural tests PASSED against the unfixed code, and the honest response was to
     doubt the test rather than the theory.** They summed numeric labels, where a garbage operand
     matches nothing -- and "matches nothing" was also the correct answer for that data, so the two
     readings agreed by luck. `SUMIF` returned 0 either way.

418. **A direct assertion on the platform settled it: `"<ZWJ>>=5".StartsWith(">=")` is TRUE
     culture-sensitively and FALSE ordinally.** The defect was real; the test was blind. Rewritten so
     a cell holds the criteria text itself, making the correct answer 20 and the buggy answer 0 --
     four tests then failed on the unfixed code and pass on the fixed one.

419. **This is the mirror of the program's recurring lesson.** Six times a detector indicted correct
     code and the scan was the suspect. Here a test exonerated broken code, and the test was the
     suspect. "Verify the premise" cuts both ways: a passing test is evidence only if it could have
     failed.

420. **`Contains` deliberately excluded from the fence.** Unlike its siblings it is ordinal by
     default, so requiring a comparison on its 458 call sites would be noise -- the same
     distinction-drawing that kept r278's directory APIs out of that contract.

## r287 -- generalising r286, and a hazard that turns out to be structurally blocked

421. **r286's defect shape generalises to "match with one semantics, index with another", so the
     round surveyed the whole family. It is clean.** Zero culture-aware `IndexOf`; zero
     `IndexOf`-plus-`Length` arithmetic anywhere; no sorted structure keyed by a string with a
     comparer that disagrees with how it is searched. The one culture-aware `CompareInfo` use is
     FreeW's index ORDERING, where culture-awareness is correct -- and it is tie-broken with
     `StringComparer.Ordinal` so the sort stays deterministic.

422. **Floating-point keys checked and cleared on the platform's actual behaviour, not folklore.**
     The `Dictionary<double,>` and `HashSet<double>` uses are frequency counts and date serials, and
     .NET normalises both `NaN` and negative zero when hashing, so the "-0.0 and NaN are unfindable"
     failure does not apply.

423. **FreeW compiles the user's Find pattern into a Regex with NO match timeout.** That is only
     survivable because wildcard syntax cannot express a catastrophically backtracking expression:
     everything outside a bracket class goes through `Regex.Escape`, and the syntax has no grouping
     construct, so the `(a+)+` shape has no way to be written.

424. **Measured before believing it, and the measurement contradicted the theory.** The round began
     from "ten consecutive `*` should blow up". It does not -- 400 characters of non-matching text
     with ten stars completes in single-digit milliseconds, because `*` becomes a lazy `.*?` and the
     engine optimises the sequence. The ReDoS risk is real in principle and absent in fact.

425. **So the deliverable is the PROPERTY, not a fix.** Four tests pin that regex syntax typed into
     Find arrives escaped, that the translated pattern is still valid, that wildcards still match,
     and that the ten-star case stays fast. The risk they guard is a future "richer wildcards" change
     that passes more syntax through and silently removes the reason the missing timeout is safe.

426. **The first draft of that property test was itself the bug.** Expressing "an unescaped bracket"
     as a regex needs its own escaping, and getting it wrong produced `RegexParseException` rather
     than a finding. Rewritten as a plain character scan -- no pattern, nothing to escape. Proved by
     loosening the converter to pass parentheses through: the test names the offending translated
     pattern.

## r288 -- three classes surveyed, three clean, and no contract invented for them

427. **Unsigned underflow in grid arithmetic: clean.** `CellAddress` is `(SheetId, uint Row, uint
     Col)` and 1-based, so `row - 1` at row 1 yields 0 -- outside the valid range -- and the type
     performs NO validation, so an invalid address would be silent rather than throwing. Of 122
     decrements, the ones that flow directly into a `new CellAddress` all guard inline with
     `Row > 1 ? Row - 1 : 1u`.

428. **The one that looked unguarded was the seventh false positive of this program.**
     `CopyFromAbovePlanner.GetSourceCell` decrements with no inline check -- because its caller
     returns null first when `Row <= 1`. The guard is one level up, and the boundary already has its
     own test, `CreateEdit_DoesNothingOnFirstRow`.

429. **No contract added, deliberately.** A source scan for "unguarded decrement" would have to
     understand a guard placed in the caller, which is precisely the shape that just fooled a
     line-level grep. After seven false positives from scans in this program, adding an eighth
     brittle one would cost more than the invariant it protects -- and the invariant is already
     covered behaviourally where it is reachable.

430. **Local-vs-UTC time in persisted data: clean.** Zero `DateTime.Now` anywhere in
     `FreeX.Core.IO`, `Free.Shared.IO`, `Free.Shared.Opc`, `FreeW.Core.IO` or `FreeP.Core.IO`. The 29
     `DateTime.Now` uses in production are in UI and in the formula functions where local time is the
     correct answer.

431. **OOXML document timestamps: correct on every axis, checked rather than assumed.**
     `saveTimestamp ?? DateTimeOffset.UtcNow`, formatted by `ToW3CDtf` as
     `ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ", InvariantCulture)`, and read back with
     `AssumeUniversal | AdjustToUniversal` so the round trip cannot drift with the reader's zone.

432. **Recording a clean survey is the point of this log, not padding it.** Finding 356 did the same
     for zip-slip. The value is that the next pass does not re-derive these three, and that the
     method is written down alongside the verdict.

## r289 -- fencing a decision the codebase had already made everywhere

433. **New class: writable static collections shared across threads.** FreeX recalculates and saves
     off the UI thread, and a `Dictionary` written concurrently does not merely throw -- it can
     corrupt its bucket chain and spin forever. That presents as a frozen application with no
     exception and no stack, which is the worst diagnostic shape a defect can have.

434. **Every one of them is already `[ThreadStatic]`, and one carries the reasoning.** The formula
     engine's named-formula recursion guard, both Avalonia ribbon icon caches, the grid's two
     text-measurement caches, and FreeW's render diagnostics -- with
     `AvaloniaRibbonIcons` stating "no need for a lock because the dictionaries are never shared".
     The remaining ~190 static collections are `readonly` lookup tables, initialised once and only
     read.

435. **Worth fencing precisely because it is clean.** The decision is invisible in the code that
     benefits from it: a new cache added without the attribute looks exactly like the correct ones
     and fails only under concurrency, on someone else's machine, without a stack trace.

436. **The eighth detector false positive, and the code was right for the eighth time.** The first
     draft reported `ShrinkToFitFontSizeCache` and `CommandIconMonochromeCache` -- expression-bodied
     PROPERTIES over the `[ThreadStatic]` backing fields above them. Splitting the line on `=` read
     their `=>` as an assignment. The first draft of the same scan had also reported 1,149 static
     methods as caches; both exclusions are now stated in the code with the reason.

437. **Two guards keep it honest.** The scan must find more than fifty fields, so a shape change
     cannot silently empty it; and removing `[ThreadStatic]` from the text-measurement cache makes it
     name that field. `readonly`, `Concurrent`, `Immutable` and `Frozen` are excluded deliberately --
     drawing those distinctions is what separates a contract from a nuisance.

## r290 -- two clean shapes, then the payload r275 never carried

438. **Static event subscriptions: clean.** The only subscriptions to process-lifetime events
     (`AppDomain.CurrentDomain.UnhandledException`, `TaskScheduler.UnobservedTaskException`) are the
     crash handlers installed once at startup, which are meant to live for the process. Nothing
     subscribes a window or dialog to something that outlives it.

439. **Undisposed disposable fields: clean, and the ninth false positive.** The lone hit,
     `PresentationVideoExportSession`, holds a `CancellationTokenSource` field -- but the source is
     created with `using var` and the field is a NON-OWNING reference, cleared in a `finally` that
     runs before the `using` disposes. The scan looked for a literal `.Dispose()` and could not see
     that ordering.

440. **The gap worth closing: r275 proved a NUMBER survives every format adapter, and nothing ever
     checked a FORMULA.** That is the payload a user would be most upset to lose, and a silent
     flattening turns a live model into static numbers on one save/open cycle.

441. **Nine adapters keep the computed value; four of the five formula-capable ones keep the
     formula.** Split deliberately into two assertions, because losing an expression in a format with
     nowhere to put it is correct, while losing the RESULT is data loss in any format.

442. **DIF's "failure" was my classification, not the adapter -- the tenth false positive.** The
     first draft listed DIF as formula-carrying and it failed. The adapter's own header says "Single
     sheet, values only ... No formulas, formats, or structure", which is what the real format
     supports and what Excel writes for it. Pinned as a deliberate flattening test rather than
     quietly dropped from the list, so the intent survives.

443. **Proved by disabling SLK's formula branch: exactly one test failed and the value test still
     passed.** That separation is the evidence the two assertions are independent rather than one
     check wearing two names.

## r291 -- the loss that is inherent, and the warning that is missing

444. **Measured which formats survive a multi-sheet workbook, because nothing tested it.** r275
     covered a number and r290 a formula; the sheet COUNT was unchecked. `json`, `ods` and `xml`
     round-trip all three sheets with their names. `csv`, `prn`, `slk`, `dif` and `html` return one
     sheet.

445. **The surviving sheet is the FIRST one, and its content arrives intact.** That is a defensible
     convention and it is now pinned -- keeping a different sheet's data would silently substitute
     content the user was not looking at, which is worse than losing it.

446. **Worth knowing rather than fixing: Excel keeps the ACTIVE sheet, FreeX keeps the first.** A
     user on Sheet3 who saves as CSV gets Sheet1. That is a behavioural difference from Excel, not a
     defect in itself, and changing it means threading the active sheet into the save path.

447. **The real gap, named rather than half-built: FreeX does not warn.** Excel says only one sheet
     will be saved; FreeX discards the rest silently. The pipeline already has the channel --
     `WorkbookSaveExecutionResult.Warnings`, displayed by the WPF host -- but only the XLSX path
     populates it, and both the display method and its resource strings are XLSX-specific. Wiring a
     general loss warning needs new strings in two shells and UI this environment cannot exercise, so
     it is recorded here the way r282's residual was, instead of being shipped unverified.

448. **The boundary is pinned so a regression is loud.** A multi-sheet format quietly dropping to one
     sheet is silent data loss of exactly the kind these formats are chosen to avoid. Proved by
     making the ODS writer emit only the first sheet: exactly one test fails, and the single-sheet
     formats keep passing.

## r292 -- closing r291's gap, because the seam was already there

449. **r291 recorded "FreeX does not warn when a save discards worksheets" as needing UI this
     environment cannot exercise. That was wrong, and re-checking it beat trusting it.**
     `WorkbookSaveService` already has a portable chokepoint that asks the adapter what it can do
     (`IWarningCollectingFileAdapter`) and returns warnings through a channel the WPF host already
     displays. The warning goes through the same place, so not one call site changed.

450. **Declared as a capability, not a list of extensions.** `ISingleSheetFileAdapter` is a marker on
     the six adapters that can hold one sheet, mirroring the interface beside it whose own comment
     explains the reasoning: a new single-sheet format surfaces the warning by implementing it,
     without every call site learning its name.

451. **A declaration can drift from behaviour, so it is checked against behaviour.** Each adapter is
     given three sheets, round-tripped, and its survival count compared against whether it declares
     the marker. Dropping the marker from `DifFileAdapter` fails that test by name and count -- so
     the warning cannot quietly start crying wolf, or quietly stop firing.

452. **The message names the sheets rather than counting them.** "2 sheets were not saved" leaves the
     user to work out which; the point of warning at all is that they can still act before closing
     the file. Singular and plural are pinned separately so the sentence stays a sentence.

453. **The r283 pattern, and now a habit worth stating.** Twice a gap was recorded as blocked on UI,
     and twice the second look found an existing seam that made it testable. Recording a gap is
     right; treating that record as permanent is not -- the next round should re-examine it rather
     than inherit the earlier verdict.

## r293 -- a real data-loss bug, found by extending the previous round's measurement

454. **Extending r291/r292's save-loss survey to charts, shapes and hyperlinks turned up something
     unexpected: ODS lost all three.** The chart and shape were default-constructed and may be
     legitimately skipped, but the hyperlink was a real link on a real text cell -- and ODS is the
     rich format, keeping sheets, styles, formulas and named ranges.

455. **This was not a format limit. The ODS adapter had NO hyperlink handling on either side.** ODF
     carries a link as `text:p/text:a/@xlink:href`; a grep for "hyperlink", "text:a" or "xlink"
     across both the reader and the writer returned nothing. Every link was dropped on save, and
     every link in a file from LibreOffice was dropped on open.

456. **The loss was invisible in the way that matters most.** The reader flattens the paragraph, so
     the link's visible TEXT survived. The cell looked right; only clicking it revealed the target
     was gone -- which is why a round-trip test on values would never have caught it, and did not.

457. **Fixed on both sides, and the write side worked first try while the read side did not.** The
     writer emitted correct `text:a` immediately; three tests still failed. Dumping the actual
     content.xml rather than re-reading the diff showed the markup was right, which located the fault
     in the reader: the hook sat inside the FORMULA branch of the cell chain, so ordinary linked text
     never reached it. Moved after the whole branch chain, where it covers formula, value and
     style-only cells alike.

458. **One test reads markup this adapter does not write.** LibreOffice nests a formatted link inside
     a `text:span`, so the anchor is not a direct child of the paragraph. The reader uses
     `Descendants` for exactly that reason, and the test rebuilds a package with the span shape --
     otherwise the fix would round-trip our own files and still fail on everyone else's.

## r294 -- the same loss again, and the document that should have caught both

459. **Asked what ELSE the ODS capability profile failed to mention, and found comments.** The
     adapter's header lists what round-trips faithfully and what is deliberately deferred (charts,
     images, data validation, conditional formatting, pivot tables, freeze panes -- "an expected
     ceiling, not a bug"). Hyperlinks and comments were in NEITHER list, and both were silently lost.

460. **That absence is the systemic defect, not the two features.** The profile exists to decide
     loss-or-bug, and a feature missing from it cannot be judged at all. Both are now listed, with a
     note saying that anything added to the adapter belongs in one of the two lists.

461. **Three separate places had to learn that a comment is content, and the first two fixes each
     looked complete.** The writer emitted the annotation -- but only for cells that already had a
     value, because the code sat below `if (cell is null) return`. Moving it above that fixed the
     markup. The reader still saw nothing, because `hasInfo` -- a DoS guard that skips a "fully
     blank" cell run in O(1) -- does not count a note as information. And the table bounds never
     reached a comment-only address in the first place.

462. **Each step was found by dumping the actual bytes, not by re-reading the diff.** Twice the
     written XML proved correct while a test still failed, which put the fault on the read side both
     times; the third time the XML was empty, which put it back on the write side. Reasoning about
     which half was wrong would have been guesswork.

463. **The DoS guard was corrected, not weakened.** The O(1) skip for huge repeat counts on blank
     cells stays exactly as it was; only the definition of "blank" changed, to include a cell
     carrying a note or a link.

464. **One test earns its place by covering an interaction rather than a feature.** The reader's
     fallback path reads a cell's whole subtree when it finds no value paragraph -- which now
     contains the annotation -- so a cell holding ONLY a note would have taken the note's text as its
     VALUE, showing a comment as if it had been typed into the grid.

## r295 -- bounding the class r293/r294 opened

465. **Asked whether ODS was the first of several or the only one, and it was the only one.**
     `SpreadsheetXml` and `NativeJson` -- the other two formats that keep every sheet -- already
     round-tripped both hyperlinks and cell comments. So the class r293 and r294 fixed had exactly
     one holder, which is a result worth recording: it CLOSES the class rather than leaving an open
     question about the rest of the adapter set.

466. **Pinned as one theory over the rich formats, not three copies.** The property is identical for
     each, so a future rich format joins the list rather than acquiring its own test. The valued-cell
     case and the no-value case are separate, because the second is what exposed all three ODS skips
     -- the writer's early return, the reader's blank-cell DoS guard, and the table bounds -- and the
     first reaches none of them.

467. **Proved by regressing ODS alone: the no-value ODS case fails while xml and json keep passing.**
     A theory that failed for all three would have meant the test, not the adapter.

## r296 -- correcting two of this program's own recorded gaps

468. **CORRECTION to r295: "five AvaloniaUiTaskGuard call sites pass no explicit reporter" was
     already closed.** They do pass none, and since r283 that is fine -- the guard resolves
     `(onFailure ?? FallbackFailureReporter)` and `MainWindow` installs the fallback. The note was
     stale, carried from r282 without re-checking. r292 finding 453 wrote down that a recorded gap is
     a note to RE-EXAMINE rather than a settled verdict; r295 then failed to apply that to its own
     list, three rounds later.

469. **Closed with evidence rather than a second claim.** r283's tests drove `ObserveAsync`; the five
     call sites use `Run`, the fire-and-forget overload. These pin `Run` specifically -- reporting
     reached the way the real callers reach it -- and the assertions wait on the reporter instead of
     asserting immediately, since a fire-and-forget path would otherwise pass or fail on timing.

470. **CORRECTION to r291: the stated blocker for the active-sheet difference was also wrong.** r291
     said matching Excel "means threading the active sheet into the save path". It does not:
     `Workbook.ActiveSheetIndex` is already on the model every adapter receives, so a single-sheet
     writer could select it without any new plumbing.

471. **That one is left open deliberately, and now for the real reason.** It changes the BYTES of
     every existing single-sheet save -- which sheet lands in the file -- so it is a product decision
     about matching Excel, not a defect fix, and r292's warning already tells the user which sheet
     was kept. Recorded as ready-to-implement with the correct reason, rather than as blocked by an
     obstacle that does not exist.

472. **Two stale notes in one round is the pattern worth naming.** This log is the program's memory,
     and a wrong entry in it is worse than no entry: it stops the next pass from looking. Both were
     found by re-reading my own gaps against the code instead of quoting them forward.

## r297 -- auditing this log against the code, after it produced two wrong entries

473. **r296 found two stale entries, so this round checked the log's other load-bearing claims
     rather than picking a new region.** The claims that can rot are the ones with no enforcing
     contract: a contract-backed statement (r286's "zero culture-sensitive StartsWith", r289's
     "every writable static collection is ThreadStatic") is re-proved on every run, while a recorded
     COUNT is just a sentence.

474. **r267's ledger claims verified.** `OutstandingCeiling` is still `0` and
     `KnownNoOpCapableNotYetFixed` is still empty, with r267's own note explaining why
     `MoveRangeCommand` was the last entry.

475. **r274's claim verified, and the four apparent counter-examples are not projects.** Re-running
     the scan finds 62 production projects and 4 never named by a test: two are gitignored
     `*_wpftmp` MSBuild artifacts in the working tree, and two live under `freep/TestSupport/`, which
     the original exclusion pattern would have skipped as harnesses. `Free.Shared.TextSearch` was
     indeed the only one, and it has tests now.

476. **CORRECTION to finding 405: r284's census is the PRE-fix state, and reads as though it were
     current.** It records "196 empty-bodied catches: 167 commented, 29 bare". Today the total is
     unchanged at 196, but the split is 172 commented / 24 bare -- exactly the five sites r284 itself
     commented in the same round (three `OverflowException` catches in rounding, the calendar fallback,
     the currency-label sweep).

477. **The generalisation is small and worth stating: record the state AFTER the round's own change,
     or say which state it is.** A census taken before the fix and written up after it is not wrong
     about anything that happened -- it is just no longer a description of the code, which is what a
     later reader will use it as.

478. **Three claims checked, two held, one drifted -- and the one that drifted did so by the round's
     own hand rather than by anyone else's edit.** That is the failure mode worth watching in a log
     this long: not that the code moves away from the note, but that the note was never a description
     of the code that shipped.

## r298 -- idempotence, which finds losses without needing to name them first

479. **Tested a PROPERTY instead of a feature: save, load, save, compare the bytes.** Every previous
     format round in this program had to know what to look for -- a number (r275), a formula (r290),
     a sheet count (r291), a hyperlink (r293), a comment (r294). Idempotence needs no such list: a
     second save that differs means the load lost something or invented something, whatever it was.

480. **Seven of eight adapters reproduce themselves byte-for-byte. PRN does not, and the diff named
     the fault immediately.** A value written in column B on a row whose column A is empty comes back
     in column A. Confirmed directly: B2 = 9.5 in, A2 = 9.5 and B2 blank out.

481. **NOT called a bug, because the adapter documents the strategy that causes it.** The write side
     is fixed-width, so position encodes the column; the read side splits on runs of whitespace,
     which discards position. The header says so and calls it "the minimal correct interpretation ...
     how Excel re-imports one". What it did NOT say is the cost, and the cost is a silent column
     shift plus a non-idempotent round trip.

482. **So the deliverable is the declaration, matching r294's lesson.** A format's losses have to be
     written down before they can be judged loss-or-bug; that is what let ODS drop hyperlinks and
     comments for so long. The consequence is now in the adapter's own docs, and pinned by tests that
     say to INVERT them rather than delete them if the reader ever gains position awareness.

483. **The change itself is deliberately not made.** Recovering the columns means inferring
     fixed-width boundaries from whitespace runs across lines -- Excel's Text Import Wizard heuristic
     -- which changes how every real .prn imports, not only files FreeX wrote. That is a format
     decision, not a review edit.

484. **The idempotence check is kept for the seven that pass.** It costs one theory and guards every
     format against a whole class of loss nobody has thought of yet, which is the property that made
     it worth writing.

## r299 -- the same property, applied to a different app's adapters

485. **r298's idempotence check carried over to FreeW, where reader and writer are entirely separate
     code from FreeX's.** Five of six reproduce themselves byte-for-byte: DOCX, ODT, RTF, plain text
     and WordML.

486. **HTML does not, and the diff named the cause precisely.** A paragraph with
     `StyleId = "Heading1"` and no direct formatting writes as `<h1>text</h1>`; the reader takes the
     bold that `h1` IMPLIES and materialises it as direct run formatting, so the second save emits
     `<h1><strong>text</strong></h1>`.

487. **It converges -- 326, 343, 343, 343 -- and that is the first thing worth establishing.**
     Unbounded growth would make every open-and-save cycle inflate the file; a single normalisation
     is a different and much smaller thing. The test asserts the FIXED POINT rather than the mere
     inequality, so a future change that made it compound would fail here.

488. **Not "fixed", and for a reason that cuts the other way from r298's.** For HTML written
     elsewhere, reading the implied bold PRESERVES the author's appearance -- correct for an import
     path. It is only redundant for HTML this adapter produced itself. Removing it would trade
     fidelity on foreign documents for byte-stability on our own.

489. **The cost is named rather than left implicit: style-implied formatting becomes DIRECT
     formatting.** After a round trip, editing the Heading1 style no longer unbolds that text,
     because the bold is now on the run. That is the kind of consequence a size comparison surfaces
     but never explains, which is why the round did not stop at "17 bytes larger".

## r300 -- the idempotence sweep, finished across all three apps

490. **FreeP completes what r298 (FreeX) and r299 (FreeW) began.** All three apps' persistence
     layers have now been asked the same question -- does saving what you just loaded reproduce what
     you saved -- and the answer is known for each rather than assumed for any.

491. **Split into three properties, because one "the bytes match" assertion cannot distinguish
     their failures.** The writer is DETERMINISTIC; a round trip preserves the PART SET; the round
     trip CONVERGES. Each fails for a different reason and each names a different defect.

492. **Establishing determinism FIRST is what made the rest interpretable.** `ppt/presProps.xml`
     differs between the first and second save at IDENTICAL length -- the signature of a regenerated
     identifier. Had the writer been nondeterministic, every save of an unedited file would dirty it,
     which version control and external-modification detection both read as a real edit. It is not:
     writing one model twice is byte-identical, so the difference is the READER normalising, not the
     writer inventing.

493. **PPTX keeps all 15 parts and converges after one reload.** Theme goes 3004 to 3068 bytes and
     then never moves; `presProps` changes once at constant length. Same shape as r299's HTML: a
     one-time normalisation, not compounding growth.

494. **Compared by PART, not by raw bytes.** A zip's container metadata is not the adapter's output,
     and comparing it would have reported a difference that means nothing -- the kind of false
     positive that makes a property test get deleted rather than fixed.

495. **What the sweep found, across three apps and fifteen adapters: one real defect and two declared
     normalisations.** PRN shifts values left when leading columns are empty (r298, documented rather
     than changed); FreeW's HTML materialises heading-implied bold (r299); FreeP's PPTX rewrites two
     parts once (r300). Everything else reproduces itself exactly. That is a stronger statement about
     the persistence layer than any single feature test in this program has produced, and it needed
     no list of features to make.

## r301 -- the round-trip property applied to the clipboard

496. **The idempotence idea moved off the persistence layer and onto the pipeline the user touches
     most: copy and paste.** The property is the same shape -- what the writer emits, the reader must
     reconstruct -- but the pipeline is entirely different code.

497. **Both halves were pinned; the relationship between them was not.**
     `ClipboardSerializerTests` asserts what `Serialize` produces for a given grid, and what
     `Deserialize` yields for a given string, each against text typed into the test. Nothing fed the
     writer's output to the reader, so "copy in FreeX, paste in FreeX, get the same cells" -- the only
     property a user depends on -- was unchecked. r290's shape exactly: two directions covered, the
     relation between them not.

498. **The escaping is correct.** Twelve cases pass, including the three that break naive schemes:
     the field delimiter (tab), the row separator (both LF and CRLF), and the quote character used to
     escape them. Leading and trailing spaces, empty cells, and text that already looks quoted also
     survive, as does a sparse grid's SHAPE -- gaps come back as gaps rather than closing up.

499. **Proved by a plausible regression rather than a contrived one.** Dropping `'\t'` from the
     quoting predicate -- the shape of an "optimisation" that notices most cells contain no tab --
     fails exactly the tab case and nothing else. A cell containing a tab would otherwise paste as two
     cells and shift every column after it.

500. **A probe that silently does not apply proves nothing, and this one did not the first time.**
     The `perl` substitution failed on the escaped quotes, the source was unchanged, and the run
     reported twelve passes that meant nothing. Caught by checking the edited line before trusting
     the result -- the same discipline the stale-binary readings needed.

## r302 -- the round-trip property where failure costs the most

501. **Autosave is the highest-stakes writer/reader pair in the three apps: it exists to give a user
     back work they never saved.** A sidecar that loses a field is a recovery prompt naming the wrong
     document, or a snapshot that cannot be matched to its original.

502. **Unlike r301's clipboard, the pair IS exercised end-to-end** -- several workflow tests write a
     real sidecar and read it back through production code. So the relationship was covered.

503. **What was not covered is COMPLETENESS.** No test asserted that every field survives, so a field
     added to the DTO later could be dropped by the serializer and the entire suite would stay green,
     because nothing looks at it. All five round-trip correctly today.

504. **The guard derives the field list by reflection rather than trusting a hand-written one.**
     Adding a sixth property fails it immediately -- proved by doing exactly that -- while the
     round-trip test keeps passing, which is the correct split: one says "the fields we check
     survive", the other says "these are all the fields there are".

505. **Malformed input pinned too, because of WHERE this code runs.** A truncated sidecar is precisely
     what a crash mid-write leaves behind, and the recovery sweep reads every sidecar it finds.
     Throwing on one bad file would fail the whole sweep -- so empty, non-JSON and truncated input all
     return null rather than throwing.

506. **The r301 lesson repeated itself within one round, and the check caught it.** The first probe's
     `perl` substitution silently failed to match, the field was never added, and the run reported six
     meaningless passes. Verifying the edit landed -- not the test result -- is what distinguished
     that from a real green.

## r303 -- configuration, the round trip a user notices as "my settings keep resetting"

507. **`AppOptionsStoreTests` covers the store's MECHANICS well and round-trips two options out of
     forty-two.** Path resolution, atomic write, unwritable targets, invalid JSON and schema
     compatibility are all pinned; whether a given setting survives a restart is not.

508. **Driven by reflection, so it is complete by construction rather than by a maintained list.**
     r302 needed a separate completeness guard because its assertions named fields one by one;
     enumerating the properties is the better shape once a type is this wide, and it covers a
     forty-third setting the day someone adds one.

509. **Run through `SaveToPath`/`LoadFromPath` rather than a bare serializer.** Both call
     `Normalize()`, so the expectation is normalised the same way -- otherwise a legitimate
     normalisation would be indistinguishable from a value that failed to persist, and the test
     would have reported a defect that was not there.

510. **Forty-one of forty-two persist. The one that does not is correct.**
     `LastPersistenceError` reports the outcome of the CURRENT save or load; persisting it would show
     the user a stale failure on every subsequent launch, long after the disk had space again. It has
     `[JsonIgnore]` and a private setter -- and reflection still reports it writable, so the
     exclusion is necessary, not cosmetic.

511. **Excluded by name WITH the reason, and the reason is itself a test.** An unexplained exclusion
     is how a real persistence bug gets filed away as "known", so a separate test asserts the field
     is transient rather than leaving that as a comment.

512. **Proved with the shape a real mistake takes.** Marking one ordinary option `[JsonIgnore]` --
     what happens when someone adds an attribute to the wrong line -- fails the test with the
     property named and both values shown: `saved [True] loaded [False]`.

## r304 -- bounding r303's class across the sibling apps

513. **Checked before writing anything, and the siblings did NOT have r303's gap.** FreeX's
     forty-two-option DTO had two options round-tripped; FreeW's six and FreeP's three are each
     named repeatedly in their own dedicated test files. The values are covered.

514. **What is not covered there is the NEXT option.** Those tests name settings individually, so a
     seventh FreeW option would simply have no test and a persistence failure on it would be
     invisible. Enumerating the properties is redundant with the per-option tests today and is the
     only thing that will cover the option added tomorrow.

515. **The guard immediately earned its keep by refusing to pass two options it could not vary.**
     `AutoFormat` and `AutoCorrect` are nested settings objects -- whole option PAGES. Treating an
     unrecognised type as "passing" would have quietly excluded them; the failure said so instead,
     and the fix was to recurse into them. A nested object that fails to serialise resets a whole
     page of settings at once, not one checkbox.

516. **Two reflection traps, both fixed rather than worked around.** An INDEXER is a property to
     reflection but cannot be read without arguments -- one nested type has one, and it threw
     `TargetParameterCountException` rather than reporting anything about persistence. And the nested
     types do not override `Equals`, so structural comparison was needed or every page would have
     compared unequal and reported loss that was not there.

517. **Proved on a nested page, which is the case the flat version would miss.** Marking
     `AutoCorrect` `[JsonIgnore]` fails with the property named -- and the two objects print
     identically, so only the structural comparison catches it.

518. **A stale-binary reading again, and again caught by rebuilding rather than believing.** The
     verification run reported one failure because `FreeW.slnx` does not contain the shared test
     project, so it still linked the probe's assembly. Rebuilding that project gave 445/445.

## r305 -- the other half of the settings journey: the hand-written copy

519. **r303 proved every option PERSISTS; `CopyFrom` is the step that gets a reloaded value back
     into the live object, and it assigns forty-odd fields by hand with nothing checking the list.**
     Its own summary says it exists so shells and sibling windows can keep one options reference
     while a reload is adopted -- so a field missing from that list is not a crash: the value is read
     from disk correctly and then silently not copied, and the window keeps showing the old setting
     until the app restarts.

520. **It is complete today. The point is the next property added to the type.** Same shape as the
     snapshot-completeness contracts that drove this program's no-op ledger to zero: the risk was
     never that the current list is wrong.

521. **The first draft reported TWO failures and BOTH were the test's fault.** `CopyFrom` ends with
     `Normalize()`, which legitimately rewrites `DefaultFormat`, the font settings and both lists --
     so "r305-DefaultFormat" was rejected as an extension, exactly as it should be, and the list
     assertions compared against literals that normalisation had reshaped.

522. **Normalising the EXPECTATION is what separates the two questions.** With that, the test
     measures whether `CopyFrom` carries each field rather than whether an arbitrary test value
     survives validation -- the same correction r303 needed, repeated here because the trap belongs
     to the code under test, not to one round.

523. **Aliasing pinned separately, because a value comparison cannot see it.** A list copied by
     REFERENCE passes every equality check and still lets one window's edit rewrite another's
     toolbar. The snapshot is taken after the copy and before mutating the source, so normalisation
     reshaping a list cannot be mistaken for sharing.

524. **Proved by deleting one assignment: `ShowGridlines: source [False] target [True]`.** That is
     precisely the shape of the real mistake -- a property added to the type and forgotten in the
     copy.

## r306 -- bounding r305's class in FreeW, where the copy is shallow ON PURPOSE

525. **`FreeWOptions.Clone()` is the sibling of FreeX's `CopyFrom` -- six fields copied by hand --
     and NO test called it at all.** Its purpose makes the failure specific: it captures the Options
     dialog's OPEN-TIME state for the reload-before-write merge, so a field it forgets is one the
     merge believes was never edited, and the user's change to it is discarded on OK, silently.

526. **The nested pages are shared by reference DELIBERATELY, and the type says why.** "Production
     code never mutates AutoFormat or AutoCorrect in place -- an edit always assigns a freshly built
     replacement object." So unlike r305's FreeX lists, independence is NOT the property here.
     Asserting it would have contradicted a documented design decision; the sharing is pinned
     instead, so a future move to deep copying is a decision rather than a drift.

527. **The guard-the-guard test earned its place immediately.** `AutoFormatOptions` has VALUE
     equality, so a freshly constructed default instance compares equal to the default -- meaning
     the completeness test would have "passed" on a field it never actually varied. The guard said
     so, and the fix was to flip a flag inside the nested object rather than merely construct one.

528. **That asymmetry is worth recording: `AutoFormatOptions` has value equality and
     `AutoCorrectOptions` does not.** r304 needed structural comparison for the latter; this round
     needed content variation because of the former. Two sibling settings types, two different
     equality behaviours, and a test that assumes either one is wrong half the time.

529. **Proved by deleting one assignment: `AutoCorrectEnabled: source [False] clone [True]`** -- the
     exact shape of a property added to the type and forgotten in the clone.

## r307 -- surveying the whole hand-written-copy class, then filling its largest hole

530. **Generalised r305/r306 instead of guessing the next instance: nineteen hand-written
     field-by-field copies exist across the three apps with five or more assignments.** The largest
     are `Sheet.Clone` (94), `ConditionalFormat.Clone` (62), `TextDocument.Clone` (52),
     `AppOptions.CopyFrom` (43) and `CellStyle.Clone` (44).

531. **Four already carry completeness guards, and one of them records that this class has bitten
     here before.** `Sheet.Clone`'s own summary lists "the previously missed fields" --
     `BackgroundImage`, the outline levels, the comment authors -- and
     `SheetClone_CanonicalCopyPreservesEveryFieldAndIndependentLists` is what keeps them there.
     `CellStateSnapshot`, the picture clone and the slicer copy-state are guarded too.

532. **`ConditionalFormat.Clone` was the largest unguarded one, and its failure mode is the quiet
     kind.** Duplicating a sheet or pasting formats copies every rule through it. A dropped field
     does not remove the rule -- it changes ONE ASPECT of it, a colour scale's midpoint or an icon
     set's reversal, so the formatting still applies and merely applies differently. That is much
     harder to notice than a rule that disappeared.

533. **Complete today for every scalar member; the guard is for the fifty-ninth property.** Fifty-
     eight assignments maintained by hand will eventually gain one nobody adds, and a hand-written
     test would have to be extended by the same person who forgot -- which is the argument for
     reflection rather than a list, made once in r303 and reused since.

534. **The test states its own limit rather than implying completeness.** Reference-typed members
     (ranges, colour stops, icon criteria) need per-type construction and are left to the existing
     behavioural tests; naming them in the test keeps the boundary visible instead of letting a
     reader assume every member is covered.

535. **Proved by deleting one assignment: `Value1: source [r307-Value1] clone []`.**

## r308 -- closing the hand-written-copy class instead of one instance per round

536. **r307 surveyed nineteen hand-written copies and guarded one; guarding the rest one per round
     would have cost fourteen rounds and produced fourteen near-identical files.** The property is
     identical for every one of them, so the machinery is written ONCE
     (`CloneCompletenessAssertions`) and a type is covered by being named.

537. **Nine types now guarded across all three apps.** FreeX: `CellStyle` (44 assignments),
     `DataValidation`, `ChartDataTableModel`. FreeW: `ShapeEffectLst`, `PageSettings`, `WordArt`,
     `Chart`. FreeP: `FieldRun`, `AnimationScaleBehavior`. With r305-r307's `AppOptions.CopyFrom`,
     `FreeWOptions.Clone` and `ConditionalFormat.Clone`, and the four that were already guarded, the
     class is closed at every site with a parameterless `Clone()`.

538. **Every one passes: none of the nine drops a scalar member today.** The guards exist for the
     member added tomorrow, which is the whole argument for reflection over a hand-maintained list --
     a list has to be extended by the same person who forgot the assignment.

539. **The helper states its own limit rather than implying completeness.** Scalars only:
     reference-typed members need per-type construction, and a generic way to build them would be
     guessing. A guard that covers the scalars completely and SAYS SO is worth more than one that
     appears to cover everything.

540. **One shared helper is a single point of failure, so it was probed rather than trusted.** A
     broken helper would silently disarm all nine guards at once. Deleting one assignment from
     `CellStyle.Clone` fails with `Superscript: source [True] clone [False]`.

541. **The perl-edit-did-not-apply trap for the third time in three rounds, caught the same way.**
     The first probe reported four passes with the source unchanged. Checking the edited line before
     believing the result is now the routine -- and it is the only thing separating a real green from
     a meaningless one.

## r309 — the hand-written-copy class, closed at the hazard

r307 surveyed nineteen field-by-field copies; r308 guarded the ones a reflection helper can reach.
This round finished the remainder and then stopped guarding call sites, because naming N of them
does nothing about caller N+1 (r277).

**Extended the reflection guards** to the last three types from the survey with a public
parameterless `Clone()`: `CellGradientFill` (FreeX), `FloatingPlacement` and `Source` (FreeW). The
helper's own `NotBeEmpty` assertion rules out a vacuous pass, so a type with no scalars would fail
rather than appear covered.

**Added a shape contract** —
`R309_InitializerClonesCopyEveryMemberContractTests`. A `Clone()` written as `=> new(...) { ... }`
enumerates what it copies in one place, so the omission is mechanically visible: every settable
instance member the type declares must appear as a constructor argument or an initializer
assignment. Thirteen such copies exist across the three apps; all thirteen are complete. This covers
the two the reflection helper cannot touch — `RtfReader.State` (private nested, fields not
properties) and `EmbeddedObject` (passes members as constructor arguments) — and, unlike a list of
types, it covers the copy someone writes next.

**Guarded `PreservedParts.CopyFrom`** (`R309_PreservedPartsCopyFromCompletenessTests`): all seven
members are reference-typed so the scalar helper sees nothing, and it is a statement body so the
shape contract does not either. It is also the copy with the most at stake — these are parts of an
opened package FreeW does not model, carried forward so a derived document saves without dropping
what it never understood. Three tests: every member carried, no mutable state shared with the
source, and a census pin so an added member fails until someone looks. All pass; the copy is
correct.

**A false positive, the eleventh of its family.** The contract's first run reported four incomplete
copies — `EmbeddedObject.IsLinked`, `FloatingPlacement.IsFloating`, `ShapeEffectLst.HasAny`,
`WordArt.IsFloating`. All four are computed read-only properties whose values follow from members
the clone already carries; my field regex read `public bool IsFloating => ...;` as a field with an
initializer. The code was right every time. The exclusion and the reason are now in the regex's own
doc comment, where the next reader of that line will need them.

**Proved it can fail**: removing the single initializer assignment from `InlineTableInfo.Clone` made
the contract report exactly that member; restored, and `git diff HEAD` confirmed clean.

**Not covered, with the reason**: `CellFontColorFilterCommand.Capture` (`FilterCommand.cs:838`) is
not a self-copy — it captures filter state *from* a `Sheet`. Deciding which of a sheet's members
belong to that capture is a judgement about what filter state means, not something derivable from
the type, so a mechanical guard here would either be vacuous or wrong. It stays a reviewed-by-hand
site.

With this the class r307 opened is closed: every hand-written copy is either behaviourally guarded,
covered by the shape contract, or recorded above with why it cannot be.

## r310 — a single-sheet save must keep the sheet the user is looking at

r309's log listed this as a product decision deliberately left open: FreeX keeps the FIRST sheet on
a single-sheet save where Excel keeps the ACTIVE one. **That entry was wrong, and the correction is
the finding.** FreeX had already made the decision — `DelimitedTextWorkbookWriter` states the rule
outright ("Real Excel's CSV/TXT Save-As exports the active sheet, not the first sheet in tab
order"), and DIF, PRN and SLK all follow it. Five of six writers were right. There was no product
question here, only one writer that had not been brought along.

**Bug 1 — `HtmlTableWriter` exported `Sheets[0]`.** A user who switched tabs and saved as HTML got a
different sheet than the one on screen, silently. Fixed to the active sheet with the same bounds
check the other writers use.

**Bug 2 — the sheet-loss warning named the wrong survivor, and it was mine.** r292's
`SingleSheetSaveWarningPlanner` reported `sheets[0]` as the sheet that was saved. Against writers
that keep the active sheet, that is exactly inverted: the user was told their current sheet had been
discarded and some other sheet kept. A warning that misnames what survived is worse than no warning,
because it is the one message the user acts on before closing the file. Fixed to the active sheet,
with the discarded list computed by exclusion rather than `Skip(1)`.

**Why r292's own six tests did not catch it**: none of them ever made a sheet other than the first
one active, so the bug was invisible to a suite that otherwise covers this planner well. The new
tests vary precisely that, and one of them checks the warning against the bytes the adapter actually
wrote rather than against a constant — the warning and the file have to agree.

**Guarded the hazard too**: `NoSingleSheetWriterSelectsItsSheetByPosition` fails on any `Sheets[0]`
in a single-sheet adapter or its writer, so the next one cannot reintroduce this. Its first run
reported the fixed line itself — my explanatory comment names `Sheets[0]` — which would have
punished writing the explanation down; it now reads code only.

**Proved both fixes can fail**: reverting the HTML writer failed the HTML case and the contract;
reverting the planner failed exactly the two tests that vary the active sheet, and neither of the
two that do not. Full lanes green afterwards: FreeX.Core.IO.Tests 6281 passed / 0 failed,
FreeX.App.Services.Tests 3575 passed / 0 failed.

**A process note worth keeping**: after each revert probe the restored source was newer than the
compiled assembly, yet `dotnet build` reported success without refreshing the test project's copy,
so a full rerun showed my own new tests failing against probe binaries. `--no-incremental` on both
the production project and the test project was needed. A build that says nothing is not the same as
a build that did something.

## r311 — slicer selections are file data, so they must match by the file's rules

Followed r310's lens: the bug there survived because the persistence layer and the presentation
layer answered the same question differently. Asked where else that split exists, and found it in
the pivot/slicer stack.

`XlsxPivotSlicerCacheData`, `XlsxSlicerTimelineStateRewriter` and the filter engine all decide
whether two slicer items are the same item with `OrdinalIgnoreCase`. The presentation layer matched
those same persisted strings with `CurrentCultureIgnoreCase`. That is not a stylistic difference:
ICU collation ignores characters such as a soft hyphen, so `"Total­Revenue"` and
`"TotalRevenue"` compare EQUAL culture-sensitively and UNEQUAL ordinally. The visible costs are a
tile shown as selected that the filter does not include, and two distinct source values collapsing
into a single tile so one of them cannot be selected at all.

**Fixed, in identity roles only** (`SlicerLayoutModel`, `SlicerTimelinePanePlanner`,
`PivotFieldItemsReader`, `PivotFieldFilterPlanner`, `SlicerTimelineSourceReader`,
`GetPivotDataFormulaPlanner`, `PivotTableSlicerCommands`, `PivotFieldFilterDialog`):
`HashSet`/`Contains`/`Distinct`/`Equals` over persisted values now use `OrdinalIgnoreCase`.
`PivotTableSlicerCommands` mattered most -- it is the only path by which a user selection reaches
the model, and it deduplicated culture-sensitively.

**Deliberately NOT changed, and the distinction is the point**: sorting. `OrderBy`, `Sort` and the
locale ordering of displayed items stay `CurrentCultureIgnoreCase`, because which order a user sees
names in IS their locale's question. Two sites were doing both jobs with one comparer -- a
`SortedSet` that deduplicated and ordered at once -- and were split into an ordinal dedupe followed
by a culture sort, so neither job borrows the other's answer. A test pins the ordering so the fix
cannot silently become a byte-order sort. User-facing search boxes (`Contains(query, ...)`) also
keep culture matching: type-to-find should be forgiving.

**Proved before and after**: a platform probe first (r286's lesson -- the behavioural tests would
have passed against unfixed code had the two comparers not actually disagreed), then reverting the
comparer failed four of the seven tests. Lanes green: App.Presentation 5610/0, Core.Model 6701/0,
Core.IO 6281/0.

**Measured but NOT swept, with the count**: `PivotTableRefreshService` compares pivot row/column
keys culture-sensitively in about thirty further places (`ColumnKeys`, `Details`, `Filters`,
`MatrixWriter`, `Writers`). That is the same class, but those comparisons drive grouping and
subtotal placement in the refresh engine, and changing thirty of them on the strength of a pattern
match is how this program has produced false positives before. Named here as a bounded, measured
follow-up rather than half-done.

**Process, again**: two builds reported "Build succeeded / 0 Errors" while leaving the assembly
older than the source, so a lane run showed my own new tests failing against probe binaries. I had
also filtered build output to `error CS`, which would have hidden a non-CS failure. Check the
artefact's timestamp, not the build's summary.

## r312 — auditing my own deferrals: two of three were not real

The open items this program was carrying were three. Investigating them rather than restating them
dissolved two.

**1. r311's "~30 more culture-sensitive comparisons in PivotTableRefreshService" is NOT r311's
class, and my note saying so was wrong.** r311's defect was presentation code matching *persisted
file values* by different rules than the IO layer that wrote them. The refresh engine's keys are a
different thing: `GroupKeyText` formats them with `CultureInfo.CurrentCulture` deliberately, because
that string IS the row label the user sees -- a German user should keep seeing the `0,5-1` bucket.
Comparing culture-formatted strings with culture rules is consistent, not confused. The genuine
hazard here -- captions persisted under one culture, reopened under another -- was already found
(r174/r176) and fixed at `MatchesFieldKeyCandidate`, which tries the culture spelling first and then
a culture-INVARIANT candidate, deliberately leaving the DISPLAYED spelling local. Changing those
sites to ordinal would regress a solved problem. Removed from the follow-up list.

**2. r309's `CellFontColorFilterCommand.Capture` was a misattribution.** `FilterCommand.cs:838` is
inside `FilterUndoSnapshot` (which begins at line 808); `CellFontColorFilterCommand` ends well
before it. My r309 note took the wrong enclosing type from a scan and then reasoned about the wrong
thing. The real member is already guarded: r252's
`R252_FilterSnapshotComparisonCoverageContractTests` compares `Matches` against `Capture` field for
field and fails if `Capture` reads a sheet member `Matches` does not -- verified passing. Removed
from the follow-up list.

**3. PRN's whitespace-split read stands, and is accurately recorded.** The cost is documented in the
adapter's own remarks, pinned by `R298_PrnWhitespaceReadShiftsLeadingEmptyColumnsTests`, which tells
whoever changes it to invert those assertions rather than delete them. Recovering column positions
means inferring fixed-width boundaries, which changes how every real `.prn` imports -- Excel asks
the user through its Text Import Wizard rather than guessing. This is a product question, not an
oversight.

**Surveyed and clean, with a fence**: comparer PAIRING. r311 fixed a comparer answering the wrong
question; the worse failure is a comparer whose `Equals` and `GetHashCode` answer different ones --
keys that compare equal but hash differently, so a dictionary stores duplicates and a lookup misses
an entry that is present, with no exception and no wrong value. All eleven explicit string-hashing
sites across the three apps pair correctly. `R312_EqualityComparersHashAndCompareAlikeContractTests`
now holds that, and it reads only rules NAMED on both sides -- a side naming none is using its
members' default rule, which the contract cannot see and must not guess about. Proved it fails by
making one comparer hash ordinally while comparing case-insensitively; it named the file and both
rules.

**Where the review actually stands.** The follow-up list is now one item (PRN), and that one is a
product decision with a test pinning it. This does not mean no defects remain in the codebase --
r310 and r311 each found real bugs invisible to suites that covered their areas well, and the honest
lesson from both is that the next defect will come from a dimension no test varies, not from a
region no one has read. What is true is that every item this program has recorded as outstanding has
now been either fixed or re-examined and found not to be outstanding.

## r313 — saving the same workbook twice produced two different files

I said the next defect would come from a dimension no test varies rather than a region no one has
read, so I looked for such a dimension instead of asserting it. Three candidates were measured and
found already covered: the 1904 date system (74 production sites, varied by many tests), all 71
settable `Sheet` properties (every one with real production use is set by at least two tests), and
culture (42 test files switch it). The gap was inside that last one: the suite exercises only de-DE,
fr-FR, en-US and en-GB -- all Latin, none with Turkish case mapping -- which is exactly where r286
and r311 lived. And r275 fenced the culture class on the PARSE side only, saying so explicitly; the
write side had no fence.

So rather than pattern-match `ToString()` calls (a `ToString()` has no type prefix to key on, so a
regex would be all noise), I varied the dimension: save the same workbook under de-DE, fr-FR and
tr-TR and require identical output. **The write side is clean** -- ODS, native JSON and
SpreadsheetXML are byte-identical across all three cultures, and XLSX is identical part-for-part.

**What it found instead was worse than a locale leak**: `_rels/.rels` differed between two saves of
an unchanged workbook. The packaging layer gives the root `officeDocument` relationship a RANDOM id
(`Rb8ce4c41530e4534`, then `R7ea447fa93bb4cbf`) while its siblings get `rId1`/`rId2`. Every XLSX
save produced a different file. That costs the user wherever a file is compared rather than opened:
version control shows a change that is not one, sync and backup tools re-upload an identical file,
content-hash caches miss. `XlsxRootRelationshipIdNormalizer` now assigns it the next free `rIdN`.

**The control is the reason any of this is trustworthy.** My first version compared raw bytes and
reported XLSX as culture-dependent under all three cultures. It is not -- a control saving twice
under the SAME culture also differed. Comparing raw bytes measured the clock and the id, not the
locale. Without that control I would have recorded three culture bugs that do not exist.

**Two things the fix got wrong before it got right, both caught by existing tests**: the first
version renamed every ill-formed root id and broke three customXml tests -- a customXml root
relationship's id IS referenced by its property sidecar binding, so my premise that root ids are
never referenced was wrong; it is true only of `officeDocument`, which readers find by Type. And the
call initially split `NormalizeWorkbookForSchema(); return;`, which an existing source contract
anchors on. I moved my call rather than loosen that contract: accommodating a new change by
weakening the guard that caught it is how a suite stops meaning anything.

## r314 — the same question asked of the sister apps

r313 found FreeX's XLSX save was not reproducible. FreeW and FreeP write OPC packages too, and the
shared tier is known to mirror FreeX and then drift, so the honest move was to ask rather than to
assume the defect generalises -- or that it does not.

**Both are clean.** A .docx and a .pptx each save byte-identically twice over, once the parts that
record a timestamp are excluded by name rather than hoped to be stable. FreeX's defect came from the
packaging layer it uses for XLSX specifically, not from anything shared. Guards are now in place in
both apps, with vacuity checks -- the package must contain `_rels/.rels` and more than three parts --
because a test that compares two empty dictionaries passes forever and means nothing.

**A mistake worth recording, because it was mine and it was loud.** My FreeP test declared
`namespace FreeP.App.Presentation.Tests`, which is not what that project uses (`FreeP.App.Compositor
.Tests`). Declaring it made `FreeP.App.Presentation` a visible namespace, which then shadowed the
`Presentation` TYPE in every sibling file importing the model: one new file's namespace stopped the
whole project compiling, in files I had not touched. I diagnosed it by removing my own file and
rebuilding -- the error count went to zero, which located the cause in one step and ruled out the
"this project was already red" explanation I would otherwise have reached for. Matching the
surrounding convention is not a style preference here; it is load-bearing.

Lanes green: FreeW.Core.IO.Tests 1939/0, FreeP.App.Presentation.Tests 5915/0.

## r315 — the read side of the culture class

The third and last side of a class that had been fixed seven times before it was ever fenced. r275
scans PARSES in source; r313 proved the WRITE side behaviourally. Nothing opened a file under another
culture, so a parse a source scan cannot see -- inside a custom tokenizer, a date splitter, a
third-party reader -- was free to misread numbers on a German machine.

The workbook is written once under the invariant culture, then loaded under de-DE, fr-FR and tr-TR,
and the loaded MODEL is compared rather than re-saved bytes: it is the values the user sees that
matter, and comparing models isolates the reader from anything the writer might also get wrong.

**All four adapters are clean** -- XLSX, ODS, native JSON and SpreadsheetXML read identically in
every culture.

**The first fail-probe passed, and that was the useful part of this round.** Flipping ODS's number
parse from invariant to current culture did NOT fail the test: `NumberStyles.Float` does not allow
group separators, so `"1.5"` under de-DE does not parse as `15` -- it fails to parse at all, and the
reader's own second attempt (which was still invariant) rescued it. My probe had created a
parse-FAILURE path, not a wrong-VALUE path, which is not the defect being guarded against. Flipping
BOTH attempts failed exactly the three ODS cases and left the other nine green, so the test does have
power over that reader. Recorded because the distinction generalises: this test can only catch a
culture leak that changes a value, and .NET's stricter number styles turn many leaks into failures
that a fallback then hides. It is a real guard with a stated blind spot, not a proof of absence.

**Also a fixture correction**: the first version compared values with `BeEquivalentTo`, which threw
`No members were found for comparison` on these value types -- twelve red tests that said nothing
about the product. Value equality (`Be`) is the right assertion for a record.

Lane green on freshly built binaries: 6309 passed, 0 failed. The first run after the probe showed
four ODS failures because the restore had not been rebuilt -- the same stale-binary trap as r310 and
r313, and the third time this program has read its own probe leftovers as a regression. The tell is
always the same: failures in tests the change could not plausibly touch.

## r316 — the source-loaded dimension, measured field by field

A drawing loaded from .xlsx replays its original XML on save, so a model edit is dropped unless a
save-time rewriter patches that specific field. This codebase has fixed that class repeatedly, one
field at a time, and carries 176 test references to `IsSourceLoaded` -- all of them EXAMPLES. What
was missing is completeness: nothing said which fields are covered, so a field added to the model
joined the unpatched set silently.

So the field list is now derived by reflection, and every scalar member of `PictureModel` must be
exercised, declared derived-on-load, or declared lost -- a new member belongs to none of those and
fails the census until someone decides which it is, at the time it is added rather than when a user
reports it.

**Six members are genuinely not carried back**, and they are now declared and counted rather than
silent: `Title`, `IsDecorative`, `IsVisible`, `LockAspectRatio`, `Locked`, and `Name`. `AltText`
survives, which is what makes `Title` and `IsDecorative` look like gaps rather than design --
they are the same accessibility concept written to neighbouring attributes.

**`Name` is the interesting one, and it is structural.**
`XlsxSourceDrawingGeometryRewriter` pairs a source-loaded picture with its physical `xdr:pic`
element by MATCHING `cNvPr@name` against `PictureModel.Name`. Name is the identity key, so a rename
cannot be written through the very mechanism that locates the element to write it to. That raised a
worse hypothesis than a dropped rename: a renamed picture matches nothing and falls into positional
pairing among the leftovers, so another picture's size edit might land on it. **I tested that and it
does not happen** -- renaming the first of three pictures and resizing the third puts the resize on
the third and leaves the others untouched. Hypothesis raised, tested, disproved, and the test kept.

**Most of the first measurement was my own fault, not the product's.** The raw run reported 24 lost
edits. Sizes and offsets "failed" by 0.00005 because they round-trip through EMUs; the four crops
"failed" because I set them to 3.5 when a crop is a fraction clamped to 1; `Kind`, `ContentType` and
`DrawingAnchorKind` "failed" because they are derived on load, and the camera-picture fields because
they are meaningless for an embedded image. Six real losses out of twenty-four reported. Reporting
the twenty-four would have been worse than reporting nothing.

**Bounded follow-up, with exact names**: the five non-structural declared losses (`Title`,
`IsDecorative`, `IsVisible`, `LockAspectRatio`, `Locked`) each need a save-time rewriter patching
their `cNvPr` attribute. That is five OOXML writer changes in the drawing path, and this program's
own history says sweeping that many at once on the strength of one measurement is how false fixes
get made. They are declared in the test, so they can no longer regress silently or be forgotten.

Lane green: 6311 passed, 0 failed.

## r317 — closing r316's declared losses, and fixing a flaky guard I had just added

**Two of r316's six declared losses are now fixed.** `XlsxSourceDrawingGeometryRewriter` patched
`cNvPr@descr` for a source-loaded picture but not its two neighbours, so editing a picture's Title
or marking it Decorative was kept for a picture FreeX authored and silently dropped for one loaded
from a file. The shape path has always patched `title`, and the fresh writer emits both -- only the
picture's source-loaded path was behind. Proved by removing the fix: the census named exactly
`Title` and `IsDecorative`.

**r316's reasons for the other three were wrong, and that matters more than the fix.** I wrote that
`IsVisible`, `LockAspectRatio` and `Locked` are "not written back onto replayed XML", which implies
a freshly authored picture keeps them. It does not: `picLocks`, `noChangeAspect` and `cNvPr@hidden`
appear NOWHERE in the drawing writer, so these are model state the .xlsx layer never records by any
path. That is a wider gap than the source-loaded class, and a reader chasing my original wording
would have gone looking in the wrong place. Reasons are now accurate.

**A flaky test I had introduced two rounds earlier.** The full lane failed once on r313's tr-TR case
-- a test with no pictures, which my picture change could not touch -- and passed on the repeat and
in isolation. Cause: r313 and r315 set `CultureInfo.CurrentCulture` on the calling thread and
restored it in a finally. The culture is thread-scoped, xUnit runs other tests in parallel and
resumes async work on pooled threads, so the setting could be observed by, or restored on, a thread
other than the one doing the work. Both now run their save/load on a dedicated thread that carries
the culture and is joined. Three consecutive full-lane runs are green.

That failure was worth more than the fix. A flaky guard in this position is not merely noise: it
teaches the next reader to disbelieve it, so the real culture regression it exists to catch gets
waved through as "that one's flaky". I also nearly misread it as a regression from the picture
change, which is the same trap as the stale-binary runs -- the tell was the same, a failure in a
test the change could not plausibly reach.

Lane green three times: 6311 passed, 0 failed.

## r318 — hiding a picture now survives the save

The third of r316's declared losses turned out to be a plain user-visible bug rather than a format
limitation. `SelectionPaneCommands` is the Selection Pane's eye toggle: it sets
`PictureModel.IsVisible`, and nothing wrote it. Hide a picture, save, reopen -- it is back. The
format has a place for this (`cNvPr@hidden`); FreeX simply never read or wrote it.

Threaded end to end: `XlsxPicturePackagePart` gained `IsHidden`, the reader gained
`ReadNonVisualHidden` beside its existing `descr`/`title`/decorative readers, both picture model
construction sites set `IsVisible`, all three fresh-write paths emit the attribute, and the
source-loaded rewriter patches it -- so an authored picture and a loaded one behave the same, which
is the failure mode r316 exists to catch. Proved by removing the writer and rewriter lines: the
census named exactly `IsVisible`.

**The remaining two are a documented decision, not an oversight, and I had it backwards.**
`PictureModel.Locked`'s own doc comment says reading/writing `a:picLocks` is deferred follow-up
(R111-model-drawing-object-lock-1-1) and the field is session-only by design. `LockAspectRatio` is
the same pair. So the census's last two entries now cite that decision rather than reading as
undiscovered gaps -- the difference between "nobody noticed" and "someone decided", which is exactly
what a reader of this list needs to know.

**Two mistakes of mine in one round, both from the same cause.** My two perl edits for the two model
construction sites BOTH matched the first site, so it got a duplicate `IsVisible` and the second got
none. The build failed with CS1912 -- and the test run chained after it reported "Passed", because
`--no-build` happily tested the previous binary. That is the fourth stale-binary read in this
program. The lesson has now cost enough that it is worth stating plainly: when a build and a test run
in one command, the test result is meaningless unless the build's error count was zero, and grepping
for `error CS` is not the same as checking that count.

Lane green twice: 6311 passed, 0 failed.

## r319 — PRN reads its columns from position; the last carried item is closed

This is the item the program had been carrying since r298, and it was the right call to leave it
until the change could be made narrow enough to be safe. It now can be.

.prn writes fixed-width, so a cell's column IS its position, but the reader numbered
whitespace-separated tokens sequentially and discarded position. A row whose leading columns were
empty came back shifted left -- a value saved in B2 with A2 empty loaded into A2 -- which made .prn
the one adapter whose save-load-save could change a workbook's shape.

The columns are now recovered the way Excel's Text Import Wizard suggests them: a character position
blank on EVERY line is a separator, and the runs between separators are the columns. What makes this
safe rather than the sweeping rewrite r298 declined:

- **Tokenization is untouched.** Fields are still cut on whitespace runs exactly as before, so no
  file separates differently. Only the column INDEX comes from position.
- **The map is used only on evidence of a grid**: more than one column, and some line indented past
  the first. A file with no empty leading column takes the old sequential path unchanged -- which is
  precisely the case where a reader change could introduce a difference but never remove one.
- **Ambiguity falls back rather than guessing.** Where a line packs two tokens into a width another
  line fills completely, the rest of that line reverts to sequential columns instead of overwriting
  a cell, and a test pins that no token is dropped.

`R298_PrnWhitespaceReadShiftsLeadingEmptyColumnsTests` is INVERTED rather than deleted, exactly as
its own summary instructed a year of rounds ago: it now asserts the value keeps its column, and it
remains the assertion that would notice if the inference were removed or bypassed. The adapter's
remarks are rewritten too -- they described the shift as a documented cost, and leaving that text in
place would have been worse than the bug, since the next reader would trust it.

Lane green: 6315 passed, 0 failed.

**The carried list is now empty.** That is not a claim that no defects remain -- r310 through r318
each found something a well-covered area was hiding, and the method that found them is not
exhausted. It means every item this program recorded as outstanding has been fixed, or re-examined
and found not to be outstanding, or (in the two lock fields' case) traced to a decision recorded in
the product rather than a gap.

## r320 — renaming a loaded drawing object duplicated it

Extending r316's question to the other two drawing kinds found something better than a census: a
user-visible defect in the rename path, and a correction to what r316 concluded.

**r316's `Name` finding was wrong.** It reported that a source-loaded picture discards a rename.
True of the model in isolation; not true of the product. Every command that edits a drawing's
format, text or name clears `IsSourceLoaded` first, so the writer regenerates the object instead of
replaying its XML -- and `SelectionPaneCommands` says so in a comment describing the exact discard
r316 rediscovered. The mechanism was already understood and handled. r316 measured a state no user
can reach, which is what a reflection census does when the product's edit path does more than set a
property.

**What the realistic path does instead: it duplicates.** R124 fixed "rename is discarded" by
clearing the flag so the writer emits a fresh anchor under the new name. But the merger decides
which ORIGINAL anchors to supersede by matching each model's CURRENT name
(`GetRewrittenSourceObjectNames`), so after a rename nothing matches the original -- it is copied
through beside the regenerated object. Renaming a loaded picture, text box or shape left a SECOND
copy bearing the old name, and again on every subsequent rename. Fixed by recording the old name in
`DeletedSourceDrawingObjectNames`, which exists for exactly this ("keep this original anchor out of
the merge"); undo withdraws it, so undoing a rename restores the object rather than deleting its
source XML. Proved by removing the fix: all three kinds came back as
`{"Renamed", "Picture 1"}`.

**A census I had to throw away.** The first version of this round censused all 42 shape and 25
textbox members by reflection, reporting 34 and 16 discards. Both numbers were meaningless: the
product clears the flag on edit, and setting every member at once produces mutually invalid objects
-- with the flag cleared, the mass-mutated textbox vanished from the file entirely. The replacement
makes the edits the product makes, the way it makes them, through the real command. A census is the
right tool when a field is just data (r316's picture attributes); it is the wrong tool when reaching
the field goes through behaviour.

Lanes: Core.IO 6319/0 after the rename tests were added, App.Presentation 5610/0.

**Unrelated regression found on main, reported not absorbed**: `FreeX.Core.Model.Tests` has 19
stable failures clustered entirely on sheet-scoped defined names (`NamedRangeTests`,
`R92_FormulaAuditingServiceScopedNameTests`, `FormControlInteractionServiceTests`,
`R163_DataValidationDateListDisplayTests`). That lane was 6701/0 earlier in this same session, my
HEAD is r319, and my only uncommitted change is 27 lines in `SelectionPaneCommands` which none of
those tests reference -- so this arrived from another session's commit via a rebase, not from this
work. Recorded here rather than fixed, because a parallel session is likely mid-change in that area
and racing them would be worse than naming it.

### r320 correction — the "regression on main" was mine, and it was stale binaries again

The entry above reported 19 stable failures on sheet-scoped defined names and attributed them to
another session's commit arriving via a rebase. **That was wrong.** A `--no-incremental` rebuild of
`FreeX.Core.Model.Tests` makes the lane 6701 passed / 0 failed. There is no regression, and nothing
of another session's is broken.

What actually happened: rebasing onto origin/main brought new upstream sources into a tree whose
build artifacts were incremental, and the mixed result failed a coherent-looking cluster of tests.
The cluster is what made it convincing -- nineteen failures all on one feature reads exactly like a
real regression, not like a build problem.

Two things worth keeping from it. First, this is the SIXTH stale-binary incident in this program,
and the newest variant: the trigger was not my own probe but a REBASE, so "I did not touch anything
since the last good run" was not a defence -- upstream had. Any run after a rebase needs a clean
rebuild before its failures mean anything. Second, I nearly published a false regression report
naming another session's work. The check that caught it cost one rebuild; the report would have cost
somebody else a debugging session on a bug that does not exist. Verify before attributing, and
attribute to a build before attributing to a person.

## r321 — composing r320's fix

r320's fix put state on a SHEET-level list from inside a command
(`DeletedSourceDrawingObjectNames`). That is the shape of fix most likely to be wrong in the second
call rather than the first, so this round tests the orderings that touch it twice rather than adding
another single-rename case:

- rename twice -- one object survives under the final name, and the intermediate tombstone (for a
  name no source anchor ever bore) is harmless;
- rename then delete -- nothing comes back, neither the regenerated copy nor the original anchor;
- rename, undo, redo -- exactly one tombstone for the anchor, not two, and one object under the new
  name. The count is asserted directly, because a redo re-running `Apply` after `Revert` is the
  concrete way this fix would leak entries.

All pass; the fix composes. A clean result rather than a finding, and worth the round: the value of
a guard added to a mechanism I had just changed is highest immediately after changing it, while I
still know which orderings are load-bearing.

Lane green: 6325 passed, 0 failed.

## r322 — r320's class asked of both sister apps: neither has it, for two different reasons

r320's defect needed a specific precondition: a model that is BOTH editable and replayed from
preserved XML, reconciled by a mutable key. FreeX had all three (the merger supersedes originals by
matching the model's current NAME, which a rename changes). The question is whether FreeW and FreeP
share it.

**FreeW cannot, by construction.** A run carries either a modelled `InlineImage` -- which the writer
emits in full and the `SetImage*` commands edit -- or an opaque `PreservedDrawing` for a drawing the
reader could not model, which has no editable fields at all. The two are mutually exclusive, so
there is nothing to reconcile. Verified rather than assumed: editing a loaded image's alt text and
resizing it both survive a save and leave exactly one image, not two.

**FreeP has the precondition but handles it better than FreeX did.** A `ChartShape` can be modelled
AND carry `PreservedChartExXml` -- a verbatim `cx:chartSpace` replayed on save. `BuildChartExDoc`
parses that payload and patches each modelled aspect into it (title, legend, area formatting, series
layouts, shape properties, colour scales, data points, data labels), which is the mature form of
what FreeX's source-loaded rewriter does. The completeness question r316 would ask -- is that patch
list complete? -- has a deliberate answer: each patch is gated on an explicit
`ChartEx*EditRequested` flag, so an aspect is written only when an authoring command actually asked
for it. The in-code reason is exactly right: "a null high-level value can mean that a preserved
native legend has not been materialized yet". Patching unconditionally would clobber preserved
native state with model defaults, which is a worse failure than not patching.

I checked that by reading the two methods rather than matching their names against the model's
property list. Name-matching would have reported `PlotAreaFill`, `LegendOverlay` and
`LegendManualLayout` as unpatched, and all three are handled -- the same false-positive shape that
made r316's raw census 24 findings when six were real.

**So FreeX was the outlier, and the reason is worth keeping**: it reconciles by a key the user can
change. FreeW removes the reconciliation, FreeP makes the write-back explicit per aspect, FreeX
matched on a mutable name -- and that is where the duplicate came from.

Lanes green: FreeW.Core.IO 1941/0.

## r323 — the formula engine, by an invariant that needs no Excel

The formula engine is one of the areas this program had not touched. The obvious dimension is error
propagation, and the obvious test -- "every function propagates an error argument" -- is one I
cannot honestly write: Excel's rules for which functions swallow errors are intricate, this machine
has no Excel to check against (Excel COM is not registered here), and asserting my belief about
Excel would encode a guess as a contract. That is how this program has produced false findings
before.

So the test asserts something narrower that needs no external ground truth: whatever a VALUE-taking
function does with a literal `#REF!`, it must do the same when that error arrives through a cell
reference. There is no semantics under which those two differ, so a disagreement is a bug whatever
Excel does. The function list comes from `BuiltInFunctions.Names`, so a function added tomorrow is
covered by construction.

**Every value-taking built-in agrees** -- more than a hundred examined, no disagreements.

**The first run reported fourteen, and all fourteen were mine.** Twelve were reference-taking
functions (`ROW`, `COLUMN`, `COLUMNS`, `AREAS`, `SHEET`, `COUNT`, `ISREF`, `ISFORMULA`, ...), where
the two spellings are not two ways of passing the same thing: `A1` is a location and `#REF!` is a
broken location, so `ROW(A1)` answers 1 while `ROW(#REF!)` answers #REF! -- and `ROW` is not
entitled to look at what A1 CONTAINS. My invariant was true only of functions that consume a value,
and the qualifier is now in the summary rather than implied. The other two were `HSTACK`/`VSTACK`,
where `RangeValue` has no value equality, so two structurally identical ranges compared unequal --
fixed by comparing rendered content.

That the census came back clean is the result; that it took a corrected premise to get there is the
part worth remembering. A census is only as good as the invariant behind it, and an invariant that
sounds obviously true ("an error is the same error however it arrives") can still be false for a
whole category of the things being censused.

Lane green: FreeX.Core.Formula.Tests 5245 passed, 0 failed.

## r324 — the Avalonia shell, and a red lane r311 left behind

The shell's known crash class is re-parenting a long-lived control without detaching it first, which
Avalonia rejects at runtime. Three sites guard it explicitly against thirty-six that add a
field-held control to a panel -- and what separates the safe majority from the dangerous few is
whether the path can run TWICE. The existing launch guard constructs the window once and lays it out
once, so the dimension that decides whether this class fires was never varied.

`R324_ShellRebuildDoesNotThrowTests` drives each internal rebuild seam twice with a layout pass
between, so the second pass meets controls the first already parented. **It passes, and it is not
vacuous**: removing the sheet-tab detach guard fails it.

**It covers less than it first appeared to, and the probe is how I know.** Removing the
slicer/timeline pane's detach guard does NOT fail it -- that path only runs with the pane open, and
nothing in the test opens it (there is no internal seam that would). So the claim is exactly: this
guards the sheet-tab rebuild path. The pane's rebuild is still reachable only through parity capture
or a new seam, and its own in-code comment already describes what happens without the guard ("a
plain window resize is enough ... the second refresh with the pane open would take the shell down").
Stating that precisely is worth more than a test description implying the whole class is covered.

A source scan over the thirty-six add-sites was the alternative and was rejected: they cannot be
classified textually into "runs once" and "runs again", and guessing would have produced a list of
mostly-safe sites.

**r311 left this lane red and I did not notice for thirteen rounds.** `PivotFieldFilterSourceTests`
pins the comparer in `PivotFieldItemsReader` as source text, and r311 changed exactly that line from
CurrentCulture to Ordinal. I ran App.Presentation, Core.Model and Core.IO for r311 -- not
App.Avalonia, which is where this parity contract lives. The change itself stands (both shells share
that reader, so parity is unaffected; what changed is that a culture-aware set no longer merges two
source values the file keeps distinct), so the pin is updated to the new comparer with the reason
recorded beside it. The lesson is about lane selection, not the fix: "the lanes that build the code I
touched" is not the same set as "the lanes that assert about the code I touched", and a source-text
contract can live anywhere.

**Seventh stale-binary incident**, same shape: a `--no-build` run after a probe build reported the
slicer test failing, which briefly looked like the probe had found a second real defect.

Lane green: FreeX.App.Avalonia.Tests 2282 passed, 0 failed.

## r325 — closing the gap r324 measured in itself

r324 added a shell-rebuild guard and then, by probing, found that it did NOT cover the
slicer/timeline pane's detach: removing that guard left the test green. I recorded the gap rather
than closing it, on the grounds that no seam opens the pane. That was wrong -- the seam existed.

Two conditions had to hold at once, and each explains why the first attempt missed:
`RefreshSlicerTimelinePane` builds its header only when the ACTIVE SHEET has a slicer, and
`RefreshFromSharedWorkbook` returns early while the window is not visible. Showing the window and
adding a slicer anchored to the active sheet meets both, with no production change: `window.Session`
is already reachable from this lane, which existing tests here have used all along.

The new test refreshes twice so the second pass meets a close button the first already parented --
the exact sequence the pane's own comment describes ("a plain window resize is enough ... the second
refresh with the pane open would take the shell down"). **It fails with the guard removed and passes
with it**, which is what r324's version could not do.

Worth keeping: r324's probe did its job, and the value came from probing a PASSING test. It would
have been easy to add the rebuild test, see green, and record the class as covered. Removing each
guard in turn is what turned "this passes" into "this covers the sheet-tab path and not the pane" --
and that, once stated, was specific enough to close in one round.

Lane green: FreeX.App.Avalonia.Tests 2283 passed, 0 failed.

## r326 — the other commands that clear the flag, and a flake I had built into r313

**The r320 sibling question, answered.** r320 fixed the RENAME path, where clearing
`IsSourceLoaded` regenerated the object under a new name while the merger -- which supersedes
originals by matching the model's CURRENT name -- failed to drop the original. Format and text edits
clear the same flag but do not change the name, so the merger should still match. It does: changing
a source-loaded shape's fill and editing a source-loaded text box's text each leave exactly one
object. A prediction, checked, because r320 exists precisely because a prediction about this merge
was wrong once.

**And a flake in r313 that took three hypotheses to run down -- all mine.** The reproducibility
control failed roughly one full-lane run in four while passing in isolation every time.

1. *Thread-local caches*: my r313 helper runs each save on a fresh thread, and this codebase uses
   `[ThreadStatic]` for writable static caches, so a cold thread might differ from a warm one. I
   added a warm-up save. **Failures went UP** -- hypothesis falsified by its own fix, which I
   reverted rather than keeping a change that did nothing.
2. *Writer parallelism*: load-dependence suggests scheduling. There is no `Parallel.For` or
   `AsParallel` anywhere in the save path. Falsified.
3. Then I stopped guessing and captured WHICH part differed: `docProps/core.xml` -- the part holding
   `dcterms:created`. An earlier version of `StableContent` excluded it; the exclusion was lost when
   I refactored that method to report part NAMES, and its summary, which still promised the
   exclusion, was left in place. Two saves straddling a second boundary then differed.

The code and its own doc comment had disagreed for three rounds, and the comment was the accurate
one. Both hypotheses I chased were plausible, and both cost a full build-and-run cycle; asking the
failure what it was measuring cost one. **Get the failure to name the thing before theorising about
why it differs** -- the test was already printing the part name and I had been filtering it out of
the output.

Four consecutive full-lane runs green afterwards: 6327 passed, 0 failed.

## r327 — FreeP's ChartEx write-back is complete; four candidate gaps, four resolved

r322 established that FreeP patches each modelled aspect into a preserved `cx:chartSpace` and gates
each patch on an explicit `ChartEx*EditRequested` flag. It did not ask the completeness question that
r316 would: does every command that edits one of those aspects actually SET its flag, and does every
aspect the UI offers actually reach the file?

**The flag pairing is disciplined.** All four flags exist and all four are set; every write to a
gated aspect is immediately followed by its flag, and each command's `Revert` restores the PREVIOUS
flag value rather than clearing it, so an undo cannot strand the chart in "edit requested" state.

**Four candidate gaps, each traced rather than pattern-matched:**

- `Title`, `Legend`, area formatting, series aspects -- patched and flag-gated. Fine.
- `TitleOverlay` -- I thought this was lost, because the create-a-new-title branch writes `overlay`
  and the common case is a title that already exists. The update branch writes `overlay`, `pos` and
  `align` too. Fine, and I had to read the second branch to know it.
- `RoundedCorners`, `PlotVisibleOnly` -- read and written ONLY in the classic `c:` namespace. These
  are not cx concepts, so the writer is right not to emit them.

**The one residue is an affordance, not data loss.** `ChartDisplayOptionsPlanner` exposes
`RoundedCorners` and `PlotVisibleOnly` for every chart, gating only `SupportsChartExTitleLayout` on
`IsChartEx`. So the options dialog offers a waterfall or histogram chart two toggles that cannot
affect its file. Nothing is corrupted and nothing is silently discarded from a format that could
hold it -- the format has nowhere to put them. The fix, if wanted, is one more capability flag
beside the one already there. Recorded rather than done: it changes what a dialog shows, which is a
product call rather than a correctness one.

No code change this round. The survey's value is that the ChartEx write-back is now known-complete
against the aspects cx can represent, by tracing each candidate to its reader and writer rather than
by matching names -- which is what r322 warned about after name-matching would have reported three
handled aspects as unpatched.

## r328 — testing my own claim: the WPF parity capture runs here

I had been ending rounds by saying the remaining work included "running the parity-capture suite,
which reaches paths these headless lanes structurally can't" -- listed as something I could not do.
That was an assumption I had never tested, so this round tested it.

**It runs.** `FreeX.ParityCapture.Wpf.exe --parity-capture=<dir>
--parity-capture-target=dialog.Options.EaseOfAccess` completed in about a second, wrote a 744x521
PNG plus a manifest, shut down cleanly and left no stray process. The image is 20 KB, so it is not
one of the blank renders this codebase is prone to. Only the LINUX/Avalonia half needs Docker+Xvfb;
the Windows half needs nothing I do not have.

**A real obstacle found on the way, and fixed.** Two leftover MSBuild WPF temp projects
(`FreeX.ParityCapture.Wpf_llrvpq2r_wpftmp.csproj`, `FreeX.App.Host_yw3jtym5_wpftmp.csproj`) sat in
their source folders from interrupted builds. They are untracked, so they are not a repository
problem -- but they break `dotnet build <folder>` outright with MSB1050 ("contains more than one
project or solution file"). Anyone building either of those two projects by folder path, as every
build in this program has done, hits a hard failure whose message says nothing about temp files.
Deleted; both build cleanly again.

**The correction matters more than the capability.** I had repeated the "I can't run parity capture"
line across several rounds, and it had started to function as a boundary on what this program could
examine -- while being an untested assumption about my own tooling. Checking it cost one build and
one 300-second timeout. The lesson generalises past this tool: an assumption about what I cannot do
deserves the same probe as an assumption about what the code does, and it is cheaper to test than to
carry.

Capability now available for future rounds: WPF dialog and surface captures, per-surface, locally.

## r329 — using r328's capability: a capture that captured nothing reported success

r328 established that the WPF parity capture runs locally. This round used it, and the first thing
it found was in the harness rather than the product.

A full-suite capture writes 116/116 surfaces in about 13 seconds, none failed, no degenerate
dimensions (smallest 208x136), no blank renders. Diffing that against the promoted baseline in
`docs/parity/dialog-visual-assets/wpf-capture` showed twenty-plus differences, several halving in
byte size -- which looks exactly like content loss. **It is not evidence of one**: the wave notes
show those baselines are promoted from TARGETED per-surface captures, several of which seed
dialog-specific fixtures, while a full-suite run renders each dialog from generic state. Different
route, different content, no regression demonstrated. Reporting those twenty as visual regressions
would have been r316's census mistake at scale.

**Trying to separate route from regression is what found the real defect.** Re-capturing three of
the big movers with `--parity-capture-target` produced no files at all -- and the tool said
`wrote 0/1 surfaces` on a line that scrolls past, then **exited 0**. An explicitly requested surface
that captured nothing reported success. The documented way to refresh a promoted baseline is exactly
this per-surface route, so a mistyped or no-longer-reachable id yielded no file, no error and a green
exit, leaving whatever was already in the output directory to be promoted as though it were fresh.

Fixed: an explicit target that captures nothing now writes an error naming the id and exits 2, and
the startup carries the capture's outcome into the process exit code instead of `Shutdown()`'s
default 0 -- which also means a THROWN capture no longer exits green. Verified: bad target 2, good
target 0, full suite 0.

**A method note, because it nearly cost the finding.** My first exit-code measurement piped the run
into `grep`, so `$?` was grep's status and every run looked like 0. My own notes warn about exactly
that. Measuring again without the pipe is what showed the fix working -- and, before the fix, would
have shown the defect immediately.

`dialog.AdvancedFilter`, `dialog.DataTable` and `dialog.ForecastSheet` are reachable in the
full-suite route but not the targeted one. Whether their targeted ids are stale or those surfaces
were never targetable is a question for whoever maintains the surface catalog; the tool now says so
instead of exiting quietly.

## r330 — answering r329's handoff instead of leaving it

r329 ended by handing off a question: are `dialog.AdvancedFilter`, `dialog.DataTable` and
`dialog.ForecastSheet` stale targeted ids, or were they never targetable? The code answers it, so
handing it off was the wrong call.

**Never targetable.** The targeted route is not a lookup over the same catalog the full suite walks
-- it is a hardcoded `if/else if` chain supporting 23 enumerated ids plus three prefix families
(`dialog.FindReplace.*`, `dialog.PivotTableOptions.*`, `dialog.PageSetup.*`), against 116 surfaces
the full-suite route produces. The three ids were never in it. So a promoted per-surface baseline can
only ever cover the targeted subset, which is also why a full-suite capture is not comparable to it
(r329).

**The tool already explained itself, in the one place nobody looks.** `AddMissing` records a note
naming every supported id -- but only in `manifest.json`, which no one opens after a run that
appeared to succeed. Now that r329 makes such a run fail, the failure prints that note, so it carries
its own answer instead of sending the reader to the JSON to discover the id never existed. Verified:
the unsupported id prints the full supported list and exits 2; a supported id still exits 0.

Worth stating plainly, since it is the second time in three rounds: both r329 and r330 fixed
something whose information was already present and merely unreachable -- an explanatory note stuck
in a manifest, and a `0/1` count on a line that scrolls past. Neither was a missing capability. The
work was making what the tool already knew arrive where someone would act on it.

## r331 — the Avalonia half does not run here, and says nothing about it

r328 opened the WPF capture; the obvious next step was the Avalonia one, which would make a
local two-shell comparison possible without Docker. It does not work, and the way it fails is worth
recording.

The tool builds cleanly as a plain `net10.0` exe. Run on Windows with the same arguments the WPF tool
accepts, it **hangs and prints nothing at all** -- no banner, no error, no partial manifest -- until
killed. Two attempts, 150s and 600s, produced an empty log and zero files. It is built for the
Linux/Xvfb route, so this is outside its documented contract; the defect is not that it declines to
run but that it declines silently, leaving an operator to guess between "still working", "wrong
arguments" and "wrong platform".

That is the same family as r329 and r330 -- information the tool has and does not surface -- but
unlike those it sits behind a platform boundary I cannot verify a fix against here. Writing a
fail-fast guard I could not exercise on the platform it targets would be worse than naming it: I
would be guessing at what the Linux route needs, and a wrong guard would break the one route that
works.

**Correcting r328's phrasing.** I wrote that "only the Linux/Avalonia half needs Docker+Xvfb; the
Windows half needs nothing I do not have". True of the WPF tool, and I let it imply that the Avalonia
tool might substitute on Windows. It does not. A cross-shell comparison still requires the Docker
route; what is available locally is the WPF side alone.

## r332 — Docker was a second disk bomb, in a place the hygiene tooling never looked

r331 ended saying cross-shell comparison "still needs the Docker route", which I had never checked
was available. r328's lesson applied again: **Docker is installed and running here.** The base image
the documented Linux capture wants, `freex-linux-interactive:ubuntu24.04`, is already built.

Looking at what else was there found the round's actual result. `docker system df` reported **79.9 GB
of images and 77.6 GB of build cache**. 147 of those images were per-run parity-capture artifacts --
`freex-linux-interactive-app-<app>-<hash>:current`, about 2 GB each, one per Linux capture run, 76
for FreeX and 71 more for FreeW and FreeP. This machine's documented disk history is a 132 GB bin/obj
bomb that the reaper was written to clear; a comparable one had been accumulating in Docker, which
the reaper does not look at.

Removed the 147 per-run images: **79.9 GB down to 23.8 GB**. Non-forced, so anything still referenced
would have been skipped -- none were. The unhashed base tags survive, so the next capture does not
rebuild from scratch.

**The care here was in what I did NOT do.** Sixteen containers are running on this daemon and they
are the user's own Nextcloud and nginx-proxy stack, not FreeX test containers. A `docker system
prune`, the obvious command for a 158 GB report, could have taken down real services. The build cache
(77.6 GB, 21.5 GB reclaimable) is likewise shared with whatever else builds here and was left alone.
Scoped deletion of images this project's own tooling created is defensible; a broad prune on a
machine running someone's production stack is not, whatever the disk figure says.

The reaper now REPORTS leftovers (all three apps, matching only images with a per-run hash so base
tags are excluded) and prints the scoped reclaim command, rather than deleting anything itself --
for the same reason. Validated with the PowerShell parser and by running it.

**Two assumptions of mine were wrong in two rounds**: that parity capture could not run here (r328),
and that Docker was unavailable (r331/r332). Both were load-bearing in how I described the review's
limits, and both cost one command to check.

## r333 — the cross-platform parity comparison, run for real

r331 and r332 each corrected an assumption of mine about what I could run. This round used what they
established: the **full WPF-vs-Linux-Avalonia parity comparison ran end to end**, the thing I had
twice described as out of reach.

`Run-LinuxParityCapture.ps1` published linux-x64, ran the capture under xvfb in an owned container,
validated a nonblank PNG at the requested dimensions, and removed its container. Then
`FreeX.ParityCompare` captured both shells and compared 180 surfaces.

**The fidelity gate passes.** 115 surfaces present in both shells, `"passed": true`, and **0 hard
regressions**. The largest diffs are the documented chrome-by-design set -- `backstage.Info` 18.4%,
`backstage.Account` 16.4%, `backstage.Export` 16.0%, `dialog.CreateTable` 8.3% -- every one marked
`hardRegression: false`, matching what the matrix already records about the Avalonia shell's extra
toolbar row and native title bar. So cross-platform rendering is healthy at current main, verified
rather than assumed.

**But the suite cannot pass its own default invocation.** `RESULT: FAIL`, exit 1, on a clean tree
with a passing fidelity gate -- entirely from the name-box contract. It requires the Linux
`popup.nameBoxDropdown` to carry `evidenceProvenance: native-x11-root-crop` from a separate physical
selector; the default Linux capture route produces `managed-popup-diagnostic` instead, and the
contract is evaluated unconditionally (`Program.cs`: `comparison.Passed && nameBoxContract.IsValid`
decides both the printed result and the return code). There is no flag to skip it.

So anyone running the documented command on a healthy tree gets a red result caused by the capture
route rather than by the code. That is r317's lesson at suite scale: a gate that cannot pass teaches
people to ignore it, and the next real parity regression arrives in a report they have learned to
skim past.

**Not fixed, deliberately.** The two candidate remedies -- have the compare tool drive the physical
selector, or report the contract as not-evaluated when the capture route cannot produce its evidence
-- differ in what they promise, and someone made this a hard gate on purpose to force authoritative
evidence. Weakening it from the outside is exactly what r324 declined to do to a contract that had
just caught something. Recorded with the file, the deciding line, and both options.

Artifacts (198 MB of captures and diff images) removed; the container removed itself.

### r333 refinement — "cannot pass" was too strong

r333 said the parity suite "cannot pass its own default invocation". The first half is right and the
phrasing overreached, so here is the precise version.

A route that satisfies the contract exists and has worked:
`Run-FreeXLinuxInteractionValidation.ps1 -PhysicalOnly -PhysicalProbeSelector name-box-dropdown-parity`,
recorded passing `1/1` in wave183 with an authoritative unscaled 208x136 crop. It is a SEPARATE
tool. `FreeX.ParityCompare` never invokes it, its `--help` does not mention it, and its only way to
consume that evidence is the general `--skip-capture --lin-dir <dir>` path with a hand-assembled
capture directory.

So the accurate statement is: the suite CAN pass, but only through a multi-tool workflow that the
compare tool's own interface does not describe. Running the documented single command on a healthy
tree still returns FAIL and exit 1 for a reason that is about capture plumbing rather than the code
-- which is the part worth fixing, and still a product call about which of the two remedies to take.

Worth noting that the correction came from asking one more question -- "is there a route that DOES
satisfy it?" -- after I had already written the finding up. The finding was real; the sweeping half
of the sentence was not, and it took one grep to find that out.

## r334 — clearing a shape's text produced a schema-invalid .pptx

FreeP already runs `OpenXmlValidator` in eight places, and this ledger's own notes call the pptx
writer a recurring source of element-order and relationship-allocation bugs -- exactly the class a
schema validator catches. But each of those eight validates a deck built for its own feature, so
every one is a SINGLE-feature package, and a part that is well-formed alone can still be wrong beside
a neighbour. So this writes one deck carrying several shape kinds together and validates the whole
package.

**It failed immediately**, and on something simpler than an ordering interaction:
`The element has incomplete content. List of possible elements expected: <a:p> @
/p:sld[1]/.../p:txBody[1]`. `CT_TextBody` requires at least one `a:p`, and the writer emitted a
`txBody` with none whenever the model's paragraph list was empty.

**Reachable two ways in the product, not just in my fixture** -- which is the part that makes it a
defect rather than a fixture artefact:

- `SlideShape.Text = ""` creates a `TextBody`, clears its paragraphs and adds none. So typing text
  into a shape and then clearing it again leaves exactly this state.
- `HeaderFooterCommandPlanner` creates header/footer placeholders with `TextBody = new TextBody()`.

Either way, saving produced a package that violates the schema -- the shape of defect PowerPoint
reports as a file needing repair. `TextBody`'s own doc comment says the list "may be empty for a
shape with no text", so the model is behaving as designed and the writer was not honouring it.

Fixed by emitting an empty `a:p` carrying only `endParaRPr` when the list is empty, which is what
Office itself writes for an empty text box. Proved by reverting: both tests fail without it. The
second test drives the product path (`Text = "typed"` then `Text = ""`) rather than the synthetic
one, so the guard survives someone deciding the fixture was unrealistic.

Lane green: FreeP.App.Presentation.Tests 5917 passed, 0 failed.

The lens is worth restating because it keeps working: eight existing validators all passed while the
defect sat behind them, because each validated a package containing only its own feature. What found
it was combining features in one package -- the same shape as r310 (nothing varied which sheet was
active) and r324 (nothing varied how many times a region was rebuilt).

## r335 — the same lens on .docx: every table FreeW wrote was schema-invalid

r334's lens carried straight across. FreeW has twenty-one `OpenXmlValidator` tests and every one
validates a document built for its own feature -- BuildingBlockGallery, CheckBox, Citation, TabIndex,
one content-control per file. So this wrote ONE document combining styled paragraphs, a table, an
inline image, a hyperlink and an empty paragraph, and validated the whole package.

**`w:tbl` had `w:tr` where `w:tblGrid` belongs.** `CT_Tbl` is `tblPr, tblGrid, rows` and the grid is
mandatory, but the writer emitted it only `if (table.ColumnWidthsPt.Count > 0)`. Reachable through
the model's own factory: `Table.Create(rows, columns)` builds a uniform table and assigns no widths,
so inserting a table and saving produced an invalid `.docx`.

Fixed by always emitting the grid. `w:w` is optional on `w:gridCol`, so when the model has no widths
the grid declares the column COUNT and lets Word autofit, rather than inventing measurements.

**The fix broke an existing test, and that test was right.** `Table_WithoutShadingOrWidths_
StillRoundTrips` asserts a width-less table comes back width-less. Now that a grid is always written,
the reader -- which called `DxaToPoints(gridCol.Attribute("w")?.Value)` unconditionally -- invented a
width from an attribute that was not there. So the reader had a latent bug the writer had been hiding
by never emitting a width-less grid. It now takes widths only when EVERY column declares one, since
a partial set would misalign the columns it does describe.

That is the second time in two rounds that a schema violation sat behind validators that all passed,
and the first time the fix exposed a matching hole on the read side. Worth noting the sequence: the
failing existing test was the thing that found the reader bug, and the temptation was to treat it as
fallout from my change.

Lane green: FreeW.Core.IO.Tests 1943 passed, 0 failed.

## r336 — the lens completes the set: FreeX is clean, and the reason matters

r334 and r335 applied one lens -- validate a package carrying SEVERAL features at once, rather than
one built for a single feature -- and each found a schema violation sitting behind validator tests
that all passed. This closes the set with the third app.

**FreeX is clean.** A workbook combining two sheets, two registered styles, a merged range, a
hyperlink, a comment and a formula validates with no schema errors. Verified, not assumed, and with
a content-based vacuity guard (the package must actually contain the `mergeCell` and `hyperlink` it
claims to combine) rather than a size heuristic -- r335's first attempt failed on a 3902-byte package
because I had guessed 4096 as a floor, which measured my guess and nothing else.

**Why two of three apps failed the same lens is the useful part.** FreeX's `.xlsx` skeleton comes
from ClosedXML, which constructs the package structurally; FreeP and FreeW hand-build their XML with
`XElement`. Hand-built XML is where "emit this child only when we have a value for it" produces a
missing MANDATORY element -- FreeP's `txBody` without an `a:p`, FreeW's `w:tbl` without a
`w:tblGrid`. Both defects were conditional emission of a required element, and both apps that had
them build their parts by hand. That is a structural prediction about where to look next in those two
writers, not a coincidence about two features.

Lane green: FreeX.Core.IO.Tests 6328 passed, 0 failed.

## r337 — testing r336's hypothesis: half right, and the half that held found another defect

r336 predicted that FreeP's and FreeW's hand-built writers would have MORE mandatory elements
emitted conditionally. Tested on both.

**FreeW: no.** A document adding a header, an empty footer, a footnote, an endnote and a bookmark to
r335's fixture validates clean. So the `tblGrid` bug was a single site, not a pattern -- worth
knowing, because "hand-built writers are riddled with this" would have been the easy conclusion from
two data points and it is not what the evidence says.

**FreeP: yes, at a second site.** A table cell whose text body exists but has no paragraphs writes a
`txBody` with no `a:p` -- r334's exact defect, in the table-cell writer rather than the shape writer.
r334 fixed one and left the other.

The telling detail: the neighbouring `else` branch, for a cell with NO text body at all, already
emits `<a:p/>` with the comment *"Empty txBody is required by spec"*. The author knew the rule and
had written it down three lines away; the gap was the case where a body exists and is empty. Fixed
the same way.

**What this says about the lens.** r334's fix was correct and incomplete, and nothing in that round
could have revealed the second site: its fixture had no table. The multi-feature idea is what found
both -- first by combining features to expose the class, then by adding one more feature to find the
class's second instance. A prediction that is half wrong is still worth testing; the half that held
was a real bug and the half that failed corrected an over-generalisation I would otherwise have
carried.

Lanes green: FreeP.App.Presentation.Tests 5918/0, FreeW.Core.IO.Tests 1943/0 (r335's three tests plus
the new one).

## r338 — finishing the class instead of waiting for it to resurface

r334 fixed one `txBody` site; r337 found a second because a later fixture happened to include a
table. Rather than wait for a third fixture to expose a third site, I enumerated them: five
`txBody` constructions in `PptxPackageWriter`, of which one hardcodes a paragraph (fine), one is the
already-correct "no body at all" branch, and three take the model's paragraph list.

The third is `BuildNotesTxBodyEl`, and it had the same defect. Fixed, with a test, and the fix proved
by reverting.

**Its reachability is weaker than the other two, and the entry says so.** Clearing a slide's notes
sets `Slide.Notes` to null rather than to an empty body, so no editing path demonstrably reaches it;
what does is loading a `.pptx` whose notes slide carries a body with no paragraph. I fixed it anyway
because leaving one of three identical sites is precisely how r334 came to need r337 -- and because
the cost of a wrong guess here is a redundant three-line guard, while the cost of the other guess is
another round.

That closes the class in this writer by enumeration rather than by encounter. The distinction is
worth keeping: r337 found its site because a fixture grew, which is luck; this one was found by
asking how many sites exist, which is not.

Lane green: FreeP.App.Presentation.Tests 5919 passed, 0 failed.

## r339 — the same enumeration on FreeW: clean, and that is the finding

r338 closed FreeP's `txBody` class by counting the sites rather than waiting for fixtures to trip
over them. Applied here to the writer that produced r335's `tblGrid` defect, on the states a
feature-demonstrating fixture never contains:

- an EMPTY table cell -- the direct analogue of FreeP's empty `txBody`, since `CT_Tc` requires a
  block-level child just as `CT_TextBody` requires an `a:p`. r335's fixture put text in every cell
  and could not have found it;
- a document with every block deleted;
- a table row that lost its last cell.

**All three validate.** FreeW guards each of these already.

That result is worth a round on its own. After r334, r337 and r338 -- three fixes of one shape in one
writer -- the live hypothesis was that "emit a required child only when a value exists" is how these
hand-built writers are written generally. It is not. FreeP's writer had it three times and FreeW's
had it once, in a spot (`tblGrid`) whose conditional was about WIDTHS rather than about content. The
pattern was specific to one writer, and knowing that stops the next reader from going through
FreeW's writer looking for a class that is not there.

Six schema tests now cover the .docx writer across combined features and degenerate shapes.

Lane green: FreeW.Core.IO.Tests 1947 passed, 0 failed.

## r340 — the degenerate end, on all three writers

r336 validated a feature-RICH package for each app; r339 did the degenerate end for FreeW. This
finishes the symmetry, because the two ends fail for opposite reasons and a fixture built for one
never reaches the other. r334's defect lived at the degenerate end (an empty text body), r335's at
the rich end (a table beside other features) -- so covering only one would have missed a real bug
either way.

**FreeX** -- a workbook whose only sheet has no cells; a sheet whose last cell was cleared back to
blank; a merged region spanning cells that carry no values. All validate.

**FreeP** -- a deck whose slide has no shapes; a shape with NO text body, which is a different state
from r334's empty one and takes a different branch. Both validate.

All clean. Combined with r339, the degenerate end is now covered for all three writers, and the one
place it found something was FreeP's empty `txBody` -- already fixed at all three of its sites by
r334, r337 and r338.

**What the whole seven-round sequence (r334-r340) actually established**, since "seven rounds, four
fixes" undersells the negative results: schema validity is now pinned for all three apps at both the
rich and degenerate ends; the "conditional mandatory element" class exists in FreeP's writer (three
sites, all fixed) and at exactly one spot in FreeW's (fixed); FreeX has it nowhere, because its
package skeleton comes from ClosedXML rather than hand-built `XElement`. That last point is the
reusable one -- it predicts where to look first if this class ever surfaces again.

Lanes green: FreeX.Core.IO 6331/0, FreeP.App.Presentation 5921/0, FreeW.Core.IO 1947/0.

## r341 — schema validity is not data survival

r334-r340 established that all three writers produce schema-valid packages at both the rich and
degenerate ends. That is a statement about parsing, not about content: a package can be perfectly
valid and still be missing what the user put in it. Degenerate content is where the two diverge,
because "there is nothing here" is a defensible thing for a reader to conclude and a wrong thing to
do with a structure the user created deliberately.

So each app was asked whether its degenerate content comes BACK:

- **FreeX** -- two empty sheets beside a populated one. All three return. An empty sheet is a sheet;
  dropping it loses structure the user made.
- **FreeP** -- an empty slide before and after a populated one. All three return. Dropping one would
  renumber every slide after it.
- **FreeW** -- two consecutive empty paragraphs between text. Both return, in place. Those are blank
  lines the user typed, and a reader that skips "empty" content reflows the document.

**All clean.** No fixes this round.

The distinction is the point, and it is not hypothetical for this codebase: r310's defect (a
single-sheet save keeping the wrong sheet) and r320's (a rename leaving a duplicate) were both
content losses through paths that produced perfectly valid files. A schema validator would have
passed every one of them. Adding these three tests costs almost nothing and closes the gap between
"the file parses" and "the file says what it said before".

Lanes green: FreeX.Core.IO 6332/0, FreeP.App.Presentation 5922/0, FreeW.Core.IO 1948/0.

## r342 — checking that my own fixes do not accumulate

r341 showed degenerate content survives ONE round trip. That is not stability. The fixes r334, r337
and r338 all work by ADDING an element the model did not have -- an empty `a:p` where a text body
carried no paragraph -- and that is precisely the shape that accumulates: if the reader turns the
added paragraph into real content, the next save adds another beside it, and a document grows a blank
line per save. A single round trip cannot see it, because generation one is where it looks correct.

So each fix was run three generations deep and compared against the first:

- **FreeP** -- a shape with an empty text body, paragraph count compared across three save/load
  cycles. Stable. The added `a:p` does not round-trip into a paragraph that then gets a sibling.
- **FreeW** -- a document with an empty paragraph between two populated ones, three generations.
  Stable, and the blank line stays exactly one.

**All clean.** No fixes.

This round exists because of what r334-r338 did rather than in spite of it: four fixes that make the
writer emit something extra deserve a check that the something extra is idempotent, and the natural
time to run it is immediately after, while the mechanism is still fresh. Convergence over generations
is a property this ledger already knows about (r299/r300 tested it for whole packages); what was
missing was applying it to the specific elements this sequence introduced.

Lanes green: FreeP.App.Presentation 5923/0, FreeW.Core.IO 1949/0.

## r343 — generation stability for the third writer, where the mechanism is built in

r342 checked FreeW and FreeP; this completes it. FreeX is the one where the accumulation mechanism
is not hypothetical: `ApplyPackagePostProcessing` re-captures each saved package as the SOURCE
package for the next save, so whatever one save adds is replayed by the following one, by design.
That is the same feedback loop r316-r320 worked in from the other side.

Three generations, comparing sheet count, merged-region count, a cell value and a formula. **Stable
at every generation.** No drift.

Worth stating what this does and does not cover: it measures a shape (counts and two cells), not the
whole package, so it would miss drift in a part nothing here reads. The stronger property -- byte
stability across generations -- is r313's territory, and r313 found a real defect there (a random
relationship id) which is now fixed. Between them the two cover the same loop from opposite ends: one
asks whether the bytes stop changing, the other whether the content does.

With r342 this closes generation stability for all three writers.

Lane green: FreeX.Core.IO 6333 passed, 0 failed.

## r344 — closing r343's stated limitation, and two probes that would not fail

r343 said of itself that it compared a shape -- counts and two cells -- so drift in a part it never
read would be invisible. This compares EVERY part of the package, generation over generation, and it
is stronger than r313's control: there the same in-memory model was saved twice, here the model goes
back through the READER between saves, so a part that survives writing but is re-read slightly
differently surfaces on the next write.

**Every part is byte-identical across three generations.**

**The interesting part is that I could not make it fail on purpose.** Two attempts to prove it had
teeth, both by breaking the product:

1. Reverting r313's relationship-id normalizer. Passed.
2. Making that normalizer emit a random id per save. Passed.

Neither is a flaw in the probes -- it is a fact about the architecture, and a useful one. Those paths
only run on a FRESH workbook save; generations two and three take the source-package path, which
replays the root `.rels` VERBATIM. The random id is therefore frozen at generation one and cannot
drift, which is exactly why r313's control (two saves of a fresh model) caught the defect while a
generation loop structurally cannot. The two tests are not redundant; they cover different halves of
the same save.

Rather than ship a comparison whose power was unproven, the test now demonstrates its own
sensitivity: a workbook with one extra cell must compare as DIFFERENT, asserted in the same test. A
stability claim from a comparator that cannot see differences is worth nothing, and after two failed
probes that was a live possibility rather than a formality.

Lane green: FreeX.Core.IO 6334 passed, 0 failed.

## r345 — an independent implementation reads FreeX's ODS correctly

r334-r344 checked the three OOXML writers against a schema validator. ODS has no equivalent validator
to hand, but it has something better available on this machine: LibreOffice, the reference
implementation of the format. This ledger already records that the format-fidelity harness is
same-implementation round-trip and therefore structurally blind to wire-format bugs -- LibreOffice is
the oracle that is not.

A multi-feature workbook (two sheets, a bold header, a currency-styled number, a formula, a merged
range, a hyperlink, a comment) was written to `.ods` and handed to LibreOffice headlessly:

- **Values** -- converted to CSV, every cell reads back correctly.
- **The formula recomputed.** `SUM(B2:B2)` produced 1234.5 in LibreOffice's own evaluation, so it was
  parsed as a formula rather than salvaged as a cached value.
- **Round-tripped as a formula.** FreeX writes `table:formula="of:=SUM([.B2:.B2])"` -- correct
  OpenFormula, with the `of:` prefix and bracketed reference syntax -- and LibreOffice re-emits it as
  `<f aca="false">SUM(B2)</f>` when converting to .xlsx.
- **Structure survives** -- both sheets by name, and the merge as `A5:C5`.

**Clean, by an oracle that shares no code with us.** Every other check in this program's file-format
rounds has been FreeX reading FreeX, or FreeX against a schema; this is the first that asks a
different implementation whether the file means what we intended.

Not committed as a test, deliberately: it depends on LibreOffice being installed, and a test that
silently skips on machines without it would report green while checking nothing -- the failure mode
this program keeps finding. The commands are recorded here instead so the check is repeatable by
hand:

```
soffice --headless --norestore --convert-to csv  --outdir <dir> <file>.ods
soffice --headless --norestore --convert-to xlsx --outdir <dir> <file>.ods
```

## r346 — LibreOffice reads FreeW's .docx correctly, and nearly caught me twice

r345 used LibreOffice as an oracle for ODS. It reads .docx too, so the same check extends to FreeW --
the first time this program has asked an independent implementation whether a FreeW file means what
was intended.

**Everything resolves.** A document with a styled heading, body text, a hyperlink, a 2x3 table and a
trailing empty paragraph converts cleanly: all text in order, the table as a real table (one
`table:table`, six `table:table-cell`), and the hyperlink with its exact URL.

**Two things looked like defects and were mine.**

1. LibreOffice showed no heading -- the styled paragraph arrived as plain text. The document
   referenced `<w:pStyle w:val="Heading1"/>` while `styles.xml` defined no styles at all, which looks
   exactly like a writer emitting a dangling style reference. It is not: the product defines the
   style first (`FreeWSampleDocumentFactory` does `document.Styles["Heading1"] = new DocumentStyle{…}`
   before referencing it), and my fixture invented the id from nothing. Rebuilt the way the product
   does it, `styles.xml` carries `w:styleId="Heading1"` and LibreOffice resolves it.
2. Then the heading still had no `outline-level`, which looks like FreeW not marking headings as
   document structure. Also mine: `DocumentStyle.OutlineLevel` exists and `DocxWriter` emits
   `w:outlineLvl` when it is set. My fixture did not set it.

Both were caught by asking where the product gets the value before believing the file was wrong --
the same check that turned r316's twenty-four "losses" into six. An external oracle raises the stakes
on that discipline rather than lowering them: a real implementation disagreeing with us is
persuasive, and it was reporting faithfully on a document I had built badly.

Remaining for this oracle: FreeP's .pptx, which LibreOffice also reads.

## r347 — the oracle completes: LibreOffice reads all three apps' output

r345 (ODS) and r346 (.docx) asked an independent implementation whether our files mean what we
intended. This finishes the set with FreeP's .pptx.

A two-slide deck -- a titled shape, speaker notes, a 1x2 table with text in both cells, and a second
shape on slide two -- converted to .odp:

- **Both slides** arrive as `draw:page`.
- **The table is a table**: one `table:table`, two `table:table-column`, one `table:table-row`, two
  `table:table-cell` -- structure, not flattened text boxes.
- **Every string survives**: the title, the second slide's body, and both cell texts.
- **Speaker notes survive** as notes content, not as a stray shape.

**All three apps now verified against an implementation that shares no code with them, and all three
are clean.**

One process note, small but the same shape as r346's two: my first check reported `table:table` as
ABSENT while two cells were present, which reads like a table flattened into loose cells. It was my
grep -- the pattern had a trailing space and `<table:table>` carries none. Checking the element
properly showed the full structure. Three rounds running, the thing that looked like a defect was in
the measurement rather than the product, and each took one command to settle. The oracle is only as
good as the question put to it.

## r348 — the remaining four FreeX formats against LibreOffice

r345-r347 checked ODS, .docx and .pptx against an independent implementation. FreeX writes four more
formats a spreadsheet can round-trip: DIF, SLK, HTML and SpreadsheetXML. All four were handed to
LibreOffice.

**All four clean.** Values, signs and decimals correct in every one, and the formula cell's computed
total (1234.25) arrives in all four.

**The interesting part was a false alarm I nearly filed.** The first run showed DIF and SLK exporting
the formula row as EMPTY -- `Total,` with no number -- while SpreadsheetXML got it right. That reads
like two writers dropping a formula cell.

They were reporting faithfully. My fixture called `SetFormula` and never recalculated, so the cell
carried a formula and no computed value; SLK duly wrote `C;Y4;X2;K"";ESUM(R[-2]C:R[-1]C)` -- the
formula correct, the cached value an empty string, because that is what the model held. Giving the
cell the value a recalc leaves behind, both export `Total,1234.25`. SpreadsheetXML "got it right"
only because LibreOffice recomputed the formula it wrote.

HTML looked like a third failure -- no output at all -- and was also mine: LibreOffice opens HTML in
Writer unless told otherwise, so the conversion produced a text document rather than a sheet. With
`--infilter=calc_HTML_WebQuery` it reads correctly.

**Five measurement errors in six rounds** (r345's grep, r346's two fixture gaps, r347's grep, and
these two). Every one looked like a product defect, and every one was answered by asking where the
value comes from before believing the file was wrong. That ratio is worth stating plainly: at this
depth, the failure mode is no longer missing bugs -- it is inventing them.

All seven formats FreeX and its siblings write are now verified against an implementation that
shares no code with them.

### r331 refinement — the Avalonia capture never starts on Windows, and my proposed fix would not have run

r331 recorded that the Avalonia capture "declines silently" on Windows and proposed a fail-fast guard
as the obvious remedy, deferred because I could not verify it on the platform it targets. r332 later
established Docker IS available here, which removed that blocker -- so the deferral was revisited.

One diagnostic settled it: the tool hangs identically on `--help` and on `--version`, producing zero
bytes before being killed. It never reaches argument handling. The block is at STARTUP, not in the
capture path.

Two things follow. The finding is sharper than r331 stated -- not "declines silently" but "never
starts". And **the fix I proposed would not have worked**: a guard inside the capture code cannot run
when nothing gets as far as parsing `--parity-capture`. Had I implemented it in r331 as the obvious
remedy, it would have shipped as a guard that never fires, and looked like a fix.

Left unfixed deliberately, now for a better-founded reason than r331 gave: the block is in Avalonia
app startup on a platform this tool does not target, its product impact is nil (a dev tool, and the
Linux route it exists for works -- r333 ran the full comparison through it), and locating it means
debugging desktop-lifetime initialisation rather than adding a guard anywhere.

## r349 -- PDF export against an independent extractor (clean)

Dimension: the PDF backends, checked with an oracle that shares no code with us
(`pdftotext`, poppler, shipped with Git for Windows). Motivation: every existing PDF test asserts
our own raw output (`pdf.Should().Contain("(Hello) Tj")`) -- the same-implementation pattern the
LibreOffice sweep exists to escape. Nothing checked that a real reader can recover the text, which
is what "search and copy/paste in the exported PDF" means for a user.

Probe: one page, ASCII plus an accented word, written by BOTH backends and extracted.

- `PortablePdfWriter` (dependency-free, WinAnsi Helvetica) -- text recovered exactly.
- `SkiaPdfWriter` (embeds/subsets fonts) -- text recovered exactly.

No defect. Three further checks, all correct as built:

- `PortablePdfDocumentExporter` preflights via `PortablePdfTextCapabilityPlanner` and refuses with a
  clear message before writing, so the WinAnsi limit surfaces as a message, not corrupt output.
- `SkiaPdfDocumentExporter` does NOT apply that WinAnsi gate. This is the right split and worth
  stating, because the tempting bug is the opposite: letting the fallback's capability constrain the
  primary path, which would block Unicode export on the backend that handles it.
- `PdfBackendFallbackExecutor` truncates the stream (`Position = 0; SetLength(0)`) before running the
  portable fallback, so a partial Skia write cannot be appended to. It skips truncation on a
  non-seekable stream, but the catch filter is `IsSkiaUnavailable`, which is decided on first use --
  before bytes exist -- so the corrupt-append case is not reachable from these callers.

Not pinned in-repo, deliberately: extractability of the SKIA output cannot be asserted without a PDF
text extractor as a test dependency. Its objects are compressed, so a `strings`-level check for a
ToUnicode CMap is inconclusive (it returned 0 for both files that extracted perfectly -- a detector
that would have produced two false findings had I trusted it). The portable side's guarantee IS
pinned already, by the existing `/Encoding /WinAnsiEncoding` assertion.

Standing gap confirmed, not a regression: `FreeX.App.Host` (the WPF shell) has no PDF exporter --
the FreeX side of the "Save as PDF in every app and platform" requirement is still Avalonia-only.

## r350 -- fmtScheme style lists below the schema minimum (FreeP, FIXED)

Swept the defect class that produced four bugs earlier in this program: a schema-REQUIRED child
emitted only when its collection happens to be non-empty. Both hand-built writers were checked
against every conditional-emission guard they contain -- 31 in `PptxPackageWriter`, 23 in
`DocxWriter`.

The class itself is now exhausted. The guarded elements in FreeW are `w:tabs` (optional) and the
`w:hdr`/`w:ftr` ROOTS, which turned out not to be guarded at all: the `Count > 0` beside them gates
the part's .rels, correctly, while the root is written unconditionally. The four instances fixed in
r334/r335/r337/r338 were the four that existed.

But the sweep found a NEIGHBOURING defect in the same file, of a shape the earlier fixes did not
have. `BuildThemeFormatSchemeXml` handled an EMPTY style list (generic 3-slot defaults) and a full
one (reuse verbatim, which is what stops real effect styles being discarded on save). All four lists
are `minOccurs="3"` in DrawingML, and one or two entries fell BETWEEN those branches and were
written straight back out. `OpenXmlValidator` rejects the package: "The element has incomplete
content" on `fillStyleLst` and `lnStyleLst`. Reachable by opening a .pptx whose theme carries a
short style list and saving it -- the file FreeP writes is then schema-invalid.

Worth naming: this is the same guard the r334 comment says was already fixed once, for the empty
case. Fixing the degenerate end of a range does not fix the range.

Fix: one `StyleListEntries` helper behind all four lists. Empty still takes the defaults; a short
list is padded to three by repeating its own LAST entry, not a stock placeholder, because a
`fillRef`/`lnRef` `idx` is a 1-based index into the list -- slots 1..N must keep their positions, and
a reference past N is already outside the source's contract, where the theme's own final style is
the closer answer. Lists longer than three are untouched: the schema sets a minimum, not a cap.

Pinned by `R350_ThemeStyleListsMeetSchemaMinimumTests` in both directions -- 1 and 2 entries
validate, padding preserves slot 1, a complete list is written back verbatim IN ORDER, and a
four-entry list keeps its fourth. The order and pass-through assertions matter as much as the
padding: padding a short list would be worthless if it quietly reordered or truncated a good one.
Fail-before is genuine -- the probe failed on the unfixed writer with the two validator errors above,
then passed.

Regression check: FreeP.App.Presentation.Tests 5928/0, FreeP.App.Host.Tests 2540/0.

## r351 -- theme font patch silently swallowed the edit (shared, FIXED)

Followed r350's lens into the neighbouring builder. `BuildThemeFormatSchemeXml` and
`BuildThemeFontSchemeXml` sit next to each other and use the same preserve-the-source-verbatim
pattern, so having found a gap in one, the other was the obvious place to look. It had a worse one.

`DrawingMlThemeXml.TryPatchNativeFontScheme` applied the caller's typeface through a `?.` chain:

    fontScheme.Element(A + "majorFont")?.Element(A + "latin")?.SetAttributeValue("typeface", ...)

A source `a:fontScheme` missing `a:majorFont` or its `a:latin` therefore SILENTLY SWALLOWED the
edit -- the method returned the unchanged XML as though it had patched it, so the theme font the
user picked never reached the file. No error, no diagnostic, and a saved document that looks
correct. On top of that the returned XML failed validation, because `CT_FontCollection` requires
`latin`, `ea` and `cs` in that order: the probe package came back with "The element has incomplete
content" on `minorFont` and "has unexpected child element" on `majorFont`.

This is a SHARED helper with two consumers, so both apps had it: FreeP through
`PptxPackageWriter`, and FreeX through `WorkbookTheme.WithFonts`, whose result is exactly the XML
that gets saved. Neither had a test with a partial native scheme.

Fix: `ApplyLatinTypeface` creates whatever the source omitted -- the collection itself (seated
major-before-minor), then `latin`/`ea`/`cs` -- applies the typeface, and re-seats the three required
children at the front in schema order, which leaves script-specific `a:font` children after them
untouched.

This is the standing "never let reflection-shaped code silently no-op" rule showing up in plain
LINQ-to-XML. The rule is about the SHAPE -- a nullable handle plus a null-conditional call -- not
about reflection, and it is worth restating that way, because that shape is far more common in
XML patching than it is in reflection.

Pinned by `R351_ThemeFontPatchCreatesMissingStructureTests` (6 tests, in FreeX.Core.Model.Tests
where the shared helper is already covered): missing `latin` still receives the typeface, a missing
collection is created in order, the required three come first, script-specific fonts survive after
them, a complete scheme keeps its East-Asian/complex-script detail, and FreeX's own `WithFonts`
carries the change through. Revert probe: 4 of the 6 fail on the unfixed helper. The 2 that pass in
both states are the preservation tests -- they exist to catch the fix DAMAGING a good scheme, so
passing before is what they should do.

Regression check: FreeX.Core.Model.Tests 6707/0, FreeX.Core.IO.Tests 6334/0,
FreeP.App.Presentation.Tests 5928/0.

## r352 -- sweeping the r351 shape, and a tripwire that was vacuous (FreeW)

Swept the r351 defect shape across all three apps: a MUTATION applied through a `?.` chain, which
does nothing at all when the path is absent. `?.Remove()` is excluded -- removing something already
missing is the intended no-op. That leaves three sites. Two are `chartXml.Root?` /
`worksheetXml.Root?` on documents that cannot lack a root and would be unusable if they did.

The third, `DocxWriter.LoadSmartArtLayoutTemplate`, stamps a diagram's gallery category into an
embedded template's `dgm:catLst/dgm:cat` through the chain. A template without a `catLst` would keep
the stock category silently, filing the diagram under the wrong gallery in Word.

FALSE POSITIVE FIRST, and worth recording as such: `orgChart1-data-chain.xml` has no `dgm:cat` at
all, which looked like a live instance. It is loaded by a different code path that never applies a
category. Tracing the consumer before believing the finding again earned its keep -- fourteenth time
in this program. All four templates that DO take the category path carry the element, so there is no
live bug; the `?.` was latent.

Guarded anyway, per the standing rule about this shape: the writer now throws, naming the resource,
so a template added without a `catLst` fails at the point of use rather than shipping a mislabelled
diagram.

Then the part worth the entry. A guard without a tripwire only converts a silent bug into a crash,
so `R352_SmartArtLayoutTemplatesCarryACategoryTests` asserts the four templates carry the element.
Its first draft was written as

    root.Element(Dgm + "catLst")?.Element(Dgm + "cat").Should().NotBeNull(...)

and PASSED when pointed at `orgChart1-data-chain.xml`, which has no `catLst` whatsoever: the `?.`
short-circuits, so `.Should()` never runs. The test for the silent-no-op defect was itself a silent
no-op. It only surfaced because the negative control was run against a real file known to lack the
element -- the four real templates went green either way, so nothing else in the round would have
caught it.

Two things follow. First, `?.` before an ASSERTION is the same hazard as `?.` before a mutation, and
a fluent-assertion library makes it invisible because the expression still compiles and reads
correctly. Second, "prove the test can fail" is not satisfied by reasoning about the assertion; only
running it against a genuinely bad input distinguishes a real check from a vacuous one. Both are now
recorded in the test itself, since that is where the next reader will need them.

Regression check: FreeW.Core.IO.Tests 1953/0.

## r353 -- 600+ XML assertions that could not fail (all three apps, FIXED + 3 defects found)

r352 found a tripwire that passed against the very input it existed to reject, because a `?.`
short-circuited before `.Should()` ever ran. This round asked how far that goes. It goes a long way:
623 attribute assertions across 123 files, in every app.

PROVED BEFORE FIXING, on the product rather than in the abstract. `CustomViewsDialogXamlTests` pins
`IsDefault="True"` on the Custom Views dialog's Show button. I deleted that attribute from the XAML
-- a real regression; Enter stops activating the default button -- and ran the suite. 18 passed, 0
failed, including the test whose only job is that attribute. Restored immediately.

The mechanical part: `element.Attribute("x")?.Value.Should()...` becomes `!.Value`, so a missing
attribute throws instead of skipping. The discriminator took two corrections, and the corrections are
the useful part of this entry:

1. First cut excluded only `.BeNull()`. Wrong: every NEGATIVE assertion (`NotBe`, `NotContain`, ...)
   is SATISFIED by absence -- `DoesNotResurrectModeledPageSetupAttributes` asserts
   `Attribute("copies")?.Value.Should().NotBe("3")`, and no attribute at all is the strongest way to
   pass that. 87 sites, reverted.
2. Second cut still broke tests whose EXPECTED VALUE is itself null or nullable
   (`Should().Be(percent ? "1" : null)`, `expectedDxfId` typed `string?`, WML tri-state `w:val` where
   absent means on). Not detectable syntactically -- the expected value is a runtime expression.

So the discriminator is empirical, not syntactic: convert, run, and revert whatever turns red. Green
means the attribute is present, where `!` costs nothing today and fails loudly the day it disappears.

THREE FAILURES SURVIVED THAT TRIAGE -- assertions expecting a non-null literal against an attribute
that is genuinely absent. These are live product defects that vacuous assertions have been hiding:

- `Backlog_CellMetadataTests.FullSave_...ButKeepsItOnUneditedCell`: A2 carries `vm="1"` in the source
  and is never edited; after a full save the `vm` is GONE. The test's own message says "vm must be
  reattached on a full save". Rich-value/linked-data metadata is dropped from unedited cells.
- `R82_CellMetadataRichValueDeleteShiftTests`: the same `vm` loss on B2 after a row delete.
- `ColorScaleAdvancedOptionsTests.RoundTrip_ColorScaleIndexedColors_WritesTintedResolvedRgbColors`:
  all three `color` elements are written with no `rgb` attribute at all, which is the entire point of
  the test.

Worth noting how these hid: in the first test the SIBLING assertion (A3 must have no `vm`) is written
in the safe form, so one direction was real and the other vacuous, in the same test, on adjacent
lines. Nothing about reading it suggests a problem.

Those three sites are left as `?.` WITH a comment naming the defect, so main stays green; hardening
them is the fix's acceptance test, in the rounds that follow. Everything else stays hardened.

Deliberately deferred to the next round: a source-contract tripwire banning the `?.Value.Should()`
subject form. It cannot be added until those three are fixed, or it fails on the three sites that are
documenting the defects.

Regression check: FreeX.Core.IO.Tests 6334/0, FreeX.App.Services.Tests 3575/0,
FreeW.Core.IO.Tests 1953/0, FreeP.App.Presentation.Tests 5928/0.

### r353 addendum -- the WPF host lane

Two more vacuous assertions, and they are a different sub-species from the IO ones: the attribute was
never going to be found, because the LOOKUP was wrong.

`MainWindowXamlKeyTipTests.RibbonSurface_IsReachableByKeyboardTabTraversal` asked for
`Attribute(keyboardNavigation + "KeyboardNavigation.TabNavigation")` against an
`XNamespace` of `clr-namespace:System.Windows.Input;assembly=PresentationFramework`. A XAML
attached-property attribute is written unnamespaced (`KeyboardNavigation.TabNavigation="Continue"`),
so the namespaced lookup could never match anything. MainWindow.xaml has all three values; the test
verifying the ribbon is keyboard-reachable had simply never checked. Lookup corrected, and the
assertions now run and pass.

`MainWindowXamlKeyTipTests.StatusBarAggregates_AreConstrainedAwayFromZoomControls` is the opposite
and is left open: `Grid.Column`, `Panel.ZIndex` and both `KeyboardNavigation` attributes really are
absent from `StatusZoomControls`. This is not a redesign that made columns obsolete -- the sibling
`StatusStatsViewport` still carries `Grid.Column="1"` and that assertion passes. So either the XAML
lost four attributes or the test wants what the product no longer intends. Deciding is a
BEHAVIOUR question (should the status-bar zoom cluster be its own tab cycle?), and the standing rule
as of 2026-09-04 is to settle those against Excel rather than by my own judgement, so it is annotated
in place and left for a round that can check.

Three failures in this lane are NOT mine: `QuickAccessToolbarWindowBroadcastTests` (x2) and
`MainWindowSourceHygieneTests.BackstageSaveAs`, all failing with "Application services are not
initialized" out of `App.get_Services`. That is host initialisation order, in files this round does
not touch, and nothing in an XML attribute assertion can reach it. Recording rather than fixing,
and explicitly NOT claiming they pass on main -- only that they are unrelated to this change.

FreeX.App.Host.Tests: 5347/5400 with 48 skipped before this round's two fixes; the two keytip
failures are now fixed and the other three are the pre-existing ones above.

## r354 -- the three red tests on main (FIXED)

r353's host-lane run left three failures that were NOT mine -- my commit touched only test files and
docs, and the worktree was origin/main plus that commit, which makes these red ON MAIN. A live red
outranks anything on the deferred list, so they came first.

`MainWindowSourceHygieneTests.BackstageSaveAs_ForcesSaveDialogInsteadOfExistingPathSave` pinned the
literal `RunGuardedUiCommand("Backstage Save As", SaveAsFromBackstageAsync)`. The source now reads
`RunGuardedUiCommand("Save Workbook As", SaveAsFromBackstageAsync)`. Nothing is broken: the guard
label was renamed, and it is user-facing error text, so the rename looks deliberate. The test is
about Save As running THROUGH the guard rather than being invoked bare, and the label is incidental
to that, so it now matches by callback and accepts any label. A source-contract test should pin the
structure it is defending, not every literal it happens to sit next to -- over-pinning is what makes
these tests break on unrelated edits and get "fixed" by loosening the wrong half.

The two `QuickAccessToolbarWindowBroadcastTests` failures are a PRODUCT bug, and a worse one than the
test failure suggested. `ShowOptionsDialog`'s commit path called
`App.Services.GetService(typeof(ICrashAnalytics))`. That line already tolerates the service being
unregistered -- the `is ICrashAnalytics` test -- but `App.Services` THROWS when the container itself
is absent, and the call sits in the MIDDLE of the commit. So an absent container did not merely skip
the crash-analytics opt-in: it aborted the whole commit after some settings had been applied, and
before `RebuildQuickAccessToolbar`, the sibling-window QAT broadcast, and the worksheet-view settings
ever ran. A partial Options commit, with the user's other choices silently lost.

Fixed with the accessor this codebase already provides for exactly this, `App.TryGetServices`, so an
absent container behaves like an absent service -- the case the line was already written to handle.

Both fixes have a natural fail-before: these are the tests that were failing, with
"Application services are not initialized" out of `App.get_Services` for the QAT pair.

Worth noting what found this. Neither defect was discovered by looking for it; both surfaced because
r353 forced a full run of a lane whose 5 failures I first had to separate into "mine" and "not mine".
The partial-commit bug had been sitting behind a test failure that was easy to dismiss as
environmental -- and I nearly did dismiss it, having written "host initialisation order" in the r353
addendum before reading the call site.

FreeX.App.Host.Tests filtered run: 195/195.

## r355 -- the first of r353's three: one was never a defect

Took r353's `vm` finding and asked the question the standing rule now demands first: is the shape the
test expects a shape Excel actually produces? No `vm` appears anywhere in the 55 .xlsx files in the
repo, so there was no direct sample -- but the product's own code settles it. The snapshot writer's
comment says XLDAPR dynamic-array markers "are not represented with a t=e placeholder", so the
codebase already knows `vm` occurs on ordinary cells. `c@vm` is valid on any cell. The fixture's
shape is legitimate and the expectation was right.

Then the probe: A2 really is saved as `<c r="A2" s="0"><v>42</v></c>`, no `vm`. It looked like a
confirmed defect.

It is not. `Backlog_CellMetadataTests.CreateSourcePackage` builds its package from a saved EMPTY
workbook and swaps in hand-authored worksheet XML -- so the package has no `xl/metadata.xml` at all,
and `vm="1"` indexes into a part that does not exist. `XlsxWorksheetGridXmlNormalizer.
NormalizeMetadataIndex` drops an index that exceeds the available count, deliberately and correctly:
a dangling `vm` is corruption, and Excel would repair it too. The product was right; the FIXTURE was
invalid. R49 proves the point from the other side -- it passes, and it builds a real metadata part
with `valueMetadata count="4"`.

Fixed by making the fixture real: `CreateSourcePackage` now optionally writes a structurally valid
`xl/metadata.xml`, its content-type override and its workbook relationship, and the `vm` test asks
for two entries. The assertion is hardened to `!` and passes -- the product preserves `vm` on the
unedited cell and drops it on the edited one, both correct.

Fifteenth false positive in this program, and the most instructive: an assertion can be vacuous
BECAUSE the fixture cannot satisfy it. Hardening it converts a silent pass into a failure that looks
exactly like a product defect. "Verify the premise" has to extend to the fixture, not just the
production path.

R82's `vm` failure is a REAL defect and is now diagnosed. Its fixture does build a proper metadata
part (count="14"), so the above does not explain it. The cause is the signature-count guard in
`CellValueMatchesCapturedNativeMetadata`: rich-value placeholders all serialize identically, so a
same-address hit cannot prove identity, and the guard refuses the whole signature group whenever its
count changed -- which a row delete always does. B2 loses its binding even though B2 never moved. The
safety goal is met (B3 correctly refuses the stale `vm="11"`) but the blast radius is the whole group
rather than the ambiguous members. Excel keeps a rich value bound across a row delete, so the test's
target is right and the guard needs narrowing to the addresses a delete could actually have
disturbed. Left annotated with that diagnosis; fix is the next round.

Regression check: FreeX.Core.IO.Tests 6334/0.

## r356 -- attempted R82's guard, proved the approach wrong, REVERTED

Tried to narrow the signature-count guard from the whole sheet to the part a shift could have
reached. The idea: a shift only ever moves content EARLIER in row-major order, so an address whose
source and target still agree everywhere before it cannot have had a different cell shifted into it.
Compute the first divergent address, exempt everything ahead of it.

B2 started passing. B3 started FAILING -- it gained MSFT's stale `vm="11"`, the exact cross-binding
the guard exists to prevent. Strictly worse than the defect: losing a binding is recoverable, binding
a cell to the WRONG rich-value entity is silent corruption.

The fixture shows why, and it is the whole point of the original design. R82's sheet is one column of
four cells that serialize IDENTICALLY (`t="e"`, `<v>#VALUE!</v>`). After deleting row 3, source has
B2..B5 and target has B2..B4, with every surviving cell textually indistinguishable from the one that
used to occupy its address. The first divergence is at B5 -- the only address that stops existing --
so B2, B3 and B4 all sort ahead of it and all get exempted. The shift is INVISIBLE to any comparison
of the XML, because the cells are identical; only the COUNT reveals that a delete happened, and a
count says nothing about WHERE.

So the information needed to distinguish "B2 never moved" from "B3 is now a different cell" is not
present in the two snapshots. No refinement of the comparison can recover it. That is not a flaw in
the attempt, it is the reason the original author reached for an all-or-nothing count in the first
place.

The real fix is the one the code's own comment names as the missing piece: the source snapshot "is
never remapped for structural edits", unlike model-tracked state, which `RowColumnShiftHelpers`
relocates in place when the edit is applied. Remap the snapshot's cell addresses when a row/column
insert or delete happens, and address identity becomes trustworthy again -- B2 stays B2, B3's entry
is deleted with its row, B4's entry becomes B3 carrying its own `vm="12"`. Every binding then follows
its own cell, and the ambiguity guard becomes unnecessary for the delete case rather than being
approximated. That is a real piece of work in the snapshot/shift layer, not a predicate tweak, and it
is the correct next step for this defect.

Reverted in full; the production file is back at HEAD and R82 keeps its annotation. Recorded because
a rejected approach with a proven reason is worth more than an untried idea -- the next attempt
should not start here.

Regression check after revert: R82 2/2, and FreeX.Core.IO.Tests is unchanged from r355's 6334/0.

## r357 -- the colour-scale "defect" was a wrong test (FIXED, no product change)

Second of r353's three, and the second to dissolve on inspection.
`RoundTrip_ColorScaleIndexedColors_WritesTintedResolvedRgbColors` asserted through a `?.` chain and
so never ran. Probing what the writer actually does:

- UNEDITED round-trip: the saved stops keep their source spelling, `indexed="12" tint="-0.25"` and so
  on, with no `rgb`.
- After editing one stop: every stop is written as resolved rgb -- `FFC86432` for the value just set,
  and `FF4583C1` for the untouched max.

Both are correct. Preserving an untouched rule's own spelling is what Excel leaves on disk, and it is
this codebase's source-preservation rule. The decisive corroboration is three tests up in the SAME
file: `RoundTrip_ColorScaleThemeColors_WritesThemeIndexAttributes` says the writer "must round-trip
the original theme/tint attributes instead of flattening to sRGB". The indexed test demanded exactly
the flattening its sibling forbids.

It was also wrong on the number. It expected the max stop to be (91,131,171); the palette resolves it
to (69,131,193) -- which the sibling load test asserts, and passes. So the test contradicted a
passing test in its own file on both the behaviour AND the value, and nothing noticed for as long as
it has existed, because the assertion could not execute.

Replaced with the two contracts that are real: an unedited rule keeps indexed/tint and gains no
`rgb`, and an edited rule writes resolved rgb for every stop and keeps no stale `indexed`. Negative
control run: putting the old (91,131,171) back fails with "Expected ... FF5B83AB, but FF4583C1
differs", which proves both that the new assertion executes and that the old expectation was wrong.

Sixteenth false positive, and the second in a row where a vacuous assertion concealed a WRONG TEST
rather than a product defect. That is now the dominant outcome of hardening r353's sites: of the
three "product defects" it reported, two were bad tests. The lesson is specific -- an assertion that
has never executed has also never had its EXPECTED VALUE checked, so both halves are suspect, and the
sibling tests around it are the cheapest oracle for which half is wrong.

Regression check: FreeX.Core.IO.Tests 6335/0 (one test more than r355's 6334, the replacement being
two tests where there was one).

## r358 -- StatusZoomControls dissolved, and the tripwire landed

Third of r353's three, and the third to turn out not to be a product defect.

`StatusZoomControls` really is missing `Grid.Column`, `Panel.ZIndex` and both `KeyboardNavigation`
attributes -- but its PARENT carries all four. It is nested inside `StatusInteractiveControls`, a
StackPanel with `Grid.Column="2"`, `Panel.ZIndex="1"` and `TabNavigation`/`ControlTabNavigation` set
to `Cycle`. The zoom cluster used to be a direct child of `StatusBarGrid`; a refactor wrapped it, and
the container took the whole responsibility over. Nothing is broken and there is no accessibility
gap, so the Excel comparison this was deferred for is not needed -- the question dissolved on reading
the parent element, one level up from where the test was looking.

Which is the point worth keeping. The assertions did not just go stale, they went stale INVISIBLY: a
refactor moved a keyboard-accessibility contract off the element under test, and the test kept
passing because `?.` skipped every assertion that no longer applied. A stale test that FAILS is a
five-minute fix; a stale test that passes is indistinguishable from coverage.

Fixed by asserting each attribute on the element that owns it -- placement, stacking and tab-cycling
on the container, sizing and background on the zoom cluster -- plus a containment assertion, because
the four container assertions say nothing about the zoom controls unless the zoom controls are
actually inside it. Negative control: deleting `KeyboardNavigation.TabNavigation` from MainWindow.xaml
fails the test, which is exactly what the old form could not do.

So all three of r353's "product defects" are resolved: two were wrong tests (r357, this one), one was
an invalid fixture (r355), and the single genuine defect was R82's, still open with its cause
diagnosed in r356. Stated plainly because r353's own write-up called all three product defects: the
hardening was right and valuable, but the diagnosis attached to it was wrong two times in three.

With every site resolved, the tripwire could finally land.
`R358_AssertionsCannotBeSkippedByANullConditionalTests` bans
`Attribute("x")?.Value.Should().Be("literal")` across tests/, freep/ and freew/.

Deliberately narrow, to the shape that can never be intentional: a positive comparison against a
non-null literal. A `?.` subject is legitimate when absence SATISFIES the assertion (`NotBe`,
`BeNull`) or when the expected value can itself be null -- r353 reverted 87 of the first kind and
several of the second -- so those stay legal and the guard has no false positives. Two known limits,
recorded rather than hidden: an assertion split so the literal falls on the next line is not matched,
and comment lines are skipped (the guard's own documentation quotes the banned shape, which is how
the first run failed).

Negative control: reverting the Custom Views `IsDefault` assertion to `?.` -- the exact line whose
deletion-experiment started r353 -- is caught by file and line.

Regression check: FreeX.App.Services.Tests 3576/0 including the new guard.

### r358 addendum -- 17 environmental render failures, NOT this change

The host lane came back 17/5400 failed after this round, having been 0/5400 earlier in the same
session. Every one is a pixel test: PrintRenderer (7), chart render, two parity captures, the border
accent swatches, and the tester-release pixel-snapped border smoke.

Fingerprint confirmed rather than assumed: "Expected CountApproximateRgbPixels(page, 200, 30, 30) to
be greater than 100, but found 0". Zero ink -- the render produced a blank bitmap, which is the
known WPF blank-render mode on this machine, not a content difference.

Causation is settled by the diff, not by argument: this round modified one XML-attribute assertion in
`MainWindowXamlKeyTipTests.StatusBar.cs` and added one new source-scanning test. No production code,
and nothing under print/render/chart/parity. Those 17 tests are running byte-identical code to main,
so they fail on main on this machine right now.

New data points for that failure mode, which the earlier notes did not have: it PERSISTS across a
reaper run (RAM back to 19.4 GB free, still 0 ink), and the count was stable at 17 across two
consecutive full runs rather than growing. So "the count grows" is not reliable as the sole
signature -- the reliable one is zero-ink plus an unmodified render path.

Pushed on that basis. Not claiming the lane is green: it is 5335/5400 with 17 known-environmental
reds, and the same 17 would appear on a clean checkout here.

## r359 -- R82's fix, scoped concretely (plan, not yet implemented)

r356 proved the guard cannot be narrowed from the XML. This round establishes what the real fix
costs, because "needs an architectural change" is not actionable and was hiding the fact that the
pieces already exist.

The vm/cm binding is the ONLY address-bearing state in this codebase that is not modelled. Comments,
threaded comments, hyperlinks, hyperlink metadata, rich-text runs and phonetic guides are all
`Dictionary<CellAddress, T>` on `Sheet`, and every structural edit shifts them via the GENERIC
helpers `RowColumnShiftHelpers.ShiftCommentRowsUp/Down` and `ShiftCommentColumnsUp/Down`, which are
already `<TValue>`. Rich-value metadata missed that treatment because it "lives purely in the
pristine source XML snapshot" -- which is exactly why it cannot survive a shift.

So the fix is to model it, not to out-think the ambiguity:

1. `Sheet.ValueMetadataIndices` and `Sheet.CellMetadataIndices`, both
   `Dictionary<CellAddress, string>` holding the raw `vm`/`cm` values.
2. Populate at load, in `XlsxSourcePackage.Capture`, which already walks every worksheet's cells and
   is the one place holding both the source XML and the Sheet.
3. Shift them: one added line beside each existing dictionary in the 31 comment-shift call sites
   across `DeleteRowsCommand`, `InsertDeleteColumnsCommand` and their siblings. The helpers are
   generic, so no new shift code is needed.
4. Capture/restore them in `RowColumnShiftHelpers.CaptureAddressBearingState` so undo is symmetric --
   the step most likely to be missed, since a miss shows up only on undo of a delete.
5. In `MergeWorksheetCellNativeMetadata`, consult the model for the address instead of guessing from
   signature counts. The whole `BuildRichValueSignatureCounts` /
   `CellValueMatchesCapturedNativeMetadata` ambiguity guard then becomes unnecessary FOR THE DELETE
   CASE and can be reduced to its original t/formula/value equality check, which is what protects the
   edited-cell case.

Deliberately NOT started here. It is a model + commands + IO change in the code whose entire job is
preventing metadata corruption, it needs the full IO lane (6335) plus the command suites plus a
17-minute host lane to verify, and a half-applied version -- shifted but not restored on undo, say --
would corrupt bindings in a way the current conservative behaviour does not. Losing a binding is
recoverable; cross-binding to the wrong rich-value entity is not, and that is the failure mode this
area punishes.

The defect stands as documented in r355/r356: B2 loses its binding after a sibling row is deleted,
and R82's assertion on it stays annotated until step 5 lands.

## r360 -- the headless swallow, one level up (FreeW + FreeP, FIXED)

New dimension: tests that cannot fail for reasons OTHER than r353's `?.`. Scanned every `[Fact]`
/`[Theory]` in the three apps for a body with no assertion. 708 candidates, refined to 20; nearly all
false positives -- tests delegating to helpers named `AssertSharedEdgeIsDouble`,
`RunDuplicateScenario`, `ShouldPreserveVerbatim`. As usual the finding came from READING a survivor,
not from the count.

The survivor: `DocumentViewCellShadingBordersTests.SetCellShading_InBodyText_IsNoOp`, whose comment
says "document unchanged is verified implicitly by reaching this line" -- which verifies nothing --
and which ends `if (!ran) return;`. That is the signature of the headless-swallow class this
codebase already fixed once.

The per-test swallow IS gone: `HeadlessUiThread.Run` now propagates the body's exceptions, which was
the fix. But the probe that fix introduced kept the same shape ONE LEVEL UP:

    private static readonly Lazy<bool> BackendAvailable = new(() => {
        try { ...new DocumentView(); LoadDocument; Measure... ; return true; }
        catch (Exception) { return false; }
    });

It catches everything, so a genuine regression in `DocumentView` construction or measurement is
indistinguishable from "this machine has no drawing backend". Either way the answer is "unavailable"
and every `if (!ran) return;` in the assembly -- 1044 of them -- returns before asserting. The suite
reports a full green having executed none of its bodies. Nothing asserted that the probe had
succeeded.

DEMONSTRATED, not argued: forcing the probe to throw gives 1 failed and 20 PASSED, where the 20 are
`DocumentViewCellShadingBordersTests` running nothing at all. Without a guard that run is clean green.

Fix keeps the legitimate environment skip -- a machine with no backend genuinely cannot run these --
and makes it OBSERVABLE. The probe's exception is retained instead of discarded, and
`R360_HeadlessBackendIsAvailableTests` fails once, loudly, carrying the real cause. Applied to FreeW
and FreeP, which had the identical structure.

The general shape is worth naming, because this is its third appearance in this codebase (async-void
Dispatch, 154 tests; the per-test catch, 21 tests; now the probe): AN ENVIRONMENT CHECK THAT DECIDES
WHETHER TESTS RUN IS ITSELF UNTESTED. Whenever a suite can skip itself, something must assert that it
did not.

Correction to a standing note: FreeP.App.Avalonia.Tests is recorded as unable to run on this machine.
That is stale -- its backend probe succeeds and the suite runs 741 tests here.

Regression check: FreeW.App.Avalonia.Tests 2297/0, FreeP.App.Avalonia.Tests 741/0.

## r361 -- more silent self-skips, and the environment signature widens

Continued r360's sweep across every way a test can skip itself.

CLEAN, and worth recording as such: there are ZERO environmental early-returns (`File.Exists`,
`OperatingSystem.*`) in any test project, and the conditional-fact attributes -- `BenchmarkFact`,
`WindowsClipboardFact`, `HeavyWorkbookRetestFact` -- are all honest. They set `Skip`, so the runner
reports SKIPPED rather than passed, which is exactly the distinction r360 turned on.

Six more of the r360 shape, though, in the `if (x is null) return;` form:

- `ChartRenderingTests` (FreeW, 3): `if (chart is null) return; // no chart selected in test
  environment -- acceptable`. Those three tests exist to prove a style, colour scheme and quick
  layout reach the SELECTED chart; a null selection made all three pass having asserted nothing.
- `MasterLayoutRoundTripTests` (FreeP, 3): the same on `TextStyles`, `ColorMap` and a layout
  placeholder's `lstStyle`, each excused by a comment as "no X to round-trip".

Probed all six by replacing the `return` with a failure: every one PASSED, so the values are present
and the tests do run today. The guards are dead residue -- of the dangerous kind, since they convert
a future regression into a green run rather than a red one. All six now assert the precondition.

The environment note needs widening, and this is the more useful finding. Both WPF host lanes have
degraded mid-session: FreeX 17 failures, FreeP 11, FreeW 15, from 0/0/0 earlier in this same session
on the same code. The FreeX and FreeP failures are pixel tests with the known zero-ink fingerprint.
The FreeW ones are NOT all pixel tests -- `PagedEditNoteRegionTests` and `HeaderFooterPaginatorTests`
are pagination logic -- and the reason they fail is:

    Expected panel.PageBoxes to contain 1 item(s), but found 2:
    PageBox { ActualHeight = 0.0, ActualWidth = 0.0, ... }

Zero-size visuals. So the mode is not "pixel tests return blank bitmaps", it is "WPF measurement
returns zero", and everything layout-dependent fails downstream of that -- pagination included. A
lane can therefore show failures that look like ordinary logic regressions while the cause is the
same environmental one. Checking only whether a failing test is a "render test" is not enough; check
for zero dimensions.

Regression check for this round's own changes, both run inside the degraded environment:
ChartRenderingTests 20/20, MasterLayoutRoundTripTests 17/17. Lane totals are reported as-is and NOT
claimed green: FreeW.App.Host 1915/1930, FreeP.App.Host 2529/2540.

## r362 -- the WPF render failures: root cause found, and it is not our code

r361 characterised the mode as "WPF measurement returns zero" and left it there. That was still a
description, not a cause, so this round found the cause. It took three probes.

1. Session state. `query session` shows the session running the tests, ID 1 (anton), in state
   **Disc** -- DISCONNECTED. The console is a different session (ID 2). `SESSIONNAME` is empty and
   the only display is a virtual one named "WinDisc", both consistent with that.

2. Does measurement actually break? NO. A bare `TextBlock.Measure` in a plain PowerShell process
   returns 159.8 x 31.9. So "measurement returns zero" -- my r361 wording -- was wrong. Measure is
   fine.

3. Does COMPOSITION break? Yes, completely. Eight lines of PowerShell, no project code:
   draw a red rectangle into a `DrawingVisual`, render it into a `RenderTargetBitmap`, count
   non-transparent pixels. Expected ~3200. **Got 0.**

So the failure is `RenderTargetBitmap.Render` producing an empty bitmap in a disconnected Windows
session, reproducible with no FreeX, FreeW or FreeP code in the process at all. Everything follows:
the zero-ink pixel assertions, the zero `CountPixelDifferences`, and the pagination failures -- a
`PageBox` whose `ActualWidth/ActualHeight` are 0 is a visual that never composed, so the paginator
split a page that would otherwise have fitted.

That accounts for all 43 failures across the three WPF host lanes (FreeX 17, FreeP 11, FreeW 15),
all of which were 0 earlier in this same session, on the same commit.

TRIAGE TEST for the future, worth more than the diagnosis itself, because this mode has confused
this project repeatedly and previously had no cause attached:

    query session        # is this session's state Disc?
    ... render a rectangle into a RenderTargetBitmap and count pixels; 0 means composition is dead

Remedy is not in code: reconnect the session (or run these lanes from a connected one). Nothing
should be "fixed" in response to these failures, and no test should be weakened to accommodate them.

Two corrections this produced. My r361 entry named the wrong mechanism -- measurement, when it is
composition. And the standing note that the failure count "grows between runs" is unreliable: it was
stable at 17 across consecutive runs here, because the session's state is not degrading, it is simply
disconnected.

## r363 -- swallowed exceptions in PRODUCTION code (clean)

Moved off test infrastructure and onto product code, taking the class that has been most productive
on the test side: a failure that is silently discarded. In production the cost is higher -- a user
who is never told their data did not persist.

Surveyed every `catch` in FreeX, FreeW, FreeP and the shared tier that could swallow:

- 29 EMPTY catch blocks. All justified. Most are narrow typed catches over genuinely optional work
  (`catch (XmlException)` on hand-authored native XML, `Directory.Delete` cleanup). The one cluster
  worth naming is seven `try { x.Revert(ctx); } catch { }` sites across `Commands`,
  `DataTableCommand`, `DuplicateSheetsCommand` and `SubtotalCommand`. Those look alarming -- a
  swallowed rollback leaves a half-applied document -- but each is immediately followed by `throw;`
  or by returning a failure outcome carrying the ORIGINAL message. Swallowing there is correct: if
  the best-effort revert's own exception escaped, it would replace the exception that actually
  explains the failure. SubtotalCommand documents exactly this in nine lines of comment.

- 8 truly silent `catch (Exception) { return null/false; }` sites. All deliberate and documented:
  `DecodePictureSize` returns null so insertion falls back to a default size, and
  `TryOpenStartupDocument` states that an unreadable startup document returns null "matching the
  existing launch failure policy". Speech engines and context-menu renderers are availability probes.

- Every SAVE, EXPORT and AUTOSAVE path -- the highest-stakes subset, checked deliberately -- either
  filters (`when (ex is IOException or UnauthorizedAccessException)`, `when (IsUnsupportedReplaceFailure(ex))`)
  or returns a failure the user sees (`WorkbookSaveExecutionResult.Failed(ex)`,
  `OperationOutcome<...>`). `AutosavePeriodicTaskLoop` captures the exception into a local rather
  than discarding it.

No defect. Recorded because the negative result is worth as much as a finding here: this class
produced real bugs three times in the test tree (async-void Dispatch, the per-test catch, the backend
probe) and zero times in product code, which says the discipline is applied where it is written down
and lost where it is not -- test infrastructure has no reviewer.

The detector was noisy in the usual way and is worth writing down so the next sweep does not repeat
it: matching `catch (Exception)` followed by `return false;` flags every method that sets an
out-param error message on the line before the return. `QuickAccessToolbarCustomizationFile` looked
like silent data loss and is the opposite -- it builds a full user-facing message. Only a body whose
ENTIRE content is a bare return is a candidate.

## r364 -- resource management, disposal and async void in product code (clean)

Three surfaces this program had not touched, all in product code.

FILE RESOURCES. Zero `FileStream`, `ZipArchive`, `StreamWriter`, `StreamReader` or
`FileSystemWatcher` is constructed outside a `using` anywhere in FreeX, FreeW, FreeP or the shared
tier. That matters more here than usual: a leaked handle in an IO path reaches the user as "the file
is in use by another process" on their next save, which is indistinguishable from an external cause.

DISPOSABLE FIELDS. One class holds a disposable it never disposes --
`SisterAvaloniaFileCommandWorkflow._destructiveActionGate`, a `SemaphoreSlim` in a sealed class that
is not `IDisposable`. NOT a defect: `SemaphoreSlim` only allocates an unmanaged wait handle if
`AvailableWaitHandle` is read, which this never does, and there is one instance per window rather
than one per operation. Checked instead of "fixed" -- adding IDisposable here would have propagated a
disposal contract through two shells for no benefit.

The gate's use is correct on inspection: `WaitAsync(0)` so a second concurrent destructive action is
dropped rather than deadlocking, and `Release()` in a `finally` so an exception cannot strand it.

ASYNC VOID. 25 total, 11 of them ordinary event handlers. All 14 of the remaining ones are guarded by
a try/catch covering the whole body. Several carry comments explaining exactly why -- the clearest
being `FreeWRibbonPortableCommands.CompleteAsync`, which notes that Avalonia has no dispatcher-level
unhandled-exception hook, so an escaping exception "tears the whole process down", and reports
through `RibbonCommandFaultReporter` instead.

No defect on any of the three. Worth noting WHY this one came back clean where the test tree did not:
this is the exact ground the 12-wave crash-hunt program worked over, and the comments left behind at
those sites are load-bearing -- they are why the next person adding an `async void` here will guard
it. Test infrastructure has had no equivalent pass, which is where r360 and r361 found their defects.

## r365 -- a malformed row index made a workbook unopenable (FIXED)

New class, from the input-validation surface: what a HOSTILE OR CORRUPT file does to the reader. The
question that matters for a spreadsheet app is not "does it parse" but "does one bad attribute cost
the user the whole document".

Parsing itself is in good shape -- 611 `TryParse` against 2 `Parse` in the IO layer, and both of the
two are provably safe (one filters to hex digits and requires exactly 32 before parsing pairs; the
other is gated by an `IsPositiveInteger` that is itself a `TryParse`, so an overflowing value is
removed before it can be re-parsed).

So the check was made empirically instead: eleven malformed worksheets, each loaded and the outcome
recorded. Eight opened. THREE THREW, and a throw here means the workbook does not open at all:

- `<row r="0">` and `<row r="99999999">` -> "Row number must be between 1 and 1048576"
- `<c s="999999">` -> ArgumentOutOfRangeException on the style index

The row cases are the instructive ones. Row `r` was already normalized to "an unsigned integer or
nothing", which is why `-5` and a 20-digit index opened fine -- they fail to parse and get dropped.
But 0 and 99999999 ARE valid unsigned integers; they are just outside the grid. They passed the
normalizer untouched and reached ClosedXML, which threw and aborted the load. The guard was written
against malformed SYNTAX and never against an impossible VALUE.

Fixed in `XlsxWorksheetGridXmlNormalizer`: a row whose index is outside 1..1048576 is dropped, and
the rest of the sheet loads. That is what Excel does -- it repairs and opens rather than refusing.

`R365_MalformedRowIndexStillOpensTests` pins it at 0, 99999999 and uint.MaxValue, and asserts the
SURVIVING rows still carry their values, because dropping the whole sheet would also satisfy a
does-not-throw test. A fourth case pins row 1048576 -- the last valid row -- against an off-by-one
that would drop real data. Revert probe: the three malformed cases fail without the fix and the valid
one passes in both states, which is the correct shape for a test guarding over-reach.

STILL OPEN, deliberately: the style index. `<c s="999999">` still aborts the load. The fix needs the
`cellXfs` count at normalization time, and neither route to it is small -- threading a count through
`NormalizeWorksheetRoot`/`NormalizeSheetDataElement`/`NormalizeRowElement` plus their canonicality
checks, or adding a pass to `XlsxClosedXmlLoadPackageSanitizer`, whose every step is gated through a
requirements/hints record that would need a new member and a new scan. Recorded with both locations
rather than half-wired at the end of a session.

Regression check: FreeX.Core.IO.Tests 6339/0.

## r366 -- finishing r365: an out-of-range style index also aborted the load (FIXED)

r365 left this one open as "needs plumbing". That was true but not a reason to stop, and finishing it
turned out to be the more interesting half.

A cell's (or row's) `s` indexes `cellXfs`. Nothing in the format stops it naming an entry that does
not exist, and ClosedXML answers with `ArgumentOutOfRangeException`, aborting the whole load. Same
user cost as r365: one bad attribute, no workbook.

The first attempt was wrong in an instructive way. I added the pass as SELF-GATING -- it does its own
cheap streaming scan and returns immediately when there is nothing to do -- so that it needed no
entry in the sanitizer's requirements record. It never ran. `XlsxClosedXmlLoadPackageSanitizer`
returns the source package untouched at the top when `!requirements.RequiresAny`, so a package whose
ONLY problem is a bad style index never reaches the archive phase at all. The requirements record is
not bookkeeping around the gate; it IS the gate. A self-gating step is unreachable by construction.

So the member was added properly: `HasOutOfRangeCellStyleIndexes` on the record, in `RequiresAny`,
scanned in the scanning path, `true` in the catch-all that force-enables everything for an unreadable
package, and `false` in the hints-only fast path (no archive there to scan, and no hint exists for
this yet -- worth knowing, since a caller supplying complete hints will not get this repair).

`XlsxWorksheetCellStyleIndexNormalizer` counts `cellXfs` by counting `xf` children rather than
trusting `cellXfs/@count` -- a file corrupt enough to carry a bad index is exactly the file whose
declared count cannot be trusted -- then streams each worksheet and only materializes an XDocument
for one that actually has an out-of-range index.

An existing guard caught a real mistake in the new code, which is worth recording as the guard
working: `R276_PackageXmlReadersAreCharacterCappedContractTests` failed because my `XmlReader.Create`
used a bare `new XmlReaderSettings { IgnoreWhitespace = true }` instead of
`SecureXmlReaderSettings.Create()`, which sets DtdProcessing, XmlResolver and the character cap
together. An XML-bomb-hardening contract, enforced on source text, stopped a new reader opening a
hole in it. Fixed by using the shared factory.

`R366_OutOfRangeStyleIndexStillOpensTests` covers a cell index, a row index (`row/@s` with
`customFormat`, which throws the same way), and `s="0"` -- the default format and a real entry --
because stripping that would silently drop formatting from every ordinary workbook. Fail-before was
observed directly: both malformed cases threw `ArgumentOutOfRangeException` until the requirement was
wired.

All three malformed-file failures found in r365 are now fixed.

Regression check: FreeX.Core.IO.Tests 6342/0.

## r367 -- the same malformed-input method against FreeW and FreeP (clean, suites kept)

r365/r366 found three real defects in FreeX by loading deliberately malformed files rather than
reading code. The two hand-built readers had never been put through that, so they were next: 15
malformed .docx bodies and 14 malformed .pptx slides -- negative and overflowing measurements,
non-numeric offsets, gridSpan of 0 and of int.MaxValue, non-hex colours, alpha past its maximum,
references to numbering/styles/relationships that do not exist, duplicate and zero shape ids, tables
with no grid, deeply nested tables, an empty shape tree.

Every one opened. 15/15 and 14/14, no exceptions.

The contrast with FreeX is the finding, and it is structural rather than a matter of care. FreeW and
FreeP PARSE THEIR OWN XML, uniformly through TryParse, so a value they cannot use is simply ignored
-- the failure mode is a missing property, never a refused document. FreeX hands the package to
ClosedXML, whose failure mode for an impossible value is an EXCEPTION, so every value FreeX's
normalizers let through becomes a load abort. Its three defects were not carelessness; they were the
cost of delegating parsing to a library with different failure semantics, where the normalizer layer
has to anticipate everything the library rejects.

That also says where to look next in FreeX rather than in the siblings: any file-supplied value that
ClosedXML validates is a candidate, and only a fixture proves it either way.

Both probes are kept as suites -- `R367_MalformedDocumentDoesNotThrowTests` and
`R367_MalformedPresentationDoesNotThrowTests` -- rather than deleted, because "the reader ignores
what it cannot use" is a contract worth holding: the cheapest way to break it is a well-meant
`int.Parse` or an indexer added to a reader later. Negative control run: making the open throw fails
all 15, so the assertions execute.

## r368 -- the last-chance recovery path threw on its own stream (FIXED)

Followed r367's conclusion -- look in FreeX, where ClosedXML validates file-supplied values -- with a
second, broader fixture set: 24 malformed worksheets covering dimension refs, merged cells, column
min/max and widths, row heights, pane splits, selections, hyperlink refs, data-validation and
conditional-format sqrefs, autofilter refs, outline levels and shared formulas. Nineteen opened. Five
threw, deterministically across two runs.

Four of the five threw the SAME exception from FreeX's own code, not ClosedXML:

    ArgumentException: Update mode requires a stream with read, write, and seek capabilities
    at XlsxFileAdapter.StripOrphanedSharedFormulaSlaves(MemoryStream)

That is the LAST-CHANCE path: a `<f t="shared" si="N"/>` with no master is a known corruption, and
FreeX strips those slaves and retries the open. It opens the package in `ZipArchiveMode.Update` --
but `CreateClosedXmlParsePackage` returns the CALLER'S stream unchanged whenever nothing needed
sanitizing, and that stream can be read-only or already closed by the earlier attempt (a closed
MemoryStream reports `CanWrite` false). So the recovery for a repairable workbook threw, and made it
unopenable. The strip was also mutating a stream its caller still owned.

Fixed by copying to a writable stream first when the given one cannot be written. The copy must be
EXPANDABLE, and getting that wrong was instructive: the first attempt used `new MemoryStream(bytes)`,
which wraps the array at fixed capacity, so the strip's rewrite threw `NotSupportedException`
instead -- one unopenable file traded for another, and the probe caught it immediately.
`MemoryStream.ToArray()` is documented to work on a disposed instance, which is exactly the state
being recovered from.

`R368_OrphanedSharedFormulaFallbackOpensTests` pins both halves: the file opens, and the recovered
cell KEEPS ITS CACHED VALUE (42), because "swallow the sheet" would also satisfy a does-not-throw
test. Revert probe fails both.

FOUR DEFECTS REMAIN from this fixture set, and the stream fix is what exposed their real causes --
the ArgumentException had been masking them. All are the r365/r366 shape, a file-supplied value
ClosedXML rejects, and each needs a normalizer guard:

- `<col min="0" ...>` and `<col min="99999" max="99999">` -> ArgumentOutOfRangeException.
  Columns are 1..16384; clamp or drop, next to the row guard in `XlsxWorksheetGridXmlNormalizer`.
- `<dataValidation sqref="%%%">` -> ArgumentNullException.
- `<mergeCell ref="@@@">` -> NullReferenceException, raised inside
  `ClosedXML.Excel.XLWorkbook.LoadSpreadsheetDocument`. Notable because the sanitizer already has a
  `MergeCellWorksheetPathsToStrip` member, so the machinery exists and simply does not consider a
  malformed ref.

Recorded rather than rushed, with the exception and the location for each.

Regression check: FreeX.Core.IO.Tests 6344/0.

## r369 -- the last four malformed-file defects (FIXED; the set is closed)

Finished the four r368 recorded rather than fixed. All are the shape r365 and r366 established: a
file-supplied value that is syntactically well-formed but names nothing, which ClosedXML answers with
an exception instead of ignoring, aborting the load and costing the user the whole workbook.

COLUMNS. `NormalizeColumnElement` already dropped a `min`/`max` that is not an unsigned integer --
the identical guard the row index had, with the identical gap. 0 and 99999 parse perfectly well and
name no column; a reversed span (`min=10 max=2`) describes nothing either. Both reached ClosedXML as
`ArgumentOutOfRangeException`. Columns are 1..16384 and a span must run forwards, so such a
definition is dropped and the sheet loads.

REFERENCES. `mergeCell/@ref="@@@"` surfaced as a `NullReferenceException` raised inside
`XLWorkbook.LoadSpreadsheetDocument`, and `dataValidation/@sqref="%%%"` as an
`ArgumentNullException`. The instructive part: normalizers that ALREADY validate both refs exist --
`XlsxWorksheetMergeCellsNormalizer` drops a `mergeCell` whose ref fails `NormalizeCellRange` -- but
they run only on the save/source-preservation pass and were never wired into the ClosedXML LOAD path.
The validation was written; it just was not reachable from where the crash happens.

`XlsxWorksheetMalformedReferenceNormalizer` drops those elements on the load path, reusing
`XlsxSqrefParser.NormalizeCellRangeList` rather than writing a third reference parser, and also drops
a `mergeCells`/`dataValidations` wrapper left empty, which is itself invalid. Wired as a proper
requirements member, following r366's lesson that a self-gating step never runs.

`R369_MalformedWorksheetReferencesStillOpenTests` covers all five malformed shapes plus three
over-reach guards that matter more than the does-not-throw ones: the sheet's CONTENT survives a
dropped column, a valid 1..16384 span is untouched, and a well-formed `A1:B2` merge still round-trips
into `MergedRegions`. Dropping the sheet, or dropping every merge, would satisfy the negative tests
alone.

The malformed-file set opened in r365 is now closed: 11 + 24 fixtures, eight defects found, eight
fixed. Every one had the same cause -- FreeX delegates parsing to a library whose failure mode for an
impossible value is an exception, so its normalizer layer must anticipate everything that library
rejects, and the guards were consistently written against malformed SYNTAX rather than impossible
VALUES.

Regression check: FreeX.Core.IO.Tests 6352/0.

## r370 -- package-level fixtures: one bad fixture, four diagnostics, no new defects

Took the method that found eight defects in worksheet parts to the parts it had never touched:
`workbook.xml`, `styles.xml`, `sharedStrings.xml`, the theme, calcChain and `[Content_Types].xml`.
19 fixtures. The result is worth recording mostly for what it stops the next reviewer doing.

ELEVEN OF THE NINETEEN ARE ONE BROKEN FIXTURE, NOT ELEVEN DEFECTS. Every `workbook.xml` variant --
sheet with no name, empty name, a 200-character name, illegal characters, duplicate names, sheetId 0,
an r:id that does not resolve, a defined name with a bad ref, an empty defined name, a localSheetId
out of range -- threw the IDENTICAL `ArgumentOutOfRangeException (Parameter 'id')`. Varying the input
did not vary the failure, which means the thing under test was never reached: replacing `workbook.xml`
wholesale broke the part/relationship wiring, and every case failed at that same earlier point.
Reporting them would have been eleven phantom defects, and the tell was uniformity, not any
individual result. Same lesson as r355, where an assertion failed because its FIXTURE could not
satisfy it: a probe's own validity has to be established before its output means anything. To test
those attributes properly the fixture must PATCH the existing workbook.xml, not replace it.

FIVE OPENED CLEANLY, which is a real robustness result: a `sharedStrings` count that disagrees with
its contents, an empty `sst`, a `styleSheet` with no `cellXfs` at all, a removed `calcChain`, and a
workbook declaring no sheets.

THE REMAINING FOUR are a diagnostic-quality issue rather than a defect. Removing a required part --
`styles.xml`, `sharedStrings.xml`, the theme -- surfaces the framework's own
`InvalidOperationException: Specified part does not exist in the package`, and removing
`[Content_Types].xml` surfaces a bare `NullReferenceException`, where FreeX has a purpose-built
`WorkbookInvalidException` carrying an actionable message for exactly this ("the file is not a valid
.xlsx package (it may be corrupted, truncated, or not actually an Excel file)").

Checked before calling it user-facing: NO shell references `WorkbookInvalidException` -- the type
appears only in Core.IO, Free.Shared.Opc, FreeW's reader and tests. So the shells treat it exactly as
they treat any other open failure, and the user sees the same generic message either way. The cost is
to whoever reads a log or a crash report, not to the person opening the file. Recorded, not fixed:
changing load error semantics for a diagnostic improvement is not worth the regression risk against
the eight real defects this method has already banked.

## r371 -- chained exponentiation disagreed with Excel (FIXED)

First round into the calculation engine. Method as before, but the oracle is Excel's documented
semantics rather than a schema: 25 formulas covering the coercion and precedence corners where
spreadsheet engines classically diverge -- text-to-number promotion, boolean arithmetic, `&`
concatenation, mixed-type comparison, blank handling, `%` postfix, lazy `IF`, `SUM` versus `+` on
text, unary binding.

TWENTY-THREE OF TWENTY-FIVE matched Excel exactly, including the ones that are easy to get wrong:
`="5"+1` = 6, `="a"+1` = #VALUE!, `=TRUE+1` = 2, `=1<"a"` = TRUE (any number sorts below any text),
`=TRUE>1` = TRUE, `=1=TRUE` = FALSE, `=-2^2` = 4, `=100-10%` = 99.9, `=SUM(3,)` = 3.

TWO WERE MY OWN FIXTURE ERROR: I labelled `=A1=0` and `=A1=""` as blank-cell cases while the fixture
set A1 to text, so FreeX's FALSE was right and my expectation was wrong. Recorded because it is the
r355/r370 pattern for the third time -- the probe's expectations need checking as carefully as the
product's behaviour.

ONE WAS REAL. `=2^3^2` returned 512; Excel returns 64. Excel evaluates operators of equal precedence
LEFT TO RIGHT, `^` included, so it groups `(2^3)^2`. The parser was right-associative, and
deliberately so -- its comment spelled out "right-associative: 2^3^2 = 2^(3^2) = 512". That is the
mathematical convention and what most programming languages do; it is not what Excel does, and Excel
is the authority for this product's formula semantics. Nothing caught it because nothing tested a
chained exponent: the comment asserted the behaviour and no test verified it.

Worth naming the failure mode. It does not error, it returns a plausible number -- so a user
comparing FreeX against Excel on the same file sees a silent numeric disagreement, which is the worst
kind for a spreadsheet.

THE FIX EXPOSED A SECOND ISSUE, and this is the part worth reading. Making the parse a loop broke
`ParserSafetyTests.Parser_DeepPowerChain_ThrowsFormulaParseException`: a 700-term chain used to be
rejected because each link cost one RECURSIVE PARSE FRAME against MaxParseDepth. A loop parses it at
depth 1 -- but still builds a tree one node deeper per link, and evaluation walks that tree
recursively. The stack risk moved from parse to evaluate rather than disappearing, and this codebase
has a documented history of uncatchable StackOverflow crashes. The chain is now charged against the
same limit explicitly, so associativity is fixed and the safety property is kept.

`R371_ExponentiationIsLeftAssociativeTests` pins three chains (`2^3^2`, `3^2^3`, `2^2^2^2`) and four
surrounding precedence facts the fix must not disturb -- `-2^2` = 4, `2^-1` = 0.5, and `^` still
binding tighter than `*` -- because an associativity change is exactly the kind that fixes one
grouping and breaks its neighbours.

Regression check: FreeX.Core.Formula.Tests 5253/0, FreeX.Core.Model.Tests 6707/0,
FreeX.Core.IO.Tests 6352/0.

## r372 -- second calc batch: 29/31 match, and one open question for real Excel

Second semantics batch, different areas: the 1900 leap-year bug, date rollover, Excel's
round-half-away-from-zero, error propagation, lookup and text corners. 31 formulas.

TWENTY-NINE MATCHED, including several this codebase clearly got right on purpose: `=DATE(2024,1,0)`
= 45291 (day zero is the previous month's last day), `=ROUND(-2.5,0)` = -3 (away from zero, not
banker's), `=INT(-2.5)` = -3 while `=TRUNC(-2.7)` = -2, `=SEARCH` case-insensitive against `=FIND`
case-sensitive, `=VALUE("1,234")` = 1234.

ONE WAS MY EXPECTATION, AGAIN. I marked `=DATE(1900,2,29)` as 59; it is 60 -- serial 60 IS the
phantom leap day, 59 is 28 February. FreeX was right, and its two neighbours in the same batch
(`=DAY(60)` = 29, `=DATEVALUE("1900-03-01")` = 61) already agreed with it, which is the corroboration
I should have read before writing the expectation down. Fourth expectation error in this program;
they now outnumber my false positives from detectors.

ONE IS A GENUINE DISCREPANCY, LEFT OPEN. `=COUNT(1/0)` returns `#DIV/0!` in FreeX. LibreOffice
returns 0, and Microsoft's COUNT documentation says "arguments that are error values or text that
cannot be translated into numbers are not counted" -- not "propagate". `=COUNTA(1/0)` is the same
shape: FreeX propagates, LibreOffice returns 1, and the COUNTA documentation says it counts "any type
of information, including error values".

The oracle was built rather than recalled: a workbook written by FreeX, with every cached `<v>`
stripped from formula cells so LibreOffice had to compute the answers itself, then converted to CSV
headless. That same run independently confirmed r371 -- LibreOffice answers `=2^3^2` with 64.

NOT CHANGED, deliberately. The current behaviour is not an oversight: `BuiltInFunctions
.StatisticalCore.Aggregates` carries a comment stating that a bare erroring argument propagates
"matching Excel and mirroring Count()'s direct-vs-range-sourced error asymmetry", and two tests pin
it (`=COUNT(NA())` and `=COUNTA(NA())` both expect `#N/A`). Someone decided this deliberately and may
have checked it against Excel. LibreOffice is Excel-COMPATIBLE, not Excel, and diverges in places,
so it cannot settle a question against a documented deliberate decision.

To settle it, run in real Excel (COM is not registered on this machine):

    =COUNT(1/0)     expect 0   if the docs are right, #DIV/0! if FreeX is
    =COUNTA(1/0)    expect 1   if the docs are right, #DIV/0! if FreeX is
    =COUNT(NA())    expect 0
    =COUNTA(NA())   expect 1

If Excel agrees with the documentation, the fix is two lines -- `continue` instead of `return err` in
`Count` and `CountA` -- plus updating those two tests and the comment. Recorded rather than done,
because overturning a tested, deliberately-documented decision on an oracle that is not the authority
is how a correct behaviour gets broken.

## r373 -- save/reload round-trip fidelity (clean, one narrow gap)

Highest-stakes surface remaining, since the failure mode here is silent data loss rather than a
refused file: set a value, save, reload, compare. 18 shapes chosen to be awkward.

FIFTEEN SURVIVED EXACTLY, including the ones that usually do not: text containing a newline, text
with leading spaces (which OOXML needs `xml:space="preserve"` for), a 32,767-character string,
astral-plane Unicode (an emoji outside the BMP, so a surrogate pair), right-to-left text, negative
zero, `double.Epsilon`, a value in the very last cell of the grid (row 1048576, column 16384), and
sheet names with a space, an apostrophe, 31 characters, and CJK.

TWO ARE CORRECT BY DESIGN and worth writing down so they are not "fixed" later:

- Formula text loses its leading `=` (`=1+1` becomes `1+1`). That is how OOXML stores it -- `<f>1+1</f>`
  -- so the round-trip is canonicalising, not losing.
- 0.12345678901234566 comes back 0.123456789012346. Excel keeps FIFTEEN significant digits and this
  matches it exactly; storing all 17 would be the deviation.

ONE NARROW GAP. Saving a cell whose value is `double.MaxValue` throws
`ArgumentException: Value can't be NaN or infinity`, which would leave the workbook unsaveable rather
than losing one cell.

Reachability was checked before calling it a defect, and it is very low: every arithmetic overflow
-- `=1E308*10`, `=1E308+1E308`, `=10^309`, `=EXP(1000)`, `=-1E308*10`, a divide by a denormal --
evaluates to `#NUM!`, exactly as Excel does, and those workbooks save cleanly. So infinity never
reaches the writer through a formula; the value has to be pushed in through the model API directly.
Excel itself refuses numbers above 9.99999999999999E+307 at entry, so the model accepting one the
writer cannot serialise is the asymmetry -- recorded, not fixed, because guarding it means changing
`SetCell` semantics for a path no user reaches.

The result worth taking from this round is the negative one: the write path handles the string and
numeric edge cases that most commonly corrupt spreadsheets, and the overflow path already matches
Excel end to end.

## r374 -- R82's fix, attempted and measured: three steps of five are trivial, two are not

r359 costed R82's fix at five steps. This round built three of them to find out which estimates were
wrong, then reverted rather than half-land a change to metadata preservation. The estimate is now
grounded rather than guessed.

WHAT WAS BUILT AND WORKS: `Sheet.ValueMetadataIndices` / `CellMetadataIndices` (step 1); the shift
wiring (step 3); and undo capture/restore (step 4). All three compile and are behaviour-neutral,
since nothing populates the dictionaries.

THREE CORRECTIONS TO r359's ESTIMATE, all in the cheaper direction:

- Step 3 is FOUR call sites, not 31. The 31 I counted are individual dictionary calls; they cluster
  into four blocks -- one each in `DeleteRowsCommand` and `InsertDeleteRowsCommand`, two in
  `InsertDeleteColumnsCommand` -- and every block ends with `sheet.CellPhoneticGuides`, which makes
  the insertion point unambiguous. The helpers really are generic over `TValue`, so no new shift code
  is needed.
- Step 4 is NOT in `RowColumnShiftHelpers.CaptureAddressBearingState`, where r359 said to look. That
  record does not carry the comment family at all. Undo for these dictionaries lives in
  `RowColumnMutationSnapshot`, as a field plus a `CaptureDictionary` and a `RestoreDictionary` line.
  Three lines, and the pattern is copy-exact from `HyperlinkMetadata`.
- Step 1 is two properties, as expected.

THE REAL COST IS STEP 2, and r359 understated it. "Populate at load, in `XlsxSourcePackage.Capture`"
assumed that method walks worksheet cells with a sheet correspondence to hand. It does not -- its
per-worksheet loops are save-side patch paths keyed by worksheet PATH, with no Sheet. And the load
path cannot supply the values either, because it goes through ClosedXML, which does not surface
`vm`/`cm` at all. So step 2 is a NEW pass over the source worksheet XML at load, correlating each
worksheet part to its Sheet and parsing the attributes -- not a line in an existing loop.

REVERTED, deliberately. Three-fifths of a fix to the code whose job is preventing metadata corruption
is worse on main than none: the dictionaries would sit unpopulated and unused, and the next person
would have to decide whether they were scaffolding or dead code. The value of the round is that the
next attempt starts with the four insertion points named, the undo location corrected, and the one
genuinely hard step identified -- which is what r359 was missing.

## r375 -- FreeW document round-trip fidelity (clean)

r373's method against FreeW's writer/reader pair, which had never been checked this way: build a
document, save as .docx, read it back, compare the model. 12 shapes.

ALL TWELVE SURVIVED EXACTLY: a tab inside a run, leading and trailing spaces (which need
`xml:space="preserve"` in WordprocessingML exactly as they do in SpreadsheetML), astral-plane Unicode,
right-to-left text, a 100,000-character run, bold, a fractional font size (13.5pt, which is stored as
half-points and so is the size most likely to round badly), a font family, an empty paragraph between
two full ones -- easy to drop when serialising -- 500 paragraphs, and a paragraph split into three
runs with formatting on only the middle one.

This matches r367, where 15 malformed .docx bodies all opened. FreeW's IO layer is in good shape in
both directions, which is consistent with it parsing and writing its own XML rather than delegating.

MY FIXTURE WAS WRONG FIRST, for the fifth time in this program, and the shape is now familiar enough
to state as a rule. `TextDocument.CreateEmpty()` already contains one empty paragraph, so
`Blocks.OfType<Paragraph>().First()` read THAT rather than the content under test, and nine of the
twelve cases reported `InvalidOperationException: Sequence contains no elements`. Nine simultaneous
identical failures is the same tell as r370's eleven identical exceptions: when every case fails the
same way, suspect the harness, not the product. Fixed by reading the last non-empty paragraph.

The rule those five errors add up to: a probe reports the difference between the product and MY
MODEL OF IT, and the model is wrong roughly as often as the product is. A probe result is worth
acting on only after the probe itself has been shown to measure what it claims -- by a passing
control, a known-bad input that fails, or corroboration from a neighbouring case.

## r376 -- FreeP presentation round-trip fidelity (clean); the three-app sweep is symmetric

Completes the round-trip method across all three apps: FreeX (r373), FreeW (r375), FreeP here.
14 shapes written to .pptx and read back.

ALL FOURTEEN SURVIVED: a tab in a run, leading and trailing spaces, astral-plane Unicode,
right-to-left text, a 100,000-character run, bold, a fractional font size (13.5pt), a font family,
the shape's name and its ALT TEXT -- which matters because it is the accessibility field most often
dropped by a writer -- an empty paragraph between two full ones, 200 paragraphs, and a paragraph
split into three runs with formatting on only the middle one.

THE PROBE WAS CONTROLLED BEFORE THE RESULT WAS BELIEVED, which is the r375 rule applied to itself:
corrupting the value the round-trip returns made the six text-reading cases report LOST while the
eight reading other properties correctly stayed KEPT. A clean sweep from an unvalidated probe means
nothing; this one is measuring what it claims.

THE THREE-APP PICTURE IS NOW CONSISTENT, and it says something specific about where risk lives in
this codebase:

- FreeW and FreeP -- which parse and write their own XML -- took 29 malformed inputs (r367) and 26
  round-trip shapes (r375, here) without a single defect.
- FreeX -- which delegates parsing to ClosedXML -- produced eight load-abort defects from 35
  malformed fixtures (r365-r369) and needed its own round-trip pass (r373) to confirm the write side.

The difference is not diligence, it is failure semantics: a hand-written parser ignores what it
cannot use, while a library that throws turns every unanticipated value into a lost document. Future
robustness work on file handling should weight FreeX accordingly, and the two sibling apps' IO layers
can be treated as low-risk until their feature surface grows.

## r377 -- a deferred cleanup item that was already done, and would have been harmful to "finish"

Went after a concrete named loose end rather than another sweep: the r169 path-overload class
recorded two "now-dead overloads still awaiting removal". Both halves turned out to be wrong, and
following the note would have removed a deliberate safety guard.

`AppStoragePathPlanner.GetOptionsFilePathLabelOrFallback` is already gone. Its name survives only as
a BANNED STRING in three source-contract tests, which exist to stop it returning.

`ApplicationFrameDescriptor.ResolveDataFolderLabel()` (parameterless) still exists, but is no longer
the hazard the note describes: it now defaults to `PlatformApplicationDataPathProvider.Instance`
(%APPDATA%) rather than `LocalInstance`, and `R277_DataFolderLabelDefaultsToRoamingRootTests` pins
that in both directions -- it MUST resolve the roaming root and MUST NOT resolve the local one. The
test's own summary says the class is closed "at the hazard rather than at the list of places that
touch it", which is precisely why the overload is kept: deleting it deletes the guard. Production
call sites all pass an explicit store path; only the per-app wrappers and those tests reach the
parameterless form, and that is the intended end state.

Worth noting what that test does, because it is the discipline this program arrived at independently:
before asserting the label is not the local root, it asserts the two roots DIFFER on this machine --
otherwise the assertion would pass without discriminating. That is the vacuous-green shape r353 found
620 instances of, guarded against here by an author who saw it coming.

No code change. The finding is that a deferred-cleanup note aged into a harmful instruction, and the
correction is recorded in memory so the next session does not act on it.

## r378 -- picture lock flags now persist (FIXED; a deferred item the Excel rule settles)

The r377 approach again: take a named deferred item and check it against the tree. This one was real,
and the standing rule -- match what Excel does -- decides it without needing anyone's judgement.

`PictureModel.LockAspectRatio` (Format Picture > Size > "Lock aspect ratio") and
`PictureModel.Locked` (Properties > "Locked") were documented as session-only, with reading and
writing `a:picLocks` left as "deferred follow-up work". Confirmed empirically before touching
anything: unlock a picture on both axes, save, reload -- both come back TRUE, and `picLocks` never
appears in the drawing part. Excel persists both, so FreeX should.

Implemented on the pattern r317/r318 established for `Title`, `IsDecorative` and `IsVisible`: read in
`XlsxWorksheetDrawingParts` (new record fields plus a `ReadPictureLocks` helper), mapped onto the
model in `LoadSheetXmlLayoutApplication`, written by `XlsxWorksheetDrawingObjectWriter` at both
picture-anchor sites.

MY FIRST IMPLEMENTATION WAS WRONG, AND MY OWN TEST CAUGHT IT -- which is the argument for writing the
partial-state case rather than only the all-on and all-off ones. Emitting just the flag that changed
(`noChangeAspect="0"`) loses the other: the reader treats an attribute absent from a PRESENT element
as false, per the OOXML defaults, so a picture with only the aspect lock cleared came back fully
unlocked. The asymmetry is between "absent ELEMENT means locked" -- this codebase's documented
default, and Excel's authored one -- and "absent ATTRIBUTE means false", which is the schema. Fixed
by making a written element fully self-describing: all three attributes, always.

Byte-stability is preserved deliberately and pinned by a test: both model properties default to
locked, and the element is emitted ONLY when a flag departs from that, so an ordinary picture
produces exactly the XML it did before. Writing `picLocks` unconditionally would have churned every
drawing part in every existing workbook for nothing.

Four tests: both flags survive; clearing only the aspect lock leaves the other set (the case that
found the bug); an all-default picture writes no element and reloads locked; and an Excel-style
`<a:picLocks noChangeAspect="1"/>` reads as aspect-locked but movable, which is what Excel actually
writes for that picture.

Regression check: FreeX.Core.IO.Tests 6356/0.

## r379 -- chartEx charts no longer offer options the cx format cannot store (FIXED)

Second of the three deferred items the align-with-Excel rule settles, and like r378 the rule decides
it without needing a judgement call.

The chart options dialog offered "Plot visible cells only" and "Rounded corners" for every chart.
Premise verified before changing anything: `PptxChartWriter` emits `c:plotVisOnly` and
`c:roundedCorners` in the CLASSIC namespace only, and the cx part has no equivalent -- so on a
waterfall, treemap or histogram a user could tick either box, have it silently do nothing, and find
it gone at the next open. PowerPoint does not offer either control for those chart types.

`ChartDisplayOptionsPlanner.SupportsClassicChartAreaOptions` is the inverse of the existing
`SupportsChartExTitleLayout`, so the two capabilities partition the dialog: title position and
alignment are chartEx-only, plot-visible and rounded-corners are classic-only.

GREYED RATHER THAN HIDDEN, deliberately. PowerPoint hides these controls, but this dialog already
answers "capability does not apply to this chart kind" by DISABLING -- one line above, title
position/alignment are shown disabled for a classic chart. Mixing both idioms in a single dialog
would be worse than either, and the defect (a control that silently does nothing) is cured the same
way. Recorded because it is a deliberate departure from the letter of the rule.

ENFORCED IN TWO PLACES, which is the part worth keeping. Disabling the field is a UI affordance; the
commit path now refuses the values too. A disabled field still round-trips a value through
`ChartDisplayOptionsDialogInput`, and any caller can construct one directly, so gating only the plan
would have left the setting writable on a chart that cannot store it -- the same defect somewhere
quieter and harder to find.

Three tests, including one asserting the two capabilities are exact inverses. That relationship is
what stops a later edit leaving some chart kind with both false (a control that does nothing) or both
true (a control that lies).

Regression check: FreeP.App.Presentation.Tests 5945/0. FreeP.App.Host.Tests shows 12 SlideCanvas
render failures, which are the r362 environmental mode -- `query session` still reports this session
`Disc`, so WPF composition is dead; nothing in this change renders.

## r380 -- the parity name-box gate no longer reports PASS for work it never did (FIXED)

Last of the three deferred items. Unlike r378 and r379 this is not an Excel-behaviour question at
all: it is the vacuous-green class this program has been chasing since r353, in the parity tooling.

`FreeX.ParityCompare` compares a Windows capture against a Linux one. The name-box dropdown contract
is a PAIR contract, so a single-side run (`--win-only` / `--linux-only`) cannot evaluate it. The
runner handled that by hard-coding

    new NameBoxDropdownPairContractResult(true, [])

and printing `name-box pair : PASS`. A gate announcing success for work it did not do -- exactly the
shape of r353's 620 assertions and r360's backend probe, and worse here, because this output is read
as evidence that Linux parity holds.

Checked before changing: `NameBoxDropdownPairContract.Validate` itself is honest. A missing surface,
a `captured:false` surface, wrong dimensions, or evidence provenance that is not
`native-x11-root-crop` all produce real failures rather than a silent pass. The defect was only in
the caller.

Fixed by giving the result a `WasEvaluated` flag (defaulting true, so the real path is untouched) and
reporting three states rather than two: PASS, FAIL, and `NOT EVALUATED (single-side run)`. The run's
own pass/fail is deliberately unchanged -- `--win-only` and `--linux-only` are legitimate modes and
must not start failing -- so the fix is purely that the output stops implying a check happened.

Tests assert the SOURCE, not the tool's behaviour, because running it needs two real captures and a
Linux container. That is weaker than executing it and the entry says so rather than implying
otherwise. Three assertions: the single-side result is constructed as not-evaluated, the printed
status is driven by `WasEvaluated` and not only `IsValid`, and -- the one that stops the fix being
satisfied by doing nothing -- a two-sided run still calls the real `Validate`.

That closes all three deferred items put to the user: `picLocks` (r378), the ChartEx dialog options
(r379), and this.

Regression check: FreeX.App.Services.Tests 3579/0, FreeX.ParityCompare.Tests 49/0.

## r381 -- FreeX wrote a workbook it could not reopen (FIXED; r373's note was wrong twice)

Went back to an item this program recorded and did not fix: r373's "saving `double.MaxValue` throws,
and it is unreachable". Both halves were wrong.

FIRST, THE MECHANISM. The save SUCCEEDS. It is the RELOAD that throws. ClosedXML serialises with
Excel's 15 significant digits, and for a magnitude within a few ulps of `double.MaxValue` that rounds
UP past it: `1.7976931348623157E+308` is written to the file as `1.79769313486232E+308`, which is
larger than `double.MaxValue`, so reading it back yields Infinity and ClosedXML rejects it. Confirmed
by dumping the cell XML rather than inferring.

That is materially worse than the note claimed. A save that fails is visible and recoverable; a file
that saves and then cannot be opened tells the user their work is stored and loses it afterwards.

WHY r373 GOT IT WRONG, which is the transferable part: its probe wrapped save AND load in one try
block and reported "THREW" for the pair, so it could not say which had failed -- and the label it
printed named the save. A probe's GRANULARITY is part of what it measures, exactly as its expectations
are (r355, r370, r375). Splitting the two calls was the whole diagnosis.

SECOND, REACHABILITY. r373 checked formulas only. CSV import was checked here: `1.8e308`, `1e309` and
a 309-digit literal are all rejected as numbers and load as TEXT, so import cannot produce the value
either. The model API can, which is enough -- the defect is that the WRITER emits something the
READER rejects, and no input path should be able to do that.

THE FIX USES THE CODEBASE'S OWN KNOWLEDGE. `MaxExcelRepresentableNumber` already exists, with a
comment saying values this close to `double.MaxValue` "re-parse as +/-Infinity after ClosedXML's own
numeric round-trip, which would crash on reload" -- and it was applied to the DateTimeValue arm and
not to the plain NumberValue arm one line above. The hazard was known and guarded in one place.

Deliberately narrower than that constant, though: `SurvivesExcelPrecisionRoundTrip` asks only whether
the value actually survives its own 15-digit serialisation. Using the constant would have reclassified
every magnitude above Excel's limit as text, including `1.79769313486231E+308`, which round-trips
perfectly well today. Fixing the unopenable file must not silently retype a band of working numbers.

Nine tests: three extreme values reopen; the value is kept as TEXT with its digits intact, since
clamping would also stop the crash while quietly altering data; and five ordinary numbers -- including
Excel's own maximum and the above-Excel value that does survive -- are still written as numbers.

Regression check: FreeX.Core.IO.Tests 6365/0.

## r382 -- a corrupt workbook now says so in FreeX's own words (FIXED; r370 reclassified)

Reopened r370, where a missing required package part was classified as "diagnostic quality, not a
defect" because no shell references `WorkbookInvalidException`. The severity was right; the reasoning
was wrong, and following it through the shell is what showed why.

`MainWindow.ReportAsyncCommandFailure` prints `exception.Message` VERBATIM inside its
command-failed template. The shell does not need to know the exception TYPE, because it shows the
TEXT -- so what the adapter throws is literally what the user reads. Opening a workbook missing
`xl/styles.xml` therefore said

    Specified part does not exist in the package.

while this same adapter already owned

    The workbook could not be read because the file is not a valid .xlsx package (it may be
    corrupted, truncated, or not actually an Excel file).

and used it only for the not-a-zip case. A missing `[Content_Types].xml` was worse still: a bare
NullReferenceException, which reads to a user as a crash rather than a diagnosis.

Checked before changing, and it settles the design question: package corruption ALREADY surfaces as
`WorkbookInvalidException` -- `LoadWorkbook_WithDuplicateZipEntryNames_ThrowsWorkbookInvalidException`
pins it. So this aligns the missing-part case with a contract that exists rather than inventing one.

Translated at the load boundary rather than at the six-plus `new XLWorkbook(...)` sites in the
fallback chain, with a deliberately narrow predicate: the packaging layer's own "does not exist in
the package" sentence, and a NullReferenceException whose stack is inside DocumentFormat.OpenXml or
ClosedXML. `WorkbookPasswordProtectedException`, cancellation, and every other failure keep their own
type and message, so this cannot flatten an informative error into a generic one -- the r363 hazard.
The original is carried as `InnerException` (a constructor the type lacked), so the readable sentence
reaches the user without the diagnosable cause being lost.

Four tests: three missing parts each produce the readable message WITH an inner exception, and a
well-formed workbook still opens -- the last one being what stops "report invalid" from being
satisfied by failing everything.

Regression check: FreeX.Core.IO.Tests 6369/0, FreeX.App.Services.Tests 3579/0,
FreeW.Core.IO.Tests 1968/0 (the exception type is shared).

## r383 -- a false trail, stopped before it became a claim (no fix; two facts established)

Reopened r363's aside that a failed picture decode "falls back to a default size". The caller does
exactly that -- `PictureInsertionPlacementPlanner.CreateInsertPictureCommand` silently substitutes
`DefaultSize` -- and the Avalonia file picker offers `.tif`/`.tiff`/`.webp`, so if Skia cannot decode
a TIFF the picture inserts at a fixed 240x140 with no warning, while the WPF host (WIC) inserts it
correctly. That would be both a silent wrong result and a cross-shell parity defect.

IT IS STILL UNRESOLVED, and the interesting part is why.

Built a minimal 4x2 baseline TIFF and proved the FIXTURE valid first: WPF/WIC decoded it as 4x2.
Avalonia's `Bitmap` then reported 1x1 -- a successful decode with wrong dimensions, which would be
worse than failing because no fallback triggers. That looked like the defect.

A control killed it. A PNG produced by the same headless decoder ALSO came back 1x1, so the reading
was worthless. Then the control itself came under suspicion (a never-written `WriteableBitmap` might
save degenerately), and the tiebreak was an EXISTING test that asserts real capture dimensions:
`ConsolidateDialogLifecycleRegressionTests` expects 380 and, run alone, gets 1.

So the decoder reports 1x1 in that context -- and the TIFF result says nothing about TIFF.

THE SECOND FACT, found on the way: that test PASSES in the full suite (2283/0) and FAILS in
isolation. Its outcome depends on what ran before it. That is worth knowing on its own -- anyone
running it alone sees a failure that is not real -- and it is what made the probe misleading, since a
single-test run is exactly how a probe executes.

WHAT IS ESTABLISHED: WIC decodes baseline TIFF; the insert path silently substitutes a default size
when decoding fails; the picker offers TIFF. WHAT IS NOT: whether Avalonia/Skia decodes TIFF at all,
which needs a real display rather than the headless harness -- the Linux capture route, or a
connected session (this one is still `Disc`, see r362).

No claim, no fix. Recorded because the trail was three steps from being reported as a defect, and the
thing that stopped it was running a control on a result that looked too uniform -- the same tell as
r370's eleven identical exceptions and r375's nine.

### r383 addendum -- the order dependency, as far as it is actually known

Chased the mechanism behind "passes in the suite, fails filtered". Established: the class sits in
`[Collection(AvaloniaParityCapture)]`, which is `DisableParallelization = true` with an
`ICollectionFixture<AvaloniaCaptureProcessLease>` -- a lease capping concurrent capture processes,
NOT a renderer initialiser. So the collection does not explain it, and the mechanism is still
unidentified.

What is reproducible, and enough to act on: the full assembly passes 2283/0, and the same class run
under a `--filter` fails with `PixelSize` 1x1. Stated as the phenomenon rather than dressed up as a
diagnosis.

The operational consequence is the useful part: **a filtered single-class run of a parity-capture
test is not trustworthy in this assembly** -- it can report a failure that the full run does not have.
That is exactly how a probe executes, which is why r383's TIFF reading was worthless, and it is worth
knowing before anyone debugs one of these tests alone and chases a phantom.

Not pursued further. The remaining questions need a connected session (this one is still `Disc`) and
the mechanism matters less than the caveat.

## r384 -- text encoding on import/export (clean; the advice chain checks out end to end)

Fresh surface: encoding, where the failure mode is mojibake and the user complaint is "my accents
turned into question marks".

READING IS ROBUST. Five encodings of the same non-Latin sample -- UTF-8 with BOM, UTF-8 without,
UTF-16 LE with BOM, UTF-16 BE with BOM, and Windows-1252 -- all round-trip exactly through
`CsvFileAdapter.Load`. BOM detection and the big-endian case are the two that usually break; neither
does.

WRITING LOOKED LIKE A DEFECT AND IS NOT. A plain CSV save turns `日本語` into `???`, `Ω` into `O` and
the emoji into `??`. That is Excel's behaviour too -- plain `.csv` is written in the OS ANSI code
page, which is why Excel ships a separate "CSV UTF-8" -- and the adapter says so in a comment that
predates this review, naming the pipeline that reports it.

The reason my probe saw silent loss is that it called `Save`, while the app calls `SaveWithWarnings`.
Checked what the user actually gets:

    Some text could not be represented in the Western European (Windows) encoding used for this file
    type and was replaced with '?'. Save as "CSV UTF-8 (Comma delimited)" or "Unicode Text" instead
    to preserve it exactly.

That is better than Excel's own generic warning: it names the encoding, what happened, and the way
out.

THEN THE STEP THAT HAS BEEN PAYING ALL SESSION -- following the advice to see whether it is true. The
warning names two formats, so: do they exist, and do they work? Both are real adapters registered in
`WorkbookFileAdapterCatalog` (`CsvUtf8FileAdapter`, `UnicodeTextFileAdapter`), and a round-trip of the
same CJK and astral-emoji sample through each PRESERVES it exactly. The advice is not decoration.

No defect. Eighth time in this stretch a probe result that looked like a finding dissolved on the
premise check -- here the codebase's own comment named the design before I could misreport it, which
is an argument for reading the comment at the site before writing the ledger entry.

## r385 -- options persistence, every property (clean)

Another fresh surface: application settings, where the failure mode is a preference the user changes
that quietly does not survive a restart. Done exhaustively rather than by sampling -- reflect over
every readable/writable property on `AppOptions`, set a non-default value, save, reload, compare.

43 properties. 41 mutated automatically, and 39 of those round-tripped unchanged. The other four all
turned out to be deliberate:

- `LastPersistenceError` is `[JsonIgnore]` with a private setter. It records the last persistence
  failure, so persisting it would be circular.
- `DefaultFormat` normalises. The probe first set the nonsense value "probe-value" and saw ".xlsx"
  come back, which proves nothing -- so it was rerun with real ones. `.xlsx` and `.fxl` are kept,
  nonsense falls back to `.xlsx`, and `.json` becomes `.fxl`, which `NormalizeDefaultFormat` does on
  purpose: `.json` is the LEGACY workbook format and an old options file naming it is migrated
  forward rather than left pointing at something the app no longer writes.
- The two `List<string>` properties my reflection skipped -- and they are the ones where loss would
  hurt most, being user-authored. Tested separately: `QuickAccessToolbarCommands` round-trips in
  ORDER (order is the toolbar's meaning), and `SpellCheckCustomDictionaryWords` round-trips SORTED,
  including `café` and `日本語`. Different handling of two same-typed properties, each matching what
  the data means.

No defect. Two method notes worth keeping, both of which changed the result here: a probe that sets
an INVALID value cannot tell normalisation from data loss, and a probe that SKIPS a property type has
not covered it -- the skip list is a finding to chase, not a footnote. Both were the difference
between "two settings lost" and an accurate clean result.

## r386 -- the ClosedXML concurrency gate holds (clean; pinned)

Fresh surface: concurrency beyond `async void`. The concrete hazard here is named in the code --
ClosedXML's `XLWorkbook` construction and population touch PROCESS-GLOBAL static state, so a
background startup prewarm or a second window can corrupt a concurrent load. The adapter serialises
every load and save on one static `ClosedXmlGate`.

AUDITED AS A FENCE, not as a set of callers, which is the r277 distinction. The lock sits at ONE
chokepoint per direction -- `LoadCore` and `SaveCoreUnlocked` -- and each has EXACTLY ONE call site,
inside the lock. Every public and internal entry point delegates inward: `Load`,
`LoadWithWarnings` (x2), `Save`, `SaveWithWarnings`, and `SavePreservingVbaProject` (the macro-adapter
path). The startup prewarmer, which the gate's own comment names as the race it exists to prevent,
goes through the public `Save`/`Load` rather than reaching past them.

Stress-tested as well as read: 48 load-plus-save cycles at parallelism 8 across 8 distinct workbooks,
verifying every cell value on the way back. Zero failures.

BUT THE STRESS TEST WAS NOT KEPT, deliberately. It cannot fail reliably -- with the gate removed it
passes or fails on timing -- so keeping it would add a test that reports green for a broken
invariant, which is the exact shape this program has spent rounds deleting. The four tests kept are
deterministic source contracts: each core has one caller, that caller holds the lock, every entry
point delegates to it, and no other production file constructs an `XLWorkbook` at all.

That last one immediately corrected me. I had read the seven constructions as living in
`XlsxFileAdapter.cs`; the test failed and named `XlsxFileAdapter.Save.cs`, which holds the seventh
(inside `SaveCoreUnlocked`, so gated). The exclusion now matches the file PREFIX rather than the one
file I believed held them all -- a test catching its author's misreading before the entry was
written.

No defect.

## r387 -- FreeW command undo restores the document exactly (clean; pinned)

Fresh surface: the authoring command layer, where the failure mode is an undo that LOOKS like it
worked. `IDocumentCommand` has 67 implementations, each with `Apply` and `Revert`, and a `Revert`
that restores 95% of the state leaves a document the user believes they reverted.

Method: build a document with paragraphs, mixed run formatting and a 2x2 table; hash its serialised
.docx; apply a command; hash again; revert; hash again. Undo is correct only if the third hash equals
the first.

Fourteen commands covered, spanning the kinds that differ structurally -- block insert/delete,
paragraph style and formatting, run formatting, wholesale run replacement, table row and column
insert and delete, horizontal and vertical cell merges, and a block reorder. ALL FOURTEEN RESTORED
EXACTLY.

The test carries its own vacuity guard, which is the part worth copying. Between the first and second
hash it asserts the document ACTUALLY CHANGED. Without that, a command whose `Apply` silently did
nothing would sail through the undo assertion -- the state before and after a no-op revert being
identical -- and the test would report a working undo for a command that never ran. Every one of the
fourteen changed the document, so none of the fourteen results is vacuous.

Kept as `R387_CommandUndoRestoresTheDocumentTests`, and proved it can fail: skipping the `Revert`
call fails on the first command with "undo must restore the document exactly".

No defect. Fifty-three commands remain uncovered -- the ones needing images, revisions, bookmarks,
fields or content controls to construct -- so this is a sample, not a proof over the whole command
set, and the entry says so rather than implying the layer is verified.

## r388 -- extending the undo coverage, and the guard earning its place twice

Extended r387 from 14 commands to 20 by adding an image-bearing paragraph to the fixture, since the
image family carries the most fields for a `Revert` to miss -- size, alt text, rotation and flips,
crop on four edges, border colour/width/dash. `SetImageSize`, `SetImageAltText`, `SetImageRotation`,
`SetImageCrop`, `SetImageBorder` and `ResetImageSize` all RESTORE EXACTLY.

The interesting part is that the vacuity guard from r387 fired TWICE, both times on MY fixture rather
than on the product:

- `ResetImageSize(3, 0, 48, 24)` against an image already 48x24 changes nothing. Passing a command
  the state it is meant to produce is the classic way to write a test that proves nothing.
- `SetShapeWrapping` returns early unless `ShapeAt(context)` finds a SHAPE, and the fixture has an
  IMAGE. The command did nothing because it was aimed at the wrong object; the writer emits wrapping
  correctly for a floating image, which was checked before assuming otherwise.

Either would have been reported as "undo verified" by a test that only compared before against after.
Both instead surfaced as "must actually change the document" -- and the second one had me reading the
writer for a dropped-field defect that does not exist, which is exactly the trip r383 took. The guard
turned a two-hour false trail into two minutes.

Dropped `SetShapeWrapping` rather than bending the fixture: shapes need their own, and a command
aimed at absent state is not coverage.

No defect. Coverage is now 20 of 67 commands; the rest need revisions, bookmarks, fields, content
controls or drawing groups to construct, and the ledger keeps saying so rather than implying the
layer is done.

Regression check: FreeW.Core.IO.Tests 1969/0.

## r389 - FreeP presentation-command undo, and the write-time slide-id defect it exposed

Applied r387/r388's undo-verification method to FreeP's `IPresentationCommand` (137 implementations):
apply a command, assert the deck ACTUALLY changed, revert, assert the deck is byte-for-byte what it
was. Six commands covered (InsertSlide, DeleteSlide, DuplicateSlide, MoveSlide, SetSlideHidden,
SetShapeHidden).

**Two instrument errors before the real finding.** The first comparison hashed the written .pptx and
reported InsertSlide's undo as broken. Three controls disagreed with each other, which is the tell:
(1) three back-to-back writes of one deck hashed identically -> the writer IS deterministic; (2) a
part-by-part diff reported no differences at all; (3) a timestamp probe showed ZIP entry stamps move
with the wall clock -- in FreeX's writer too, and in what Office itself writes, so not a defect.
Hashing package BYTES is therefore timing-sensitive, and the failure was an artifact of the
instrument. Rewrote the comparison to read part CONTENT.

**The defect (fixed).** With content comparison the difference was concrete and survived:

    before        : sldId 256, 257, 258
    after insert  : 256, 257, 258, 259
    after undo    : 256, 258, 259     <- slide 1 changed identity, permanently

Not an undo defect. `PptxPackageWriter` allocated slide ids while walking slides in document order,
seeding `usedSldIds` as it went. A slide with no id yet -- a freshly inserted one -- took the next
counter value, 257; the slide that ALREADY owned 257 was reached later, collided, and was reassigned
to 258, its successor to 259. The writer stores the result back on the model (`slide.NumericId = ...`),
so **saving a deck permanently changed the identity of slides the user never touched**, and the
command's Revert had nothing to do with it.

Slide ids are not cosmetic: `p:sldZmObj/@sldId` zoom targets, custom shows and section membership all
reference slides by id, so a save that renumbers them silently repoints those references. The writer
already patches zoom targets at write time, which is evidence the coupling was known.

Fix: clear every id the deck already uses BEFORE handing any out -- one pre-pass raising the counter
above the deck's maximum, bounded at `int.MaxValue` so a deck sitting on ST_SlideId's ceiling cannot
push the counter out of range. The inserted slide now takes a fresh 259, existing slides keep
256/257/258, and undo restores exactly. This matches PowerPoint, which never renumbers an existing
slide on insert; only a genuine duplicate is still reassigned.

Both tests proven able to fail by neutering the pre-pass (`Take(usedSldIds.Count)`, which is empty
there) -- 2 failed with the expected message, restored, verified identical to the backup. A first
attempt at that revert probe silently did nothing because `python` is not installed on this machine
and the heredoc never ran; the resulting "Passed" was stale and would have been a false proof.

Lanes: FreeP.App.Presentation.Tests 5947/5947 green. Full FreeP.slnx has 14 failures in
SlideCanvas/RichTextEditor/RenderCompare/dialog pixel-render tests; `query session` reports session 1
`Disc`, the disconnected-session condition from r362 that returns blank WPF bitmaps. None touch slide
ids and the lanes that do are green.

## r390 - R82 rich-value binding across a row delete: fixed, and r355's premise corrected

Closed the longest-standing open lead in this ledger. r355 recorded it as "CONFIRMED DEFECT, root
cause known, fix pending", and left the assertion as `?.` on purpose so it could not report a pass it
had not earned -- the right call, and the reason the lead survived intact to be finished here.

**The defect (fixed).** Rich-value placeholders all serialize identically (`t="e"`, no formula,
`<v>#VALUE!</v>`) whatever entity their `vm` points at, so a same-address hit cannot by itself prove
the target is the same cell rather than a same-signature sibling shifted up by a delete. The guard in
`CellValueMatchesCapturedNativeMetadata` answered by refusing the whole signature group whenever its
count changed -- but a delete ALWAYS changes that count, so cells that never moved lost their
bindings too. Excel keeps a rich value bound across a row delete.

Fix: localise the shift instead of refusing wholesale. `ComputeStableRowFrontier` finds the first row
that exists in BOTH source and target yet differs in content; a cell strictly above it provably did
not move, because an insert or delete above it would itself have changed a row at a smaller index,
contradicting that row being the first. Such cells bypass the ambiguity guard; everything at or below
stays refused exactly as before. Rows present on only one side deliberately do NOT establish a
frontier -- see below.

**r355's premise was wrong about its own fixture, and correcting it mattered.** Hardening the
existing assertion to `!` still failed after the fix, and the fixture is why: every row holds ONLY
the identical placeholder, so deleting row 2, 3, 4 or 5 produces byte-identical output. Nothing
distinguishes "B2 kept its entity" from "B2 now holds what B3 held", and binding `vm="10"` there on
the assumption B2 stayed put would be precisely the silent cross-binding the guard exists to prevent.
Refusing is CORRECT for that sheet, so the `?.` stays with the reasoning rewritten. Excel never faces
the question because it knows a delete happened; FreeX reconstructs intent by diffing source XML
against the saved model, and that sheet carries no evidence of where the delete was.

The fix is therefore proven on a fixture that DOES carry the evidence -- the realistic shape, where
the rich-value column sits beside a column identifying each row, as Stocks/Geography sheets actually
are. There row 3's content changed and rows above it did not, so B2 keeps `vm="10"` (hardened to `!`)
while B3 and B4 still refuse the stale bindings of the rows that used to sit there. Proven able to
fail by neutering the frontier: the new test throws on the dropped attribute, the other two stay
green.

Had I trusted the note's stated target instead of re-deriving it, the "fix" would have been to force
the binding through -- shipping the cross-binding the guard was built to stop. Second time in this
program a pending-work note's PREMISE, not its diagnosis, was the thing that needed checking.

Lane: FreeX.Core.IO.Tests 6370/6370 green, 64 skipped.

## r391 - Culture sensitivity in the file-format writers: swept clean, now pinned

A dimension this program had not swept, and a severe one: a number formatted under a German or
French locale corrupts every file the writer produces, and does so ONLY for users running that
locale -- never on the machine that wrote the code. Save-as-PDF is table stakes for all three apps
and PDF is float-dense, so the blast radius covers FreeX, FreeW and FreeP alike.

**Result: no defect found.** Measured, not assumed:

- FreeX .xlsx save under de-DE/fr-FR/tr-TR, scanning every XML part: clean.
- FreeP .pptx write under the same three, scanning EVERY attribute of every part for a value that is
  wholly a comma-decimal: clean.
- No bare `ToString()` on any floating-point value in `FreeX.Core.IO`, `Free.Shared.Opc`,
  `Free.Shared.Drawing`, `FreeP.Core.IO` or `FreeW.Core.IO` (139 bare calls exist; all are on
  integers).
- No `string.Format` without a provider anywhere in those IO layers.
- `PortablePdfWriter` funnels every value through one `FormatNumber` helper that passes
  `InvariantCulture` -- correct by design.

**Two instrument errors, both caught by the round's own rules.** The first probe failed identically
in all three cultures at the SETUP line (`GetSheetAt(0)` on a workbook with no sheet) -- the
"every case fails the same way, suspect the harness" tell. The second reported a false positive I
manufactured myself: `"1E-07".Replace('.', ',')` contains no `.`, so the suspect string was just
`1E-07`, which legitimately appears in the output.

**What was missing was protection, not correctness.** `FormatNumber` is a single chokepoint, which
is the right design and exactly the shape a later edit erodes: one `$"{value}"` written next to the
helper instead of through it is silently correct on the author's machine. So the probes became three
permanent tests pinning the OUTPUT rather than the helper, each self-checking that the culture
actually took effect before trusting a pass. The PDF test was proven able to fail by making
`FormatNumber` culture-sensitive: it caught 15 corrupted numbers including colour components,
then the writer was restored and verified byte-identical.

Lanes: Free.Shared.Pdf.Tests 232/232, FreeX.Core.IO.Tests 6373/6373, FreeP.App.Presentation.Tests
5950/5950.

## r392 - Every FreeX adapter round-trips numbers under a foreign locale

Closes r391's stated gap. r391 pinned three writers (.xlsx, .pptx, PDF) by scanning their output;
this covers the whole adapter surface in one reflection-driven contract, so a format added later is
covered the day it appears rather than the day someone remembers to write a test for it.

A ROUND TRIP is the stronger instrument. Scanning bytes catches a writer emitting a comma decimal;
a round trip also catches a reader parsing one with the wrong culture, and the case where writer and
reader are both culture-sensitive and cancel out on the author's machine while corrupting the file
for everyone they exchange it with. The text formats are the real exposure -- CSV, DIF, SLK, PRN are
numbers-as-text by definition.

**Result: all 18 adapters preserve 3.14 under de-DE, fr-FR and tr-TR.** Covered: CSV, CSV-UTF8, DBF,
DIF, HTML, legacy XLS, MHT, native JSON, ODS, PDF, PRN, SLK, SpreadsheetXML, Unicode text, and the
XLSX/XLSM/XLTX/XLTM family. Three (DBF, legacy XLS, PDF) are load-or-save-only and say so with
NotSupportedException; the test REPORTS them in its failure message rather than skipping silently,
because a silent skip is how a contract quietly stops covering what it names. The query is pinned at
>= 18 so it cannot shrink to a confident green over zero coverage.

Proven sensitive, not vacuous: making `DelimitedTextWorkbookWriter` format numbers with
CurrentCulture turned 3.14 into **3** on reload -- real data loss -- and the contract caught it.
Writer restored and verified byte-identical against a backup.

### Open lead (characterised, deliberately not changed here)

FreeX picks the CSV DELIMITER from the locale -- `;` on de-DE -- and `CsvFileAdapter`'s own comment
explains why: "';' ... precisely because ',' is their decimal mark", citing "decimal-comma numbers
like 1,50". But `DelimitedTextWorkbookWriter` formats the NUMBER invariantly, so FreeX writes
`3.14;` -- a combination no locale produces. Excel on de-DE writes `3,14;`, and would import
FreeX's `3.14` as TEXT. The read path was already made bicultural (TryParseFiniteNumber tries
CurrentCulture then InvariantCulture, which is why the round trip above passes); the write path never
was. The asymmetry is the defect.

Not fixed in this round on purpose. The four call sites need different answers -- CsvFileAdapter uses
a locale delimiter, CsvUtf8FileAdapter a fixed ',' (locale decimals there would SPLIT fields, which
is exactly how the sensitivity probe above corrupted 3.14 into 3), UnicodeTextFileAdapter a tab --
and any fix needs a guard for the case where the list separator equals the decimal separator. Making
a four-adapter output change at the tail of a round, without Excel available to confirm per-format
behaviour, is how r356 earned a full revert. Worth its own round.

Lane: FreeX.Core.IO.Tests 6376/6376 green, 64 skipped.

## r393 - Plain CSV writes the locale decimal mark, as Excel does

Acts on the lead r392 characterised. FreeX already took the CSV DELIMITER from the OS list separator
because Excel does -- ';' on de-DE, and `CsvFileAdapter`'s own comment says why: "precisely because
',' is their decimal mark". But the number was still written invariantly, so FreeX emitted `3.14;`,
a combination no locale produces. Excel on such a machine imports that as TEXT, which means every
number FreeX exported was unusable for exactly the user the localisation was for. Only the write path
was wrong: the reader already tries the current culture then the invariant one, so FreeX read
European files correctly and its own round trip stayed green -- the defect was invisible to any test
that only went out and back.

Fix: `DelimitedTextWorkbookWriter` takes an `IFormatProvider`, defaulting to invariant so no existing
caller changes; `CsvFileAdapter` passes the current culture. Guarded -- a culture whose list separator
IS its decimal separator keeps invariant numbers, since a decimal comma beside a comma delimiter
splits one number into two fields (exactly how r392's sensitivity probe corrupted 3.14 into 3). Cells
carrying an explicit number format are unaffected; those already render through NumberFormatter.

**The suite caught two things I got wrong.** Routing the number through `WriteField` allocated a
string per cell and broke `Save_StreamsNumericValuesWithoutPerCellStringAllocation` -- a real
regression on the dense export path. Restored the zero-allocation direct write; it is safe because
default double formatting emits no group separators, so the text can never contain the delimiter, and
the guard above keeps that true. Two source guards pinning exact call-site text were updated to the
new signature with their INTENT unchanged.

**This overrides a prior deliberate decision, and that deserves stating.** `R275_CultureProbeTests`
pinned invariant decimals for nine text formats, reasoning that "the decimal separator is part of the
wire format and must not follow the operator's locale". That is right for eight of them -- SLK, DIF,
SpreadsheetML, JSON and HTML specify their number syntax, and csvutf8/delimited/prn write a FIXED
delimiter. Plain CSV is the exception: it specifies nothing, and its delimiter already follows the
locale. So r275's list was NARROWED rather than discarded, with the reasoning recorded in place.

Caveat recorded honestly: real Excel is not available here (COM is not registered), so this rests on
documentary evidence -- the adapter's own comment describing genuine European exports containing
"decimal-comma numbers like 1,50", and the fact that `3.14;` is a combination no locale writes. The
standing rule is to match Excel; if that reading is ever shown wrong, the change is one provider
argument.

Correction to my own earlier rounds: r275 had ALREADY probed culture across these text formats, so
r391/r392 partly re-covered existing ground. r392's reflection-driven all-adapter contract and the
PDF/PPTX coverage remain additions, but I overstated their novelty at the time.

Lanes: FreeX.Core.IO.Tests 6378/6378 green. Default suite green across every lane that can see a CSV
change (Services 3583, Integration 978, Model 6707, Calc 2057, Formula 5253). Two failures elsewhere
are pre-existing: a source guard on SlicerTimelinePanePlanner.cs (a file this change never touches,
so it fails identically on origin/main) and a WPF chart dialog in the r362 disconnected-session set.

## r394 - Resolving the failures I had been attributing instead of reading

Three defects, found by diagnosing failures earlier rounds waved away. Two of them were mine.

### 1. A stale guard pinning an implementation a real fix had deleted

`BuildSlicerTiles_AvoidsLinqMaterializationScaffolding` required
`new SortedSet<string>(StringComparer.CurrentCultureIgnoreCase)` in the slicer planner. r311 REMOVED
that line deliberately: one culture-aware set was deciding both which items exist and how they are
ordered, so two source values the IO layer keeps distinct could collapse into a single tile. Identity
is ordinal; ordering is the user's locale. The guard had been red ever since, pinning the very code
r311 deleted -- worse than no guard, because it pressures the next person to revert a real fix to get
green. Rewritten to pin r311's INVARIANT (ordinal identity, culture-aware ordering) with a tripwire
against reintroducing the conflated set.

### 2. An r379 regression I misattributed twice

`ChartDisplayOptionsDialog` expected `PlotVisibleOnly` false and got null. That is not a
disconnected-session render artifact, which is what I called it at r389 and again at r393 -- I read
the test NAME and pattern-matched instead of reading the message. Cause: r379 (mine) made the classic
chart-area capability enforced on COMMIT rather than only by greying the control, because a chartEx
chart has nowhere to store "plot visible cells only" and a disabled field still round-trips a value
through the dialog input. The gate is correct; the fixtures predated it, flagging a Stock chart as
IsChartEx and expecting classic options to commit. Corrected in the WPF test and its Avalonia twin,
plus a NEW classic-chart case -- without it, a gate that swallowed the option everywhere would look
identical from the chartEx test alone.

**Exact accounting for r389, replacing the blanket claim I made there.** `query session` now reports
session 1 `Active` where it previously read `Disc`, and the SlideCanvas/RichTextEditor/RenderCompare
tests pass with no code change. So 12 of those 14 failures were genuinely environmental and 2 were
this r379 regression. The whole FreeP solution is now green, all 8 assemblies.

### 3. The user is told about a worksheet loss they just agreed to

Found by running FreeX.App.Host.Logic.Tests, which is NOT in DefaultTests and so had gone unrun for
several rounds. `MultiSheetWorkbookWithChart_SaveAsCsv_WritesWhenConfirmationAccepted` saw 2 message
boxes, not 1. First suspicion was my own r393 CSV change; reverting the provider left it failing, so
not mine. Capturing the prompts showed the same fact twice:

    [1] Possible Data Loss ... only the current worksheet's data will be saved ... Keep this format?
    [2] File Saved with Warnings ... Only "Sheet1" was saved; "Sheet2" was not.

r292 added the second one reasoning "Excel warns before doing it and FreeX did not" -- but FreeX
already did, through the R69 lossy-format gate, which fires on the SAME `Sheets.Count > 1` condition
and is called by BOTH shells. The warning duplicated an existing one and left R69 red across r292 and
r310. Excel asks once and then saves silently.

Fix: `WorkbookSaveService` suppresses the post-save sheet-loss warning only for formats the pre-save
gate covers. The distinction is the whole point -- `LossyFormatFeatureLossPlanner` documents .xml,
.html/.mht and .pdf as NOT gated, and there the warning is the user's only notice, so suppressing it
everywhere would delete the notice rather than de-duplicate it. R394_SheetLossIsReportedOnceTests
pins both halves.

Lanes: full solution build green; DefaultTests 31 assemblies, 0 failures. FreeP.slnx all 8 green.
FreeX.App.Services 3590, FreeX.App.Host.Logic 1509.

## r395 - Whole test-surface sweep: the baseline, measured rather than assumed

r394 showed that `FreeX.App.Host.Logic.Tests` sits outside `FreeX.DefaultTests.slnx`, had gone unrun
for several rounds, and had quietly accumulated three reds -- one of them a real user-facing defect.
That makes the default aggregate an incomplete gate, and any lane outside it can rot unobserved. So
this round measured the whole surface instead of inferring it.

Enumerated every test project (`find . -name '*.csproj' | xargs grep -l 'Microsoft.NET.Test.Sdk'`)
-- **34** of them -- and ran each SERIALLY with a build, because concurrent lanes abort each other's
assemblies.

**Result: 58,946 passed / 181 skipped / 0 failed. 34 of 34 projects green.** No build errors, no
missing summaries. That covers FreeX, FreeW (7 projects), FreeP (7) and the shared tier, including
the lanes DefaultTests never touches: `FreeX.App.UI.Tests` (1110), `Free.Shared.Ribbon.Wpf.Tests`
(55), `FreeX.App.Host.Logic.Tests` (1509), and the whole FreeW and FreeP solutions.

Worth stating plainly: FreeW's seven suites (11,761 tests) had not been run once in this session --
r391's survey reached FreeW's writers by inspection only. They are green, but that was an assumption
until now.

The practical consequence is that **the codebase no longer has a known-red list**, so from here a red
test is a real signal rather than something to explain away. That matters more than the number: this
session twice dismissed a failing test by pattern-matching its NAME to a known environmental cause
(the disconnected-session WPF blank-render effect), and one of those was a live regression of my own.
A correct general cause is the easiest way to wave away a specific real bug. Memory updated to
supersede the old known-red entry with this baseline, the sweep command, and that lesson.

## r396 - FreeW's document formats: the third app's culture coverage, and an instrument that was lying

r391/r392 pinned FreeX's adapters, FreeP's .pptx writer and the shared PDF tier. FreeW was surveyed
by INSPECTION only -- r395 made that gap explicit when it showed FreeW's 11,761 tests had not run
once this session. This closes it, driving all 9 `IDocumentFileAdapter` implementations by reflection.

The exposure in a word processor is formatting, not cell values: font sizes are half-points, indents
and spacing twips, image extents their own units, and each is written as text. ODF lengths carry a
unit suffix ("1.25cm") and HTML puts them in CSS, so a comma decimal there yields a document the
reader rejects -- for that locale's users alone.

**Result: no defect. All 9 adapters are invariant** (PdfFileAdapter is save-unsupported and is
reported, not skipped silently).

**The finding of this round is that my first instrument could not have caught anything.** It flagged
attribute values that were WHOLLY a comma-decimal -- copied from the .pptx test, where that shape
fits. It does not fit here: ODT writes "1.25cm" and HTML writes "font-size:10.5pt", so neither is
ever an attribute that is entirely a number. The test passed, and would have passed with every
formatter broken. Rewritten to flag a comma BETWEEN digits anywhere in an attribute, and to scan
flat formats (HTML, RTF, MHTML) as whole text since their numbers live in CSS and control words.

**And the corrected instrument was still only reaching one format.** Breaking OdtFileAdapter's
length formatter produced 8 offenders including `page-width = 21,59cm` -- but HtmlFileAdapter, which
sorts BEFORE Odt and so would have shown first, produced none. Its only decimal formatter, FormatPt,
is used for image width/height alone, and the fixture had no image. Adding a fractionally sized image
took proven coverage from 1 format to 3: the same break now yields
`HtmlFileAdapter -> width="12,5pt"` and `MhtmlFileAdapter -> width=3D"12,5pt"` (MHTML shares the HTML
writer). A green from an unexercised path is the failure mode this program keeps rediscovering, and
twice in one round here.

One self-inflicted error worth recording: adding the image paragraph FIRST displaced
`Paragraphs.First()` and broke the round-trip control, which reads the font size from it. Reordered.

Lane: FreeW.Core.IO.Tests 1974/1974 green. Production files restored and verified unchanged.

## r397 - Find-with-wildcards could freeze FreeW's window, and r287 had cleared it

A new dimension: unbounded regex backtracking. 39 regexes are constructed in production parsing code
and NONE passes a match timeout -- but a missing timeout only matters where a pattern can explode and
the input is user-driven, so the count is not the finding. Tracing them, FreeX's formula regexes
already pass `FormulaSafetyLimits.RegexTimeout`; the user-supplied-pattern path was hardened there.
FreeW's Find-with-wildcards was not.

**The defect, measured.** `TextSearch.FindAll(useWildcards: true)` compiles the typed needle with no
timeout. Against a 40-character run of 'a':

    6 wildcards  ->   373 ms
    8 wildcards  ->  did not finish in 5 s

Find runs on the UI thread, so that is a frozen window with no error and nothing to cancel: the user
kills the process and loses unsaved work. The needle is something they typed, not a hostile file.

**r287 examined this exact class and cleared it.** Its reasoning: wildcard syntax has no grouping and
no counted quantifier, so the `(a+)+` shape cannot be written, therefore the missing timeout is
survivable. The first half is true and its tests still pin it. The conclusion does not follow -- the
classic exponential case needs no group at all. `*a*a*a*b` becomes `.*?a.*?a.*?a.*?b`, where each
wildcard can split the text many ways and the failures multiply. r287's measurement used ten
CONSECUTIVE stars, which collapses immediately; stars SEPARATED by literals are the dangerous shape.
It measured the wrong shape and generalised from it.

Fix: an explicit 1s `WildcardMatchTimeout`, mirroring the sibling app's precedent, with a timeout
turned into "no more matches" exactly as the existing malformed-pattern path behaves. A `yield return`
cannot sit inside a try/catch, hence the small `MatchWithinTimeout` helper. After the fix 8, 12 and 16
wildcards all complete at ~1s -- one timeout ends enumeration, so the ceiling is per search, not per
position.

r287's tests are KEPT and its doc comment corrected in place: the structural property it pins is real
and worth guarding; only its conclusion was wrong. The lesson recorded there is that "this syntax
cannot express the textbook bad pattern" is not the same claim as "this syntax cannot be slow".

Third time this session a prior round's PREMISE rather than its diagnosis was the thing to check
(r355's fixture, r292's "Excel warns and we do not", now r287's structural argument). The pattern is
consistent: each was a correct observation carried one inference too far.

Lanes: full FreeW.slnx green, all 7 assemblies, 11,771 tests.

## r398 - Regex-on-file-content: the untrusted half of r397's class, verified clean

r397 fixed the user-TYPED pattern (FreeW's Find). The other half of the class is regexes fed FILE
content, where merely opening a document could hang the app. Swept it; **no defect found.**

What was checked, and how:

- **`AccessibilityTextRules.DomainLikeTextRegex`** -- the strongest suspect, since domain-validation
  patterns are a famous ReDoS family and this one nests `(?:[A-Z0-9-]{0,61}[A-Z0-9])?` inside
  `(...)*`. It is reached from `IsDescriptiveHyperlinkText`, which the accessibility checker feeds
  hyperlink display text loaded from the workbook -- genuinely file-controlled. MEASURED across four
  adversarial shapes (repeated dots, 40-char labels, one long label, hyphen runs) up to 1,640
  characters: every case completes in single-digit milliseconds. Safe, and for a structural reason:
  each label is anchored by a mandatory literal `\.`, so segmentation is deterministic and the
  bounded inner quantifier cannot interact across segments. That is exactly what makes FreeW's
  wildcard case different -- `.*?` spans any character, dots included, so its segmentation is not
  anchored at all.
- **`SpellCheckService.IgnoredAddressSpanRegex`** and the `FormulaReferenceCycler` reference patterns
  -- assessed structurally rather than measured: every repetition is anchored by a mandatory literal
  (`/`, `@`, `.`, a quote), and the one alternation inside a quantifier (`(?:[^']|'')+`) has disjoint
  branches, so no input can be split two ways. Recorded as reasoning, not measurement, deliberately.
- **FreeX's formula regexes** already pass `FormulaSafetyLimits.RegexTimeout`; the user-supplied
  pattern surface was hardened there long ago, which is why r397's fix had a precedent to mirror.

**A probe error worth recording, because it produced a clean-looking result for the wrong reason.**
The first run terminated every adversarial string with `!` and reported 0ms everywhere. But
`NormalizeComparableText` trims a trailing `!` before the regex ever runs, so the input the engine
saw was a well-formed domain that matched immediately -- the probe was measuring the normalizer, not
the pattern. Re-run with `~` (not in the trim set) the timings were unchanged, which is what makes
the negative result trustworthy. A green from an input that never reached the code under test is the
same failure this program keeps finding in its own instruments; r396 hit it twice.

No test added. A timing assertion on a structurally-safe pattern would be flaky and would pin the
machine's speed rather than a property. The finding is the reasoning, recorded here.

## r399 - Sync-over-async on the UI thread: hazard present, deadlock not reproducible

Third hang class after r397 (user-typed regex, real) and r398 (file-fed regex, clean). Blocking on a
task from a UI thread whose continuations capture that context is the classic permanent freeze.

**The count is not the finding.** 330 `.Result` / `.Wait()` / `GetAwaiter().GetResult()` occurrences
exist in production code. Reporting that number as issues would be pattern-matching: most read an
already-completed task, and blocking is only fatal where a captured SynchronizationContext is the one
being blocked.

Narrowed by measurement instead. `FreeX.App.Services` has 37 awaits but only 7 `ConfigureAwait(false)`
(the shared tier is much better: 43 of 66), and `PortablePdfDocumentExporter.Save(path)` blocks with
`GetAwaiter().GetResult()` on `AtomicExportExecutor.ExecuteAsync`, whose chain has several awaits that
DO capture context (`return await ExecuteCoreAsync(...)`, `await using var output = ...`). On paper
that is the textbook deadlock.

**It does not reproduce.** Ran the path on a thread carrying a single-threaded SynchronizationContext
that queues continuations and never drains them -- so any posted continuation deadlocks by
construction. Result: completes, twice, and the second run wrote a **4.9 MB** PDF (32,000 cells), so
the payload was genuinely large enough to force real async file I/O rather than synchronous
completion. The file size was added to the probe precisely because "large workbook" is not the same
claim as "large written file" -- the print plan clamps the range, and without checking bytes the
negative would have rested on an assumption.

**No production change.** The hazard is real in shape and the codebase's own convention (the shared
tier's ConfigureAwait discipline) points the other way, but I could not demonstrate a failure, and
editing production code on a hazard that survives a deliberately hostile probe is speculation. What
is recorded instead: the exact call, the awaits that capture context, and the probe that would catch
it if the chain ever changes. If this is revisited, the cheap hardening is `ConfigureAwait(false)` on
`ExecuteCoreAsync` and the `await using` sites in AtomicExportExecutor.

An instrument note, since perl bit again exactly as memory records: rewriting a C# interpolated string
with perl ate the `$"`, producing a syntax error rather than silent damage this time.

## r400 - Path traversal from document content: clean, and already pinned

A high-severity class not previously swept: OPC packages are zip archives, and any code that writes a
part to disk using a name taken from the document lets `..` escape the target directory -- an
absolute path is worse still, since `Path.Combine` discards its base when the second argument is
rooted. Opening a crafted file would write attacker-chosen bytes to an attacker-chosen location.

**No defect. Every write path traced to its sanitizer:**

- **No zip extraction exists at all** -- no `ExtractToFile`/`ExtractToDirectory`, and no
  `Path.Combine` fed an entry's `FullName`/`Name` anywhere in production. The class's most common
  form is absent by construction.
- **OLE activation** (`OleActivationService`, the one production `Path.Combine(dir, <document
  name>)`): `OleActivationPlanner.SafeFileName` normalises `\` to `/`, takes `Path.GetFileName`,
  and rejects empty, `.`, `..`, any surviving separator, and control characters, then forces the
  extension to the resolved safe one. Production only ever builds a plan through that planner, and
  activation separately refuses executable/script extensions.
- **Media, transition-sound and playback temp files**: the file NAME is generated (prefix + random),
  and the extension comes from `OpcMediaTypes` -- an allowlist dictionary keyed by content type with
  a hard-coded fallback (`bin`/`mp3`/`mp4`), so a hostile content type cannot produce an arbitrary
  extension.
- **Caption tracks**, the only place a document string reaches the extension: a strict allowlist
  (`vtt|ttml|dfxp|srt`), defaulting to `vtt` for anything else.

**Already pinned, too.** The OLE tests feed `"..\outside\Budget.xlsx"` and `"../../payload"`
through the planner. No test added -- the guard this class depends on is exactly the one already
covered, and a second copy would be noise rather than protection.

Recorded because the negative is the useful artifact: the next person to ask "can a crafted file make
FreeP write outside its temp directory?" gets the four paths and their sanitizers rather than having
to re-derive them.

## r401 - A zip-bomb guard that ran after the expansion it exists to prevent

Swept decompression limits with the cross-app-drift lens that found r397. The shared
`WorkbookOpenSizeGuard` is used well: FreeX's xlsx/ods, FreeW's DocxReader and OdtFileAdapter, and
FreeP's PptxPackageReader all call it. One branch slipped past.

**The defect.** `DocxFileAdapter.Load` ran the strict pre-pass FIRST -- `StrictOoxmlTransform.IsStrict`
opens the package to read `word/document.xml`'s namespace, then `RewriteStrictToTransitional`
decompresses every part to rewrite namespaces -- and only handed the rewritten result to DocxReader,
where the guard lives. Ordering makes the guard useless on that path: it runs on the OUTPUT of the
expansion it was meant to bound.

Measured, not argued:

    WorkbookOpenSizeGuard on the archive : REJECTED (WorkbookTooLargeException)
    StrictOoxmlTransform (runs first)    : COMPLETED, 408 KB in, 400 MB of parts, ~100ms

The codebase's own guard calls the file a bomb; the strict path processes it regardless. A bigger pad
is the same code path with a bigger number.

Fix: check at the adapter entry, ahead of both decompressions, so strict and transitional routes are
bounded by the same rule. DocxReader still checks its own stream -- cheap (central directory only)
and keeps that path safe for its other callers.

Three tests, and the two controls are the point. A CONTROL proves the fixture really is a bomb by the
guard's own reckoning; without it the main test could pass by rejecting a harmless file. A POSITIVE
control proves an ordinary strict document still opens; without it a guard that refused every strict
file would look correct. Neutering the guard fails exactly the middle test, leaving both controls
green.

Two things checked rather than assumed: the Strict adapter is registered in
`DocumentFileAdapterCatalog`, so this is reachable and not dead code; and `WordXmlFileAdapter`'s
unguarded zip open reads an archive it just WROTE on the save path, so it correctly needs no guard --
adding one there would have been noise dressed as diligence.

Lanes: full FreeW.slnx green, all 7 assemblies, 11,774 tests.

## r402 - Auditing the shared protection surface, systematically rather than opportunistically

r397 and r401 both came from one shape: a protection that exists and is applied correctly nearly
everywhere, with a single path that reaches the hazard before the check. Rather than keep finding
those by luck, this enumerates the shared guards and asks of each: does every consumer apply it, and
in the right ORDER? 18 `*Guard` / `*Policy` / `*Sanitizer` / `*Limits` types live in the shared tier.

**`WorkbookOpenSizeGuard`** -- one real gap, fixed in r401 (the strict .docx pre-pass decompressed
before the check). Every other package reader in all three apps calls it.

**`ExternalFileWriteConflictPolicy`** -- the data-loss one: it stops a save clobbering a file another
program changed since load. All three apps apply it in both a coordinator and a persistence workflow.
The interesting part is the RECOVERY path, where FreeP's source documents the failure precisely: if
crash recovery does not re-establish the write-time baseline, the policy "silently treats 'unknown' as
'unchanged'", so the first save after recovery overwrites a copy that changed while the app was gone.
Checked all three apps across both shells, because a fix in one shell is not a fix in the app:
FreeP re-arms in `RestoreAutosaveSnapshot`; FreeW routes recovery through the guarded
`OpenSnapshotAsync` in Avalonia and `FileCommands.OpenSnapshot` in WPF; FreeX's WPF host re-arms in
`SetCurrentFilePathForRecovery`, recomputing from the ORIGINAL file's current write time and leaving
the guard off when the original is gone. Six of six covered.

**`XmlTextSanitizer`** -- guarded by a source-scanning tripwire in each app. Memory warns this class
of guard can go vacuously green, which is the r396 failure exactly, so I checked for that rather than
trusting the pass: all three carry a `MustStayCovered` list naming real writer files, with the
reasoning spelled out -- "if it no longer matches, the regex has gone stale rather than the bypass
having gone away". That is the right design, and it is present in all three.

**No defect. No code change.** The value is the negative plus the method: the ordering question ("is
the guard reached before the hazard?") is what turned up r401, and asking it of every shared guard is
cheaper than waiting for the next one to surface. The remaining shared policies are UI-level
(dialog/zoom/ribbon/title) where the failure mode is cosmetic rather than data loss, so they were not
pursued.

## r403 - The policies r402 waved off, and why that dismissal was wrong

r402 finished by calling the remaining shared policies "UI-level ... cosmetic rather than data loss"
and not pursuing them. That was an assumption dressed as a scope decision, and it was wrong on its
face: `AutosaveRecoveryPolicy` decides whether to DELETE a crash snapshot, which is the opposite of
cosmetic, and the dialog numeric policies parse user-typed numbers, which is the culture surface
r391-r393 spent three rounds on. Swept them.

**No defect. Three things checked, each measured or traced rather than reasoned about:**

- **`DialogNumericTextPolicy` / `PageMarginTextPolicy`** take `CultureInfo` as an explicit parameter
  rather than reaching for a global -- the right shape. The risk therefore moves to what callers
  PASS: an invariant culture on a user-typed field rejects "3,14" for a German user. All 20 call
  sites thread a culture variable, and both shells resolve it to `CultureInfo.CurrentCulture`
  (FreeW's WPF `ColumnsDialog` directly, Avalonia via `DialogCulture`). No cross-shell divergence,
  which was the specific thing worth checking since the two shells are written separately.
- **`AutosaveRecoveryPolicy.ResolveDisposition`** is careful in exactly the place it matters:
  declined -> Keep, accepted-and-recovered -> Delete, accepted-but-FAILED -> Quarantine. No path
  deletes a snapshot whose recovery did not succeed, which is what protects a user whose snapshot is
  their only copy.
- **The snapshot timestamp** is written `ToString("O")` but read with a bare
  `DateTimeOffset.TryParse` -- no format provider, so culture-sensitive parsing of a value that
  orders the recovery candidates. Wrong ordering means offering the wrong snapshot and losing the
  newer work. Measured across en-US, de-DE, th-TH, ar-SA, fa-IR and ja-JP -- deliberately including
  the Buddhist and Umm al-Qura default calendars, which are where ISO parsing usually breaks: all
  six parse to year 2026 with correct ordering. The round-trip format carries an explicit offset, so
  it is unambiguous. Stylistically the parse should still name InvariantCulture, but the code is
  correct and I am not editing it on a smell that measurement disproves (the r399 rule).

The round's real content is the correction: "cosmetic" was a category I applied without checking, and
one of the three items in it was a data-loss policy. Scope decisions made by assumption are the same
error as findings made by assumption -- they just fail quietly instead of loudly.

## r404 - Finishing the shared-policy enumeration r402 left open

r402 audited part of the shared protection surface and skipped the rest as "cosmetic"; r403 showed
that judgement was made without looking and swept three of them. This finishes the list, so the
enumeration is complete rather than partial. Depth was matched to consequence, and that split is
recorded here rather than left implicit.

**Examined closely (a failure would change data, expose content, or pick the wrong target):**

- **`FindReplaceDialogPolicy`** (27 call sites) turns out to own dialog state and status text, not
  the replacement itself -- except `ReplacementTargetIndex`, which chooses WHICH match is replaced,
  and `Navigate`, which chooses which is selected. Both are correct: the target index clamps a stale
  index to the first match rather than running off the end. One observation worth writing down:
  `Navigate` computes `(current + direction + matchCount) % matchCount`, and C# `%` keeps the sign,
  so any `|direction| > matchCount` yields a NEGATIVE index. Unreachable today -- the only path in
  is `FindNext`/`FindPrevious` passing +1/-1 -- so no change, per the r399 rule about not editing
  production code for a hazard nothing can reach. Recorded so the constraint is visible to whoever
  adds a "skip N" later.
- **`PrinterSubmissionSelectionPolicy`** resolves the queue a document is sent to, so a wrong answer
  prints someone's document somewhere they did not choose. `Resolve` returns null when an explicitly
  requested printer is not in the discovery list, and BOTH platform services -- CUPS and Windows --
  fail the submission with "the selected printer is not available" rather than falling back to the
  default. That fallback is the mistake this shape invites, and neither makes it.
- **`OutputFileNameStemPolicy`** strips directories via `GetFileNameWithoutExtension` and replaces
  everything in `Path.GetInvalidFileNameChars()`, so no separator survives and no traversal is
  expressible -- consistent with r400's finding for the OLE path.
- **`ZoomPercentPolicy`** parses user-typed text, so it lands in r391-r393's culture surface. It
  parses BICULTURALLY -- current culture, then invariant -- and formats with the current culture,
  which is the same correct pattern the CSV reader uses.

**Assessed briefly (failure is visual):** `ApplicationWindowTitlePolicy`, `RibbonCommandIconPolicy`,
`RibbonAdaptiveCollapsePolicy`, `DialogOptionPolicy`, `WorkflowCommandCatalogPolicy`, and the two
`VisualEvidence*` policies, which are test-harness infrastructure rather than product code.

**No defect. No code change.** All 18 shared guards and policies have now been through the
consumer-and-ordering question that produced r401. Two of the eighteen had real gaps and both are
fixed (r401's guard ordering, r397's missing timeout in the same family of thinking); the rest hold.

## r405 - FreeX command undo: the third app finally gets the r387 treatment

r387/r388 pinned "a command's Revert restores the document exactly" for FreeW and r389 for FreeP.
FreeX -- the app with the most commands, 243 `IWorkbookCommand` implementations -- never got it. That
gap existed because the method was invented while working on the siblings, not because FreeX was
checked and cleared.

**Result: no defect.** ClearContents, InsertRows, DeleteRows, InsertColumns and DeleteColumns all
restore exactly, including the state most at risk from a structural edit.

**Two instrument decisions carried over from the earlier rounds, both load-bearing:**

- **Compare the MODEL, not a written package.** r389 wasted a cycle on a "broken undo" that was only
  ZIP entry timestamps moving with the wall clock. Reading values/formulas/style ids straight off the
  workbook sidesteps that entirely and pins what the user actually keeps.
- **Assert the workbook ACTUALLY CHANGED between apply and revert.** A command whose Apply silently
  did nothing satisfies an undo assertion trivially; this guard caught two bad fixtures of mine in
  FreeW and one in FreeP.

**And one this round added.** The first snapshot covered cell value, formula and style only -- but
row heights, column widths and merged regions are precisely what insert/delete row and column
commands shift, so the instrument did not reach the state most likely to be lost. Widened to include
them, with the fixture seeding a row height, a column width and a merge so there is something to
lose. A separate test then asserts the snapshot really CONTAINS all four kinds of state, because a
projection that silently omits a field produces a confident green over exactly the case it was
widened to catch -- the r396 failure, and the same shape as the `MustStayCovered` guard r402 found
protecting the XML sanitizer tripwires.

Six commands of 243 is a sample, not a sweep, and the entry says so rather than implying the family
is cleared. The value is that the harness now exists in the third app, so extending coverage is
adding a line per command.

Lane: FreeX.Core.Model.Tests 6709/6709 green, 47 skipped.

## r406 - Cashing the cheque r405 wrote

r405 ended by saying extending FreeX command-undo coverage was "a line per command". That is the kind
of claim worth testing immediately, because if it were wrong the harness would be less useful than
advertised. It held: eight more commands went in as single lines, plus one that needed its own
fixture.

Coverage now 14 commands (was 6): ClearContents, InsertRows, DeleteRows, InsertColumns,
DeleteColumns, MergeCells, UnmergeCells, ApplyStyle, SetRowHeight, SetColumnWidth, AddSheet,
RenameSheet, and MoveSheet. Chosen to reach state the first six did not touch -- merges as their own
operation rather than as collateral of a row shift, style ids, the row/column sizing the snapshot was
widened for in r405, and workbook-level sheet identity and order.

**No defect. All 14 restore exactly**, and each cleared the "must actually change the workbook" gate,
so none is a silent no-op passing the undo assertion for free.

`MoveSheet` needed its own test rather than a line: sheet ORDER is workbook-level state, and the
shared fixture has one sheet, so there is nothing to reorder. A `Check` line for it would have failed
the change-gate -- which is the gate doing its job, and a good illustration of why it is there.

Still a sample: 14 of 243. The honest framing is unchanged -- this is not a swept family, it is a
harness with a growing sample, and the ledger says so.

Lane: FreeX.Core.Model.Tests 6710/6710 green, 47 skipped.

## r407 - Annotation layers, and the change-gate earning its keep twice

Extended the FreeX undo harness again: 17 commands now (from 14), adding ClearComments,
ClearHyperlinks and ToggleWorksheetAutoFilter. These were chosen because they touch state the
snapshot could NOT see, so adding them meant deepening the instrument -- which is the more valuable
half of the work.

The snapshot now also records comments, hyperlinks, data-validation and conditional-format counts,
and the autofilter reference. All 17 restore exactly.

**The change-gate caught two of my own mistakes in one round, which is the point of it.**

1. The clear-* commands need something to clear. With an empty fixture their Apply is a no-op and the
   gate rejects them -- correctly, because a test that clears nothing proves nothing about restoring
   it. Seeded the fixture with comments and a hyperlink.
2. `ToggleWorksheetAutoFilter` then failed the gate too, and that one was more interesting: the
   command changes ONLY `Sheet.AutoFilter`, which the snapshot did not record, so the instrument
   could not see the command work at all. Had the gate not existed, that test would have passed while
   comparing a workbook the command never visibly touched -- a green proving nothing, over a command
   nobody had verified. Added the autofilter reference and column count.

That is twice in one round that "assert the thing actually changed" turned a silent pass into a
visible gap. It is the cheapest assertion in the suite and has now caught bad fixtures in FreeW
(two), FreeP (one), and FreeX (two).

Still 17 of 243. The number matters less than the shape: each addition now tends to reveal whether
the snapshot reaches the state its command touches, so coverage and instrument depth grow together
rather than coverage outrunning it.

Lane: FreeX.Core.Model.Tests 6710/6710 green, 47 skipped.
