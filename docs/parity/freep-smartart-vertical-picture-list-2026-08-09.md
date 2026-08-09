# FreeP SmartArt Vertical Picture List

## Scope

FreeP now treats the native `verticalPictureList` SmartArt layout as a live,
editable picture layout in the shared presentation planner. Imported diagram
data is classified as a list with picture-backed nodes, the shared layout emits
one picture slot and caption per node in vertical order, and WPF/Avalonia use
the same command and geometry path.

## Ownership

- `SmartArtAuthoringPlanner` exposes the native layout preset and command id.
- `SmartArtLayoutEngine` reuses the shared picture-caption plan, including
  editable `Add picture` placeholders for nodes without media.
- `PptxPackageReader` classifies the layout as a picture-backed live list and
  retains node media relationships.
- Both host ribbons register the same command; the generated command inventory
  remains the source of truth for surface coverage.

## Verification

- Shared presentation: vertical picture layout and SmartArt layout round-trip
  tests passed.
- WPF: SmartArt layout round-trip plus ribbon completeness gates passed
  (`284/284` focused tests).
- Avalonia: extended SmartArt layout-gallery registration passed (`1/1`).
- The focused Release builds completed successfully through the test commands.

This is a functional/live-layout slice. It does not claim PowerPoint-authoritative
pixel parity for the native SmartArt geometry.
