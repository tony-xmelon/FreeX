# FreeP Notes Page view surface - 2026-08-25

## Delivered

FreeP's existing **View > Notes Page** command now activates a dedicated page-shaped workspace in both WPF and Avalonia. The active slide remains a live, editable canvas in the upper page region, while the existing undoable notes editor fills the lower region. A white paper surface, border, centered page width, and neutral workspace surround distinguish this from Normal view.

Switching back to Normal restores the original canvas-plus-compact-notes layout. Notes Page keeps speaker notes visible even if the Normal-view **Show > Notes** toggle is off, because notes are intrinsic to this view.

## Boundaries

The surface consumes the existing shared notes-page projection for current-slide content and preserves the same model and undo path. It does not alter notes masters, saved PPTX data, or print/export output. Ink/Draw behavior and map-chart fidelity remain explicitly out of scope.

## Verification

- WPF host and host-test Release builds passed.
- Avalonia host and host-test Release builds passed.
- Focused WPF Notes Page activation/normal-layout restoration test passed.
- Focused Avalonia Notes Page activation/normal-layout restoration test passed.
