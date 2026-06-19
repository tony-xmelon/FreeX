# FreeW File-Format Expansion Plan

## 1. Goal

FreeW today opens and saves exactly one format: `.docx`. This plan adds support for **every file format MS Word can open or save beyond `.docx`** — the OOXML variants (`.docm`/`.dotx`/`.dotm`), Rich Text (`.rtf`), plain text (`.txt`), Word XML (Flat OPC + Word 2003 WordprocessingML), HTML/MHTML, OpenDocument Text (`.odt`/`.ott`/`.fodt`), PDF (export already shipped; text import), XPS (export), and read-only legacy binary `.doc`/`.dot` — via a **data-driven adapter registry** mirroring the pattern FreeX already proved for spreadsheets. The architectural goal is that **adding a format is a data change**: write one adapter, add one line to one catalog, add one capability tuple to one registration test. No `FileCommands.cs` string edits, no dialog-filter surgery, no save-vs-save-as branching per format.

## 2. Current State

FreeW hardcodes a single `.docx` format: `freew/FreeW.App.Host/FileCommands.cs` declares `Formats = [FileFormatChoice("Word documents", ".docx")]` (lines 44-45) and calls the static `DocxReader.Read` (lines 73, 136) and `DocxWriter.Write` (line 220) directly. The dispatch seam is `FileCommands.cs` — and a comment at line ~42 already states that future format additions should be a **data change, not a string edit**. The IO engine itself (`freew/FreeW.Core.IO/`, net10.0, no WPF) is broad and mature: `DocxReader` (~2877 lines) / `DocxWriter` (~3870 lines) over the `FreeW.Core.Model.TextDocument` model (paragraphs/runs/tables/images/styles/footnotes/endnotes/comments/sections/`PreservedParts`). **FreeX has already solved this exact problem** in `src/FreeX.Core.IO/` with `IFileAdapter` + `FileFormatDescriptor` + `FileFormatResolver` + `FileDialogFilterBuilder` + `FileSavePlanner`, a single `WorkbookFileAdapterCatalog`, and registration/dialog unit tests — the blueprint FreeW will mirror over the `TextDocument` model with **zero FreeW↔FreeX coupling** (they share only `Free.Shared.*`).

## 3. Proposed Architecture

### 3.1 Layering — where things live

| Layer | Project | TFM | Contents |
|---|---|---|---|
| Model-free machinery (shared) | **`Free.Shared.FileFormats`** (NEW) | net10.0, no WPF | `IFileFormatProvider`, `FileFormatDescriptor`, `FileFormatResolver`, `FileDialogFilterBuilder`, `FilePickerTypeDescriptor`, `FileSavePlanner`/`FileSaveTarget` — promoted verbatim from FreeX |
| Model-typed seam | **`FreeW.Core.IO`** | net10.0, no WPF | `IDocumentFileAdapter` (over `TextDocument`) + concrete adapters: `DocxFileAdapter`, `PlainTextFileAdapter`, future `RtfFileAdapter`/`OdtFileAdapter`/`LegacyDocFileAdapter`/`PdfTextReader`/`WordXmlFileAdapter` |
| Registration + WPF export | **`FreeW.App.Host`** | net10.0-windows (WPF) | `DocumentFileAdapterCatalog` (the single data-change point), the rewired `FileCommands.cs`, and the host-only `IDocumentExportAdapter`/`DocumentExportCatalog` for STA/visual-tree exports (PDF raster, XPS) |

The model-free helpers in FreeX are **already 100% model-free** (verified: `FileFormatDescriptor` is a pure record; resolver/builder/planner touch `IFileAdapter` only via `Formats` and a `CanSave` walk). The recommended path (**Option B**) is to promote those five files into `Free.Shared.FileFormats`, introduce a tiny non-generic base `IFileFormatProvider { IReadOnlyList<FileFormatDescriptor> Formats { get; } }` that both FreeX's `IFileAdapter` and FreeW's `IDocumentFileAdapter` extend, and have both apps consume the shared machinery. This keeps the only per-app code the model-typed interface + concrete adapters, preserving zero coupling. **Option A** (copy the five files verbatim into `FreeW.Core.IO`, touch nothing in FreeX) is the safe fallback if schedule/risk forbids cross-app edits; the rest of the design is identical.

### 3.2 The interface and descriptor

`IDocumentFileAdapter` mirrors FreeX's `IFileAdapter` exactly, swapping `Workbook → TextDocument`:

```csharp
// ─────────── Free.Shared.FileFormats (model-free, shared) ───────────
namespace Free.Shared.FileFormats;

public sealed record FileFormatDescriptor(
    string Extension,
    string FormatName,
    bool CanOpen = true,
    bool CanSave = true,
    bool OpensAsTemplate = false);

/// <summary>Minimal base so the resolver/builder/planner stay model-agnostic.</summary>
public interface IFileFormatProvider
{
    IReadOnlyList<FileFormatDescriptor> Formats { get; }
}
// FileFormatResolver / FileDialogFilterBuilder / FileSavePlanner are the existing FreeX
// implementations with IFileAdapter replaced by IFileFormatProvider — otherwise unchanged.

// ─────────── FreeW.Core.IO (net10.0, WPF-free, TextDocument-typed) ───────────
namespace FreeW.Core.IO;
using System.IO;
using Free.Shared.FileFormats;
using FreeW.Core.Model;

public interface IDocumentFileAdapter : IFileFormatProvider
{
    string Extension { get; }
    string FormatName { get; }

    // Default: one descriptor from Extension+FormatName. Multi-extension adapters override.
    IReadOnlyList<FileFormatDescriptor> IFileFormatProvider.Formats =>
        [ new FileFormatDescriptor(Extension, FormatName) ];

    TextDocument Load(Stream stream);
    void Save(TextDocument document, Stream stream);
}

/// <summary>Stateless wrapper over the existing static reader/writer — zero engine change.</summary>
public sealed class DocxFileAdapter : IDocumentFileAdapter
{
    public string Extension => ".docx";
    public string FormatName => "Word documents";
    public TextDocument Load(Stream stream) => DocxReader.Read(stream);
    public void Save(TextDocument document, Stream stream) => DocxWriter.Write(document, stream);
    // Later, to add macro/template variants as PURE DATA:
    // public IReadOnlyList<FileFormatDescriptor> Formats { get; } =
    // [ new(".docx","Word Document"), new(".docm","Word Macro-Enabled Document"),
    //   new(".dotx","Word Template", OpensAsTemplate:true),
    //   new(".dotm","Word Macro-Enabled Template", OpensAsTemplate:true) ];
}
```

**Multi-format and read-only/template cases are pure data.** A single Word adapter exposes `.docx`/`.docm`/`.dotx`/`.dotm` by overriding `Formats`; a legacy adapter exposes `.doc`/`.dot` with `CanSave:false`; templates set `OpensAsTemplate:true`. (Confirmed FreeX gotcha: the default `Formats` impl returns only the *primary* descriptor, so any multi-extension adapter **must override** `Formats` — exactly as `LegacyXlsFileAdapter` does — or its extra extensions are invisible.)

