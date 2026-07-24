# FreeP SmartArt Matrix Live Layout

FreeP now keeps the shared SmartArt Matrix layout live when the graphic has
more than four nodes. The existing four-node two-by-two arrangement is
unchanged; larger node sets use the same two-column grid with additional rows,
so SmartArt text edits and layout changes continue to regenerate model shapes
instead of falling back to the imported cached drawing.

The layout remains renderer-neutral and bounded by the authored graphic frame.
This slice does not claim PowerPoint's exact Matrix variants, titles, effects,
or relationship semantics; those remain separate layout-family work.
