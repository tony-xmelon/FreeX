# FreeW compact Insert representative icons — Wave 238

## Scope

At the 750-DIP compact ribbon state, Avalonia had reduced the Insert > Illustrations and Insert > Links groups to the generic collapsed-group glyph. The WPF reference keeps picture and link identities.

The Avalonia portable profile now supplies `Picture` for Illustrations and `Link` for Links on their first representative controls. Commands, group order, labels, and adaptive sizing are unchanged.

## Evidence and verification

- The refreshed 750-DIP Avalonia Insert shell capture visibly shows picture and link glyphs in the two collapsed groups.
- FreeW shell evidence refresh and check passed: 40 paired static plus 32 paired contextual captures.
- The new focused representative-icon assertion passed.
- The complete `FreeW.Ribbon.Definitions.Tests` suite passed: 66/66.
- Canonical ribbon-profile evidence was regenerated and checked using the workspace-pinned .NET SDK, recording the intentional Insert and prior Review profile fingerprint changes.

Ink/Draw behavior and map-chart fidelity remain excluded by [UX visual-parity scope](ux-visual-parity-scope-2026-08-25.md).