### 3.3 Encoding / options — kept OUT of the model

Per-load/save options (plain-text encoding, EOL, BOM) are **constructor-injected into the adapter** (exactly like FreeX `DelimitedTextFileAdapter(ext, name, delimiter)`), never added to `TextDocument`, keeping the model format-neutral:

```csharp
public enum EolStyle { Crlf, Lf, Cr }
public sealed record TextSaveOptions(
    System.Text.Encoding Encoding,
    EolStyle Eol = EolStyle.Crlf,
    bool EmitBom = false)
{
    public static TextSaveOptions Default { get; } =
        new(new System.Text.UTF8Encoding(encoderShouldEmitBOM: false));
}

public sealed class PlainTextFileAdapter(TextSaveOptions? options = null) : IDocumentFileAdapter
{
    private readonly TextSaveOptions _options = options ?? TextSaveOptions.Default;
    public string Extension => ".txt";
    public string FormatName => "Plain text";
    public IReadOnlyList<FileFormatDescriptor> Formats { get; } =
    [
        new(".txt",  "Plain text", CanOpen: true, CanSave: true),
        new(".text", "Plain text", CanOpen: true, CanSave: true),
        new(".log",  "Log file",   CanOpen: true, CanSave: true),
    ];

    public TextDocument Load(Stream stream)
    {
        System.Text.Encoding.RegisterProvider(System.Text.CodePagesEncodingProvider.Instance);
        using var reader = new StreamReader(stream, detectEncodingFromByteOrderMarks: true);
        var text = reader.ReadToEnd();
        var doc = new TextDocument();
        foreach (var line in text.Replace("\r\n", "\n").Replace('\r', '\n').Split('\n'))
            doc.Blocks.Add(Paragraph.FromText(line)); // single default Run per line
        return doc;
    }

    public void Save(TextDocument document, Stream stream)
    {
        var sep = _options.Eol switch { EolStyle.Lf => "\n", EolStyle.Cr => "\r", _ => "\r\n" };
        var enc = _options.EmitBom ? new System.Text.UTF8Encoding(true) : _options.Encoding;
        using var writer = new StreamWriter(stream, enc) { NewLine = sep };
        foreach (var block in document.Blocks)
            if (block is Paragraph p) writer.WriteLine(p.PlainText); // tables flattened/skipped (lossy by nature)
    }
}
```

An optional `IDocumentLoadDiagnostics` capability interface MAY surface `LoadResultInfo(DetectedEncoding, DetectedEol)` from the last load so the host can report "opened as Windows-1252" without polluting the `Load` signature. Not required for v1.

### 3.4 Registry, resolver, dialog filter, save planner

- **Catalog** — `DocumentFileAdapterCatalog.CreateDefaultAdapters()` returns `IReadOnlyList<IDocumentFileAdapter>`. **This is the single data-change point.** v1 = `[ new DocxFileAdapter() ]` (preserves today's behavior). Adding `.txt` = add `new PlainTextFileAdapter()` here — one line.
- **Resolver** — `FileFormatResolver.FindOpenAdapter` / `FindSaveAdapter` (by normalized extension, honoring `CanOpen`/`CanSave`); shared, unchanged.
- **Dialog filter** — `FileDialogFilterBuilder.BuildOpenFilter` (prepends "All supported files", appends "All files (\*.\*)"), `BuildSaveFilter` (save-capable only, no all-files row), `FindSaveFilterIndex` (1-based default). This **replaces** FreeW's weaker `FileDialogFilter.Build(FileFormatChoice[])` (which lacks All-supported / CanOpen-CanSave split / OpensAsTemplate / FindSaveFilterIndex).
- **Save planner** — `FileSavePlanner.TryResolveExistingPath` / `CanSkipCleanSave` maps the current path → `(path, adapter)` for plain Save.

```csharp
// ─────────── FreeW.App.Host (registration point; NO DI container) ───────────
public static class DocumentFileAdapterCatalog
{
    // THE single data-change point. Adding a format = add one line here.
    public static IReadOnlyList<IDocumentFileAdapter> CreateDefaultAdapters() =>
    [
        new DocxFileAdapter(),
        // new PlainTextFileAdapter(),   // <-- adding .txt is this one line + a registration test tuple
    ];
}
```

> **Registration point note:** FreeW does **not** use a DI container (FreeX does, via `App.ConfigureServices` + `IEnumerable<IFileAdapter>`). FreeW constructs `new FileCommands(...)` directly at `MainWindow.cs:168`. So the catalog is a **static factory** consumed at the construction site with an optional ctor param for tests — do **not** model FreeX's DI injection here. Adapters are stateless, so a fresh list per `FileCommands` is fine (avoids FreeX's singleton-stateful-adapter gotcha; `DocxFileAdapter` must stay stateless, just forwarding to the static reader/writer).

### 3.5 The `FileCommands.cs` dispatch seam

```csharp
// ctor: _adapters = adapters ?? DocumentFileAdapterCatalog.CreateDefaultAdapters();

private bool OpenPath(string path, bool suppressRecentFiles)
{
    var adapter = FileFormatResolver.FindOpenAdapter(_adapters, Path.GetExtension(path), out var fmt);
    if (adapter is null) { ShowError("Unrecognized file type", new($"No reader for {Path.GetExtension(path)}")); return false; }
    try
    {
        using var fs = File.OpenRead(path);
        _editor.LoadModel(adapter.Load(fs));
        if (fmt!.OpensAsTemplate) { _state.ClearCurrentFilePath(); _editor.CurrentFileName = null; _onChanged(); }
        else SetSaved(path, suppressRecentFiles);
        return true;
    }
    catch (Exception ex) { ShowError("Could not open the document", ex); return false; }
}

public bool SaveAs()
{
    var dialog = new SaveFileDialog
    {
        Filter = FileDialogFilterBuilder.BuildSaveFilter(_adapters),
        FilterIndex = FileDialogFilterBuilder.FindSaveFilterIndex(
            _adapters, _state.CurrentFilePath is { } p ? Path.GetExtension(p) : ".docx"),
        AddExtension = true, OverwritePrompt = true,
        FileName = _state.CurrentFilePath is null ? "Document.docx" : Path.GetFileName(_state.CurrentFilePath),
    };
    if (dialog.ShowDialog(_window) != true) return false;
    // Re-derive from the CHOSEN filename, NOT FilterIndex (user-typed ext wins) — FreeX gotcha.
    var adapter = FileFormatResolver.FindSaveAdapter(_adapters, Path.GetExtension(dialog.FileName), out _);
    if (adapter is null) { ShowError("Cannot save", new($"{Path.GetExtension(dialog.FileName)} is not a writable format")); return false; }
    return SaveTo(dialog.FileName, adapter);
}

private bool SaveTo(string path, IDocumentFileAdapter adapter)
{
    try
    {
        _editor.CommitToModel();
        using var fs = File.Create(path);
        adapter.Save(_editor.Model, fs);
        SetSaved(path, suppressRecentFiles: false);
        return true;
    }
    catch (Exception ex) { ShowError("Could not save the document", ex); return false; }
}
```

