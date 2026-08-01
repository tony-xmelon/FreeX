# FreeP Add-Slide Section Membership

The backward-compatible append-slide command now keeps section navigation valid. When
an appended slide follows a slide owned by a section, it is inserted into that same
section immediately after the preceding slide.

Undo restores the exact section snapshots and redo reapplies the membership. Appends
with no section-owned predecessor retain the prior unsectioned behavior.
