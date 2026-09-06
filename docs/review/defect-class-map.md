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
| Undisposed resource / per-paint allocation | r494 | 1 defect: a picture fill decoded a Bitmap on every paint |
| Mutable toolkit visual in a static field | r495 | 4 defects (FreeW pens); tripwire added |
| Native interop: handle leaks, wrong-OS calls | r496 | clean; 51 P/Invokes, pairing and dispatch both correct |
| Equality semantics: mutable dictionary key | r497 | clean; value-equality keys and mutable types are disjoint sets |
| Save idempotence (accumulation, reorder, nondeterminism) | r499 | clean for the in-memory surface; guard added |
| File-controlled loop count (hang, not OOM) | r500 | clean; already guarded in FreeX, no sibling gap |
| Unbounded recursion over file-controlled nesting | r501, r502, r503 | 1 defect (FreeP, fatal); every nesting structure in all three readers enumerated |
| Recursive resolution in EVALUATION (named formulas) | r504 | clean; cycle-detected per (name, scope), returns #REF! as Excel does |

## Known unswept - named so they are a decision, not an oversight

(None outstanding: every class named on this map has been swept. That is NOT a claim that every
possible defect class has been enumerated - see "What the map is for" below. New classes get added
here as they are identified, and the list being empty means the identified ones are done, not that
identification is finished.)
- P/Invoke and native-interop boundaries in the Windows-only projects.

## What the map is for

Two rounds in this stretch (r476, r487) spent their effort on sweeps that produced only false
positives, and r488 established why: a sweep is worth running when its shape has a precise signature
whose violation is definable. The classes above are listed with that in mind - the unswept list is
ordered roughly by how precisely each could be expressed as a signature today.
