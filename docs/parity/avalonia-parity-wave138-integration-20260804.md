# Avalonia/WPF parity wave 138 integration

Date: 2026-08-04

## Scope

Wave 138 advanced one bounded residual in each application:

- FreeX: replaced divergent Conditional Format Manager capture setup with one shared deterministic fixture and refreshed the Avalonia authority frame.
- FreeW: aligned the Avalonia Table of Authorities dialog family with the WPF geometry and compact chrome authority.
- FreeP: admitted one audited imported `list1` SmartArt four-slot cache through the shared compositor path.

## Results

- FreeX `dialog.ConditionalFormatManage` now compares the same two-rule `$C$2:$C$6` fixture in both hosts. Its triage score improved from `0.073983` to `0.065497` (11.5%), while all 94 dialog surfaces remain paired, nonblank, and size-valid.
- FreeW Table of Authorities Avalonia content height decreased from 206 to 184 pixels at the same 514-pixel width. The three scenarios remain classified as genuine visual mismatches because the fresh WPF attempt was blank and rejected; committed paired metrics were retained rather than recomputed from invalid evidence.
- FreeP remains at `648/648` shared-profile commands with zero actionable WPF or Avalonia gaps. The bounded `list1` admission raises the generated workflow inventory from 109 to 110 rows.
- The stale FreeP function-first status prose and the generated dialog inventory, dialog summary, command inventory, and cross-app dashboard now agree with current source and evidence.

## Verification

- Repository preflight passed, including all generated-document freshness checks.
- `dotnet build FreeX.slnx --configuration Release` passed with zero warnings and zero errors.
- FreeX focused fixture and lifecycle tests passed `2/2`; the complete Avalonia owning suite passed `2025/2025`; the complete Services owning suite passed `2621/2621`.
- FreeW focused Table of Authorities parity tests passed `2/2`; all three fresh Avalonia captures passed content gates.
- FreeP focused import tests passed `10/10`, Avalonia renderer contracts `9/9`, fixture evidence `7/7`, and ribbon inventory contracts `24/24`.
- FreeP command inventory, FreeP whole-window evidence, FreeX dialog evidence, and the cross-app dashboard passed their freshness checks.

## Evidence boundaries

The default test lane initially reported 33 failures. Two were stale FreeX source-contract assertions introduced by the shared capture fixture; both were updated and their complete owning suites passed. One clipboard-isolated WPF test failed under the parallel lane and passed immediately in isolation. The remaining 30 failures reproduce the pre-existing Windows WPF raster outage across FreeX printed-grid and FreeP slide/rich-text rendering. Serial probes again returned zero painted pixels (`blackInRow1 = 0` in FreeX and `0x00` sampled channels in FreeP), so this wave does not relabel them as Avalonia product regressions.

The retained WPF Conditional Format Manager authority is nonblank and semantically explicit but predates the shared-source correction. FreeW's fresh WPF harness attempt likewise failed the nonblank gate, so no blank Windows evidence was promoted. FreeP `list1` admission is intentionally limited to four distinct flat nodes and four effect-free rounded rectangles at the exact audited shared-layout slots; changed geometry or text, malformed hierarchy, missing or richer roles, effects, and pictures retain cached-drawing fallback.
