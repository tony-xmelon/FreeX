# FreeP external RTF list restart parity

## Scope

External RTF list overrides can carry a per-level restart through an `lfolevel`
with `listoverridestart` and `levelstartat`. The reader previously retained the
list template's `levelstartat` but dropped this override, so a pasted list could
start at the wrong number.

The shared RTF planner now records the override for the active list level and
applies it only to the first paragraph using that list override/level. Following
paragraphs continue numbering through the existing `AutoNumStartAtSpecified`
lineage contract. Formatting overrides and unsupported list-template controls
remain intentionally deferred.

## Verification

- `WordListOverride_StartAtRestart_IsAppliedOnlyToItsFirstParagraph`
- `ExternalRichTextClipboardTests`: 25/25

This is a function/clipboard semantic slice; it makes no visual-baseline claim.
