# FreeP Duplicate-Slide Section Membership

Duplicating a slide now inserts the new slide ID into the source slide's named
section immediately after the source. Undo restores the original section list and
redo recreates the membership for the new duplicate identity.

Custom-show slide lists remain independent: duplicating a slide does not silently
change which slides a named custom show presents.

Focused `PresentationCommandTests` cover section membership across duplicate apply,
undo, and redo.
