# FreeP XamlPackage multi-image paste - 2026-07-30

## Scope

External WPF `XamlPackage` clipboard payloads can contain more than one image resource.
The parser previously selected only the first resolvable `Image` element even though the
shared clipboard payload and both host services already supported an ordered image list.
The parser now preserves every resolvable image occurrence in document order and keeps the
legacy first-image fields populated from the first item.

## Verification

- Presentation parser: `XamlPackageFlowDocument_PreservesAllImagePayloadsInDocumentOrder`.
- WPF host paste: `Paste_XamlPackageImages_InsertsAllPackageResourcesInOrder`.
- Avalonia host paste: `XamlPackage_images_are_pasted_in_document_order`.

This is a functional clipboard/package slice; it makes no new raster-fidelity claim.
