# FreeW References Heavy Fields Current Visual Floor

## Scope

This pass regenerated `references-heavy-fields.docx` from current source, rendered all three pages
through the current Release WPF compositor, and exported the same package through an isolated visible
Word 16.0 COM instance. It establishes a fresh matching reference after the temporary baseline cache
was removed.

## Provenance

- Fixture SHA-256: `61E986D2BD4F5AD2CF271F48CCCEE9338DE4C0354CF778D8B47F02DC6CC31D11`
- Word export: isolated visible Word 16.0, read-only open, `ExportAsFixedFormat`, 96-DPI PDF raster
- Word became ready in about 1 second, opened the document in about 0.5 seconds, exported in about
  1.65 seconds, closed the document, and quit its owned process
- Word page PNG SHA-256: `B333A09B26E0D0531FE979ED139A21709697D200F9DD6435B8EF47043BA661C0`,
  `5ECA90AA5B7E51163587C068618791CA6E061950F21CE21031437AC713AA409B`, and
  `1F22D2D1F2D56A45BE1EB97671E5FE71464B349FB5A40DC1398826AD34355A75`
- WPF page PNG SHA-256: `803D91919A64F9AB8975AC0432528895AB6AF9149ED14B97E1EA9D9E1AF95CA5`,
  `5631CBDC11D0AE88323AB48F4B296126C9C29C4A28B35294FB477ED04EEB33FE`, and
  `BD26D371379729E934BB9EC6EE02408DE975842407EF890F199148DE27ED52FF`
- All pages: 816x1056 pixels; matching source, page sequence, renderer configuration, and capture size

## Current Metrics

Normalized mean absolute RGB-channel delta and changed-pixel ratio at an average-channel threshold of
12 are:

| Page | Mean channel delta | Changed pixels |
| --- | ---: | ---: |
| 1 | 0.9675% | 1.7864% |
| 2 | 6.0044% | 10.3712% |
| 3 | 2.7321% | 4.8319% |

Page 2's highest 96x96 tiles repeat down the middle of the body-text column: 16.4356%, 16.1773%,
16.0320%, 14.9418%, 14.9103%, and 14.8361%. Raw inspection shows the same line wrapping, paragraph
cadence, page break, and bibliography-field position. The residual is dominated by Word's Calibri
glyph raster/antialiasing footprint versus WPF's darker and generally one-pixel-taller bands.

Page 3 likewise preserves the References, Table of Authorities, dotted leaders, page references, and
closing-paragraph geometry. Its remaining score is predominantly host text rasterization rather than a
missing field or displaced layout owner.

## Decision

No renderer change is accepted from this pass. A broad font fallback, WPF text formatting-mode change,
or draw-time glyph scale would affect every line and previously regressed the same fixture. This corpus
is retained as a semantic/layout control: future changes must preserve its three-page sequence and
field content, and typography-only probes must improve the complete affected sequence rather than one
ink band or scaled preview.
