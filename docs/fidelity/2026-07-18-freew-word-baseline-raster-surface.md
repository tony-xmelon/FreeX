# Word Baseline Raster Surface

## Scope

`FreeW.FidelityRender` now fits its final composite bitmap into the fixed surface
used by the Word COM baseline capture: at most 816 by 1056 pixels, preserving
aspect ratio and never enlarging a page. This is evidence-capture normalization
only. It runs after the document, headers, footers, drawings, notes, and review
markup have been composed, so it does not alter document layout or live WPF
rendering.

## Why

The landscape page in `f2-section-landscape.docx` is physically 1056 by 816 at
96 DPI. Word's fixed-width capture exports that page as 816 by 630. The fidelity
renderer previously wrote its physical-size bitmap and relied on downstream
comparison tooling to reconcile unequal dimensions. That made the direct PNG
contract ambiguous.

## Evidence

Persistent matched Word COM target:

- `f2-section-landscape_p2.png`: 816 by 630 pixels.
- Current WPF composite after normalization: 816 by 630 pixels.
- Direct Word/WPF mean-channel difference: 0.6530%.
- The previous mismatched-surface comparison was 1.2272%.

Portrait control `f2-hf-oddeven.docx` remained byte-identical to the pre-change
WPF composite capture on both pages:

- Page 1 SHA-256: `C262AFBF6F5A9D5605A067FF9331AAFEDE27F0D9586D76517F844A3ED5B23F6A`.
- Page 2 SHA-256: `E536E4056A73A3BC2A50A9382C44CF2DEA11A09D4F08953D5814F6673038F647`.

## Guard

Use the same final-raster normalization for any renderer evaluated against this
fixed Word COM capture. Do not infer document page geometry or modify a live
layout from a capture-surface mismatch.
