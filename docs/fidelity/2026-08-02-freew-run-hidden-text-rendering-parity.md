# FreeW hidden text rendering parity

## Scope

- Treat effective `RunFormatting.Hidden` as Word's default nonprinting `w:vanish` state.
- Preserve hidden source text and model offsets for editing and DOCX round trips.
- Suppress hidden glyph width, paint, decorations, backgrounds, links, and PDF text output.
- Apply the same rule to WPF, Avalonia, tables, mixed inline paragraphs, headers/footers,
  footnotes, and endnotes.
- Resolve hidden state through direct formatting, paragraph style inheritance, and document defaults.

## Implementation

- WPF retains the authoritative hidden formatting on each underlying `Run`, while rendering it with
  transparent paint and a near-zero font size. Specialized field/reference tags retain hidden state
  through a weak side table so commit does not lose `w:vanish`.
- Avalonia keeps one zero-width placed character per hidden source character. This preserves caret and
  table-cell offsets while excluding those placements from live paint and direct PDF grouping.
- The shared note-region planner removes direct and inherited hidden runs before measuring or splitting
  footnote/endnote continuation text.

## Acceptance gates

- Package/model coverage is recorded in
  `docs/fidelity/2026-08-02-freew-run-hidden-text-package-parity.md`.
- Focused WPF editor test proves hidden paint collapse and lossless commit of text, size, colour, and flag.
- Focused Avalonia test proves body/table hidden characters remain addressable at zero width and that
  body, table, header, and note secrets are absent from PDF text operations.
- Shared planner test proves direct and style-inherited hidden note text is absent from both ordinary
  note regions and continuation fragments.

No Word COM export is required for this semantic slice: `w:vanish` package ownership and nonprinting
behavior are deterministic, and the renderer checks assert the effective output paths directly.
