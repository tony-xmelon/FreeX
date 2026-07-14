# FreeP SmartArt Stacked Venn Live Layout - 2026-07-14

## Scope

This slice adds bounded no-COM geometry evidence for PowerPoint `stackedVenn`
SmartArt imports.

The reader now classifies `stackedVenn` as a relationship-family layout and
admits only two to five parsed nodes into live layout. Unsupported relationship
siblings keep the cached `dsp:drawing` fallback path.

## Shared Behavior

- `SmartArtLayoutEngine` emits parsed nodes as ordinary shared translucent
  ellipse shapes offset down and right in a stacked relationship layout.
- Stacked Venn layouts emit no connector ops.
- WPF and Avalonia consume the same compositor draw ops; no renderer-local
  SmartArt policy is introduced.

## Evidence

- `SmartArtLayoutTests` covers stacked geometry, overlap, node-count admission
  bounds, unsupported relationship fallback, and live compositor output over
  cached fallback.
- `SmartArtTests` builds synthetic PPTX fixtures proving `stackedVenn` imports
  as a live relationship-family layout while unsupported relationship siblings
  stay on cached fallback.
- `MainWindowHeadlessTests` proves the Avalonia host consumes the same shared
  stacked ellipse draw ops.

## Residual Limitations

The planner represents stacked Venn SmartArt as renderer-neutral offset
translucent ellipses, not exact PowerPoint stacked-region blending, effects, or
text offsets. Stacked Venn diagrams outside the two-to-five-node bound,
unsupported relationship-family siblings, PowerPoint-authoritative visual
baselines, and SmartArt authoring/editing remain deferred.
