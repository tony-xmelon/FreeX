# FreeP SmartArt list2 live layout

PowerPoint's `list2` SmartArt layout was classified as a List family but was
kept on the cached-drawing path. The existing shared vertical list geometry is
valid for this bounded layout family, so the reader now admits `list2` as live.
Imported diagrams can therefore regenerate after node/text edits and remain
editable instead of silently preserving stale cached artwork.

Verification covers reader admission, shared live composition, and the
renderer-neutral layout engine. This slice makes no native PowerPoint raster
fidelity claim.
