# FreeW paginated section retention Release gate

## Scope

The editable Print Layout commit path already preserved paragraph metadata by moving tagged WPF blocks between page surfaces and reassembling them through `DocumentView.ReadBlocksInto`. Its focused coordinator suite was wrapped in `#if DEBUG`, however, so normal Release parity verification silently ran none of those tests.

The coordinator suite now compiles in Release. A new end-to-end contract sends a two-section document through editable pagination, commits it, writes DOCX, reopens the package, and verifies the first section's next-page boundary, landscape geometry, and header text.

## Result

The product path required no correction: section metadata survived the complete edit, save, and reopen sequence. The stale test note claiming paginated body commit stripped section breaks was removed.

## Verification

`FreeW.App.Host.Tests` Release build: 0 warnings, 0 errors.

`PaginatedCommitCoordinatorTests`: 8 passed, 0 failed.

The adjacent `W21LabelCellAndSectionHfTests` suite is also Release-enabled so label-grid population, undoable table-cell writes, per-page section ownership, header/footer commit, and direct package retention can no longer disappear from the normal lane.
