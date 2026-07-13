# FreeP Custom Show Drag Reorder - 2026-07-13

Custom Shows authoring now has a shared drag/drop reorder plan for the visible custom-show slide-order list. `SlideShowCustomShowPlanner.BuildCustomShowSlideDragReorderPlan` validates the source row and slide id, clamps drop bounds, treats adjacent row-boundary drops as no-ops, preserves duplicate slide ids by moving the selected occurrence, and projects the resulting order and selected index.

Both WPF and Avalonia custom-show dialogs wire visible drag/drop handlers on the slide-order list, consume that shared plan through thin adapter paths, and apply real moves through the existing `MoveCustomShowSlide` mutation semantics. Focused coverage lives in the shared planner tests plus WPF/Avalonia dialog tests that guard the visible handler registrations, shared planner call, and duplicate-slide reorder behavior.
