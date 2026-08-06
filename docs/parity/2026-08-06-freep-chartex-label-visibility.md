# FreeP ChartEx data-label visibility preservation

## Scope

Native ChartEx data-label visibility already had corresponding FreeP model fields for
percent labels, legend keys, bubble-size labels, and leader lines. The ChartEx reader
and writer did not carry those fields through `cx:visibility`, so save/reopen could
silently discard valid chart options.

## Change

The native ChartEx reader now maps `percent`, `legendKey`, `bubbleSize`, and
`leaderLines` into the existing `ChartDataLabels` model. The writer emits enabled
flags and preserves an explicitly authored `leaderLines="false"` token. The existing
ChartEx command path and undo behavior remain the owner of edits; this slice closes
the package persistence gap.

## Verification

- Native ChartEx package round trip asserts all four flags and explicit false.
- Chart display-options command asserts edit, package reopen, and undo behavior.
- No visual-fidelity claim is made; this is a functional/package parity slice.
