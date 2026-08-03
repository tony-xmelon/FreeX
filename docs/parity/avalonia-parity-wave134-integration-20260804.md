# Avalonia parity Wave 134 integration

Date: 2026-08-04

## Scope

Wave 134 advances one bounded parity slice in each application and refreshes the checked-in parity
evidence from the integrated implementations.

### FreeX: About dialog

- The shared About metrics now include named Avalonia line-height and padding values, and the
  Avalonia surface reuses the shared read-only document chrome with a WPF-aligned resting OK fill.
- A fresh matched `560x420` canonical Avalonia capture improved the triage score from `0.107196`
  to `0.077246` and sample mean delta from `0.071472` to `0.057872`; luma delta is `0.005549`
  and non-background delta is `0.013546`.
- Canonical dialog evidence remains complete at 94/94 paired, nonblank surfaces with no logical
  dimension mismatches. The 21 raw dimension mismatches are normalized DPI differences.

### FreeW: AutoFormat As You Type tab

- Avalonia now uses WPF-aligned master and section margins, content inset, and checkbox glyph
  spacing. The shared compact checkbox helper retains its prior default for all other dialogs.
- Fresh evidence improved changed pixels from 25,447 (`7.5735%`) to 22,537 (`6.7074%`), mean
  delta from `8.1581` to `6.6159`, P95 delta to `34`, and perceptual hash distance to `2`.
- The route remains a genuine visual mismatch, with both content gates passing and no semantic
  difference. FreeW retains 158 catalogued genuine visual mismatches.

### FreeP: gridMatrix SmartArt live import

- The shared reader now admits the exact deterministic `/gridMatrix` grammar: four ordered,
  distinct row-major nodes with matching 2x2 square cache geometry, equal steps, planner-aligned
  gaps, and no unsupported effects.
- WPF and Avalonia continue to consume the same renderer-neutral shared layout plan. Malformed,
  ambiguous, effectful, or otherwise unsupported variants retain cached-drawing fallback.
- The checked-in SmartArt corpus now includes a real gridMatrix slide, and FreeP command/workflow
  evidence increases from 105 to 106 rows.

## Verification

- Generated dialog evidence, FreeW inventory and comparison freshness, FreeP command inventory,
  and the cross-app dashboard generation checks passed.
- Focused integrated tests passed for FreeX WPF/Avalonia About parity (3 tests), FreeW WPF/Avalonia
  AutoFormat parity (13 tests), and FreeP host, presentation, Avalonia renderer, and fixture
  gridMatrix contracts (10 tests).

## Remaining work

- FreeX retains native text, scrollbar, and low-level rasterization residuals despite complete
  paired dialog coverage.
- FreeW still has 158 catalogued genuine visual mismatches among 183 paired comparison rows and
  lacks authoritative Microsoft Word PNG baselines on this host.
- FreeP still needs broader SmartArt grammar coverage and PowerPoint-authoritative visual
  baselines beyond the currently admitted families.

Wave 134 advances the active parity goal but does not claim complete Avalonia/WPF parity.
