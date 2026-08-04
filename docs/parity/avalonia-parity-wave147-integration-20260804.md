# Avalonia parity Wave 147 integration

Date: 2026-08-04

## Accepted slices

- FreeX Change Chart Type preview spacing now follows the WPF element-level
  margin contract. A valid current Avalonia `640x390` capture improved the
  retained-pair triage score from `0.077239` to `0.076982`.
- FreeW Table of Authorities now uses the WPF action-row margin in all three
  harness states. Fresh Avalonia captures passed their content gates; a blank
  fresh WPF capture prevented promotion of a new paired score.
- FreeP authored Accent Process now has a dedicated main/accent topology,
  shared live layout, exact writer/reader cache admission, and cached fallback
  for unsupported imports. Leaving Accent Process restores one standard node
  per stage instead of rendering blank main nodes as extra stages.
- Shared WPF/Avalonia backstage realizers now consume one neutral visual
  contract for rail/content geometry, typography, detail columns, action
  spacing, and text colors. Fresh paired `backstage-open.open` captures improved
  changed ratio from `0.128074` to `0.107369` while remaining a genuine mismatch.

## Integration review

Integration strengthened the FreeX source assertion so it is scoped to the
preview method, corrected a non-causal FreeW bounds claim, requested rendered
evidence for the broad shared backstage change, and returned the first FreeP
patch for an Accent Process to Basic Process workflow regression before commit.

## Evidence boundary

The retained FreeX WPF image predates its gallery correction, the FreeW fresh
WPF capture was blank, and the FreeW Open backstage route includes persisted
recent-file content. These results are directional, bounded evidence rather
than complete pixel parity. Accent Process does not claim PowerPoint-native
effects or imported grammar beyond the exact FreeP-authored signature.

## Current-source verification

After merging `origin/main` through `df927b96aa`, all focused suites and source
guards passed:

- FreeX Change Chart Type source contract: `11/11`.
- FreeW Table of Authorities visual contract: `5/5`.
- Shared backstage Avalonia and WPF contracts: `2/2` and `2/2`.
- FreeP Accent Process presentation, WPF host, and Avalonia rendering contracts:
  `3/3`, `2/2`, and `1/1`.
- Shared compact-dialog and FreeP Grid Matrix source guards: `1/1` and `1/1`.

Focused total: `28/28`, with zero failures and zero skips.

Repository preflight passed over `220` JSON files, `261` XML-backed files,
`90` PowerShell scripts, `125` .NET projects, `92` solution entries, and all
`22` default-test solution entries. FreeP whole-window evidence remained
`33/33` paired with zero explicit mismatches or capture limitations after its
`173`-artifact manifest was regenerated.

The final serialized default lane passed `36,419` tests across `21` test assemblies;
`134` benchmark or explicitly skipped cases were not executed and no tests
failed. An earlier full lane exposed an order-dependent WPF copy-picture failure:
the clipboard retry accepted a successful text round trip even when Windows had
dropped the requested bitmap flavor. Retry success now requires both text and
bitmap round trips for rich clipboard payloads. The final lane included the
complete affected assembly at `1,498` passes with `4` benchmark skips.

The full `Release` solution build completed with zero warnings and zero errors.

The earlier Subtotal capture pause was not reproducible after correcting stale
source guards, rebuilding, and running the suite serially. No speculative
Subtotal production change was retained.
