# FreeW File-Format Adapter Status

**Last updated:** 2026-08-08

FreeW no longer hardcodes a DOCX-only file lifecycle. Current mainline uses `IDocumentFileAdapter`, `DocumentFileAdapterCatalog`, catalog-derived format resolution, and host/Avalonia picker filters so adding or changing a format is a catalog/adapter/test change instead of command string surgery.
Backstage Save As / Export rows are planned from the same catalog-derived capability view so import-only, export-only, template, and compatibility formats are described explicitly.

## Current Architecture

| Area | Current implementation |
|---|---|
| Adapter seam | `freew/FreeW.Core.IO/IDocumentFileAdapter.cs` over `TextDocument` |
| Catalog | `freew/FreeW.Core.IO/DocumentFileAdapterCatalog.cs` |
| Format metadata | `FileFormatDescriptor`, resolver, filter builder, and save-planning helpers in the IO/file-format layer |
| WPF host | File commands resolve open/save behavior through the catalog rather than a DOCX-only path |
| Avalonia shell | Uses catalog-derived picker filters and the same portable adapters |
| Tests | Registration, filter, round-trip, and corpus tests guard supported formats |

## Registered Formats

| Format | Extensions | Open | Save | Notes |
|---|---|---:|---:|---|
| Word document | `.docx` | Yes | Yes | Primary OOXML path through `DocxReader`/`DocxWriter`. |
| Macro-enabled Word document | `.docm` | Yes | Yes | Uses the DOCX model path; macro/package preservation remains fidelity-driven. |
| Word template | `.dotx` | Yes | Yes | Opens as a template-style document target. |
| Macro-enabled Word template | `.dotm` | Yes | Yes | Template/macro package fidelity remains evidence-driven. |
| Strict Open XML document | `.docx` | Yes | Yes | Separate `DocxFileAdapter.Strict()` registration (namespace-rewrite transform) alongside the transitional OOXML adapter; same extension, distinct `FormatName`. |
| Word XML (Flat OPC) | `.xml` | Yes | Yes | WordprocessingML/Flat OPC style adapter path (`WordXmlFileAdapter`). |
| Word 2003 XML | `.xml` | Yes | Yes | Word 2003 single-file WordprocessingML (`<w:wordDocument>` root) via `Wordml2003FileAdapter`; registered under the same `.xml` extension as the Flat OPC adapter but a distinct `FormatName`, so the resolver dispatches by content sniff. |
| Rich Text Format | `.rtf` | Yes | Yes | Text and supported formatting are mapped through `TextDocument`. |
| HTML | `.html`, `.htm` | Yes | Yes | Two save-mode registrations share these extensions: `HtmlFileAdapter.Filtered()` ("Web Page, Filtered" - clean HTML5) and `HtmlFileAdapter.WebPage()` ("Web Page" - adds Office round-trip scaffolding). |
| MHTML | `.mhtml`, `.mht` | Yes | Yes | Web archive document path. |
| PDF | `.pdf` | Yes | No | Import-only text extraction path through the explicit PDF import command; PDF export is a separate fixed-layout output, not editable round-trip support. |
| Legacy Word | `.doc`, `.dot` | Yes | Yes | Compatibility adapter for Word 97-2003 binary formats. Save is available, but unsupported modern features may be simplified. `.dot` opens as a template/new document. |
| OpenDocument Text | `.odt`, `.ott` | Yes | Yes | Native ODF text package adapter. `.ott` opens as a template/new document. Unsupported ODF constructs are skipped rather than implied as fully round-trippable. |
| Plain text | `.txt`, `.text`, `.log` | Yes | Yes | Encoding/EOL choices stay adapter-owned, not model-owned. |

## Fixed-Layout Export Formats

| Format | Extensions | Open | Save | Export | Notes |
|---|---|---:|---:|---:|---|
| PDF | `.pdf` | Import command only | No | Yes | Export creates a fixed-layout copy for sharing/printing; it is separate from PDF text import. |
| XPS | `.xps` | No | No | Yes | Export-only fixed-layout copy when the host provides an XPS export action. |

## Not Currently Registered

| Format | Status |
|---|---|
| Flat OpenDocument Text | `.fodt` is not registered in the current catalog. Add only with explicit adapter, corpus rows, and known-gap documentation. |
| WordPerfect or other legacy formats | Out of current scope unless a redistributable corpus and importer strategy are approved. |

## Maintenance Rules

- Add formats in `DocumentFileAdapterCatalog` plus one adapter and registration-test tuple.
- Keep options such as encoding, EOL style, and import warnings adapter-owned; do not add format-specific state to `TextDocument` unless it is real document semantics.
- Document partial fidelity with corpus rows and expected warnings rather than broad claims.
- Keep downloaded documents and comparison outputs under ignored `freew-fidelity-corpus/files/` and `freew-fidelity-corpus/runs/`.

## Historical Note

This file was originally a future expansion plan. The adapter architecture has since landed, so the durable purpose of this document is now to summarize current registration, remaining gaps, and the rules for future format additions.
