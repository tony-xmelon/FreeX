# FreeW Avalonia body SECTION field

Avalonia body paragraphs now resolve the Word `SECTION` field from the paragraph's authoritative
block-to-section assignment. The display path supports the shared Arabic, Roman, and alphabetic
numeric pictures and leaves the imported instruction and cached result unchanged.

This is deliberately separate from body `SECTIONPAGES`. The latter depends on the final physical
pagination result and needs a bounded reflow pass, including footnote-continuation ownership.

Verification:

- Exact body field contract: 1 passed.
- `DocumentViewHeadlessTests`: 37 passed.
- `dotnet build FreeW.slnx --configuration Release`: 0 warnings, 0 errors.
