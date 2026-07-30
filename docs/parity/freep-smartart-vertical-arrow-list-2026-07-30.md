# FreeP Vertical Arrow List SmartArt

FreeP now treats PowerPoint's native `verticalArrowList` diagram as a live,
editable List-family SmartArt layout.

- The reader admits the native layout identity instead of forcing cached-drawing
  fallback.
- Insert and Change Layout are available through the shared planner and both WPF
  and Avalonia ribbon routes.
- Cache regeneration emits one editable downward-arrow stage per authored node,
  preserving order and text through save/reopen.
- The current route is renderer-neutral functional coverage; exact PowerPoint
  arrow proportions and typography remain separate visual-fidelity work.
