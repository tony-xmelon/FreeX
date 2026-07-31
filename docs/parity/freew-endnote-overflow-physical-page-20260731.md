# FreeW Endnote Overflow Physical Page

## Scope

The imported `review/endnotes.docx` body occupies two Word pages. Word places its
two endnotes on a third physical page. The WPF composite previously detected that
the note region did not fit below the final body line, logged that multi-page
endnote pagination was unavailable, and emitted only the two body pages.

The compositor now measures the final body raster against the rendered endnote
region before emission. Endnotes still follow the final body paragraph when they
fit. When they do not fit, the logical page count includes one inherited-geometry
endnote page and that page is emitted instead of dropping the note content.

## Matched Evidence

- Source: `freew-fidelity-corpus/files/review/endnotes.docx`
- Word path: fresh Microsoft Word COM PDF export and Poppler raster, 816x1056
- FreeW path: rebuilt Release `FreeW.FidelityRender --composite`, 816x1056
- Page count: Word `3`, before `2`, after `3`
- Existing body pages 1 and 2: SHA-256 byte-stable
- New page 3 versus Word: mean RGB delta `1.5094`; pixels over 32 RGB delta `0.8610%`
- Full review corpus: all other 34 PNGs byte-stable; only `endnotes_p3.png` was added

The generated `f2-endnotes.docx` fitting control remains two body pages and keeps
the endnotes directly after the final body content on page 2.

## Verification

- `dotnet test freew/FreeW.App.Host.Tests/FreeW.App.Host.Tests.csproj --configuration Release --no-restore --filter FullyQualifiedName~VisualEvidenceFidelityRenderSourceTests`: 18/18
- `dotnet build freew/tools/FreeW.FidelityRender/FreeW.FidelityRender.csproj --configuration Release --no-restore`: 0 warnings, 0 errors
- Fresh review-corpus render: 12/12 documents, 36/36 pages
