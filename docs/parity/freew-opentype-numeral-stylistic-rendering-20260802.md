# FreeW OpenType numeral and stylistic rendering

## Scope

FreeW already retained and authored Word's `w14:numForm`, `w14:numSpacing`, and single
`w14:stylisticSets` run properties. This slice makes those properties visible in the WPF and Avalonia
compositors.

The shared planner maps:

- lining/old-style numerals to `lnum`/`onum`;
- proportional/tabular spacing to `pnum`/`tnum`;
- Word stylistic sets 1 through 20 to `ss01` through `ss20`.

Each explicit numeral choice disables its opposite feature. Default formatting emits no feature override and
reuses one allocation-free empty plan.

## Host ownership

- WPF editable runs, fields, and floating shape glyphs consume native `Typography` properties.
- WPF floating shape measurement uses the same native properties as paint, preserving wrap geometry.
- Avalonia's central `FormattedText` builder applies the shared feature tags, so body, table, header/footer,
  note, and floating text measurement and paint use the same shaping path.
- Multi-character ligatures remain separate because Avalonia currently shapes body text one character at a
  time; this slice does not claim or approximate ligature parity.

## Verification

- Shared planner: 5/5.
- WPF PagedEdit and floating-object render controls: 36/36.
- Avalonia source consumer, body layout, and floating shape controls: 65/65.

No Word COM raster was required for this semantic feature mapping. The OpenType tags and WPF Typography
properties directly express the serialized Word choices; font-specific glyph availability remains controlled
by the selected font.
