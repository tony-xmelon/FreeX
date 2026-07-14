# FreeP SmartArt Data-Part Authoring Evidence - 2026-07-14

This slice advances the remaining SmartArt authoring/data-part gap with a
bounded shared persistence path for edited SmartArt outline data.

## Scope

- `SmartArtEditingPlanner` can now regenerate the native
  `ppt/diagrams/data*.xml` diagram data part from the shared `SmartArtData`
  model after outline edits.
- The regenerated `dgm:dataModel` writes node text, node ids, assistant node
  type, and `parOf` parent-child connections from the shared model tree.
- The existing PPTX writer consumes the updated diagram part bytes, so WPF and
  Avalonia do not need renderer-local SmartArt persistence policy.

## Honesty Bound

This is a bounded data-part rewrite for shared outline edits. It does not
regenerate SmartArt layout, quick style, color, or cached `dsp:drawing` parts,
does not expose the full PowerPoint SmartArt text pane UI, and does not claim
PowerPoint-authoritative visual or keyboard workflow parity.

## Evidence

- `SmartArtEditingPlannerTests.RewriteDataPart_AfterSharedOutlineEdit_RegeneratesNativeDiagramData`
  proves shared model edits rewrite the native diagram data XML with updated
  text and hierarchy connections.
- `SmartArtTests.RoundTrip_SmartArt_SharedDataPartRewritePersistsEditedOutline`
  proves the existing PPTX writer persists the rewritten data part and the
  reader rebuilds the edited hierarchy from the saved package.

## Remaining Work

PowerPoint-authoritative authoring baselines, host text-pane affordances,
keyboard shortcuts, richer assistant/org-chart editing nuance, and regeneration
of layout/style/color/drawing-cache parts remain deferred.
