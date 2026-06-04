# PDF ItemsControl selectable text

## Goal

Extend the PDF selectable/searchable text overlay to include simple string items rendered by WPF `ItemsControl` derivatives.

## Scope

- Add a failing App.Host PDF export test for a `ListBox` item rendered in a fixed document.
- Add a conservative string-item extraction path that writes item text into the selectable overlay while keeping the raster page authoritative for visual layout.
- Update architecture and command parity documentation.
- Verify the PDF overlay regression set and solution build before commit.

## Out of scope

- Full item-template visual-tree extraction.
- Pixel-perfect per-item overlay positioning for multi-item controls.
- Full vector PDF rendering or tagged PDF structure.
