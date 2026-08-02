# FreeW Mail Merge Next Record Cursor

## Gap

The rule-aware record renderer correctly reported `Next Record` and matching `Next Record If`
requests through `MergeState.AdvanceRecordRequested`, but the all-record merge loop ignored that
cursor request. Finish & Merge therefore emitted the following source record instead of consuming it.

## Resolution

`MailMerge.MergeAllWithRules` now advances over one additional source row after an emitted or skipped
record requests NEXT behavior. Non-matching conditional rules leave the normal one-row cadence intact.

## Verification

- Focused model tests cover unconditional NEXT and matching/non-matching NEXTIF cursor behavior.
- Existing skip, sequence-number, bookmark, conditional, fill-in, and record-level rule contracts remain
  in the same focused mail-merge test lane.
