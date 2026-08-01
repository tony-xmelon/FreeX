# FreeW page-border z-order rendering

## Gap

FreeW preserved `w:pgBorders/@w:zOrder`, but the hosts disagreed about its physical meaning. Avalonia live
and direct PDF always painted page borders before body content, while WPF preview and FidelityRender always
painted them after body content. The package value therefore did not control output.

## Implementation

`PageBorderVisibilityPlanner.LayerFor` maps Word's `front` and `behind` values to explicit
`InFrontOfText` and `BehindText` compositor bands. Effective consumers now honor that shared decision:

- Avalonia direct PDF inserts behind borders before content and appends front borders after content.
- Avalonia live Print Layout paints a behind pass after page background/watermark and a front pass after
  body, floating, header/footer, and note text but before interactive selection/caret chrome.
- WPF Print Preview places the border on the requested side of body text, including synthetic endnote pages.
- WPF live Print Layout uses its control layer for behind paint and a non-hit-testable adorner for front paint.
- WPF FidelityRender and its software fallback use the same layer decision.

Page display scope remains enforced before the layer decision, so first-page/not-first-page behavior is
unchanged.

## Verification

- Shared planner truth table covers both z-order values (10/10 focused planner tests).
- Avalonia multi-page PDF tests assert the authored border operation is first for `behind` and last for
  `front`; the complete focused page-border lane passes 12/12.
- A deterministic WPF paginator test proves the body visual is physically before a front border and after
  a behind border; the full paginator plus owner-source lane passes 11/11.
- WPF/Avalonia source-owner contracts cover the live, preview, FidelityRender, software, and PDF paths.
- Release builds target the actual WPF Host, Avalonia app, and FidelityRender consumers; FidelityRender
  builds with 0 warnings and 0 errors.
