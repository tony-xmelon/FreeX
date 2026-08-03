# FreeP Wave116: hierarchy1 dedicated live layout

## Selection

Wave116 selects the admitted `hierarchy1` SmartArt layout as the one generic-family
candidate to receive a dedicated shared live path. `list2` was considered but not
selected: repository evidence proves its admission, package round-trip, and the
existing vertical list behavior, but does not contain a distinct `list2` fixture or
layout-specific geometry contract.

`hierarchy1` has stronger evidence in the repository. Host fixtures create a real
hierarchy with `parOf` parent-child connections, the reader rebuilds its nested node
tree, and existing authoring notes document the hierarchy tree semantics and cache
regeneration path. It was admitted already, so this change does not broaden live
admission.

## Implementation

`hierarchy1` now selects a dedicated shared top-down tree plan. It preserves the
authored forest structure, assigns root/branch/leaf roles, lays out nested subtrees
in proportional slots, and emits one editable connector for each parent-child edge.
The existing WPF and Avalonia consumers continue to consume the same renderer-neutral
`SlideShape` plan. Cache regeneration writes those shared shapes through the existing
SmartArt drawing writer, and package save/reopen preserves the regenerated outline.

Unsupported layouts still return `null` from the live engine and render from their
authoritative cached drawing fallback. No other SmartArt layout was admitted or
given new geometry in this wave.

## Limitations

This is a renderer-neutral top-down hierarchy approximation based on the repository's
existing hierarchy data and authoring semantics. It does not claim pixel identity with
PowerPoint's private layout engine, and hierarchy variants without dedicated evidence
remain on cached fallback or their existing proven paths.
