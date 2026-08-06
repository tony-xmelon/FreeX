# FreeP Spin preset semantics - 2026-08-06

PowerPoint-authored Spin is an emphasis timing with `presetID="8"`, not
`presetID="3"`. A short PowerPoint COM fixture using the Office Spin effect
emitted `presetClass="emph" presetID="8" presetSubtype="0"`.

FreeP already has shared Spin playback and effect-subtype authoring, but its
map used ID 3. Imported native Spin could therefore resolve to the wrong
emphasis family during playback while the package remained syntactically
valid.

The map now reads and writes `emph/8` as `AnimationPreset.Spin`, and the
round-trip contract covers the authored subtype used by the animation pane.
This is a functional/package correction; it makes no visual playback claim.
