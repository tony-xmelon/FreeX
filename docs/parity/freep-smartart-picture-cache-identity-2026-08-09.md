# FreeP SmartArt picture cache identity - 2026-08-09

SmartArt picture cache regeneration previously emitted picture shapes without
the diagram node identity. The reader therefore had to fall back to the
document-order picture mapping, even though it already supported tagged
picture shapes for authored packages.

Regenerated picture shapes now carry the corresponding `SmartArtNode.ModelId`
as their cache `modelId` when the node has image bytes. The existing fallback
remains available for legacy nodes without an identity. This keeps media
ownership tied to the diagram data through a reorder or partial cache edit;
the change does not alter layout geometry or picture bytes.

Verification:

- `SmartArtEditingPlannerTests`: 159/159.
- WPF `SmartArtTests`: 293/293.
- Generated cache contract asserts distinct `photo-alpha` and `photo-beta`
  identities on the two picture shapes.
- This is a functional package-ownership fix; no PowerPoint raster baseline
  claim is made.
