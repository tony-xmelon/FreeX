# Avalonia/WPF Parity Wave 129 Integration

Date: 2026-08-03

## Integrated Slices

- FreeX Format Cells Alignment now uses the shared compact-dialog tab and
  combo chrome at the WPF-authority geometry. The fresh 620x540, 96 DPI pair
  reduced the Alignment triage score from `0.086598` to `0.024344`. The full
  FreeX dialog set remains 94/94 paired with zero logical dimension mismatches.
- FreeW Insert Chart hosts now consume one shared action-button plan, and the
  Backstage Info action order has an explicit shared contract. The canonical
  295-row comparison now has zero non-null `semanticDifference` rows; the four
  target captures remain honestly classified as genuine visual mismatches.
- FreeP now parses inherited `m:mathPr/m:interSp`, preserves explicit zero,
  rejects invalid or negative twips, and converts the authored value to the
  shared WPF/Avalonia layout plan. Renderer tests prove 120 twips as 8 DIP.

## Verification

- Repository preflight passed, including generated-doc and cross-app dashboard
  checks.
- `dotnet build FreeX.slnx --configuration Release` passed with zero warnings
  and zero errors.
- The serial `FreeX.DefaultTests.slnx` Release lane passed across 21 assemblies:
  36,313 discovered, 36,179 executed and passed, 134 skipped, zero failed.
- Fresh FreeW evidence contains 190/190 WPF captures and 288/288 Avalonia
  captures with zero unsupported surfaces.

## Residuals

- FreeX dialog evidence still has raster differences; the highest current
  triage candidate is `dialog.About` at `0.084615`.
- FreeW still has 158 measured genuine visual mismatches even though its
  canonical semantic-difference count is now zero.
- FreeP `m:eqArrPr/m:maxDist` and `m:objDist` remain deferred until the shared
  OMML model distinguishes alignment points from column separators.

The parity goal remains active; Wave 129 closes these bounded slices and does
not claim complete cross-app visual parity.
