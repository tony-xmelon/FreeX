# FreeW web-hidden run rendering parity

## Scope

Word's `w:webHidden` run property suppresses content only in Web Layout. It remains visible in Print
Layout and Draft, and it remains printable. FreeW now applies that distinction in both live editors.

## Rendering ownership

- WPF rebuilds the run tree when the view mode changes. Web-hidden runs use the same lossless near-zero
  visual representation as ordinary hidden text only while Web Layout is active; their source text and
  formatting survive the rebuild and commit.
- Avalonia retains one zero-width placement per source character in Web Layout, preserving caret and
  table-cell offsets. Print Layout and Draft measure and draw the same run normally.
- Direct Avalonia PDF export always adapts through a Print Layout view. Exporting while the live editor
  is in Web Layout therefore includes `w:webHidden` text, matching Word's printing behavior.
- Ordinary `w:vanish` remains suppressed in every view and in PDF.

## Acceptance gates

- WPF focused coverage switches Print Layout to Web Layout to Draft, checks the effective glyph state,
  and commits the original text, colour, size, and `WebHidden` flag.
- Avalonia focused coverage checks positive width in Print/Draft, zero width in Web Layout, and printable
  PDF text from a Web Layout editor.
- The existing hidden-text and full PDF/round-trip controls remain the adjacent no-regression gates.

This semantic slice does not require a Word COM raster baseline: package XML and Word's documented view
ownership determine whether content is present, while focused host tests exercise the effective paths.
