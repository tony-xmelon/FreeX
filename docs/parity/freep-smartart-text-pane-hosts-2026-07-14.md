# FreeP SmartArt Text Pane Host Parity - 2026-07-14

## Scope

- Adds thin WPF and Avalonia SmartArt text-pane host surfaces for the selected SmartArt shape.
- Pane rows are rendered from `SmartArtEditingPlanner.BuildOutline`.
- Pane apply rebuilds the shared outline through `SmartArtEditingPlanner.ApplyTextPaneOutline`.
- Row keyboard handling routes Enter, Ctrl+Enter, Tab, Shift+Tab, and Alt+Shift+Up/Down through `SmartArtEditingPlanner.PlanTextPaneKeyboardRoute`.
- Successful edits refresh the live SmartArt layout and reuse the shared data-part and drawing-cache regeneration paths.

## Evidence

- `SmartArtEditingPlannerTests` covers outline application, cache/data-part rewrite sharing, and route planning.
- `ReviewWorkflowAdapterTests.MainWindow_SmartArtTextPane_RendersSharedOutlineAndRoutesKeyboard` covers the WPF pane.
- `MainWindowHeadlessTests.SmartArt_text_pane_renders_shared_outline_and_routes_keyboard` covers the Avalonia pane.

## Inventory

No generated command/evidence inventory update was required for this slice because no new FreeP ribbon command id was added.
