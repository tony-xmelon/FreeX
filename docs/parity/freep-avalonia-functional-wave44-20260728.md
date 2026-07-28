# FreeP Avalonia Functional Wave 44 - 2026-07-28

## Mismatch fixed

Avalonia's `MainWindow` attached `Closed` handlers to slideshow windows that
called `Editor.SelectSlide` for the last slide viewed. The WPF launch path in
`freep/FreeP.App.Host/MainWindow.cs` creates the slideshow as a separate window
and does not mutate the editor selection when playback ends. That made Avalonia
leave the editing surface on a different slide after previewing a deck or
named custom show.

The Avalonia handlers now preserve the editor-side selection exactly as WPF
does. The normal slideshow route still restores owner focus, which is a host
window-lifecycle concern and does not change document state. The custom-show
route now has the same selection behavior without a second editor mutation.

## Scope and authority

- WPF authority: `freep/FreeP.App.Host/MainWindow.cs`, `StartSlideShow` and
  `TryStartCustomSlideShow` contain no editor-selection mutation on close.
- Avalonia production route: `freep/FreeP.App.Avalonia/MainWindow.cs`.
- Regression route: `MainWindow.StartSlideShow` is launched through the real
  Avalonia headless window path, playback advances to another slide, and the
  editor selection is asserted to remain at the original slide.
- Secondary chart-axis authoring and all recording/video/export files were
  intentionally excluded from this slice.

## Validation

Focused validation is run from the isolated worker worktree and recorded with
the exact result in the Wave 44 handoff.

## Residuals

This slice does not claim full PowerPoint-authoritative slideshow visual
fidelity or hardware-backed recording parity. Those remain separate scopes.
