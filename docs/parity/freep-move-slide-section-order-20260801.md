# FreeP Move-Slide Section Order

Moving a slide now reorders each named section's stored slide IDs to match the
presentation order while preserving the section membership set. Custom-show order
remains independent of presentation order.

Undo restores both the original slide order and exact section lists; redo applies
the synchronized order again.

Focused `PresentationCommandTests` cover apply, undo, and redo.
