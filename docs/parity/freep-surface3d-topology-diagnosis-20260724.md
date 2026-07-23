# FreeP Surface3D topology diagnosis

## Scope

This is a diagnostic-only slice for the generic imported `Surface3D` chart in
`22-chart-baseline-depth`. No renderer change is retained. The comparison uses
the current WPF composite artifact and the persistent 1280x720 PowerPoint COM
reference with matching provenance.

## Evidence

The current WPF whole-page mean RGB delta is **2.5856%**. A prior guarded
vertical registration probe (`ImportedSurfacePointOffsetY -9 -> -6`) worsened
the same page to **2.6336%** and failed the exact geometry contract, so a
global Y translation is not an acceptance path.

Exact frequent-color component bounds in the surface crop show why. Selected
PowerPoint versus WPF bounds are:

| Facet material | PowerPoint | WPF |
| --- | --- | --- |
| `#99BD80` | `(682,132)-(943,177)` | `(687,126)-(957,189)` |
| `#97BD80` | `(733,176)-(934,221)` | `(798,157)-(928,242)` |
| `#4474C7` | `(601,226)-(765,272)` | `(602,216)-(748,259)` |
| `#F18032` | `(604,185)-(787,228)` | `(628,187)-(793,253)` |
| `#D5702C` | `(601,176)-(913,240)` | `(601,176)-(913,240)` |

The last material is already registered exactly while the other facets have
independent horizontal, vertical, and footprint errors. This rules out a
shared page offset, a single mesh scale, and a global camera translation.

## Decision

Rejected as a product probe. The next viable implementation would need a
fixture- or source-owned projected mesh topology model that corrects shared
vertices and local boundary triangles independently, with the full-page delta,
surface ROI, and the 22/26 neighboring controls gated together. The current
generic projection remains unchanged.

## Verification

- Source state restored to `ImportedSurfacePointOffsetY = -9.0`.
- The focused chart contract was restored to **27/27**.
- No renderer or chart behavior changed in this diagnostic slice.
