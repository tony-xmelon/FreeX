# FreeW Compare respects do-not-track-moves

## Scope

FreeW already read, wrote, and retained Word's `w:doNotTrackMoves` setting and already supported
paired `w:moveFrom` / `w:moveTo` revisions for unique whole-paragraph moves. The comparison engine
did not connect those two paths, so comparing a revised document with the policy enabled still
created move markup.

`DocumentCompare` now treats the revised document as the result-policy authority:

- with `DoNotTrackMoves=false`, the existing exact unique-paragraph move recognition is unchanged;
- with `DoNotTrackMoves=true`, the same change is represented as ordinary deletion and insertion
  revisions, matching the setting's OOXML contract;
- the comparison result retains `DoNotTrackMoves`, so save and reopen preserve the policy;
- Compare dialog settings remain an additional gate: disabling Moves still has the existing effect.

No change was made to ambiguous/edited move recognition, accept/reject behavior, revision author/date,
or ordinary insertion/deletion comparison.

## Verification

- focused move-policy model tests: 4/4 passed;
- focused policy/package tests: 10/10 passed;
- complete `DocumentCompareTests`: 30/30 passed;
- compare, move-revision, and do-not-track-moves IO families: 30/30 passed.

The serialized control asserts `w:doNotTrackMoves` is present, `w:moveFrom` / `w:moveTo` are absent,
and ordinary `w:del` / `w:ins` wrappers survive reopen without `MoveRevisionId` values.
