# FreeP Change Font Style Animation Authoring

## Scope

FreeP now authors and round-trips PowerPoint's combined `Change Font Style` emphasis effect through the shared WPF/Avalonia animation command surface.

## PowerPoint contract

An installed PowerPoint COM probe using `msoAnimEffectChangeFontStyle` produced:

- `presetClass="emph"`
- `presetID="5"`
- `presetSubtype="1"`
- three `p:set` behaviors with `override="childStyle"`
- `style.fontStyle` -> `normal`
- `style.fontWeight` -> `bold`
- `style.textDecorationUnderline` -> `false`
- each style setter targets the same shape and uses `dur="indefinite"`

The reader recognizes the complete three-target group before resolving preset ID 5, so it is not confused with Grow. The writer preserves imported behavior children and the authoring planner emits the same native group. Playback keeps a distinct `ChangeFontStyle` identity and uses the existing emphasis pulse visual track until a separate text-style compositor is warranted.

## Verification

- Presentation animation planner, package round-trip, and playback focused lane: 236/236.
- Command inventory: 655/655 commands shared by WPF and Avalonia; 110 workflow evidence rows.
- Visual parity was not claimed by this functional slice; the native package contract is the authoritative evidence.
