# Defect-class map

The round ledger (`region-coverage.md`) is chronological, so what has been swept is implied rather
than stated. This file makes it explicit: which defect CLASSES have been driven across the codebase,
what each one found, and - the part a chronological log cannot show - which classes are known to be
unswept.

It is a map of coverage, not a proof of absence. A class marked closed means the sweep was designed,
validated against a known positive, and run to completion; it does not mean the code is free of
defects outside that shape.

## Closed - swept, instrument validated, findings fixed

| Class | Rounds | Outcome |
|---|---|---|
| Undo restores value but not structure | r438, r441 | 2 defects |
| Redo mints a fresh identity | r457, r458 | 2 defects |
| Damaged file read as plausibly empty | r448-r454, r467 | 6 defects, 8 readers already sound |
| Non-finite double written to a file | r468, r469, r485, r486 | 11 defects across PDF, XPS, pptx, xlsx |
| Protection bypassed by a mutator | r455, r471 | 11 defects |
| Mutation without change notification / undo | r472 | guard added, no defect |
| Schema element ordering in OOXML | r483, r484, r498 | 2 defects; widened from the zoom writers to every writer in r498 |
| Equal-value setter clears redo | r479, r480 | 1 defect + census premises audited |
| Culture-sensitive NUMBER formatting | r470 | clean; the naive test proved vacuous |
| Culture-sensitive STRING casing/comparison | r490 | clean; 392+178 invariant uses, no bare ToLower |
| Hostile input to dialog planners | r478 | clean; 190 methods, 3,420 invocations |
| Hostile arguments to formula functions | r463 | clean; 4,960 evaluations |
| Recursion depth from a crafted file | r477 | clean; all three readers guarded |
| Zip-slip / archive path traversal | r471 | clean; nothing is extracted to disk |
| Destructive partial save | r471 | clean; temp lease + fsync + move |
| Sibling drift between app shells | r474, r475 | 1 defect; 52 pairs compared |
| Blocking a UI thread on a Task | r489 | latent trap documented; no live path |
| Division by an empty collection | r487, r488 | clean; 52 raw -> 19 real -> 0 |
| Throwing XML navigation on file input | r487 | clean; 8 sites, none file-derived |
| `async void` in production | r491 | clean; 14 non-handler sites, all fully guarded |
| Cancellation token accepted then ignored | r491 | clean; 5 candidates, all declarations or expression-bodied |
| Integer overflow / unbounded size from a file | r492 | 1 defect: an .ods decimal-places count allocated 4 GB |
| Local time where UTC is meant | r493 | clean; 35 sites, all legitimately local |
| Equals without GetHashCode | r493 | closed by the compiler: TreatWarningsAsErrors, no NoWarn for CS0659/CS0661 |
| Undisposed resource / per-paint allocation | r494, r512 | 2 defects: picture fills and picture shapes each decoded a Bitmap per paint |
| Mutable toolkit visual in a static field | r495 | 4 defects (FreeW pens); tripwire added |
| Native interop: handle leaks, wrong-OS calls | r496 | clean; 51 P/Invokes, pairing and dispatch both correct |
| Interop marshalling: buffer size units, struct layout | r514 | clean; only 3 StringBuilder params exist repo-wide (all correct units) plus one HGlobal two-call buffer; NO managed delegate is ever handed to native, so the collected-callback crash class is absent; X11 LP64 layout now guarded |
| Disposable ownership across an async boundary | r515 | clean; all 27 fire-and-forget sites checked by hand -- every one that hands over an object TRANSFERS ownership into the continuation rather than letting a using close under it |
| Culture-sensitive ordering in a file-output path | r515 | FIXED in FreeX .fxl save (observable: mixed-case error codes reorder); FreeP media extensions made ordinal for consistency (not reachable); no culture-less ToLower/ToUpper, no string .Sort() |
| XML entity expansion / external entities (XXE) | r516 | clean; .NET default is DtdProcessing.Prohibit and all 17 explicit settings say Prohibit, all 13 XmlResolver assignments are null; nothing overrides the safe default |
| Catastrophic regex backtracking (ReDoS) | r516 | clean; every user-supplied-pattern path (REGEX* functions, Find/Replace, wildcard criteria) passes FormulaSafetyLimits.RegexTimeout, so the timeout handlers are live rather than decorative |
| Integer overflow in EMU/coordinate math from file input | r516 | clean; conversions widen to long before multiplying, and the one checked((int)) cast is range-bounded to 1584pt upstream |
| Duplicate key built from a file-controlled id | r516 | clean; the one ToDictionary over an untrusted id (XlsxRelationshipReader.LoadTargetsStrict) is caught BY DESIGN -- caller param is rejectDuplicateRelationshipIds, the catch is commented, and a test pins TryCreate returning null. See r516: my "fix" was RETRACTED |
| Shared mutable static collection (thread safety) | r517 | clean; all 12 runtime-mutated statics guarded by a gate lock, [ThreadStatic] isolation, or lock-on-collection; now enforced by a source tripwire with one documented WPF-affinity exemption |
| Undisposed file handle on an exception path | r518 | clean; zero disposable locals created outside a using across all production code |
| Truncated/damaged part in a package | r518 | DIVERGENCE recorded, not a bug: FreeX and FreeW throw XmlException; FreeP opens the deck, blanks the damaged slide and warns (naming the save-over hazard). Repair-on-open in FreeX/FreeW is a product gap vs Office, not a review fix |
| Non-BMP text (surrogate pairs) in text functions | r519 | clean; FreeX counts UTF-16 units exactly as Excel does (LEN=4 for A+emoji+B, LEFT splits the pair), now pinned by test; four DEAD helpers implementing the other semantics removed as a trap |
| Sort stability vs Excel | r520 | clean; FreeX's two List.Sort comparators both end in an OriginalIndex tiebreaker, FreeW's ParagraphSort uses OrderBy and takes direction from the comparer, not by reversing results |
| Untrusted HTML paste (clipboard) | r520 | clean; iterative parser, colspan/rowspan clamped to sheet width so a small paste cannot amplify into a huge allocation |
| Unchecked cast/index in command targets | r520, r521, r522 | FIXED in FreeW EditCommands: 18 TableAt (r520), 8 ParagraphAt (r521), 6 INLINE casts (r522, two also indexing Runs unguarded). Name-based sweeps missed the inline ones; the pattern sweep found them. Two sites outside the file are safe by construction. Also CORRECTS r518 |
| Index captured at construction, dereferenced later | r523 | REFRAMED: the danger is the temporal gap, not the cast. All 42 element casts in production swept; every one outside the command layer is safe because resolution and use are adjacent. Command-layer regressions now blocked by a tripwire |
| Pattern-match indexing without a bounds check | r524 | FIXED 38 sites in FreeW: Blocks[i] is Paragraph p type-checks safely but indexes FIRST. Half-guards that bounds-checked runIndex on the same line and missed the block index. Invisible to every cast-based sweep |
| Captured index dereferenced after the document changed | r525 | FIXED 7 more in FreeW (DeleteParagraph read+RemoveAt+Insert, drawing-group _members coordinates, _members[0] with no emptiness test). Confirmed FreeP/FreeX clean with THEIR collection names -- r524 scan searched Blocks[] and was blind to both |
| Insert at a captured index (upper bound is Count) | r526 | FIXED 1 of 9: DeleteTableRow.Revert checked the lower bound only. The other 8 across all three apps clamp correctly (Math.Clamp/Math.Min, bounded loops, or start at Count and only descend) |
| Hostile index, driven behaviourally (not by regex) | r527 | FIXED 4 sites invisible to five prior sweeps because the index was a FIELD (_paragraphIndex) and every scan required a leading [a-z]. Census test now constructs every FreeW command with an impossible index and requires no throw |
| Hostile index census, FreeP | r528 | clean; 65-67 commands actually exercised, none throws. NOT ported to FreeX: 227 command classes, zero constructible from primitives, so the census would exercise nothing while looking like coverage |
| Equality semantics: mutable dictionary key | r497 | clean; value-equality keys and mutable types are disjoint sets |
| Save idempotence (accumulation, reorder, nondeterminism) | r499 | clean for the in-memory surface; guard added |
| File-controlled loop count (hang, not OOM) | r500 | clean; already guarded in FreeX, no sibling gap |
| Unbounded recursion over file-controlled nesting | r501, r502, r503 | 1 defect (FreeP, fatal); every nesting structure in all three readers enumerated |
| Recursive resolution in EVALUATION (named formulas) | r504 | clean; cycle-detected per (name, scope), returns #REF! as Excel does |
| Decompression bomb (zip bomb) | r505, r506 | clean; honest, lying and zip64-sentinel forms all closed, measured |
| Event-subscription leak (source outlives subscriber) | r507 | clean; 2 static subscriptions, both process-lifetime by design |
| Autosave racing the user's edits | r508 | clean; every shell snapshots on the dispatcher thread |
| Path built from document content (traversal) | r509 | clean; one site, sanitised upstream; reserved names measured harmless |
| Apply throws mid-mutation (torn edit, phantom undo) | r510 | clean; all three buses roll back and push only on success |
| Style inheritance cycle (basedOn chain) | r511 | clean; six walkers, same visited-set idiom; siblings have no cyclic chain |
| Image decoded on every render pass | r512, r513 | FIXED in FreeP Avalonia (shapes, fills) and FreeP WPF (shapes, bullets); FreeW watermark cache moved off a single evicting slot; FreeW's other decodes already cached, converter/import paths are not per-paint |
| Undisposed Avalonia bitmap (no finalizer) | r513 | Avalonia's Bitmap declares no Finalize, so an abandoned one leaks permanently; the remedy is a never-evicting identity cache, NOT eager Dispose, which would risk a queued draw op replaying freed pixels |
| Capture-then-apply index (FreeX) | r529 | clean; cells are KEY-addressed so no positional range exists, and 8 of 9 sheet-index sites are guarded/loop-bounded. MoveSheetCommand.Revert is unguarded but unreachable (sheets removed only by commands on one LIFO stack) and contained by the bus -- recorded with its trigger, not hardened |
| Event subscription multiplying across undo/redo | r530 | clean; exactly ONE event subscription exists in the model+command layers and it already uses remove-first. Adjacent finding: chart position IS snapshot-restored on undo (identity-keyed), but nothing pinned it -- now covered |
| Snapshot aliases live state (undo restores nothing) | r531 | clean in all three apps, by different mechanisms: FreeX copies every dictionary AND its value types are immutable records/strings (the one IReadOnlyList is never cast back or mutated in place); FreeW/FreeP hold two shallow snapshots where sharing element references is correct because only ORDER is mutated |
| Excel exact-answer quirks (1900 leap year, near-zero arithmetic) | r532 | clean and pinned; 1900-02-29 handled explicitly with 1904-system support (279 test refs), and RoundTo15SignificantDigits on every arithmetic result gives Excel's 0.1+0.2-0.3 = 0 |
| Stale or aliased dependency-graph edge | r532 | clean; SetDependencies clears before adding (symmetric for cell AND range precedents), and the cached-plan path shares only frozen/array data the graph never mutates |
| FreeP undo census blind to nested model collections | r533 | FIXED (coverage): Describe now walks animations (+motion path), comments (+replies) and group children recursively; fixture seeds every slide with TWO of each so invented indices land. Exercised 18 -> 19 |
| FreeP census constructor blockers | r534 | blocked types 39 -> 27 via a recursive record/class fallback in the argument factory; twelve more commands now driven through HasEffect+Apply (so the false-no-effect check covers them), but exercised stayed 19 -- constructible is NOT exercised |
| Apply weaker than its own HasEffect precondition | r535 | FIXED in ConvertSmartArtToShapesCommand: HasEffect required Kind==SmartArt, Apply required only that the id exist, so it destroyed a non-SmartArt shape and its animations. Found by the census once r533/r534/r535 made it reachable |
| Census limit: commands taking the previous state as an argument | r536, r537 | NOT checkable, but now DETECTED mechanically (r537): the tell is two parameters of the same non-primitive type, so they are skipped and the rest of the fallback is safe to keep (exercised 34 -> 39, blocked 27 -> 20). CommentMutationCommand and ReplaceCustomShowsCommand take before+after as constructor args, so Revert restoring the invented before is correct by construction; inventing it manufactures false undo failures |
| Census throw bucket assumed harmless | r538 | CHECKED: 5 of 6 are constructor validation rejecting invented arguments (the claimed factory limit); the 6th (SetChartDataTableOptions) throws at execution but cannot tear state -- Apply builds a new settings object and assigns it last |
| FreeW undo correctness (does Revert restore?) | r539 | clean; new census drives every constructible command with VALID arguments and requires Revert to restore the fingerprint exactly -- 10 exercised, 0 failures, neuter-verified. 51 unbuildable / 64 noChange record where its reach ends |
| Census answers enums with their default value | r540 | FIXED in FreeW R539 (last value, not first): every set-an-enum-property command was setting the value it already held and being filed noChange. exercised 10 -> 14. FreeP already stepped past the default; the flaw came from copying the nearer sibling |
| Census fixture contorted to one invented index | r541, r542 | FIXED: the index is a swept SEED (0,1,2), not the constant 0, so each command finds its own target. exercised 14 -> 19 with no fixture change; dissolves the conflict where chart commands need Blocks[0] to be a Paragraph and table commands need it to be a Table |
| FreeW census missing the redo check | r543 | FIXED: Apply-Revert-Apply now verified against the first Apply, matching FreeP. No redo failures among 19 exercised commands; assertion verified to fire, but no behavioural neuter found for FreeW (the one tried was inert) |
| Numeric written outside what the format can represent | r544, r545 | FIXED in FreeP: an infinite/overflowing crop wrote srcRect l=9223372036854775807, but ST_Percentage is an xsd:int, so PowerPoint rejects the file. Writer now clamps to the format range; model has no clamping anywhere upstream |

## Known unswept - named so they are a decision, not an oversight

(None outstanding: every class named on this map has been swept. That is NOT a claim that every
possible defect class has been enumerated - see "What the map is for" below. New classes get added
here as they are identified, and the list being empty means the identified ones are done, not that
identification is finished.)

## What the map is for

Two rounds in this stretch (r476, r487) spent their effort on sweeps that produced only false
positives, and r488 established why: a sweep is worth running when its shape has a precise signature
whose violation is definable. The classes above are listed with that in mind - the unswept list is
ordered roughly by how precisely each could be expressed as a signature today.
