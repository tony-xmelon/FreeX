# FreeP external RTF baseline round-trip - 2026-08-09

External RTF import already converted `\\upN` and `\\dnN` half-point controls
to the shared run model's DrawingML-style baseline units (thousandths of a
percent of the run font size). The RTF writer previously collapsed every
positive or negative model value to `\\super` or `\\sub`, which silently lost
the authored offset on a rich-text copy/paste round trip.

The writer now inverts the same conversion and emits `\\upN` or `\\dnN` in
half-points, using the run font size and the existing bounded range. A focused
round-trip test covers both signs at a non-default 16pt font size, so the test
proves the exact controls rather than only the visible direction.

This is shared clipboard semantics consumed by both WPF and Avalonia. It makes
no PowerPoint raster-fidelity claim and does not change the slide text model.
