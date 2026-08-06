# FreeP SmartArt relationship1 two-node cache grammar - 2026-08-06

## Source evidence

The existing relationship-family evidence in
`docs/parity/freep-smartart-relationship-tail-20260727.md` identifies
`relationship1` / Basic Relationship as two or three overlapping ellipses.
The checked-in `15-smartart-grouped-list.pptx` fixture proves the three-node
cache form. The FreeP fixture builder now constructs the corresponding real
OOXML package with two ordered ellipse node shapes using the same 0.58
diameter overlap step already emitted by the shared planner.

## Admitted grammar

An imported `relationship1` cache is promoted to the shared live planner only
when all of the following are true:

- the flattened data model has exactly two or three nodes and the cache has the
  same number of shapes;
- every cached shape is an auto shape with `ellipse` geometry and non-empty text;
- cached text matches the flattened data-node sequence exactly, with no duplicate
  labels;
- all ellipses have equal positive square extents, share the same Y position,
  appear in increasing X order, overlap, and each X step equals the planner's
  `diameter * 0.58` value within one EMU;
- the cache and drawing carry no unsupported effects or extra roles.

The shared model, `SmartArtLayoutEngine`, drawing-cache regeneration, undo bus,
package writer, and compositor remain the authorities. WPF and Avalonia consume
the same regenerated/live draw plan through `SlideCompositor`.

## Fallback-only residuals

`relationship1` caches with fewer than two or more than three nodes, non-ellipse
roles, extra background/divider/connector roles, reordered or missing text,
non-square/different-size geometry, a different overlap ratio, authored effects,
or malformed/ambiguous content remain on the preserved `dsp:drawing` fallback.
This slice does not broaden any other relationship-family cache grammar and does
not claim PowerPoint-authoritative visual equivalence for effects or text
placement.

## Verification

- Shared Presentation SmartArt filter: **398/398**;
- WPF host SmartArt/package filter: **316/316**;
- Avalonia renderer SmartArt consuming-route filter: **12/12**;
- Avalonia host SmartArt/reachability filter: **33/33**.

The WPF and Avalonia renderer assertions verify that both desktop surfaces
continue to consume the shared compositor plan; the package test verifies edit,
undo, redo, cache regeneration, write, and reopen for the two-node fixture.
