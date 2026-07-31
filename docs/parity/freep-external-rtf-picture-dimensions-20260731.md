# FreeP external RTF picture dimensions

## Scope

External RTF `\\pict` payloads now retain the authored `\\picwgoal` and
`\\pichgoal` display extents, including the common `\\picscalex` and
`\\picscaley` percentage controls. The shared rich-clipboard payload carries
the resulting EMU dimensions through its private serialization, and WPF and
Avalonia use them when creating the pasted slide-level picture shape.

Legacy payloads and XAML images without dimensions continue to use the existing
default insertion bounds. This remains a slide-level picture fallback; inline
picture runs and OLE activation inside a text body remain separate work.

## Verification

- External RTF parser and private clipboard serialization preserve both extents.
- WPF paste creates the authored-width/height picture shape.
- Avalonia paste creates the authored-width/height picture shape.
- Existing picture/text and multiple-picture clipboard paths remain covered.

This is a functional clipboard/package slice and makes no PowerPoint raster
baseline claim.
