# FreeP Change Line Color Animation Authoring

## Scope

FreeP now authors PowerPoint's native emphasis animation for changing a shape's line color. The shared `AnimationPreset.ChangeLineColor` is exposed through the WPF and Avalonia animation command surfaces as `Change Line Color`.

## PowerPoint contract

PowerPoint COM inspection of `msoAnimEffectChangeLineColor` produced:

- `presetClass="emph"`
- `presetID="7"`
- `presetSubtype="2"`
- `p:animClr` targeting `stroke.color`
- a companion `p:set` targeting `stroke.on` with `true`
- the default `accent2` destination color

The package reader recognizes the native `stroke.color` behavior rather than classifying it as the generic text/fill color effect. The writer preserves imported behavior children and authors the same native behavior group for the ribbon command. Playback uses the existing color-emphasis effect surface until a separate line-color visual compositor is warranted.

## Verification

- Presentation animation planner, package round-trip, and playback focused lane: 233/233.
- Command inventory: 654/654 commands shared by WPF and Avalonia; 110 workflow evidence rows.
- Visual parity was not claimed by this functional slice; the native package contract is the authoritative evidence.
