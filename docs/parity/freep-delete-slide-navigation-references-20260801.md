# FreeP Delete-Slide Navigation Reference Integrity

Deleting a slide now removes every matching slide-id occurrence from named custom
shows and presentation sections. Undo restores the original slide and the exact
ordered reference lists; redo prunes them again.

This keeps slideshow routes and section membership valid when a referenced slide is
deleted, including custom shows that intentionally repeat a slide. The change is
limited to the shared `DeleteSlideCommand`; it does not alter slide identity or
duplicate-slide behavior.

Focused `PresentationCommandTests` cover apply, undo, and redo for both section and
custom-show references, including duplicate occurrences.
