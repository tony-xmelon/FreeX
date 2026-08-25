# FreeP View color and grayscale parity - 2026-08-25

## Delivered

FreeP's **View** ribbon now includes a **Color/Grayscale** group with window-local **Color**, **Grayscale**, and **Black and White** commands.

The WPF and Avalonia slide canvases render the complete realized viewing surface through the selected treatment. This includes slide backgrounds, shapes, text, pictures, charts, rulers, gridlines, and guides. The implementation uses the shared picture color-effect planner, so grayscale and bi-level behavior stay consistent with other FreeP rendering paths.

## Intentional behavior

- The selected view mode is non-persistent and applies only to the current FreeP window.
- It does not change slide content, themes, or the saved PPTX package.
- Export and print paths continue to use the original presentation colors; this is a viewing aid, as in the PowerPoint View experience.

## Boundaries

Editable Master Views remain a separate editor-mode capability. FreeP reads and writes masters and layouts, but the interactive editing session and canvas are currently slide-oriented; presenting an incomplete switch would be misleading. That work needs a dedicated master/layout editing surface and remains outside this bounded View-ribbon slice.

Per the active parity scope, Ink/Draw behavior and map-chart visual fidelity are excluded.

## Verification

- `FreeP.App.Presentation.Tests`: planner, workflow, and dispatcher tests passed (56 tests).
- WPF slide-canvas color-treatment test passed.
- Avalonia slide-canvas color-treatment test passed.
- `Generate-FreePCommandParityInventory.ps1 -Check` passed after regenerating the FreeP command inventory.
