# FreeW Cross-Cell Selection Parity

## Scope

This slice aligns Avalonia table selection editing with the native WPF `RichTextBox` route while keeping rectangular `SelectedCellRange` editing structure-preserving.

## WPF oracle

- A selection spanning multiple paragraphs in one cell deletes the selected text and joins the remaining prefix and suffix into one paragraph.
- A linear selection crossing cells is normalized to the full logical cells touched by the selection. Deleting `Axx`, `Bmiddle`, and `Cyy` leaves three cells and clears all three contents; it does not preserve endpoint `A` or `yy`.
- Single-character replacement through `Selection.Text` places the replacement in the first touched cell and leaves later touched cells empty.
- The repository's native WPF route was also exercised through `PastePlainText()` with a real clipboard value of `Z\nQ`; multiline paste places `Z` and `Q` in the first touched cell and leaves later touched cells empty. This is distinct from the single-line typing case and is covered separately.
- The WPF selection operation preserves table cell structure. The Avalonia rectangular selection route has no WPF `TextSelection` equivalent, so it clears each selected logical cell while preserving rows, cells, grid spans, and vertical merges.

## Avalonia behavior

- Same-cell multi-paragraph deletion, cross-cell whole-cell deletion, and rectangular block deletion are routed through the command bus.
- Cross-cell tracked deletion marks every touched paragraph's text as deleted; it does not remove table structure.
- Paragraph replacement shells retain paragraph formatting, bookmarks, section-break metadata, preserved numbering, and paragraph-format revision metadata. The local shell intentionally keeps same-document metadata references because the source paragraph is consumed by the splice; `DocumentMerge` remains an independent deep-clone implementation.
- Typing, paste, and Enter replacement join an existing outer undo group when one is open. Otherwise each replacement is one undoable edit, with no undo entry for an empty/protected selection.

## Verification

- WPF oracle: `DocumentViewTableSelectionOracleTests`, Release, 5/5 passed.
- Avalonia strict interaction/model suite: `DocumentViewCrossCellDeletionTests`, Release, 20/20 passed.
- Avalonia Release build: 0 warnings, 0 errors.
- Regression suites: `DocumentViewTableEditTests` 15/15, `DocumentViewTableStructureTests` 30/30, `DocumentViewProtectionTests` 8/8.
- Linux production harness: pointer-selected the merged-cell fixture, pressed Delete, typed `Z` over a fresh pointer selection, and pressed Ctrl+Z. Screenshots were captured from the rebuilt Docker app at 1280x820, 96 DPI:
  - selection: `artifacts/freew-cross-cell-delete-20260726/screenshots/manual-20260726T090033Z.png`
  - after Delete: `artifacts/freew-cross-cell-delete-20260726/screenshots/manual-20260726T090038Z.png`
  - after typing `Z`: `artifacts/freew-cross-cell-delete-20260726/screenshots/manual-20260726T090047Z.png`
  - after Ctrl+Z: `artifacts/freew-cross-cell-delete-20260726/screenshots/manual-20260726T090052Z.png`

The physical Linux screenshots prove the production pointer/keyboard route and visible restoration. They do not expose the app's private model for independent cell-by-cell assertions; the strict Avalonia suite supplies that model-level proof.
