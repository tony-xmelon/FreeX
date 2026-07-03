# FreeP Modern Comments Anchor Fidelity - 2026-07-03

## Scope

This slice advances the FreeP modern comments/review workflow-depth lane after
the metadata-preservation work by preserving modern comment anchor identity
alongside the existing X/Y position fields.

## What changed

- `SlideComment` now carries the modern PowerPoint comment anchor element name
  and raw anchor XML separately from legacy comment position fields.
- `PptxPackageReader` reads the first modern `p188:*Anchor` element from a
  modern comment part and keeps its local name on the comment model.
- `PptxPackageWriter` emits the preserved supported modern anchor XML when
  writing modern comment parts, falling back to `unknownAnchor` for new,
  missing, or invalid anchor payloads.
- `PresentationCommentDescriptor` now exposes `ModernAnchorKind` and a stable
  `AnchorSummary` for review panes and host adapters.
- `SlideCloner` preserves the anchor metadata during slide duplication.

## Verification

- Shared planner coverage proves legacy anchor summaries and modern anchor
  summaries on comment pane descriptors.
- PPTX IO coverage proves modern comment read/write keeps anchor kind, raw
  anchor XML, and position in the package XML.
- Model coverage proves slide cloning keeps modern anchor identity.

## Remaining Work

This does not implement rich mention UI, visible Add/Edit execution depth, or
PowerPoint-authoritative visual baselines. It preserves supported anchor XML
payloads but does not yet interpret richer shape/text target semantics for host
navigation or visual placement.
