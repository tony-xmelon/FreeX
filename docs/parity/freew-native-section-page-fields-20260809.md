# FreeW native SECTION and SECTIONPAGES fields

## Scope

Word's `SECTION` field displays the current section number. `SECTIONPAGES` displays the number of
pages in the current section. Both fields retain their authored field instruction and cached result
in the document model; live values are presentation state.

## Implementation

- Added `SECTION` and `SECTIONPAGES` to the shared field picker.
- Reused the existing physical-page-to-section plan and added the physical page count for each
  section, including parity blank pages and a dedicated endnote page.
- Added shared Arabic, Roman, and alphabetic integer-picture formatting for page-context fields.
- Resolved both fields from live section context in WPF and Avalonia headers/footers.
- Resolved both fields in WPF paginated body page boxes after blocks are assigned to physical pages.
- Preserved imported DOCX field instructions and cached results through render and round-trip.

## Deliberate boundary

Avalonia body `SECTIONPAGES` remains a follow-up. Its body paginator lays out text before the final
section page count is known, so replacing cached text after layout can change wrapping without a
repagination pass. This slice does not claim parity by substituting a guessed or stale body value.

## Verification

- `ComplexFieldEngineTests`: 81 passed.
- `ComplexFieldRoundTripTests`: 30 passed.
- Focused presentation planner/picker/visual tests: 41 passed.
- `PagedEditW18HfPolishTests`: 11 passed.
- `DocumentViewHeaderFooterTests`: 12 passed.
- `dotnet build FreeW.slnx --configuration Release`: 0 warnings, 0 errors.
- All five focused lanes passed again with `--no-build --no-restore` (175 tests total).
