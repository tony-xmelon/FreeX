# FreeP Custom Show Duplicate Occurrences

Date: 2026-07-30

## Function slice

Custom shows already stored ordered slide-id occurrences, but the WPF and Avalonia
dialogs exposed only deck-order membership checkboxes. That made the existing duplicate
occurrence capability inaccessible to users. Each deck slide now has an explicit `Add`
action, and the selected custom-show occurrence has a `Remove` action. Both routes use the
existing shared `UpdateCustomShowSlides` mutation, so repeated slide IDs remain ordered,
undo/save semantics stay on the existing host path, and removing one occurrence does not
remove other occurrences of the same slide.

## Verification

- WPF `CustomShowDialog_RendersExistingShowsAndSlideRows`: 2/2 passed.
- Avalonia `CustomShowDialog_renders_existing_shows_and_slide_rows`: 1/1 passed.
- `git diff --check`: clean.

This closes the visible authoring gap for duplicate custom-show occurrences. Drag-ghost
visual polish and PowerPoint-authoritative custom-show baselines remain separate follow-up
work.
