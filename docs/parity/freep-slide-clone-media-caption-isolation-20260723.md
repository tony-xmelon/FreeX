# FreeP slide-clone media and caption isolation

Date: 2026-07-23  
Scope: `FreeP.Core.Model.SlideCloner.CloneShape`

## Change

Cloned media shapes now receive an independent `MediaInfo` object, media byte payload, and caption-track collection. Caption-track metadata and WebVTT bytes no longer remain shared between a source slide and a duplicate. This preserves the clone isolation expected by duplicate-slide, undo, clipboard, and caption-authoring workflows while retaining all media relationship and link metadata.

## Verification

- Focused compiled test: `SlideCloner_CloneShape_ClonesMediaAndCaptionTracks`.
- Existing clone regression coverage remains in the `SlideCloner_` family.
- The consuming `FreeP.RenderCompare` build is included in the slice verification.
