# FreeW cross-reference PAGEREF logical-page parity

## Gap

The physical-page slice let both hosts find a bookmark's rendered page, but field results still used
the physical decimal number. A target on physical page 2 in a section numbered `IV, V` therefore
refreshed to `2` instead of `V`. Imported complex `PAGEREF` fields also bypassed the host page-label
resolver entirely.

## Change

`PageNumberFormatDialogPlanner.BuildBlockPageReferenceResolver` combines host physical-page
ownership with the existing header/footer page-label plan. It therefore reuses the established
section restart, continuation, Roman/letter format, and chapter-prefix behavior rather than creating
a second numbering model.

Both WPF and Avalonia build this resolver only when a modeled or imported `PAGEREF` is present. The
formatted label is authoritative when available; the existing numeric physical-page resolver and
core-model default remain the fallback. Ordinary `REF`, `NOTEREF`, and unrelated complex fields are
unchanged.

## Verification

- Shared cross-reference and complex-field contracts: 69/69.
- Page-number and header/footer planner controls: 22/22.
- WPF cross-reference, complex-field, and Table of Authorities controls: 25/25.
- Avalonia References-tab and field-display controls: 63/63.
- WPF and Avalonia consuming Release builds: 0 warnings, 0 errors.

The host fixtures place a bookmarked target on physical page 2, set the section to start at 4 in
upper Roman format, and assert that both modeled and imported fields refresh from stale `9` to `V`.
Shared planner coverage separately verifies lower-Roman front matter resolves to `i` while the main
section restarts at decimal `1`.

## Evidence boundary

This is deterministic field and package behavior, so it does not require a Word raster baseline.
Live layout remains responsible for physical block-to-page ownership. The shared page-label planner's
existing chapter-prefix behavior is consumed by this resolver; an explicit host-level chapter-prefix
fixture remains useful future coverage rather than a prerequisite for the restart/format correction.
