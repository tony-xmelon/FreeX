# FreeP Avalonia Parity Wave 145: Authored Titled Matrix topology

Date: 2026-08-04

## Scope

Authored non-COM `Titled Matrix` now writes its title and body nodes as flat
level-zero `dgm:pt` siblings, matching the shared live planner's imported
topology. Focused coverage proves native `titledMatrix` identity, no `parOf`
connections, shared title-band/body-cell geometry before and after PPTX
writer/reader round-trip, and thin WPF/Avalonia consumption through
`SlideCompositor`.

## Boundary

This closes only authored Titled Matrix topology depth. It does not claim
PowerPoint-pixel geometry, native effects or theme fidelity, richer imported
Titled Matrix cache grammars, Grid Matrix or other matrix-family parity, or
broad SmartArt parity. Imported variants outside the existing flat-node
planner contract continue to use their cached drawing fallback.
