# FreeP Custom Show Launch Plan Parity - 2026-07-04

## Scope

This slice advances the FreeP presenter/custom-show workflow-depth lane by
moving slide show launch choices into a shared WPF/Avalonia planner contract.
The planner covers From Beginning, From Current Slide, and stored PowerPoint
custom shows without requiring PowerPoint COM.

## What Changed

- `SlideShowCustomShowPlanner` now builds a `SlideShowLaunchPlan` with enabled
  state, labels, start indexes, slide counts, and disabled reasons for empty
  decks or empty custom shows.
- WPF and Avalonia `StartSlideShow` now route From Beginning and From Current
  through the same shared launch-choice route builder used by custom shows.
- WPF and Avalonia main windows expose the shared launch plan for host UI
  surfaces and paired parity tests.

## Verification

- Shared planner tests prove full-deck, current-slide, and custom-show launch
  choices, including current-slide clamping and dangling custom-show members.
- WPF host tests prove the main window exposes the shared launch choices and
  keeps the custom-show route order/source indices.
- Avalonia headless tests prove the same shared launch choices are exposed by
  the cross-platform host.

## Remaining Work

This does not add a visible custom-show picker dialog or PowerPoint COM visual
baseline. It provides the shared route/evidence contract those host pickers can
consume without diverging between WPF and Avalonia.
