# FreeP canvas parity wave 84: Zoom double-click terminality

## Divergence

WPF stops canvas gesture processing after a valid Zoom double-click navigates to its target
slide. Avalonia selected the target slide but then fell through to the ordinary shape
selection/move path, because its matching branch omitted the terminal return.

## Fix and evidence

Avalonia now returns after Zoom navigation, matching WPF priority semantics. Paired source-backed
tests in `FreeP.App.Host.Tests` and `FreeP.App.Rendering.Avalonia.Tests` require the terminal
return so a future textless-shape policy change cannot reintroduce the fall-through.
