# FreeW Avalonia Page Edit Parity

## Decision

The WPF implementation uses `PaginatedEditorPanel` because its ordinary editor is a continuous
`RichTextBox`. Avalonia's ordinary `DocumentView` is a different implementation: `PrintLayout` is
already a live editor that lays out the shared document into separated white page surfaces on a grey
desk. It uses the shared model and command bus, so adding a second page editor would duplicate layout,
caret, header/footer, and undo behavior without adding a user-visible capability.

The Avalonia `View > Page Edit` command therefore remains a host-level alias over that production
`PrintLayout` surface. This is an intentional architecture difference, not a source-token parity claim.

## Verified contract

`freew/FreeW.App.Avalonia.Tests/PagedEditParityTests.cs` proves on the production Avalonia editor:

- entering Page Edit visibly switches to separated multi-page PrintLayout surfaces;
- the live workspace, caret, and selection remain the same editing surface and survive the toggle;
- exiting restores the view that was active before Page Edit;
- edits mutate the real shared model, trigger re-pagination, and support undo/redo;
- header and footer regions remain editable and retain their model changes;
- long content exposes multiple pages and routes the caret to a later page.

The host lifecycle correction is in `freew/FreeW.App.Avalonia/MainWindow.cs`: Page Edit records the
prior continuous view, enters PrintLayout, and restores that view on exit. The shared `DocumentView`
already performs the page layout, hit-testing, model mutation, reflow, and header/footer rendering.

## Bounded residuals

The WPF panel-specific implementation details are intentionally not ported: separate WPF `PageBox`
controls, WPF FlowDocument tag transfer, and the WPF panel's cross-page clipboard coordinator have no
Avalonia counterpart because the Avalonia editor keeps one model-backed caret and selection. This slice
does not claim pixel-identical chrome or native WPF control identity. Visual parity remains covered by
the existing PrintLayout render lanes and requires further screenshot comparison where those lanes find
differences.
