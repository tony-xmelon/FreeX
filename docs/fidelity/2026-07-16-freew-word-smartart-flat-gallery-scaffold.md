# FreeW Word SmartArt Flat Gallery Scaffold - 2026-07-16

## Finding

The FreeW writer emitted a minimal `list1`/`process1` layout and flat data graph. Microsoft Word accepted the DOCX but rendered only the semantic node text, while FreeW rendered the cached node shapes. This was an accepted-package visual parity failure.

## Fix

Flat List and Process diagrams now carry the same Word presentation scaffold used by the known-good hierarchy package:

- stock gallery ids and node properties are present on the data points;
- the layout part uses the embedded Word hierarchy scaffold with the requested flat gallery id;
- the data part carries presentation points and parent links;
- Basic List emits a parent chain so Word lays its nodes out vertically;
- the reader flattens that presentation-only chain back to the FreeW List/Process model.

The cached FreeW drawing remains the renderer path for FreeW itself. Hierarchy and pyramid contracts are unchanged apart from consuming the shared gallery-label generation.

## Word COM proof

Using `tools/FreeW.RenderCompare/Export-WordPdfsVisible.ps1` against a fresh corpus generated from the changed writer:

| Fixture | Word PDF | Rasterized pages | Result |
| --- | ---: | ---: | --- |
| `08-smartart-list.docx` | 1 | 1 | visible connected vertical nodes |
| `09-smartart-process.docx` | 1 | 1 | visible horizontal nodes |
| `10-smartart-hierarchy-cycle.docx` | 1 | 1 | hierarchy retained; cycle retained |
| `11-smartart-styled-color.docx` | 1 | 1 | styled process/radial nodes retained |

Process arrow connectors remain a follow-up; Word now materialises the node geometry rather than dropping the gallery to text-only output.

## Verification

- `SmartArtRoundTripTests`: 30/30
- `FreeW.Core.IO.Tests`: 1,030/1,030
- Fresh Word visible-publish export: 4/4
