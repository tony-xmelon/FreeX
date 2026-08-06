# FreeP Teeter preset semantics - 2026-08-06

PowerPoint-authored Teeter is an emphasis timing with `presetID="32"`, not
`presetID="4"`. A short PowerPoint COM fixture created a Teeter effect and
emitted `presetClass="emph" presetID="32" presetSubtype="0"` together with
the native rotation sequence.

FreeP already has shared Teeter playback in WPF and Avalonia, but its map used
ID 4. Imported native Teeter therefore fell through the unknown-preset fallback
to Pulse during playback while preserving the original XML as raw metadata.

The map now reads and writes `emph/32` as `AnimationPreset.Teeter`, so the
existing playback path remains authoritative and the raw-preset fallback is no
longer involved. The regression test verifies write, read, and write again.

This is a functional/package correction; it makes no visual playback claim.
