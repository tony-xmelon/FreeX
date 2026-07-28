# Review-Markup Capture Provenance

## Scope

`f2-comments.docx` exposed a capture-mode provenance gap. The FidelityRender
composite path can explicitly render review comment balloons with
`--review-markup`, but Word's PDF reference for this fixture contains the
print surface without those balloons. Both modes previously wrote the same
host metadata, allowing a visual comparison to treat them as interchangeable.

## Change

Every FidelityRender composite evidence row now declares
`reviewMarkup=true` or `reviewMarkup=false` in `hostMetadata`. The software
fallback explicitly declares `reviewMarkup=false`, since it has no review
balloon compositor. Consumers must match this value before comparing captures.

## Evidence

Against the fresh Word PDF baseline, the stale WPF image with review markup
scored `5.1270%` on page 1. A rebuilt default composite capture, which matches
Word's no-markup print surface, scored `1.7691%`; page 2 scored `0.5272%`.
The change records this rendering distinction rather than accepting an invalid
cross-mode comparison.

## Verification

- Focused `VisualEvidenceFidelityRenderSourceTests` provenance contract.
- Release build of `FreeW.FidelityRender`.
- Fresh default composite `f2-comments` render and manifest inspection.
