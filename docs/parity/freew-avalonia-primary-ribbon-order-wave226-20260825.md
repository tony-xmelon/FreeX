# FreeW Avalonia primary ribbon order — Wave 226 (2026-08-25)

FreeW's Avalonia primary ribbon now follows the same Word-style discovery order as the WPF host, while retaining Avalonia's backed File entry:

`File, Home, Insert, Design, Layout, References, Mailings, Review, View, Help, Developer`

Previously, the Avalonia strip placed Layout before Design and put View/Review/Developer ahead of References and Mailings. That made standard Word commands appear in different locations between FreeW hosts. The change is made in the shared capability profile that feeds the real Avalonia `MainWindow`, and a focused definition test guards the complete primary sequence.

The canonical shell evidence was recaptured at 1500, 1100, 900, and 750 DIPs, including all contextual fixtures. It passed its 40 paired static-capture and 32 paired contextual-capture inventory checks. This is host-to-host ribbon topology evidence, not a claim of raw pixel equality between WPF, Avalonia, or Microsoft Word.

Ink/Draw behavior and map-chart fidelity remain deferred by the [UX visual-parity scope](ux-visual-parity-scope-2026-08-25.md).
