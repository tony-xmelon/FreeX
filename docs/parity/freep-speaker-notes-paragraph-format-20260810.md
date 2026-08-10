# FreeP Speaker Notes Paragraph Formatting

FreeP now routes paragraph formatting commands to a selected speaker-notes range
before falling back to slide text or table-cell editing in both WPF and
Avalonia. Alignment, bullet and numbering toggles, list-gallery presets, and
indent/outdent use the existing shared paragraph mutation planner and commit
through one undoable `SetSlideNotesCommand`.

The host text-box selection is translated from display CRLF offsets to the
model paragraph separator before mutation. No display-only marker text is
added to the notes model.

Verification on the isolated current-main branch:

- `FreeP.App.Presentation.Tests` EditingSession focused lane: 79/79.
- `FreeP.App.Host.Tests` RibbonEditorCompleteness5B focused lane: 215/215.
- `FreeP.App.Avalonia` Release build: 0 warnings, 0 errors.

This is a functional/package editing slice; no new raster-fidelity claim is
made.
