# FreeP Chart Empty-Cell Options

FreeP now exposes PowerPoint's chart empty-cell display choice in the shared Chart Options
dialog on both WPF and Avalonia: Automatic, Gap, Zero, and Connect data points.

The selected value is carried by the existing undoable chart display-options command. Automatic
clears the authored `c:dispBlanksAs` value; the other choices round-trip as the native `gap`,
`zero`, and `span` tokens already consumed by the shared chart renderer and PPTX writer.

Focused verification:

- Presentation chart planner/command tests passed.
- WPF ChartDataDialog tests passed.
- Avalonia ChartDisplayOptionsDialog headless test passed.
