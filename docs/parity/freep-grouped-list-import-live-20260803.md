# FreeP Grouped List Import Admission - 2026-08-03

Imported SmartArt `groupedList` now uses the live layout path only when its cached
`dsp:drawing` contains exactly one text-bearing AutoShape per parsed SmartArt node,
in node order, with matching text. This covers simple imported grouped lists while
keeping PowerPoint caches authoritative when they contain extra roles such as
backgrounds or connectors that the bounded live geometry does not model.

Focused evidence:

- `FreeP.App.Host.Tests` SmartArt lane: 240/240 passed.
- `FreeP.App.Presentation.Tests` SmartArt layout lane: 206/206 passed.
- Release builds for both consuming test projects: 0 warnings, 0 errors.

The guard is intentionally source/cache-based and does not claim full grouped-list
role parity. Richer grouped-list caches remain on the existing fallback path until
their additional roles have corresponding live geometry and tests.
