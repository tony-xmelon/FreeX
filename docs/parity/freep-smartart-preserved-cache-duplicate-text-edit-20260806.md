# FreeP SmartArt duplicate-text cache edits

## Scope

PowerPoint SmartArt commonly contains repeated node labels. The preserved native
cache synchronizer previously rejected a single edit batch whenever two changed
nodes shared the same prior text, because text-only matching could not identify
which cached shape owned each edit.

The synchronizer now records each changed node's flattened ordinal. It uses that
ordinal only when both preserved representations prove the complete prior
sequence: every cached `dsp:txBody` and every text-bearing fallback shape must
match the prior logical node-text sequence in count and order. When that proof is
absent, unique-text matching remains available and duplicate source text still
fails closed. Topology, layout, effects, and authored geometry are unchanged.

## Verification

- Duplicate-source-text ordinal mapping: **5/5** focused synchronizer tests.
- FreeP Presentation: **3,788/3,788**.
- WPF SmartArt: **313/313**.
- Avalonia SmartArt: **33/33**.
- WPF Release consumer build: **0 warnings, 0 errors**.
- Avalonia Release consumer build: **0 warnings, 0 errors**.

This is a functional cache-edit parity slice; it makes no new visual-fidelity
claim.
