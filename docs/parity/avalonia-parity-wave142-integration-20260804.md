# Avalonia/WPF parity wave 142 integration

Date: 2026-08-04

## Scope

Wave 142 closed four evidence-backed host divergences:

- FreeX: rebuilt the Avalonia Data Table dialog around the WPF two-row reference-editor layout, added both worksheet range pickers, and captured the same populated `E2`/`F2` evidence state.
- FreeW: moved the representative populated Table of Authorities state into the shared planner and made both hosts and visual harnesses consume the same `ToaOptions`.
- FreeP: made chart and table context-menu placement explicit at the pointer/mouse point in both hosts.
- Shared shell: adapted mnemonic-bearing Avalonia dialog action buttons to `AccessText`, including automation access-key metadata, while preserving button order and default/cancel semantics.

## Generated evidence

- FreeX remains complete for declared dialog inputs: 57/57 routes and 94/94 paired screenshot surface ids, with zero nonblank failures, zero scale-aware size mismatches, and zero review candidates above the 0.4 triage threshold.
- The corrected Data Table pair now compares the same populated state. Its triage score is `0.100622`; the prior lower score came from mismatched fixture semantics and is not retained as a parity claim.
- FreeW remains at 940 command rows with zero actionable WPF- or Avalonia-missing rows.
- FreeP remains at 648/648 shared-profile command rows. The whole-window manifest was refreshed for the paired context-menu source changes.

## Focused verification

- FreeX Data Table source parity: 2/2 passed.
- FreeW Table of Authorities filtered solution run: all matching tests passed, including planner 18, WPF host 15, and Avalonia visual 2.
- FreeP context-menu parity: Avalonia 17/17 and WPF 5/5 passed.
- Shared Avalonia dialog mnemonic behavior: 1/1 passed.

## Evidence boundaries

The retained WPF Table of Authorities raster remains the authority because fresh WPF attempts still produced zero-pixel output and were rejected. Native font rasterization, control chrome, message-dialog metrics, and authoritative Microsoft Office baselines remain visual-depth work; command and route coverage are not treated as proof of complete visual parity.
