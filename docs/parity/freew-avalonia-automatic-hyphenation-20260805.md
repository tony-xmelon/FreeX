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
heuristic. Table-cell and auxiliary-story wrapping, `HyphenationZonePt`, and
`ConsecutiveHyphenLimit` remain separate follow-up ownership paths.
