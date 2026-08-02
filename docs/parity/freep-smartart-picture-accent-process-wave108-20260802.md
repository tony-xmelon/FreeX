# FreeP Wave 108: SmartArt Picture Accent Process

## Scope

Wave 108 adds the missing `pictureAccentProcess` SmartArt family to FreeP's shared authoring catalog. It is a bounded process layout with one picture stage and an accent text block per node.

## Shared implementation

- `SmartArtLayoutPreset.PictureAccentProcess` is admitted by the shared insertion, change-layout, and PPTX reader paths using the native PowerPoint layout ID.
- `SmartArtLayoutEngine` owns the renderer-neutral geometry: an ordered process rail, picture nodes when media is present, editable `Add picture` placeholders otherwise, and shared accent blocks.
- The same ribbon definition and layout command are wired into the WPF and Avalonia host registries; neither host owns a second geometry implementation.
- Existing SmartArt style planning and theme-aware fills remain shared by both hosts.

## Verification

Focused presentation and host tests cover layout geometry, mixed media/placeholder output, native layout round-trip, process-family admission, insertion payloads, ribbon routing, and source guards for both host registrations.

## Authoritative PowerPoint limitations

The implementation preserves source SmartArt data and media, but does not claim pixel-identical PowerPoint rendering for proprietary picture crops/masks, gradient/effect details, or arbitrary native layout XML. Those cases continue to use FreeP's shared editable fallback contract.