**Seam behaviors (from the FreeX blueprint):**
- **Templates** (`.dotx`/`.dotm`/`.ott`/`.dot`) are data-only via `OpensAsTemplate:true`. The single observable effect is clearing `_currentFilePath` after load so the next Save becomes Save-As. No separate template-load code path.
- **Save-As re-derives the extension from the chosen *filename*, not the FilterIndex** — a user typing/keeping `.txt` while the `.docx` row is selected must write `.txt`.
- **Unknown extension on open** — FreeX silently `return`s; FreeW will **improve** with a clear "unrecognized file type" error.
- **`CanSave:false` formats** (`.doc`, `.dot`, `.ott`, read-only Word-2003 XML) are filtered out of the Save dialog by `BuildSaveFilter` and rejected by `FindSaveAdapter`; their `Save()` also throws `NotSupportedException` ("Save As .docx") as belt-and-suspenders, mirroring `LegacyXlsFileAdapter.Save`.
- **Save a Copy** falls out for free: a Save-As that writes to the chosen path but does not mutate `_state` (no `MarkSaved`, no dirty clear), reusing the same resolver + `adapter.Save` plumbing.

### 3.6 WPF-only exports kept out of Core.IO

PDF raster export (**already shipped** in `PdfExport.cs`) and XPS export walk the live WPF visual tree / paginator on the STA thread and do **not** fit `Save(TextDocument, Stream)`. They live in `FreeW.App.Host` behind a separate host-only contract and surface via the **Backstage Export pane**, never File→Save-As:

```csharp
public interface IDocumentExportAdapter      // FreeW.App.Host (WPF), NOT Core.IO
{
    string Extension { get; }                // ".pdf", ".xps"
    string FormatName { get; }
    void Export(DocumentExportContext context, Stream output); // walks paginator/visual tree on STA
}
```

Do **not** use the WPF `System.Windows.Documents` RTF route — it is WPF-only, bypasses `TextDocument`, and breaks the blueprint. RTF must be a native Core.IO adapter.

## 4. Format Coverage Table

| Format family | Extensions | Word open | Word save | FreeW read | FreeW write | Approach | Library (license) | Effort | Priority |
|---|---|---|---|---|---|---|---|---|---|
| Plain text | `.txt` `.text` `.log` | ✅ | ✅ | ✅ | ✅ (lossy) | Native (BCL) | none (+ System.Text.Encoding.CodePages, MIT) | S | **P0** |
| OOXML Word variants | `.docm` `.dotx` `.dotm` | ✅ | ✅ | ✅ | ✅ | Native (reuse Docx engine) | none | S | **P1** |
| Rich Text Format | `.rtf` | ✅ | ✅ | ✅ | ✅ | Native (hand-rolled) | none | L | **P1** |
| OpenDocument Text | `.odt` `.ott` `.fodt` | ✅ | ✅ | ✅ | ✅ | Native (ZIP+XML) | none (Free.Shared.Opc) | L | **P1** |
| Legacy binary Word | `.doc` `.dot` | ✅ | ✅ | ✅ (read-only) | ❌ | Library | DocSharp.Binary.Doc (MIT) | M | **P1** |
| Word XML (Flat OPC + 2003) | `.xml` | ✅ | ✅ | ✅ | Flat-OPC ✅ / 2003 read-only | Native | none | L (S–M for Flat-OPC alone) | **P2** |
| HTML & MHTML | `.htm` `.html` `.mht` `.mhtml` | ✅ | ✅ | ✅ (library) | ✅ (native) | Mixed | AngleSharp + MimeKit (MIT) for read | L | **P2** |
| PDF | `.pdf` | ✅ (best-effort) | ✅ | ✅ (text import, lossy) | ✅ **DONE** (raster export) | Mixed | Export: PDFsharp-WPF 6.2.4 (MIT, present); Import: PdfPig (Apache-2.0) | M | **P2** |
| XPS | `.xps` | ✅ | ✅ | ❌ (infeasible) | ✅ (vector export) | Native (in-box WPF) | none (ReachFramework, in-box) | S | **P3** |
| Niche legacy | `.wpd` `.wps` `.wri` Word 6.0/95 `.doc` | ✅ (via converters) | ❌ | ❌ (dropped) | ❌ | — | none viable (LGPL/commercial only) | XL | **P3** (drop) |

## 5. Per-Format Detail

### 5.1 Plain text — `.txt` `.text` `.log` (P0, native, read+write)

- **Recommendation:** Native BCL. BOM sniff (`StreamReader(detectEncodingFromByteOrderMarks:true)` recognizes UTF-8/16LE/16BE/32); if no BOM, strict-UTF-8 decode then fall back to system ANSI codepage. Lines → `Paragraph` (one default `Run` each); write flattens `Paragraph.PlainText` joined by configured EOL. This adapter is the **forcing function and proof-of-concept** for the whole registry.
- **Model mapping/gaps:** Zero model gaps. The model is far richer than the format needs. Only non-model additions: an open-result encoding/EOL hint and `TextSaveOptions` (Encoding/EolStyle/EmitBom), carried at the IO layer, not in `TextDocument`.
- **Fidelity:** ~100% read for BOM-marked / valid-UTF-8 files; soft spot is BOM-less legacy-codepage files (inherently a guess) — mitigated by UTF-8-strict-then-codepage heuristic + a future encoding chooser (Word parity). Write is intentionally lossy (characters + paragraph breaks only), exactly as Word's `.txt` export; reuse the existing unsupported-feature-on-save warning.
- **Library/license:** none for the core; add `System.Text.Encoding.CodePages` (MIT, Microsoft) for legacy codepages on net10.0, registered once via `Encoding.RegisterProvider`. **Reject** UTF.Unknown/Ude (MPL weak-copyleft) for v1.
- **Risks:** Registry must land first (this task forces it). BOM-less CJK/ANSI mis-decode without a chooser → mojibake. Forgetting `RegisterProvider` throws at runtime on cp1252. Guard against decoding huge/binary files into millions of paragraphs (size cap / binary sniff). Match Notepad/Word EOL+BOM defaults; preserve detected values on no-touch round-trip.

### 5.2 OOXML Word variants — `.docm` `.dotx` `.dotm` (P1, native, read+write)

