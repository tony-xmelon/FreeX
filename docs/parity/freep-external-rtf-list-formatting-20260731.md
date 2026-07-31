# FreeP external RTF list formatting parity

## Scope

Word RTF list overrides can replace a list level's numbering format and
paragraph geometry inside `lfolevel`/`listoverrideformat` groups. The external
clipboard reader previously skipped those nested list levels and fell back to
the base template.

The shared planner now retains supported per-level format overrides for number
format, bullet semantics, left indent, first-line indent, and explicit start-at
values. Explicit paragraph `li`/`fi` values remain authoritative; otherwise
the imported list-level geometry is used. Existing restart overrides continue
to apply only to the first paragraph in the override lineage.

Unsupported list-template formatting controls remain deferred rather than being
silently guessed.

## Verification

- `WordListOverride_FormattingLevel_PreservesBulletAndIndentGeometry`
- `WordListOverride_StartAtRestart_IsAppliedOnlyToItsFirstParagraph`
- Full Release presentation and repository gates are required before merge.

This is a function/clipboard semantic slice; it makes no visual-baseline claim.
