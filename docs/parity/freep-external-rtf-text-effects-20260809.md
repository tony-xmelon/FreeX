# FreeP External RTF Text Effects: 2026-08-09

External Word/RTF clipboard text can carry the boolean `\\outl` and `\\shad`
character controls. The reader previously ignored them even though FreeP's
shared `Run` model already owns text outlines and shadows and both WPF and
Avalonia consume those effects through the normal text visual plan.

The RTF boundary now maps `\\outl`/`\\outl0` to a shared 0.75pt black
`ShapeOutline.Visible` and `\\shad`/`\\shad0` to the shared default
`RunTextShadow`. The RTF writer emits the corresponding boolean controls when
those run effects are present. This preserves the effect's supported semantic
presence through parse, edit-buffer serialization, host consumption, and RTF
round-trip without claiming provider-specific color, width, blur, or offset
metadata that these controls do not encode.

Verification on the isolated branch:

- `ExternalRichTextClipboardTests` focused filter: 64/64.
- WPF `WpfRichTextClipboardAdapterTests`: 23/23.
- Avalonia clipboard-focused filter: 40/40.

No PowerPoint raster comparison is attached; this is a functional external
clipboard semantics slice.