- **Recommendation:** Native — **no third-party library** (reject the Open-XML-SDK as redundant). These are byte-identical OPC/ZIP packages to `.docx` with the same WordprocessingML schema. `DocxReader` keys only on the presence of `word/document.xml` (DocxReader.cs:29-30) and is content-type-agnostic, so it **already** reads all three correctly. A single Word adapter exposes a `Formats[]` array (`.docx`/`.docm` open+save; `.dotx`/`.dotm` open+save+`OpensAsTemplate:true`).
- **Model mapping/gaps:** Essentially zero for body content — bodies *are* WordprocessingML. Two additions: (1) macro pass-through — extend `ReadPreservedParts` to capture `word/vbaProject.bin`, `word/vbaData.xml`, and `word/_rels/vbaProject.bin.rels` into `PreservedParts.Parts` (the `PreservedPart(PartName, Bytes, ContentTypeOverride, RelationshipType)` shape fits exactly, incl. the implicit `document → vbaProject` relationship); (2) derive the `document.xml` content-type from the chosen **save extension** at the adapter boundary (keep `TextDocument` format-neutral). The only genuinely new code is the content-type map + cross-variant Save-As logic.
- **Fidelity:** Identical to existing `.docx` fidelity. Macros (`vbaProject.bin`) are preserved **byte-for-byte, never executed** (opaque, safe). `.docx → .docm` with no source macros yields a valid macro-enabled package Word opens cleanly; `.docm → .docx` drops macro parts and switches content-type.
- **Library/license:** none.
- **Risks:** `[Content_Types].xml` Default-extension collision — `vbaProject.bin` needs `application/vnd.ms-office.vbaProject` while OLE `.bin` parts use `oleObject`; a single `Default Extension="bin"` cannot serve both → emit a **per-part Override** for `/word/vbaProject.bin`. Save-As cross-variant matrix (drop macros + switch content-type). The satellite `word/_rels/vbaProject.bin.rels` must be captured (part-local, not `document.xml.rels`). A SECURITY review must confirm `vbaProject.bin` is never deserialized/executed.

### 5.3 Rich Text Format — `.rtf` (P1, native, read+write)

- **Recommendation:** Native hand-rolled `RtfReader.cs` + `RtfWriter.cs` in `FreeW.Core.IO` (zero new NuGet), mirroring `DocxReader`/`DocxWriter`. Reader = tokenizer over the group (`{`/`}`) + control-word grammar with a formatting-state stack, `\'XX` hex and `\uN`/`\ucN` Unicode escapes, `\ansicpg`/`\fcharset` code-page decode (reuse `CodePagesEncodingProvider`). Writer emits header (`\rtf1\ansi\ansicpg1252`, sorted `\fonttbl`/`\colortbl`) then walks the model. **Reject** every library: DocSharp's RTF path is welded to DOCX via the Open-XML-SDK (contradicts FreeW's no-SDK design); RtfPipe is one-way RTF→HTML; ReasonableRTF is RTF→plain-text only; NRtfTree is LGPL/GPL; commercial libs rejected; the WPF `TextRange` route is WPF-only and bypasses the model.
- **Model mapping/gaps:** Clean — RTF is the same conceptual model as OOXML, different syntax. `\b\i\ul\strike\fsN\cfN\fN\highlightN\super\sub` → `RunFormatting`; `\par\pard\ql/\qc/\qr/\qj\liN\riN\fiN\sbN\saN\slN\brdr*` → `Paragraph`/`ParagraphFormatting`; `\trowd\cellxN\cell\row\clvmgf/\clvmrg` → `Table`/merges; `\pict\pngblip/\jpegblip/\emfblip` → `InlineImage`; `\field{\fldinst HYPERLINK|PAGE|DATE}` → hyperlink/`RunFieldKind`; `\footnote`/`\ftnalt` → `Footnote`/`Endnote`; bookmarks/tabs/sections/tracked-changes/comments all map. `\fsN` = half-points (pt = N/2); twips = pt×20. **No new model types.** Exotic groups (`\shp`, `\object`, custom `\*` destinations) are skipped on read / not emitted on write. Optional P2: `PreservedParts`-style verbatim capture of unknown destination groups.
- **Fidelity:** Good-to-very-good for everything FreeW renders. Traps: the `\uN`/`\ucN` skip-count (must consume the right fallback-byte count or non-ASCII corrupts), code-page selection, 16-bit-signed negative Unicode params, nested tables/`\cellx` boundaries, hex `\pict` payloads.
- **Library/license:** none (first-party).
- **Risks:** Unicode/code-page correctness (silent corruption) — needs byte-exact non-ASCII tests, not just counts. Breadth (hundreds of control words) — unknown destination groups must skip cleanly. Nested/merged tables. Scope creep toward Word-perfect — hold v1 to the modelled subset.

### 5.4 OpenDocument Text — `.odt` `.ott` `.fodt` (P1, native, read+write)

- **Recommendation:** Native ZIP+XML reader/writer reusing `Free.Shared.Opc` (`SecureXmlReaderSettings` + size guard) and the `DocxReader`/`DocxWriter` pattern. No permissive maintained .NET ODF library exists (AODL/AODLCore are LGPL + abandoned; commercial libs rejected), and ODT is structurally an OPC-like ZIP of OASIS XML, so the existing stack transfers directly. One adapter: `.odt` open+save, `.ott` open+`OpensAsTemplate`, `.fodt` open (flat single-file XML). Do read and write **together** — the style flatten/generate logic is shared.
- **Model mapping/gaps:** Maps well, no new top-level block types. `text:p`/`text:h` → `Paragraph` (+HeadingN via `text:outline-level`), `text:span` → `Run`, `text:a` → hyperlink, `table:table` → `Table` (spans/column widths), `draw:frame`+`draw:image` → `InlineImage` (bytes from `Pictures/`), `text:note` → `Footnote`/`Endnote`, `office:annotation` → `Comment`, `text:list` → list paragraphs, master-page `style:header`/`style:footer` → headers/footers, `style:page-layout` → page settings, `meta.xml` → `DocumentProperties`. Gaps: (1) an ODT-specific `PreservedParts`-style verbatim store for `settings.xml`/unknown auto-styles (the existing `PreservedParts` is docx-part-shaped); (2) ODF `text:section` (nested/columned) collapses to plain paragraphs (FreeW `Section` is page-level); (3) MathML↔OMML — fall back to `Equation.LinearText` for v1. SmartArt/charts/OLE downgrade to image or drop.
- **Fidelity:** Good for the common text core (paragraphs/headings/runs/links/lists/tables/images/footnotes/comments/page geometry/headers-footers/metadata); on par with Word's own lossy `.odt` converter. Partial: tracked changes, multi-column/sections, theme colors (resolve to literal). Dropped/rasterized: SmartArt, charts, OLE, WordArt/shapes, content controls, OMML (unless MathML mapping built).
- **Library/license:** none (first-party + in-box BCL ZIP/XML).
- **Risks:** `mimetype` MUST be the **first** zip entry and **stored uncompressed** (explicit ordering + `CompressionLevel.NoCompression`). Style flatten-on-read / generate-with-dedup-on-write is the core effort/fidelity risk. Round-trip loss for unmodelled features needs the verbatim store. Unit parsing (cm/mm/in/pt/pc, `#rrggbb`). Untrusted ZIP-of-XML → hardened `XmlReader` + zip-bomb guards. Scope discipline (full Word `.odt` fidelity is XL).

### 5.5 Legacy binary Word — `.doc` `.dot` (P1, library, read-only)

