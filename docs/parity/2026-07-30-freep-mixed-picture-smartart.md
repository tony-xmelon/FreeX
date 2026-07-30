# FreeP mixed picture SmartArt

## Scope

Picture SmartArt layouts can contain a mixture of populated picture nodes and
nodes that still expose PowerPoint's `Add picture` placeholder. The reader used
to admit only an empty drawing or an exact one-picture-per-node drawing, so a
partially populated drawing fell back to the cached SmartArt image.

## Change

FreeP-authored drawing shapes already carry `modelId` values that correspond to
the SmartArt data nodes. The reader now uses those identities when all imported
pictures are tagged, allowing partial picture population while leaving missing
nodes live and editable. Complete drawings retain the existing document-order
fallback for packages whose drawing IDs are producer-specific or untagged.
Ambiguous partial identity, duplicate IDs, and unknown IDs remain on the cached
fallback rather than guessing ownership.

## Verification

- New partial picture-caption-list reader/compositor test: 1/1.
- Host SmartArt filter: 221/221.
- Presentation SmartArt filter: 329/329.
- No visual parity claim was made; this slice restores functional editability
  and source-owned node-to-picture mapping.
