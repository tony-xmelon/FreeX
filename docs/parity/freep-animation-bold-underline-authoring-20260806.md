# FreeP Bold and Underline Animation Authoring

FreeP now preserves the native PowerPoint emphasis contracts for the existing
Bold and Underline animation commands.

An installed PowerPoint COM probe established these source identities:

- Bold uses `presetClass="emph"`, `presetID="15"`, `presetSubtype="0"`, with a
  `p:set` targeting `style.fontWeight` and the value `bold`.
- Underline uses `presetClass="emph"`, `presetID="18"`, `presetSubtype="0"`,
  with a `p:set` targeting `style.textDecorationUnderline` and the value
  `true`. PowerPoint also emits an `lt` iterator with `tmPct=4000`.

The reader retains those native IDs, style behavior groups, and the underline
iterator. The writer and authoring planner emit the same package semantics,
while playback continues to use the renderer-neutral Bold and Underline
effect identities. Round-trip tests cover the package XML, model identity,
clone preservation, playback mapping, and undo/redo authoring paths.
