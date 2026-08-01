# FreeP Comments Pane Rebind - Wave94

Date: 2026-08-01

## Scope

This slice closes one lifecycle mismatch between the FreeP WPF host and the
Avalonia host. WPF rebuilds the realized comments pane after a file load and
when the current slide changes. Avalonia previously refreshed only the shared
comment plan, so an already-open pane could continue displaying cards from the
previous slide until a later comment action caused another render.

## Change

`FreeP.App.Avalonia.MainWindow` now refreshes the realized comments controls
after review-plan refreshes during presentation load and current-slide changes,
but only when the pane was already open/requested. The shared review planner
and comment mutation behavior are unchanged.

## Evidence

- `MainWindowHeadlessTests.Open_comments_pane_rebinds_to_current_slide_after_selection_changes`
  creates one comment on slide 1 and two on slide 2, opens the pane on slide 1,
  switches to slide 2, and verifies the realized accessibility item count moves
  from 1 to 2.
- The WPF authority already performs the equivalent refresh through
  `RefreshCommentPane()` in both lifecycle paths.

## Residuals

This is a managed lifecycle fix; native Avalonia template/text rasterization
differences and full physical Linux comments-pane evidence remain outside this
slice.
