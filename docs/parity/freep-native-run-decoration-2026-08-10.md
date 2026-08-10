# FreeP Native DrawingML Run Decorations - 2026-08-10

## Functional gap

PowerPoint DrawingML text runs can author underline variants such as
`wavyHeavy` and double strike, while FreeP previously reduced both `a:rPr`
tokens to booleans and rewrote them as single underline/single strike.

## Change

`Run` now retains nullable raw `a:rPr/@u` and `a:rPr/@strike` tokens. Reader,
writer, model clones, rich clipboard payloads, text-run splitting/merging,
table-cell editing, and the WPF no-op editor round-trip preserve exact tokens
and omission. Existing boolean properties remain the compatibility and
rendering surface; disabling a decoration through the editor clears its raw
token, while ordinary unchanged edits retain it.

## Scope

This establishes source and editing parity for authored decoration variants.
It does not claim that the WPF/Avalonia renderers paint every DrawingML
underline geometry variant identically; that is a separate renderer-owned
visual task.
