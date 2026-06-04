# PDF headered content selectable text

## Goal

Extend the PDF selectable/searchable text overlay so simple WPF `HeaderedContentControl` headers, such as `GroupBox.Header`, are emitted as text when PDF bitmap-text suppression is not selected.

## Scope

- Add a red App.Host PDF export test proving header text is missing from the generated PDF overlay.
- Extract nonblank string headers from `HeaderedContentControl` instances using the same simple font, foreground, and padding metadata captured for string `ContentControl` content.
- Update architecture and command parity documentation.
- Run the focused PDF overlay regression set and the solution build before commit.

## Out of scope

- Full vector PDF graphics.
- Arbitrary `HeaderTemplate` visual-tree extraction beyond existing UIElement traversal paths.
- Tagged PDF structure or PDF/A output.
