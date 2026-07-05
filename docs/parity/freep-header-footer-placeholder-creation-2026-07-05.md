# FreeP Header/Footer Placeholder Creation - 2026-07-05

This slice improves Insert > Header & Footer depth by moving missing slide date/footer/slide-number placeholder creation into the shared FreeP presentation planner.

Parity improved:

- `HeaderFooterCommandPlanner` now creates missing date/time, footer, and slide-number placeholders when the corresponding apply option is enabled.
- Created placeholders use model-level `PlaceholderType.DateTime`, `PlaceholderType.Footer`, and `PlaceholderType.SlideNumber` plus PowerPoint-compatible field runs (`datetime1`, `footer`, `slidenum`).
- The planner prefers layout/master placeholder geometry through `PlaceholderResolver` and falls back to conservative slide-size-relative bottom placement when no inherited geometry exists.
- WPF and Avalonia keep thin routing: both collect user options and call the shared planner without renderer-local header/footer policy.
- Existing placeholder and field-only shapes are reused instead of duplicated, and undo restores the previous slide state.

Remaining gaps:

- PowerPoint-authoritative header/footer visual baselines still require a COM-capable machine.
- This slice does not add advanced Header & Footer dialog variants such as fixed/auto date formatting choices, title-slide suppression UI, or theme-specific visual tuning.
- Exact PowerPoint layout heuristics for decks without layout/master footer placeholders remain bounded to FreeP's shared fallback geometry.
