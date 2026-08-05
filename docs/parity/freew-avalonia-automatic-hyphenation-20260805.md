# FreeW Avalonia Automatic Hyphenation

## Scope

FreeW preserved Word's automatic-hyphenation settings and the Avalonia ribbon could edit them, but
the Avalonia document surface wrapped only at spaces or hard character boundaries. Enabling
automatic hyphenation therefore did not change rendered line breaks.

## Change

- `AutomaticHyphenationDisplayPlanner` converts the pure model hyphenator's soft-hyphen plan into
  model-relative display break offsets.
- The plan respects document enablement, effective paragraph suppression, and
  `DoNotHyphenateCaps`.
- Avalonia includes the measured visible hyphen width when choosing a wrap point, aligning the
  line, and preflighting keep-lines/widow placement.
- A dedicated display-only glyph layer paints the consumed hyphen. It is never added to the placed
  model-character stream, so caret offsets, selection offsets, edits, and saved text remain based
  on the original document characters.
- Direct Avalonia PDF export consumes the same display glyphs, including inherited hyperlink,
  revision, comment, and run-decoration metadata.
- Horizontal page flow, section vertical alignment, and long-footnote second-pass layout move or
  clear the display layer with the rest of the body surface.

## Verification

- Shared planner contracts: 5/5, including an existing U+00AD plus a later generated break without
  offset drift.
- Avalonia host contracts: 5/5.
- The host fixture proves the break is consumed: the visible hyphen starts exactly after the prior
  glyph, while the following model character starts on the next line.
- Disabled, paragraph-suppressed, and excluded all-caps paths paint no automatic hyphen.
- An explicit paragraph opt-in overrides a suppressing named style through effective formatting.
- Model text and placed character streams contain neither a literal hyphen nor U+00AD after layout.
- Direct PDF text contains the consumed visible hyphen but no inserted U+00AD.
- Existing headless paragraph/column/tab/wrap controls: 79/79.
- Consuming Avalonia Release build: 0 warnings, 0 errors.
- A full unfiltered Avalonia project run was attempted once but produced no result before its
  10-minute bound; its exact owned `dotnet`/`vstest`/`testhost` PIDs were reaped. Acceptance uses the
  deterministic 84-test affected host gate plus the shared planner contracts above.

This slice is renderer-functional parity for ordinary body paragraphs and does not require a Word
COM raster baseline: it activates an already serialized Word layout setting while preserving source
text and caret semantics. Exact dictionary-quality hyphenation remains bounded by the shared English
heuristic. Table-cell and auxiliary-story wrapping remain separate follow-up ownership paths.

## Measured line policy follow-up

The same-day follow-up closes the two serialized settings that require measured-line state:

- An omitted `w:hyphenationZone` now uses the Open XML default of 360 twips (18 points).
- An authored zone is compared with the ordinary whole-word line's trailing whitespace, excluding
  trailing spaces. An automatic break is consumed only when that whitespace exceeds the zone.
- `w:consecutiveHyphenLimit` now caps generated hyphenated line endings; zero remains unlimited and
  each emitted non-hyphenated line resets the paragraph streak.
- The exact decision is shared by keep-lines height preflight and actual line emission, preserving
  pagination/render agreement.
- Overlong first words remain eligible because they have no ordinary whole-word fallback to which a
  hyphenation zone can apply.

The semantics follow the official Open XML
[`hyphenationZone`](https://learn.microsoft.com/en-us/dotnet/api/documentformat.openxml.wordprocessing.hyphenationzone)
definition and Word's
[`ConsecutiveHyphensLimit`](https://learn.microsoft.com/en-us/office/vba/api/word.document.consecutivehyphenslimit)
contract. Modern Word reports a compatibility-mode caveat for the VBA zone property, so this is
package/layout semantic evidence rather than a claim that every modern-mode Word build changes its
raster for an authored zone.

Follow-up verification:

- Shared candidate and measured-line policy: 13/13.
- Avalonia automatic-hyphenation compositor: 7/7.
- Combined hyphenation, column, and floating-wrap controls: 33/33.
- Consuming Avalonia Release build: 0 warnings, 0 errors.

## Table-cell follow-up

Avalonia table cells now consume the same automatic-break candidates, default/authored zone, and
consecutive-line policy as ordinary body paragraphs. The table row-height preflight and actual cell
render use the same wrapped-line plan, so a generated hyphen cannot produce a different measured row
height from the painted row.

The wrapped-cell line carries the optional visible hyphen separately from its original characters.
Rendering and direct PDF export consume that display glyph, while the table model, placed cell
characters, paragraph offsets, editing boundaries, and saved text remain unchanged. Existing table
formatting ownership remains narrow: the cell's established effective run formatting measures and
paints the generated hyphen.

Table follow-up verification:

- Automatic-hyphenation host contracts: 9/9, including model/caret/PDF invariants and a bounded
  consecutive-line-limit comparison inside a table cell.
- Table structure, vertical alignment, PDF, hidden-text, and hyphenation controls: 131/131.
- Consuming Avalonia Release build: 0 warnings, 0 errors.

## Footnote and endnote follow-up

Footnote and endnote regions use a separate fragment renderer rather than body/table placed glyphs.
Their formerly duplicated height-measurement and item-emission loops now share one layout routine.
Consequently, footnote-band reservation, endnote fit checks, live drawing, and direct PDF export all
consume identical line breaks.

When enabled for the effective note paragraph, an accepted automatic break emits a note-only text
fragment ending in `-`. It never edits the source `Footnote`/`Endnote` paragraph. The decision uses
the same authored/default zone and consecutive-line cap; when the cap rejects a break in an
overlong active word, a non-hyphenated fragment advances the line and resets the streak. With
automatic hyphenation disabled or suppressed, the prior overlong-word behavior remains unchanged.

Auxiliary-story verification:

- Automatic-hyphenation host contracts: 11/11, including footnote live/PDF/source invariants,
  disabled control, and unlimited-versus-limited consecutive line endings.
- Footnote, endnote, continuation pagination, PDF, and hyphenation controls: 100/100.
- Consuming Avalonia Release build: 0 warnings, 0 errors.

This completes the Avalonia automatic-hyphenation owner set for ordinary body paragraphs, table
cells, and the rendered footnote/endnote stories. Header/footer editing remains on its independent
single-line region model and is not an automatic line-wrap owner.
