# PDF header element selectable text

## Goal

Extend the PDF selectable/searchable text overlay to traverse simple UIElement headers on WPF `HeaderedContentControl` instances.

## Scope

- Add a failing App.Host PDF export test for a `GroupBox.Header` containing a `TextBlock`.
- Reuse the existing overlay traversal so header UIElements contribute the same text overlays as ordinary fixed-page children.
- Update architecture and command parity documentation.
- Verify the PDF overlay regression set and full solution build before commit.

## Out of scope

- Full WPF control-template visual tree extraction.
- Pixel-perfect header offsets for complex templates.
- Tagged PDF, PDF/A, or full vector PDF rendering.
