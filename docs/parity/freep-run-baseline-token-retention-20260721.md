# FreeP run baseline token retention

Date: 2026-07-21

## Scope

Imported DrawingML run properties now preserve `a:rPr/@baseline` through the FreeP model, PPTX read/write, presentation cloning, text-edit run splitting/merging, and resolved WPF/Avalonia run state. Positive values raise a run and negative values lower it; values use DrawingML `ST_Percentage` units (one thousandth of a percent).

The edit planners compare the token when coalescing adjacent runs, so a superscript/subscript boundary cannot be erased by a later text edit.

## Evidence

`RunBaselineRoundTripTests` writes positive and negative baseline tokens, checks the serialized `slide1.xml`, reloads the package, and verifies both values. The focused test is the acceptance gate for this semantic/package slice.

## Deliberate limitation

This slice does not change WPF or Avalonia glyph placement. The resolved run state carries the authored token so a dedicated renderer contract can consume it later; no visual parity claim is made for superscript or subscript rasterization yet.
