# FreeP SmartArt Titled Matrix - Wave 29

FreeP now gives the PowerPoint `titledMatrix` layout its own shared live plan.
The first node is treated as semantic title content and is rendered as a full-width
title band. Remaining nodes render in a bounded two-column body grid. WPF and Avalonia
both consume this through the shared `SmartArtLayoutEngine` and `SlideCompositor`.

Malformed input with no body, a blank title, or more than eight body nodes returns
`null`, preserving the imported `dsp:drawing` cache as the authoritative fallback.
No ribbon command or inventory row was added: `titledMatrix` was already admitted and
registered on both hosts, and this slice deepens its shared layout semantics.

## Verification

- Presentation layout lane: 4 passed (`TitledMatrix` geometry and bounded fallback).
- WPF host/import/compositor lane: 2 passed (`TitledMatrix`).
- Avalonia headless compositor lane: 1 passed (`titled_matrix_shape`).

## PowerPoint-authoritative residuals

This is function-first parity. Exact PowerPoint title-band proportions, cell corner
geometry, theme effects, text insets, automatic text fitting, and native DrawingML
layout regeneration remain deferred. Unsupported or malformed diagrams still render
from the preserved cache rather than claiming exact live-layout fidelity.
