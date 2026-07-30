# FreeP Empty Picture SmartArt

PowerPoint permits picture-based SmartArt to exist before any node has an image. The
reader previously disabled the live layout whenever its cached drawing contained no
resolvable pictures, hiding the editable `Add picture` state behind a fallback.

The reader now keeps zero-image picture layouts live so the shared layout engine emits
the existing placeholders. Ambiguous partial image mappings still use the cached
fallback. Package admission and compositor coverage verify the empty authoring state.

This is a functional SmartArt editing/package slice with no new visual parity claim.
