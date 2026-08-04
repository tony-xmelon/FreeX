# FreeW Style Set combo state parity (2026-08-04)

## Gap

The Design Style Sets combo applied catalog values in both hosts but could not report the set represented
by the current document. It therefore stayed stale after load, apply, reset, or Undo.

## Change

`DocumentStyleSet.FindMatching` identifies a catalog set from the three values the set uniquely owns:
the document body font, Heading 1 font, and Heading 1 accent. WPF and Avalonia commands now publish that
model-derived name through their existing stateful combo paths. No new shadow field or package metadata
was introduced.

## Behavior

- New documents publish `Office`.
- Applying `Elegant` publishes `Elegant`; Undo and Reset publish `Office`.
- A loaded document whose catalog carries the `Formal` signature publishes `Formal`.
- Unknown and empty values remain no-ops.
- A customized signature that matches no catalog set publishes no selected value.

## Verification

- Focused model signature contract.
- WPF `RibbonComboCommandContractTests`.
- Avalonia `DesignTabTests`.

## Process rule

When OOXML does not serialize a direct picker identity, derive state only from the exact model properties
the operation owns. Do not add shadow UI state that can drift from loaded or manually edited content.
