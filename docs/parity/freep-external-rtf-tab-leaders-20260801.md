# FreeP External RTF Tab Leaders

## Scope

External RTF paste now preserves the leader pattern attached to a paragraph tab
stop instead of silently discarding it. This extends the existing `\\tx` and
`\\tq*` tab-stop support without changing the PPTX tab-stop contract.

## Implemented behavior

- `\\tlnone`, `\\tldot`, `\\tlhyph`, `\\tlul`, `\\tlth`, and `\\tleq` map to
  explicit shared leader values.
- Leader state is scoped with the RTF group stack, resets after the associated
  `\\tx` stop, and clears with `\\pard`.
- The leader survives paragraph cloning, rich clipboard serialization, and
  deserialization.
- WPF and Avalonia receive the same resolved leader through the shared visual
  plan; the shared tab layout plan associates it with the segment following the
  tab. Native host painting of leader glyphs remains a separate renderer task.

## Verification

- Focused Presentation tests: `100/100` for external RTF, rich visual planning,
  and tab layout planning.
- Full `FreeP.App.Presentation.Tests`: `3180/3180`.
- WPF rich editor/clipboard lane: `70/70`.
- Avalonia clipboard interop lane: `36/36`.
- Release builds completed with zero warnings and zero errors for the exercised
  shared and host projects.

This is a functional source-semantics slice. It does not claim native
PowerPoint visual parity or complete leader glyph rasterization.
