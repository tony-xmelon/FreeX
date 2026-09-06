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
| Schema element ordering in OOXML | r483, r484 | 2 defects, both corrupting the saved file |
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

## Known unswept - named so they are a decision, not an oversight

- Resource disposal: streams, bitmaps and fonts not disposed on exception paths.
- `DateTime.Now` where `UtcNow` is meant, and time-zone-dependent comparisons.
- Equality/`GetHashCode` contracts on model types used as dictionary keys.
- Thread-affinity of statics beyond the brush/pen audit already recorded in memory.
- Integer overflow on file-controlled sizes (the non-finite sweep covered doubles only).
- P/Invoke and native-interop boundaries in the Windows-only projects.

## What the map is for

Two rounds in this stretch (r476, r487) spent their effort on sweeps that produced only false
positives, and r488 established why: a sweep is worth running when its shape has a precise signature
whose violation is definable. The classes above are listed with that in mind - the unswept list is
ordered roughly by how precisely each could be expressed as a signature today.
