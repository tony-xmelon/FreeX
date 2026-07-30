# FreeP Wave69: pointer edge selection and auto-scroll

Wave69 closes the next in-canvas rich-text pointer-selection gap adjacent to
Wave68. The Avalonia editor now follows the native WPF `RichTextBox` contract
when a captured drag enters the visible editor edge or leaves the editor
bounds.

## Implementation

- `InCanvasRichTextPointerSelectionPlanner` owns renderer-neutral vertical edge
  direction, bounded scroll advancement, and the existing anchor/caret
  clamping policy.
- `AvaloniaRichTextEditingSurface` now tracks measured document extent, paints
  and hit-tests through a bounded vertical scroll offset, and clamps the
  offset to the document end.
- `AvaloniaRichTextEditor` keeps pointer capture through an edge drag and uses
  a short dispatcher timer to continue auto-scrolling while the pointer is
  held near or beyond the top/bottom edge. Capture loss and release stop the
  timer.
- WPF continues to delegate pointer selection and auto-scroll to native
  `RichTextBox`; the paired tests assert its logical edge contract rather than
  recreating native behavior in shared code.

## Managed verification

- Shared planner: 12 passed.
- Avalonia pointer edge drag: 1 passed.
- Avalonia Shift-click, double-click, and triple-click selection: 1 passed.
- Avalonia Linux physical-probe source contract: 1 passed.
- WPF native pointer parity family: 4 passed.

## Physical follow-up

The parent integration session should run the strict Linux lane after merging:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\Run-FreePRichTextShortcutValidation.ps1 -PointerSelection -Port 6097 -OutputDir artifacts\p69 -SkipPublish -SkipImageBuild
```

The pointer probe now releases the forward drag 64 pixels below the fixture
editor and still requires exact forward/reverse clipboard readback, screenshots,
and an unchanged mounted fixture hash.

## Residuals

The physical Docker result is intentionally not claimed by this agent. Exact
pixel comparison of the WPF native selection highlight against Avalonia's
custom selection surface remains a separate visual-fidelity task; this slice
closes input capture, edge clamping, and scroll behavior.
