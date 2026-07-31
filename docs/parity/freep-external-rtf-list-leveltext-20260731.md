# FreeP external RTF list-level text parity

## Scope

External RTF list tables can carry a bullet glyph in `\\leveltext`, while `\\levelnfc23` only identifies the level as a bullet. The bounded RTF planner previously discarded that payload and substituted a generic bullet, which changed the authored list marker on paste.

## Implemented

- Capture the first authored `\\leveltext` glyph for bullet-format levels.
- Apply the glyph through the existing `Paragraph.BulletChar` model used by WPF and Avalonia.
- Keep numeric level templates out of glyph capture so punctuation such as `.` is not mistaken for a bullet.
- Preserve the existing list restart, indentation, nested-level, and host clipboard paths.

## Evidence

- `WordListTable_UsesCustomLevelTextGlyphForBulletLevels` proves the custom glyph survives parsing without leaking level-template text into the visible paragraph.
- The complete `ExternalRichTextClipboardTests` class passes 28/28.

Full Word list-template semantics remain broader than this bounded custom-bullet slice: multi-character templates, numbering placeholders, template fonts, and complete locale-specific numbering are still deferred.
