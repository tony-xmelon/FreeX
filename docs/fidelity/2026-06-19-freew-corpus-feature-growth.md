# FreeW DOCX corpus feature growth - 2026-06-19

Added 20 download-on-demand DOCX rows to `freew-fidelity-corpus/manifest.csv`, growing the
FreeW fidelity corpus from 114 to 134 files without committing third-party binaries.

## Added source families

- Open XML PowerTools (MIT): broad feature fixtures for text effects, fonts, fields, revision
  tracking, RTL/Hebrew content, run positioning, and a complicated mixed-feature document.
- Open XML SDK (MIT): strict/conformance fixtures for WordArt shadows, document background,
  proofing anchors, expanded/compressed text, line spacing, field variants, outline levels, and
  page layout settings.

## Coverage added

New or strengthened tags include `advanced-typography`, `document-background`, `page-color`,
`page-size`, `orientation`, `proofing`, `rtl`, `text-effects`, and `wordart`.

This pass intentionally favors fixtures from the same permissively licensed upstream repositories
already used by the corpus. It did not commit DOCX binaries; `tools/Fetch-FreeWFidelityCorpus.ps1`
continues to download every non-local row into the ignored `freew-fidelity-corpus/files/` folder.
