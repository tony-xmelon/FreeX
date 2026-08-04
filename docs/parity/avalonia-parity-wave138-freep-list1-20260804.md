# FreeP Wave 138 SmartArt list1 import depth

Date: 2026-08-04
Branch: `codex/avalonia-parity-wave138-freep-residual-20260804`

## Selected layout

This slice admits one strict imported `list1` cache grammar from the
deterministic `tools/FreeP.RenderCompare/corpus/15-smartart-grouped-list.pptx`
fixture, slide 5. The package contains four flat data nodes and four ordered
effect-free `roundRect` cache slots.

## Exact grammar

The reader promotes the cache only when the four node texts are non-empty,
distinct, and in data order; the hierarchy is flat with no connections; every
cached role is a rounded rectangle; and the local EMU slots exactly match the
shared `LayoutList` plan for the 8,229,600 x 5,744,800 EMU frame:
`x=329,184`, `cx=7,571,232`, `cy=1,213,589`, and y positions `229,792`,
`1,587,001`, `2,944,210`, and `4,301,419`.

Changed geometry, reordered or mismatched text, malformed hierarchy, missing
roles, effects, pictures, richer roles, and other unproven list caches remain
on the preserved cached-drawing path. Authoring-only `list1` data without a
cached drawing keeps the existing shared live layout behavior.

## Shared renderer evidence

`SmartArtLayoutEngine.LayoutList` remains the geometry source and
`SlideCompositor` supplies the same ordinary shape operations to WPF and
Avalonia. Fixture XML evidence, host reader/composition tests, focused shared
layout coverage, and paired renderer source contracts cover the package and
renderer-neutral boundary.

The deterministic SmartArt corpus remains a 10-slide deck while extending its
list slide with the audited four-slot cache. The generated FreeP workflow
inventory increases from 109 to 110 rows. The cross-app dashboard is
intentionally unchanged.

This is bounded WPF/Avalonia functional evidence. It does not claim
PowerPoint-pixel identity, exact Office text fitting, effects parity, or wider
import coverage for list-family layouts.
