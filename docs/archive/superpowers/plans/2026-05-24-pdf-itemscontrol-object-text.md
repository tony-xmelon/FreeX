# PDF ItemsControl object text overlay

## Goal

Make PDF selectable/searchable text overlays include simple non-UIElement items rendered by WPF `ItemsControl` derivatives through `ToString()`.

## Scope

- Add a failing App.Host PDF export test for a numeric `ListBox` item.
- Reuse the simple content-text extraction helper for ItemsControl item values.
- Update architecture and command parity documentation.
- Verify the PDF overlay/export tests and solution build before commit.

## Out of scope

- Full item-template visual tree extraction.
- Per-item overlay positioning for complex item containers.
- Tagged PDF and full vector PDF rendering.
