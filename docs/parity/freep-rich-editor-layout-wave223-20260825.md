# FreeP rich-editor layout evidence — Wave 223 (2026-08-25)

The FreeP whole-window capture path now settles the slide canvas layout before it activates the rich-text editor overlay in both native hosts.

- `RefreshCanvas` invalidates the slide surface. Previously, the evidence adapter could derive editor placement from the previous transform before the invalidation had been laid out.
- WPF now updates layout and drains render-priority work before activating the `RichTextBox`; Avalonia updates layout before activating its production rich-text editor.
- A focused source-level regression test protects that ordering in both adapters.

The isolated rich-editor selection capture now reports matching editor bounds:

| Host | X | Y | Width | Height |
| --- | ---: | ---: | ---: | ---: |
| WPF | 382.392 | 266.614 | 250.520 | 73.323 |
| Avalonia | 382.950 | 267.200 | 250.400 | 73.600 |

That is less than 0.6 DIP of positional difference and less than 0.3 DIP of size difference. Visual review confirms the selection and editor frame occupy the same slide-space rectangle; the prior roughly 60-by-18 DIP drift was a capture-layout defect, not a production editor geometry difference.

The refreshed whole-window catalog completed 36/36 paired scenarios with zero capture limitations. `editor.rich-text-selection` still records a 21.86% selection-raster delta against its 20% threshold. With geometry aligned, that residual is native text rasterization: WPF and Avalonia give the same italic Calibri run different glyph widths. The gate remains unchanged so this difference stays visible in evidence rather than being hidden by a threshold adjustment.

This wave does not expand scope into Ink/Draw behavior or map-chart fidelity; those remain deferred by the [UX visual-parity scope](ux-visual-parity-scope-2026-08-25.md).
