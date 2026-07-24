# FreeW WordArt Bold Retention

## Scope

WordArt now retains the bold state of its embedded WordprocessingML text run.
The model carries `WordArt.Bold`; the DOCX reader recognizes `w:rPr/w:b`, the
writer emits it only when authored, and the shared WordArt visual plan passes
the state to both WPF and Avalonia renderers.

## Verification

- `WordArtRoundTripTests`: 50/50 passed, including XML emission and reopened
  model state for an authored bold run.
- `DrawingObjectVisualPlannerTests`: 22/22 passed, including authored bold and
  default regular plan states.
- `DocumentEffectRenderingTests`: 7/7 passed, including WPF `TextBlock`
  `FontWeight` consumption.
- WPF FidelityRender and Avalonia Release builds completed with zero warnings
  and errors.

The manually saved `wordart-watermark-stress.pdf` reference remains an
unbolded control. After rebuilding the actual FidelityRender consumer, its
816x1056 composite PNG SHA-256 was byte-identical before and after this slice.
