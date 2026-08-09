# FreeW Avalonia body page boundaries

Avalonia Print Layout now honors authored paragraph `PageBreakBefore`, common break-only page-break
runs, and section-ending Next Page, Even Page, and Odd Page boundaries. Even/odd section starts
retain the intervening parity page in the physical page count. Continuous section breaks remain on
the current page.

This is the pagination prerequisite for live body `SECTIONPAGES`; count convergence remains a
separate follow-up.

Verification:

- Boundary contracts: 5 passed.
- `DocumentViewHeadlessTests`: 42 passed.
- `DocumentViewHeaderFooterTests`: 12 passed.
- `dotnet build FreeW.slnx --configuration Release`: 0 warnings, 0 errors.
