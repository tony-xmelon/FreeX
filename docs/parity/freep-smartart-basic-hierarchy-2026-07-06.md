# FreeP SmartArt Basic Hierarchy - 2026-07-06

## Scope

This slice admits PowerPoint `basicHierarchy` diagrams into the bounded FreeP
SmartArt live-layout allow-list and closes the remaining generic-geometry gap.

The reader already classifies the layout as `Hierarchy`; this change keeps that
classification and routes the common basic-hierarchy variant through a dedicated
shared top-down plan. Unsupported hierarchy-family siblings remain disabled for
live planning and continue to use cached drawing fallback.

## Shared-First Behavior

- `PptxPackageReader` marks `basicHierarchy` as live-layout supported.
- `SmartArtLayoutEngine` emits role-named root, branch, and leaf boxes plus
  role-named parent-child connectors from the dedicated BasicHierarchy path.
- WPF and Avalonia remain thin consumers of the shared slide shapes and draw
  ops, with no renderer-local SmartArt policy.
- `SmartArtEditingPlanner` regenerates the existing `dsp:drawing` cache from
  the same plan; the reader and writer continue to preserve raw native diagram
  parts for unsupported semantics.

## Evidence

- `SmartArtLayoutTests` proves the dedicated root/branch/leaf roles and
  top-down placement, while `SmartArtEditingPlannerTests` proves cache
  regeneration preserves those roles and emits the same shape count.
- `SmartArtTests` proves the PPTX reader enables live layout for
  `basicHierarchy` while disabling an unsupported hierarchy-family sibling, and
  that composed PPTX input emits shared live shape ops for a three-level tree.

## Residual Limitations

This is not full SmartArt parity. Broader SmartArt layout geometry, richer
PowerPoint-authored roles and connector semantics, authoring and editing
workflows, and PowerPoint-authoritative visual baselines remain deferred.
