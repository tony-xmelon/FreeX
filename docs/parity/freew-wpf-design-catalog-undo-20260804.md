# FreeW WPF Design catalog Undo parity (2026-08-04)

## Gap

Avalonia routed Themes, Colors, Style Sets, Fonts, Paragraph Spacing, and Effects through a reversible
catalog command. WPF committed pending edits and mutated the model directly, so these document-wide
Design changes could not be undone even though Word exposes each as a normal Undo step.

## Change

The catalog snapshot command now lives in `FreeW.Core.Model` and WPF routes all six Design catalog
operations through its `DocumentCommandBus`. The command captures document run/paragraph defaults,
theme metadata, and the run/paragraph formatting of every built-in style those catalogs can rewrite.
The existing command-bus change event remains the sole WPF re-render owner.

## Behavior

- Each catalog application creates one Undo entry.
- Undo restores the exact prior defaults, theme, and affected styles.
- Redo reapplies the catalog mutation.
- WPF theme combo state returns to `Office` after undoing `Berlin`.
- Avalonia continues to consume the same shared command without behavior changes.

## Verification

- Focused `DesignCatalogCommand` model contract.
- WPF `RibbonComboCommandContractTests` catalog and state contracts.
- Avalonia `DesignTabTests` regression control.

## Process rule

Document-wide formatting is still user editing state. Route catalog mutations through one shared
snapshot command and let each host's existing command-bus change event own re-render and state refresh.
