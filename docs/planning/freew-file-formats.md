# FreeW File-Format Adapter Status

**Last updated:** 2026-06-21

FreeW no longer hardcodes a DOCX-only file lifecycle. Current mainline uses `IDocumentFileAdapter`, `DocumentFileAdapterCatalog`, catalog-derived format resolution, and host/Avalonia picker filters so adding or changing a format is a catalog/adapter/test change instead of command string surgery.

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
| Word XML | `.xml` | Yes | Yes | WordprocessingML/Flat OPC style adapter path. |
| Rich Text Format | `.rtf` | Yes | Yes | Text and supported formatting are mapped through `TextDocument`. |
| HTML | `.html`, `.htm` | Yes | Yes | Document HTML import/export path. |
| MHTML | `.mhtml`, `.mht` | Yes | Yes | Web archive document path. |
| PDF | `.pdf` | Yes | No | Import-only text extraction path; export remains a host/export concern. |
| Legacy Word | `.doc`, `.dot` | Yes | No | Import-only legacy adapter. |
| Plain text | `.txt`, `.text`, `.log` | Yes | Yes | Encoding/EOL choices stay adapter-owned, not model-owned. |

## Not Currently Registered

| Format | Status |
|---|---|
| OpenDocument Text | `.odt`, `.ott`, and `.fodt` are not registered in the current catalog. Add only with explicit adapter, corpus rows, and known-gap documentation. |
| XPS | Export remains separate from document-file open/save adapters. |
| WordPerfect or other legacy formats | Out of current scope unless a redistributable corpus and importer strategy are approved. |

## Maintenance Rules

- Add formats in `DocumentFileAdapterCatalog` plus one adapter and registration-test tuple.
- Keep options such as encoding, EOL style, and import warnings adapter-owned; do not add format-specific state to `TextDocument` unless it is real document semantics.
- Document partial fidelity with corpus rows and expected warnings rather than broad claims.
- Keep downloaded documents and comparison outputs under ignored `freew-fidelity-corpus/files/` and `freew-fidelity-corpus/runs/`.

## Historical Note

This file was originally a future expansion plan. The adapter architecture has since landed, so the durable purpose of this document is now to summarize current registration, remaining gaps, and the rules for future format additions.
