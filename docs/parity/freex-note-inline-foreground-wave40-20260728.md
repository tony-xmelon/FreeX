# FreeX New/Edit Note Foreground Parity - Wave 40

Date: 2026-07-28

## Scope

This slice closes the foreground worksheet-anchored New Note/Edit Note residual from Wave 39.
The WPF `GridView.CommentPreview` implementation remains the authority for popup geometry,
chrome, focus, and viewport lifecycle.

## Changes

- Avalonia now places the note popup to the right of its anchor cell, flips it to the left near
  the viewport edge, and applies the WPF 8px edge padding and 6px cell gap.
- Popup width and maximum height use the WPF planner limits: 180-320px width and 72-220px
  height. The note no longer forces a fixed 230px frame.
- Avalonia now applies the WPF yellow surface, olive border, subtle drop shadow, 5px text-box
  padding, top-aligned multiline editing, automatic vertical scrolling, and 6px action-button
  spacing.
- Existing-note focus restores the caret at the end with no selection, matching WPF.
- Scrolling the anchor cell out of the visible viewport dismisses the Avalonia editor state,
  matching WPF's popup lifecycle.

## Verification

- Avalonia `AvaloniaReviewCommentInlineRuntimeTests`: **8/8 passed**, covering placement theory
  cases, note visual-token assertions, caret/focus behavior, save/undo, cancel, and threaded-comment
  regressions.
- WPF `GridCommentPreviewPlacementPlannerTests`: **8/8 passed**, covering authority geometry and
  inline-note chrome/lifecycle source checks.

## Residuals

- Pixel-level foreground capture still depends on a paired WPF/Avalonia runtime capture at the
  same viewport size and zoom. The production geometry and style tokens are now locked by tests.
- Threaded-comment editor foreground parity is outside this New/Edit Note slice.
