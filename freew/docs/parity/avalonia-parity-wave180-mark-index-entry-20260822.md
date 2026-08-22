# Avalonia Parity Wave180: Mark Index Entry

Date: 2026-08-22
Base: `504bcd2b311d3fac5c64589e857c17e576fb8795`
Target DPI: 96

## Selected Route

`mark-index-entry` was selected from the canonical FreeW dialog comparison as
the highest actionable non-Legal-Notices route with a product-owned geometry
residual. WPF places the `Page range:` radio button and bookmark selector in a
single horizontal row. Avalonia previously stacked those controls vertically
and used a wider selector, changing the dialog topology and increasing its
height. This is an application-owned layout difference, not a text raster
difference.

## Bounded Change

The Avalonia renderer now matches the WPF row topology: the page-range radio
button and bookmark selector share a horizontal `StackPanel`, the radio button
is vertically centered with an 8-DIP trailing gap, and the selector uses the
WPF-aligned 220-DIP minimum width. The shared planner, state transitions,
validation, and action semantics are unchanged.

Files changed:

- `freew/FreeW.App.Avalonia/ReferencesDialogs.cs`
- `freew/FreeW.App.Avalonia.Tests/ReferencesTabTests.cs`

The focused test asserts the parent topology, orientation, alignment, spacing,
and selector width without weakening semantic behavior.

## Fresh Route Evidence

Fresh WPF authority and Avalonia captures were taken from the route-local
harness at 96 DPI:

- Before WPF: `artifacts/wave180-freew-mark-index-before/wpf/`
- Before Avalonia: `artifacts/wave180-freew-mark-index-before/avalonia/`
- Before comparison: `artifacts/wave180-freew-mark-index-before/compare-focused/`
- After WPF: `artifacts/wave180-freew-mark-index-after/wpf/`
- After Avalonia: `artifacts/wave180-freew-mark-index-after/avalonia/`
- After comparison: `artifacts/wave180-freew-mark-index-after/compare-focused/`
- Focused inventory: `artifacts/wave180-freew-mark-index-route-inventory.json`

The three applicable states remained semantically equal and were compared at
the same WPF-authority dimensions. Changed-pixel metrics improved as follows:

| State | Changed pixels before | Changed pixels after | Mean channel delta before | Mean channel delta after |
| --- | ---: | ---: | ---: | ---: |
| Initial | 11.78% | 8.21% | 6.13 | 5.68 |
| Populated | 11.61% | 8.06% | 6.35 | 5.91 |
| Validation error | 11.90% | 8.34% | 6.27 | 5.82 |

Perceptual hash distance remained 8 for all three states. The rows therefore
remain honestly classified as `genuine-visual-mismatch`; residual differences
include native control/text rasterization and remaining compact-dialog chrome,
not a semantic mismatch or a fabricated pass.

## Verification

- `dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release --filter FullyQualifiedName~MarkIndexEntry --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1`
  passed `7/7`.
- WPF route capture: `3/3` captured.
- Avalonia route capture: `3/3` captured.
- Focused comparisons: `3` comparable rows, all semantically equal and still
  classified `genuine-visual-mismatch`.

