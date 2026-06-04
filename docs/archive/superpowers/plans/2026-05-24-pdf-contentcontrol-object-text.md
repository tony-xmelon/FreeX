# PDF ContentControl object text overlay

## Goal

Make PDF selectable/searchable text overlays include simple non-UIElement `ContentControl.Content` values rendered by WPF through `ToString()`.

## Scope

- Add a failing App.Host PDF export test for a `Label` whose content is numeric.
- Extract nonblank text from non-UIElement content objects through `ToString()` while preserving the existing UIElement traversal path.
- Update architecture and command parity documentation.
- Verify the PDF overlay/export tests and solution build before commit.

## Out of scope

- Full control-template visual tree extraction.
- Culture-specific formatting beyond the already-rendered WPF content object's `ToString()` value.
- Tagged PDF and full vector PDF rendering.