- **Recommendation:** Library, read-only. Use **DocSharp.Binary.Doc (MIT)** to transcode `.doc`/`.dot` → in-memory `.docx`, then feed that stream into the existing `DocxReader` — reusing all ~2877 lines of mapping for free. Open-only (`CanSave:false`); users round-trip via Save As `.docx`. This is the direct Word-side analogue of FreeX's `LegacyXlsFileAdapter` (ExcelDataReader, open-only). `Save()` throws `NotSupportedException` ("Save As .docx"). **Reject** commercial (Aspose/Spire/GemBox/Syncfusion); **reject** NPOI (no binary `.doc`); native FIB/piece-table parsing (OpenMcdf MPL-2.0 for the CFB container) is L–XL bespoke work and not recommended given the permissive library exists.
- **Model mapping/gaps:** Delegated entirely to `DocxReader → TextDocument`; no new `.doc`-specific model code. Pre-existing `DocxReader` limits also apply to converted `.doc` (legacy VML shapes, form fields, complex fields, OLE embeds). Do **not** add a parallel binary-doc model path.
- **Fidelity:** Good for mainstream business docs (text, char/para formatting, tables, lists/numbering, sections, inline + many floating images). Lossy/unsupported: complex fields, form fields, OLE embeds, legacy VML/Escher shapes, some list/tab edge cases. **Pre-97 Word 6/95 `.doc` is a different format — unsupported; fail gracefully.** Treat as a faithful-content importer, not pixel-perfect.
- **Library/license:** DocSharp.Binary.Doc + DocSharp.Binary.Common (MIT), actively maintained (0.20.0, 2026-05). Add to `Directory.Packages.props` + `THIRD_PARTY_LICENSES.md`/`NOTICES.md`; verify the resolved transitive tree at implementation time (likely carries its own CFB reader; flag OpenMcdf MPL-2.0 if pulled in).
- **Risks:** Registry prerequisite. Pin the DocSharp converter entry-point by inspecting the package (README has no sample). The `.doc → docx → TextDocument` double hop means failures can originate in either hop — wrap with distinguishable error messages. Untrusted CFB/FIB parsing → defensive, bounded, caught.

### 5.6 Word XML — Flat OPC + Word 2003 WordprocessingML — `.xml` (P2, native)

- **Recommendation:** Native, no library (reject the Open-XML-SDK — it would add a second OOXML stack; it also has **no** Word-2003 support). Two sub-formats share `.xml`; **sniff the root element** to dispatch. (A) **Flat OPC** (`<pkg:package>` root, optional `<?mso-application progid="Word.Document"?>` PI): inline parts are the *same* OOXML parts `DocxReader` already consumes — seam `DocxReader`/`DocxWriter` behind a tiny `IPartSource`/`IPartSink` with `ZipPartSource`/`ZipPartSink` (today) + `FlatOpcPartSource`/`FlatOpcPartSink`; ~95% of logic reused, fidelity == `.docx`. **READ+WRITE, P1-worthy.** (B) **Word 2003 WordML** (`<w:wordDocument>` root): a *different* schema — needs a hand-written `Wordml2003Reader`. **READ-ONLY first; write optional / `CanSave:false`.**
- **Model mapping/gaps:** Flat OPC = zero model gaps (reuses full model incl. `PreservedParts`). Word 2003 maps the common subset onto the same model; gaps: (1) a format-provenance marker (or derive content-type from save extension); (2) 2003 images via `w:pict`/VML + `w:binData` → bridge to `InlineImage`; (3) no SmartArt/charts/modern comment threads/embedded fonts in 2003 — document, don't model.
- **Fidelity:** Flat OPC = HIGH (== `.docx`). Word 2003 = MEDIUM for the common subset (text/runs/formatting/tables/styles/sections/simple images), LOWER for fields/footnotes/comments (different 2003 shapes); write inherently lossy.
- **Library/license:** none.
- **Risks:** Content-sniff dispatch (root element / PI), not extension — and `.xml` also collides conceptually with spreadsheet-XML. Seaming the 2877-line reader / 3870-line writer behind `IPartSource`/`IPartSink` risks regressing the golden-master/round-trip suites — gate with the full existing DocxRoundTrip + PreservedParts suites, keep `ZipPart*` as the default. Single-file XML can be large (base64 media inflates ~33%) → size cap + secure XML + base64-decode guard. 2003 is easy to under-scope; ship read-only first.

### 5.7 HTML & MHTML — `.htm` `.html` `.mht` `.mhtml` (P2, mixed)

