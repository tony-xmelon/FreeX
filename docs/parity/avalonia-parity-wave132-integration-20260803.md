# Avalonia parity Wave 132 integration

Date: 2026-08-03

## Scope

Wave 132 advances one bounded parity slice in each application and removes a shared test-harness
blocker exposed by the integrated lane.

### FreeX: Shape Gradient parity

- WPF and Avalonia now consume one deterministic `ShapeGradientParityFixture` instead of using
  different gradient stops in visual evidence.
- Avalonia dialog metrics were aligned to the measured WPF surface while retaining shared compact
  dialog chrome.
- Fresh matched `500x300` captures improved triage score from `0.062809` to `0.055491`, sample
  delta from `0.044160` to `0.040534`, and raw changed-pixel ratio from `5.90%` to `3.48%`.

### FreeW: Icon Picker thumbnails

- The shared SVG rasterizer now offers an opt-in painted-bounds path. Existing ribbon and SVG
  consumers retain view-box behavior, while Icon Picker thumbnails match WPF's painted-bounds
  expansion.
- Changed-pixel ratio improved from `12.1131%` to `9.6783%`, mean delta from `15.3291` to
  `9.3391`, and changed pixels from 40,700 to 32,519. Perceptual hash distance remains 5.
- Canonical FreeW evidence and freshness metadata were regenerated from the matched captures.

### FreeP: grouped-list SmartArt live import

- A checked-in `15-smartart-grouped-list.pptx` fixture now exercises a real grouped-list package.
- The shared reader admits only the proven grammar and produces the same eight-shape live plan for
  WPF and Avalonia. Missing, duplicate, ambiguous, extra, effect, picture, and unsupported roles
  retain the safe cached-drawing fallback.
- FreeP workflow evidence increases from 103 to 104 rows.

## Integration corrections

- Corpus and generated-profile guards now include the grouped-list fixture and workflow row.
- The compact-dialog source guard recognizes Shape Gradient's measured button-height exception.
- `Free.Shared.Ribbon.Tests` now disables xUnit parallelization, matching the other headless
  Avalonia test assemblies. This removes a repeatable suite-level testhost hang with four UI tests
  left in flight; the complete Ribbon suite now runs 731/731 and exits normally.

## Verification

- Repository preflight passed across 10,824 text files, including generated documentation, macOS
  readiness, and Linux packaging readiness.
- Full serialized `FreeX.slnx` Release build passed with zero warnings and zero errors.
- Generated dialog evidence, FreeP command inventory, and cross-app dashboard checks passed.
- Focused integrated tests passed for FreeX Shape Gradient, shared SVG rasterization, FreeW Icon
  Picker, FreeP grouped-list import, corpus retention, generated profiles, and compact-dialog
  contracts.
- The three clipboard failures observed under the first competing all-up lane passed 3/3 in
  isolation and were confirmed as environment interference.
- Full `FreeX.DefaultTests.slnx` clean run: 36,338 discovered across 21 projects, 36,204
  executed and passed, 134 not executed, and zero failed.

## Remaining work

- FreeX retains native text and low-level rasterization residuals despite complete paired dialog
  coverage.
- FreeW still has 158 catalogued genuine visual mismatches among 183 paired comparison rows and
  lacks authoritative Microsoft Word PNG baselines on this host.
- FreeP still needs broader SmartArt grammar coverage and PowerPoint-authoritative visual
  baselines beyond the admitted grouped-list family.

Wave 132 advances the active parity goal but does not claim complete Avalonia/WPF parity.
