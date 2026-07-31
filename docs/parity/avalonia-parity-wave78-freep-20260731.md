# FreeP Wave 78 Avalonia SmartArt action reachability

## Concrete gap

The WPF and Avalonia SmartArt text-pane hosts use the same fixed 320px pane and
the same five lower command actions: Toggle Assistant, Replace picture, Remove
picture, Apply, and Close. Avalonia placed those controls in a single
right-aligned horizontal `StackPanel`. Their minimum widths exceed the pane, so
the left-side controls were laid out outside the visible host; the physical
Wave 77 lane could reach the outline actions but could not honestly claim the
lower Apply/gallery workflow.

## Fix

FreeP Avalonia now uses a width-constrained, left-aligned `WrapPanel` for the
same five controls. The command order and callbacks are unchanged, while the
band grows vertically and keeps every action reachable at the existing 320px
pane width. The existing outline action band remains unchanged.

## Verification

- Avalonia headless SmartArt text-pane workflow still verifies outline rows,
  Apply, undo/redo, keyboard edits, data-part rewrite, and drawing-cache
  regeneration.
- A source regression test locks the fixed-width host and wrapping command-band
  contract.
- No PowerPoint COM, Docker, microphone, camera, or external-input validation
  was run in this slice.

## Residuals

This closes Avalonia command reachability for the bounded SmartArt pane host. It
does not claim exact PowerPoint SmartArt geometry, broader gallery visual
fidelity, or a new WPF layout change; the WPF host remains the comparison
authority and its native rendering is outside this Avalonia-owned write scope.
