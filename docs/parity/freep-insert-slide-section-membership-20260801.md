# FreeP Insert-Slide Section Membership

Slides inserted through the normal `EditingSession.InsertSlide` path now inherit
the named section of their adjacent slide. Insertion after the current slide adds
the new ID immediately after the preceding member; insertion at the beginning uses
the following section member.

Undo restores the exact section list and redo reapplies the membership. The
legacy `AddSlideCommand` remains unchanged for callers that intentionally append a
standalone model slide.

Focused `PresentationCommandTests` cover insertion, undo, and redo.
