# FreeW Compare respects do-not-track-formatting

## Scope

Both FreeW editors and the DOCX package layer already honor Word's `w:doNotTrackFormatting`
policy. The comparison engine remained disconnected from that setting: a format-only difference
still produced `w:rPrChange`, and the comparison result lost the source policy.

`DocumentCompare` now uses the revised document as the result-policy authority:

- the revised formatting remains visible in the comparison result;
- `DoNotTrackFormatting=true` suppresses creation of format-revision metadata;
- the result retains the setting through save and reopen;
- the Compare dialog's Formatting checkbox remains an additional gate;
- ordinary text revisions and move recognition are unchanged.

## Verification

- focused format-policy model tests: 3/3 passed;
- focused setting/package tests: 10/10 passed;
- complete `DocumentCompareTests`: 31/31 passed;
- compare revision plus do-not-track-formatting IO families: 29/29 passed.

The serialized control asserts there is no `w:rPrChange`, the revised run formatting remains,
and `w:doNotTrackFormatting` reopens as enabled.
