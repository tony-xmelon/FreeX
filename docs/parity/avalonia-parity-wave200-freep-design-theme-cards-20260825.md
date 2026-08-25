# Wave 200 — FreeP Design theme-card previews

## Scope

This slice improves the app-owned Design ribbon preview surface in FreeP's WPF
and Avalonia hosts. It does not add unsupported PowerPoint themes or create
placeholder commands. Ink/Draw behavior and map-chart fidelity remain outside
the active parity scope.

## Change

The five implemented built-in themes now render as familiar PowerPoint-style
cards: a type sample (`Aa`) over the six accent swatches. The same existing
theme commands, accessibility names, tooltips, and selection flow are retained
on both hosts.

## Evidence

The fresh WPF Design-ribbon capture is retained at
`artifacts/wave200-freep-design-theme-cards/design.png`. It shows Office Theme,
Berlin, Facet, Ion, and Slice as recognisable theme cards rather than generic
color bars. Native PowerPoint reference remains a semantic design reference,
not a raw host-pixel target.

## Verification

- `FreeP.RibbonShot`: WPF Design capture completed.
- `FreeP.RibbonShot` build: passed, zero warnings/errors.
- `FreeP.App.Avalonia` build: passed, zero warnings/errors.
- `PresentationThemeGalleryTests`: validates all built-in routes and the five
  visible type samples.
