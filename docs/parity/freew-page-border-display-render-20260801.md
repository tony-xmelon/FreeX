# FreeW page-border page visibility

## Scope

Word's `w:pgBorders/@w:display` controls whether a section border appears on all pages, only its first
page, or every page except its first. After preserving that package metadata, FreeW still painted every
page identically.

`PageBorderVisibilityPlanner` now owns the zero-based page rule, and the effective page-border consumers
use it:

- WPF FidelityRender, including its software fallback
- WPF Print Preview, including a synthetic endnote page
- WPF's single editable Print Layout sheet, treated honestly as page zero
- Avalonia's discrete live Print Layout pages
- Avalonia direct PDF export

`w:zOrder="behind"` is covered independently by `freew-page-border-zorder-render-20260801.md`.

## Verification

- Shared planner: all/first/not-first truth table, 8 focused tests total with the wave planner.
- Avalonia: multi-page PDF behavior proves first-page and not-first-page border placement; live/PDF source
  ownership is guarded.
- WPF: live, preview, FidelityRender, and software-render owner calls are source-guarded.
- The actual Release `FreeW.FidelityRender` consumer builds with 0 warnings and 0 errors.