- **Recommendation:** Asymmetric. **WRITE is the priority and native** (no dependency): clean semantic HTML5 (filtered-HTML-style) with a `<style>` block + sidecar/data-URI images for `.htm`/`.html`, and a Single-File Web Page (`.mht`/`.mhtml`) via MimeKit `multipart/related` (or a small hand-rolled writer). **READ is library-based** (AngleSharp for the DOM, MimeKit for the MHTML wrapper) but **scoped to Word-generated + clean structural HTML, NOT arbitrary web pages**. Do **not** attempt Word's "full HTML" OOXML-island round-trip. Reject commercial libs; HtmlAgilityPack not recommended over AngleSharp (no HTML5 tree-construction / CSS model).
- **Model mapping/gaps:** Maps well. `<p>`/`<h1..6>`/`<li>`/`<table>` → blocks; `<b|strong>/<i|em>/<u>/<s>/<sup>/<sub>/<a>/<img>/<br>` → runs; rowspan/colspan → merges. New piece: a **CSS↔formatting mapping helper** (both directions) — the biggest new component. Optional: `<head>` metadata/base-href via `DocumentProperties`; a resource-set abstraction for the image sidecar folder. No new block/run *types*. Footnotes/endnotes/comments/fields/equations/SmartArt/charts/OLE/content-controls/tracked-changes have no HTML home → flattened to text on write, never produced on read.
- **Fidelity:** WRITE high for prose/headings/formatting/links/lists/tables/images; lossy for page layout; total loss for footnotes/comments/fields/equations/charts/SmartArt/tracked-changes. READ good for clean/Word HTML+MHTML; poor-to-noise for arbitrary modern web HTML (CSS layout, JS, web fonts, SVG, forms). Treat HTML as interchange/publish, not fidelity-preserving — exactly how Word treats "Web Page".
- **Library/license:** AngleSharp (MIT, active) + MimeKit (MIT, active) for read; none for write (MimeKit only for the `.mht` branch, or hand-roll it). AngleSharp.Css cascade is pre-1.0 beta — prefer parsing inline `style=` + a hand-rolled property subset.
- **Risks:** Reading arbitrary web HTML is an unbounded tar pit — scope it. CSS↔formatting mapping is fiddly (px/pt/em, named/rgb()/#hex, shorthands, inheritance) — needs its own corpus tests. Fidelity-loss expectations must be documented. Sidecar (`name_files/`) vs data-URI decision early.

### 5.8 PDF — `.pdf` (P2, mixed; export DONE)

- **Recommendation:** Split decisively. **EXPORT (write) is already shipped** — `freew/FreeW.App.Host/PdfExport.cs` reuses the print pipeline (`PrintLayout.BuildPaginator` → header/footer/watermark/border/footnote compositing), rasterizes each page to a `RenderTargetBitmap` onto a PDFsharp `PdfDocument`, wired into File→Export / Backstage, flushed via `ExportAtomicWriter`, tested by `PdfExportTests.cs` (`%PDF-`/`%%EOF`). **Treat as DONE** (optionally file a P2/P3 enhancement for selectable-text vector PDF). **IMPORT (read)** = library `PdfPig` (Apache-2.0), read-only lossy text extraction surfaced as an explicit **"Import PDF (text only)"** command, *not* a peer of File→Open. Reject commercial; reject iText (AGPL).
- **Model mapping/gaps:** Export already maps the full model through the paginator. Import maps poorly (PDF has no model concepts): recovered text block → `Paragraph` (single default `Run`, no `StyleId`); optional best-effort glyph-height → font size, bold/italic from font-name heuristics. No model gaps to add (import populates a strict subset). Explicitly **not** mapped: tables, images (optional P3 XObject extraction), lists, columns, footnotes, comments, styles.
- **Fidelity:** Export = HIGH layout but **raster** (text not selectable/searchable, larger files) — known limitation, matches FreeX's exporter. Import = LOW and inherently lossy (text-only, best-effort reading order; multi-column/table/scanned PDFs degrade badly; no OCR).
- **Library/license:** Export — PDFsharp-WPF 6.2.4 (MIT, **already referenced**). Import — PdfPig (Apache-2.0; **permanently alpha-versioned** — pin the exact version; NOTICE attribution mandatory).
- **Risks:** Do **not** re-implement export. PdfPig reading-order on multi-column/RTL is unreliable — set expectations low, add known-poor-input tests. Import must be a dedicated command (cannot save back to PDF) to keep dirty/save semantics sane; keep it in Core.IO as a `PdfTextReader` returning a sparse `TextDocument`.

### 5.9 XPS — `.xps` (P3, native export only)

- **Recommendation:** Native WPF export only; **no import** (reconstructing logical structure from positioned glyphs is OCR-grade; Word can't open `.xps` either). Add `ExportToXps` mirroring `ExportToPdf`: same `PrintLayout.BuildPaginator` → `XpsDocument` (FileMode.Create) → `XpsDocumentWriter.Write(paginator)`. `ReachFramework.dll`/`System.Printing.dll` ship in-box under `UseWPF=true` (no NuGet). The cheapest possible format addition — the entire paginate pipeline already exists.
- **Model mapping/gaps:** None — consumes the already-built `DocumentPaginator`, inheriting whatever Print/PDF render.
- **Fidelity:** High and **superior to the current PDF path in one respect** — XPS serializes real vector glyph runs (selectable/searchable text, crisp scaling) vs the PDF raster path. Inherits the shared paginator's known approximations (footnotes only on single-page docs; header/footer geometry).
- **Library/license:** in-box WPF XPS (MIT, ships with runtime) — no `THIRD_PARTY_LICENSES` entry needed.
- **Risks:** dotnet/wpf #9418 (`IOException` in `OpenInUpdateMode`) — always write a fresh path with `FileMode.Create`. Must run on STA (walks the visual tree). For atomic writes, render to a `MemoryStream` package then hand bytes to `ExportAtomicWriter` (parallels `PdfExport.RenderToBytes`). Low format relevance (Windows-centric, viewer deprecated) → P3 despite trivial effort.

### 5.10 Niche legacy — `.wpd` `.wps` `.wri`, Word 6.0/95 `.doc` (P3, drop)

- **Recommendation:** **Drop** all four binary members for the foreseeable roadmap. No permissive, maintained, fidelity-adequate .NET library exists: WP_Reader (LGPL-3.0, abandoned, incomplete); libwpd/libwps (C++ LGPL/MPL → per-RID native build + P/Invoke); binary `.doc` covered only by commercial libs (rejected) which target 97-2003, not 6.0/95. Realistic fidelity is text-only, undersells the product. The registry makes adding a read-only adapter later a pure data change, so dropping now costs nothing.
- **Model mapping/gaps:** If ever implemented read-only, maps only to the lowest-common-denominator subset (paragraphs + runs + basic char formatting + alignment). No new model fields justified.
- **Fidelity:** Text + minimal formatting at best; tables unreliable, images/OLE/headers/columns lost. (Modern Office blocks these converters by default anyway.)
- **Library/license:** none viable — WP_Reader LGPL-3.0 (reject), libwpd/libwps LGPL/MPL C++ (reject for in-proc .NET), commercial (reject).
- **Risks:** Copyleft/relinking obligations; per-RID native binaries break the pure-managed build; near-zero demand; legacy OLE2 parsers are classic malware vectors (another reason Word blocks them).

## 6. Library & Licensing Decisions

The project is license-careful (`THIRD_PARTY_LICENSES.md` / `THIRD_PARTY_NOTICES.md`). Prefer permissive (MIT/Apache/BSD) or native; central-manage every package in `Directory.Packages.props`.

**Allowed / chosen:**
- **PDFsharp-WPF 6.2.4 (MIT)** — already referenced; PDF export. No change.
- **System.Text.Encoding.CodePages (MIT)** — legacy codepages for plain text (and reused by RTF/legacy-`.doc` decode).
- **DocSharp.Binary.Doc + DocSharp.Binary.Common (MIT)** — legacy `.doc`/`.dot` → in-memory `.docx`. Verify transitive tree; add notices.
- **PdfPig / UglyToad.PdfPig (Apache-2.0)** — PDF text import. Pin exact (alpha) version; Apache NOTICE attribution mandatory.
- **AngleSharp (MIT)** + **MimeKit (MIT)** — HTML / MHTML read.
- **In-box WPF XPS (`ReachFramework`, MIT, ships with runtime)** — XPS export; no NuGet, no notice.
- **Native / first-party** — RTF reader+writer, ODT reader+writer, Word XML (Flat OPC + 2003), plain text, OOXML variants. The preferred approach wherever tractable (zero dependency, full control, no SDK).
- Pattern reference: FreeX's `ExcelDataReader` (MIT) read-only/`CanSave:false` adapter is the template for legacy `.doc`.

**Rejected — commercial/proprietary (project policy):** Aspose.Words, Spire.Doc, GemBox.Document, Syncfusion DocIO. Cover everything but disallowed.

**Rejected — copyleft (license-careful policy):** NRtfTree (LGPL/GPL), iText 7 (AGPL), WP_Reader (LGPL-3.0), libwpd/libwps (LGPL/MPL, also C++). UTF.Unknown/Ude (MPL 1.1 weak-copyleft) deferred — native BOM+UTF-8+codepage heuristic suffices for v1.

**Rejected — redundant (not on license grounds):** DocumentFormat.OpenXml / Open-XML-SDK (MIT, fine license) — FreeW already owns a mature OOXML reader/writer + `PreservedParts`; adopting it would add a parallel stack for zero capability gain. Useful only as a constants reference. DocSharp.Docx (RTF/Flat-OPC) likewise welds to the SDK.

## 7. Testing & Fidelity Strategy

Mirrors FreeW/FreeX's existing conventions so every new test is a near-copy of an existing pattern. Non-UI IO tests live in `freew/FreeW.Core.IO.Tests` (net10.0, runs in the green `freew-ci` lane); only paginator/WPF-bound export tests live in `FreeW.App.Host.Tests` behind `[StaFact]`.

**Three test shapes + two ported registry suites:**
- **Shape A — Round-trip drift** (read+write formats: `.docm`/`.dotx`/`.dotm`, RTF, ODT, Flat-OPC XML, plain text, HTML/MHTML): mirror `DocxRoundTripTests` (`Save → MemoryStream → rewind → Load`) + the `ContentStats` drift comparator from `FreeWFidelityCorpusRoundTripTests`. Promote `ContentStats` into a shared test helper. Add targeted-construct tests per modelled facet. For native serializers, also **parse the written bytes structurally** (RTF control-word groups; ODT `mimetype` is entry[0] + stored-uncompressed + secure-XML-clean). Asymmetric/lossy formats round-trip the *intersection* only, with dropped sets named in the test (`Footnotes_AreDroppedOnHtmlSave_ByDesign`).
- **Shape B — Golden / extraction** (read-only: legacy `.doc`/`.dot`, Word-2003 WordML, PDF import): mirror `LegacyXlsFileAdapterTests` — a committed tiny `Fixtures/` file, `adapter.Load`, assert structure. Capability test asserts `CanOpen && !CanSave` and `Save()` throws. The legacy-`.doc` test exercises the DocSharp → docx → DocxReader double hop and asserts the two hops are distinguishable on failure. PDF import asserts reading-order text vs a golden `.txt` sidecar (NOT structure) + a documented poor-input (2-column) case.
- **Shape C — Render-compare / smoke** (PDF export DONE; XPS export): mirror `PdfExportTests` under `[StaFact]` in `FreeW.App.Host.Tests`; assert well-formed package (XPS: `PK\x03\x04` magic + a `FixedDocumentSequence` part). No pixel-diff (paginator already covered by `PrintLayoutTests`/`HeaderFooterPaginatorTests`).
- **Registry suite — `AppDocumentAdapterRegistrationTests`** (port of FreeX `AppFileAdapterRegistrationTests`): flatten `CreateDefaultAdapters().SelectMany(a => a.Formats)` and assert the capability tuple per extension (`.docx` open+save, `.dotx` open+save+template, `.rtf` open+save, `.txt` open+save, `.doc` open+!save, `.wpd`/`.wps`/`.wri` rejected). **Each new format adds one asserted tuple — the assertion that keeps adding-a-format a data change.**
- **Dialog suite — `DocumentDialogFilterBuilderTests`** (port of FreeX `FileDialogFilterBuilderTests`): exact `BuildOpenFilter`/`BuildSaveFilter` strings, `FindSaveFilterIndex` default, `NormalizeExtension` cases, resolver dispatch, the **Save-As-extension-override** test (chosen `.txt` filename overrides the `.docx` filter row), and the unknown-extension-on-open behavior.

**Corpus reuse (don't invent new corpora):** `freew-fidelity-corpus/` (download-on-demand, `manifest.csv`) is the primary fidelity engine — relax the `.docx`-only assertion to an allow-list, or add per-family sibling manifests reusing the `CorpusRow` parser. **Corpus runners stay corpus-gated** (`if (files.Count == 0) return;`) so the binary-free CI lane stays green — this is the single most common way to red the lane. Tiny license-clean committed fixtures go in `freew/FreeW.Core.IO.Tests/Fixtures/`; real messy samples stay download-on-demand only (never committed — licensing). Keep FreeW decoupled from FreeX's `fidelity-corpus/`/`test-corpus/`.

**Encoding/edge matrices:** plain text (P0, biggest): BOM × codepage × EOL × empty/no-trailing-newline + huge/binary guard + `RegisterProvider` smoke. RTF: `\uN`/`\ucN` skip-count byte-exact, `\ansicpg` decode, negative Unicode params, unknown-destination skip, nested tables. OOXML: `bin` Default collision, cross-variant Save-As, `vbaProject.bin`+`vbaData.xml`+satellite `.rels` byte-for-byte. Word-XML: sniff-dispatch + oversized-base64 guard. ODT: unit/color parse, mimetype packaging, hardened XML, style dedup. HTML/MHTML: CSS unit/color mapping, malformed-HTML tolerance, `cid:` resolution. All importers: malformed/truncated/zip-bomb → clean caught exception. Native writers: a "two writes are byte-identical" determinism test (sorted tables, no timestamps).

## 8. Phased Roadmap

Ordered by value/effort using the research priorities. Per AGENTS.md, build with `dotnet build FreeX.slnx --configuration Release`; the FreeW lane is `freew-ci.yml`.

### M1 — Registry foundation + plain-text proof (P0)
- **Scope:** Stand up the data-driven registry (Option B: promote model-free helpers to `Free.Shared.FileFormats`; or Option A fallback). Add `IDocumentFileAdapter` + `DocxFileAdapter` (wraps existing static reader/writer, zero engine change) + `PlainTextFileAdapter` + `DocumentFileAdapterCatalog`. Rewire `FileCommands.cs` open/save to dispatch by extension; handle `OpensAsTemplate`, Save-As-extension-override, unknown-ext error. Add `SaveCopy()`.
- **Deliverables:** `Free.Shared.FileFormats` (or copied files), `IDocumentFileAdapter`, `DocxFileAdapter`, `PlainTextFileAdapter`, `TextSaveOptions`, `DocumentFileAdapterCatalog`, rewired `FileCommands.cs`; `AppDocumentAdapterRegistrationTests` + `DocumentDialogFilterBuilderTests` + `PlainTextFileAdapterTests` (encoding/EOL matrix) + a `DocxFileAdapter` round-trip test; `System.Text.Encoding.CodePages` in `Directory.Packages.props`.
- **Effort:** S (registry is the bulk; `.txt` adapter is tiny). **Dependencies:** none. **This is the forcing function for everything else.**

### M2 — OOXML variants + Word Flat OPC XML (P1 / P2)
- **Scope:** Multi-descriptor Word adapter for `.docm`/`.dotx`/`.dotm` (content-type map by save extension; macro pass-through via `PreservedParts`; templates as data). Then seam `DocxReader`/`DocxWriter` behind `IPartSource`/`IPartSink` to add Flat-OPC `.xml` read+write (`ZipPart*` stays default).
- **Deliverables:** extended Word adapter `Formats[]`, `ReadPreservedParts` macro capture, content-type map, `IPartSource`/`IPartSink` + `FlatOpc*` impls, `WordXmlFileAdapter` (Flat-OPC branch); `OoxmlVariantRoundTripTests`, `WordXmlDispatchTests`, security note on `vbaProject.bin`.
- **Effort:** S for variants; S–M for Flat-OPC. **Dependencies:** M1. The 2003-WordML read-only half is deferred to M5/M6 backlog.

### M3 — Rich Text Format read+write (P1)
- **Scope:** Native `RtfReader.cs` + `RtfWriter.cs` mapping the modelled subset; tokenizer + state stack; `\uN`/`\ucN`/code-page handling; sorted font/color tables.
- **Deliverables:** `RtfFileAdapter` (open+save), `RtfRoundTripTests` (byte-exact non-ASCII, nested tables, unknown-group skip, determinism).
- **Effort:** L (largest native matrix). **Dependencies:** M1.

### M4 — PDF text import + XPS export (P2 / P3)
- **Scope:** PdfPig-based `PdfTextReader` surfaced as a dedicated "Import PDF (text only)" command (not File→Open). `ExportToXps` mirroring `ExportToPdf` via in-box `XpsDocumentWriter` behind `IDocumentExportAdapter`/`DocumentExportCatalog` in the Backstage Export pane. (PDF export already DONE — no work.)
- **Deliverables:** `PdfTextReader`, Import command + UI label, `PdfImportTests` (golden `.txt` + 2-column degradation); `XpsExport` static, `XpsExportTests` (`[StaFact]`); PdfPig (Apache-2.0) in `Directory.Packages.props` + NOTICE.
- **Effort:** M (import) + S (XPS). **Dependencies:** M1 (import adapter); export seam independent of M2/M3.

### M5 — HTML & MHTML (P2)
- **Scope:** Native HTML5 write (filtered-style + `<style>` + sidecar/data-URI images) and MHTML write (MimeKit). AngleSharp+MimeKit read scoped to Word-generated/clean structural HTML. Build the CSS↔formatting mapping helper.
- **Deliverables:** `HtmlFileAdapter`, `MhtmlFileAdapter`, CSS↔formatting helper; `HtmlMhtmlRoundTripTests` (intersection + `cid:`/CSS edges); AngleSharp + MimeKit (MIT) in `Directory.Packages.props`.
- **Effort:** L. **Dependencies:** M1.

### M6 — OpenDocument Text (P1)
- **Scope:** Native ODT reader+writer (ZIP+XML via `Free.Shared.Opc`); style flatten-on-read / generate-with-dedup-on-write; mimetype-first/stored packaging; ODT-specific verbatim-preservation store. `.odt` open+save, `.ott` template, `.fodt` flat-XML.
- **Deliverables:** `OdtFileAdapter`, ODT preserved-parts store; `OdtRoundTripTests` (packaging + unit/color + style dedup); corpus runner round-tripping through LibreOffice/Word.
- **Effort:** L. **Dependencies:** M1. (P1 value but scheduled after the cheaper P1 wins; can run in parallel with M3/M5.)

### M7 — Legacy `.doc`/`.dot` binary read (P1, read-only)
- **Scope:** `LegacyDocFileAdapter` transcoding via DocSharp.Binary.Doc → in-memory `.docx` → existing `DocxReader`; `CanOpen`, `CanSave:false`, `.dot` `OpensAsTemplate`; `Save()` throws "Save As .docx". Pre-97 fails gracefully.
- **Deliverables:** `LegacyDocFileAdapter`, `LegacyDocFileAdapterTests` (capability + golden extraction, two-hop error distinction); DocSharp.Binary.Doc/Common (MIT) in `Directory.Packages.props` + notices; verified transitive tree.
- **Effort:** M. **Dependencies:** M1.

### M8 — Niche/deferred (P3)
- **Scope:** Word-2003 WordML **read-only** adapter (hand-written `Wordml2003Reader`, `CanSave:false`) if demand warrants. Legacy `.wpd`/`.wps`/`.wri`/Word-6/95 `.doc` remain **dropped** — only a "rejected/not-registered" registration assertion. Optional P2/P3 enhancement: selectable-text vector PDF export.
- **Deliverables:** (optional) `Wordml2003Reader` + golden tests; rejection assertions in `AppDocumentAdapterRegistrationTests`.
- **Effort:** L (2003 reader) / trivial (rejection assertions). **Dependencies:** M2 (Word XML sniff dispatch).

## 9. Risk Register & Open Questions

**Risks:**
- **The entire roadmap is gated on M1** (FreeW has no registry today). Scope the registry + first two adapters together; the registry/dialog test suites cannot be written until it lands.
- **Option B touches FreeX** (`IFileAdapter` must extend `IFileFormatProvider`; resolver/builder/planner signatures change; five files move). Mechanical but cross-app — run FreeX's `AppFileAdapterRegistrationTests` + `FileDialogFilterBuilderTests` to prove no drift. Fallback: **Option A** (copy into `FreeW.Core.IO`, zero FreeX edits, identical FreeW outcome).
- **No DI container in FreeW** — use a static factory with an optional ctor param; do not replicate FreeX's `IEnumerable<IFileAdapter>` injection or you over-engineer. Existing `FileLifecycleTests.cs:43` must keep compiling (default arg preserves `.docx`-only behavior).
- **Seaming the 2877-line reader / 3870-line writer** behind `IPartSource`/`IPartSink` (Flat-OPC) risks regressing golden-master suites — gate with the full DocxRoundTrip + PreservedParts suites; keep `ZipPart*` the default.
- **Corpus runners that forget `if (files.Count == 0) return;`** red the binary-free CI lane.
- **RTF `\uN`/`\ucN` + `\ansicpg`** and **ODT mimetype packaging** and the **`[Content_Types].xml` `bin` collision** are silent-failure traps — a count-only round-trip test passes while output is wrong; add byte-exact / OPC-validity assertions.
- **`DocxFileAdapter` must stay stateless** (forwards to static reader/writer) — do not replicate FreeX's stateful-singleton `XlsxFileAdapter`.
- **PDF/XPS export must stay out of `IDocumentFileAdapter`** (STA/visual-tree bound); **PDF import must be a dedicated command** (cannot save back).
- **Each permissive dependency** needs `Directory.Packages.props` central registration + `THIRD_PARTY_LICENSES.md`/`NOTICES.md` entries (PdfPig Apache NOTICE mandatory). Reject all commercial + copyleft.
- **Untrusted binary/XML importers** (legacy `.doc`, ODT, Word-XML) are malware vectors — hardened, bounded, caught parsing; security review for `vbaProject.bin` (never deserialize/execute).

**Open questions:**
1. **Option A vs B** — promote the model-free helpers to `Free.Shared.FileFormats` (shared, touches FreeX) or copy into `FreeW.Core.IO` (zero FreeX edits)? Recommend B; decide before M1.
2. **Unknown-extension-on-open** — error dialog (recommended improvement over FreeX's silent return) vs silent return? Pin the behavior in a test.
3. **Plain-text encoding chooser** — defer to a later milestone, or ship a minimal Word-style "Encoded Text" dialog in M1 to avoid mojibake support tickets?
4. **Word-2003 WordML** — ship read-only (M8) or drop entirely? Depends on real corpus demand.
5. **`.odt` MathML↔OMML** — linear-text fallback for v1 (recommended) or build the mapping (raises effort materially)?
6. **HTML images** — sidecar `name_files/` vs data-URI default? Decide in M5.

## 10. Implementation Note

Per AGENTS.md, **do not edit the main worktree for code.** All implementation must happen on an isolated worktree/branch; the `freew-ci.yml` lane triggers on `freew/**`, `FreeW.slnx`, `shared/**`, and `Directory.*.props`. Verify with `dotnet build FreeX.slnx --configuration Release` and `dotnet test FreeX.slnx -c Release`.
