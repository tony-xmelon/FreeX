# FreeW Weaving Ribbon page-border sprites (2026-08-04)

## Scope

The imported Weaving Ribbon page border (`ArtId=95`) used synthetic stripe polygons
with fixture-specific phase and seam corrections. Word renders a fixed black, white,
and silver border-art raster with distinct side orientations and corner joins. The
shared planner now decodes eight compact 32x32 material masks and emits measured
top, bottom, left, right, and corner fills for both WPF and Avalonia/PDF consumers.

## Matched reference

- Fixture SHA-256: `03B99A9A97D8A0EF8996D59AB8686B6F3CB5F3AAA6CECC8179948909558BBCC5`
- Fresh Word COM PNG SHA-256: `6AD8B4289B275293A5834BD3409B322E9E5E971BC41117F91A7BB8F3C938EA3C`
- Before WPF composite PNG SHA-256: `8587AFBA54DB34AAB3032EACB1339EA95871B0862CAF1B01A1807A7A6A217BB6`
- Candidate WPF composite PNG SHA-256: `11E13F6A385FCC819535A7AF38091623F81D418AF7229DC7CF232B782B922D17`
- Dimensions: 816x1056
- Candidate provenance: `FreeW.FidelityRender`, `renderPath=composite`,
  `captureSource=wpf-composite-renderer`

## Visual result

Mean absolute RGB delta against the fresh Word PNG:

| Region | Before | After | Change |
| --- | ---: | ---: | ---: |
| Whole page | 5.5954% | 1.6242% | -3.9712 pp |
| Top border | 26.1061% | 6.4384% | -19.6677 pp |
| Bottom border | 27.7060% | 4.8944% | -22.8116 pp |
| Left border | 28.0902% | 7.9301% | -20.1602 pp |
| Right border | 28.3939% | 6.1565% | -22.2374 pp |
| Top-left corner | 34.0142% | 5.0776% | -28.9365 pp |
| Top-right corner | 41.1140% | 2.9597% | -38.1543 pp |
| Bottom-left corner | 35.9521% | 4.4113% | -31.5409 pp |
| Bottom-right corner | 37.2130% | 3.0150% | -34.1980 pp |
| Interior control | 0.6631% | 0.6631% | 0.0000 pp |

The interior crop changed zero pixels. Removing the superseded polygon helpers and
rebuilding the consuming renderer reproduced the accepted PNG byte-for-byte.

## Verification

- Focused Weaving Ribbon shared planner contract: 1/1
- Complete shared page-border planner suite: 19/19
- Avalonia Weaving Ribbon direct-PDF composition/raster contract: 1/1
- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors
- Fresh WPF candidate render: 1/1 in 6.2 seconds

## Process note

Treat border art as an oriented raster/material asset once phase and corner probes
show that synthetic vector stripes do not reproduce the host. Store compact masks,
keep the shared planner authoritative for both backends, and accept only when every
edge and corner plus the whole page improve while the page interior remains stable.
