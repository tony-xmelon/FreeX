# Avalonia Parity Wave 147: FreeW Table of Authorities

Date: 2026-08-04

## Scope

This bounded slice covers `table-of-authorities.initial`,
`table-of-authorities.populated`, and `table-of-authorities.validation-error`
at the existing `560x600`, 96-DPI dialog-harness target.

## Change

Avalonia's Table of Authorities action row now uses the WPF button-row margin
`(0,12,0,0)`, removing the extra one-DIP bottom margin. Planner state,
validation behavior, and action semantics are unchanged.

## Evidence

Fresh Avalonia captures passed the content gate for all three scenarios:

| Scenario | Before canonical Avalonia bounds | After fresh Avalonia bounds | Retained WPF authority |
| --- | --- | --- | --- |
| `initial` | `514x184` at `16,20` | `513x184` at `16,20` | `513x185` at `16,20` |
| `populated` | `514x184` at `16,20` | `513x184` at `16,20` | `513x185` at `16,20` |
| `validation-error` | `514x184` at `16,20` | `513x184` at `16,20` | `513x185` at `16,20` |

The retained paired comparison remains `changedRatio=0.1135804` and
`meanAbsoluteChannelDelta=4.5137143`. A fresh WPF capture was not available
because this host produced a blank raster, so those paired values were not
recomputed or promoted. The fresh horizontal bound also measured one pixel
narrower, but this source change is vertical-only, so that observation is not
attributed to the margin correction. The one-pixel vertical residual remains
visible for follow-up.

## Verification

- Focused Avalonia parity tests: `5/5` passed.
- Bounded Avalonia harness captures: `3/3` captured and content-gated.
