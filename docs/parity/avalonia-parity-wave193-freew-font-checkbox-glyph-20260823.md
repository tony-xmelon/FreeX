# Avalonia Parity Wave 193: FreeW Font Checkbox Native Frame

Date: 2026-08-23
Scope: FreeW Avalonia Font dialog, `initial`, `populated`, and `validation-error` states
Authority: FreeW WPF `FontDialog`
Source revision: `20105a1cc31a775eda9719f654a7e3f7aa13a796`

## Implementation

The Font route continues to use the shared compact-dialog checkbox template. Its style now selects
a `14` pixel indicator, a `1` pixel vertical offset, and WPF-matched inner bevel brushes
(`#EBEBEB` top/left and `#F6F6F6` bottom/right). The shared defaults remain the existing `13`
pixel indicator with no offset or bevel, so other dialog routes retain their previous rendering.
No Font-local checkbox template or platform-specific replacement was added.

The original `1` pixel checkmark-stroke proposal produced no changed-pixel improvement because all
three canonical states render unchecked boxes, so it was removed. A `14` pixel height-only probe
regressed all three states by `260` pixels each and was also rejected. The accepted native-frame
change improved every state.

## Measured result

| State | Wave192 changed pixels | Wave193 changed pixels | Delta |
|---|---:|---:|---:|
| `font.initial` | 11,227 | 10,782 | -445 |
| `font.populated` | 11,384 | 10,939 | -445 |
| `font.validation-error` | 11,585 | 11,140 | -445 |
| **Aggregate** | **34,196** | **32,861** | **-1,335** |

Aggregate changed-pixel ratio fell from `6.469898%` to `6.217316%`, a `3.9040%` reduction in
changed pixels. Every Font state improved; none regressed. All six host captures retained exact
painted bounds of `x=12, y=12, width=421, height=321`, and both content gates passed.

The canonical refresh changed only the three `font.*` rows. All `288` non-Font comparison rows
were structurally unchanged, and classification totals remained `141` genuine visual mismatches,
`80` passes, and `70` Avalonia extensions.

## Verification

- Shared compact-dialog contract: `3/3` passed.
- FreeW Font planner and text-raster policy guards: `35/35` passed.
- FreeW Font visual and source-policy guards: `6/6` passed.
- Focused WPF and Avalonia capture-host builds: succeeded with `0` warnings and `0` errors.
- Canonical WPF and Avalonia Font captures: `3/3` states captured per host.
- Focused comparison: exact `421 x 321` painted bounds and `32,861` aggregate changed pixels.

The six PNGs and two capture manifests remain untracked local artifacts. Their actual SHA-256
identities, source revision, canonical row hashes, dimensions, and bounds are recorded in
`freew_font_visual_provenance.json`; the tracked comparison JSON remains the inspectable pixel
authority.
