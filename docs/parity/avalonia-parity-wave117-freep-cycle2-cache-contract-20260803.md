# Avalonia parity Wave117: FreeP cycle2 cache contract

## Selection

Wave117 selects the `cycle2` SmartArt import boundary after Wave116's dedicated
`hierarchy1` path. The repository contains both sides of the contract: the real
`tools/FreeP.RenderCompare/corpus/14-smartart-live.pptx` package has a
`/cycle2` layout with five data nodes (`Idea`, `Plan`, `Execute`, `Review`, and
`Improve`) and a `dsp:drawing` containing exactly five editable `ellipse`
nodes plus five empty `rightArrow` transitions. The shared presentation planner
already models the bounded native shape grammar for two through seven nodes.
Earlier WPF authority evidence kept this slide on the cached path while cycle2
was unsupported, including the neutral cached connector treatment documented in
`freep-smartart-cached-cycle-neutral-2026-07-16.md`.

## Implementation

`PptxPackageReader` now admits an imported cycle2 drawing to the shared live path
only when its complete fallback set matches that evidence: one non-empty ellipse
per parsed node, one empty right-arrow per node, and no other shape role. This
keeps WPF and Avalonia as thin consumers of the same shared `SlideShape` plan.
An imported cache with extra roles, connectors, pictures, malformed counts, or a
node-count outside the planner's two-to-seven bound remains authoritative.
Authoring and explicit cache regeneration retain the existing live cycle2 path.

The host regression reads the real corpus, verifies the ten-shape contract, and
saves/reopens the package while preserving `/cycle2`, node order, and live
composition. The renderer-neutral layout tests and existing fallback compositor
coverage remain unchanged.

## Verification

- `FreeP.App.Presentation.Tests` SmartArt layout filter: 204 passed.
- `FreeP.App.Host.Tests` SmartArt filter: 247 passed, including corpus, fallback, and save/reopen coverage.
- `FreeP.App.Avalonia.Tests` headless filter: 344 passed.
- `dotnet build FreeP.slnx -c Release`: 0 warnings, 0 errors.

## Limitations

This is a bounded import-admission and editability slice, not a claim of
pixel-identical PowerPoint cycle2 geometry. Exact arrow contours, spacing,
theme/effect behavior, text fitting, and richer cycle2 caches with background or
role shapes remain on the authoritative cached fallback until matching package
evidence and shared geometry exist.
